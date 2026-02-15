#!/usr/bin/env python3
"""
Systolic Array Dataflow Performance Comparison Script
功能：解析 Vivado 综合报告，生成三种数据流的性能对比
"""

import re
import os
import json
from pathlib import Path
from typing import Dict, List, Tuple

class ReportParser:
    """解析 Vivado 综合报告"""

    def __init__(self, reports_dir: str = "../reports"):
        self.reports_dir = Path(reports_dir)

    def parse_utilization(self, dataflow: str) -> Dict[str, int]:
        """解析资源利用率报告"""
        file_path = self.reports_dir / f"utilization_{dataflow}.rpt"

        if not file_path.exists():
            print(f"Warning: {file_path} not found")
            return {}

        utilization = {}

        with open(file_path, 'r') as f:
            content = f.read()

            # 解析 LUT
            lut_match = re.search(r'Number of LUTs\s*\|\s*(\d+)', content)
            if lut_match:
                utilization['LUT'] = int(lut_match.group(1))

            # 解析 FF
            ff_match = re.search(r'Number of Flip Flops\s*\|\s*(\d+)', content)
            if ff_match:
                utilization['FF'] = int(ff_match.group(1))

            # 解析 DSP
            dsp_match = re.search(r'Number of DSPs\s*\|\s*(\d+)', content)
            if dsp_match:
                utilization['DSP'] = int(dsp_match.group(1))

            # 解析 BRAM
            bram_match = re.search(r'Number of BRAM\s*\|\s*(\d+)', content)
            if bram_match:
                utilization['BRAM'] = int(bram_match.group(1))

        return utilization

    def parse_timing(self, dataflow: str) -> Dict[str, float]:
        """解析时序报告"""
        file_path = self.reports_dir / f"timing_{dataflow}_summary.rpt"

        if not file_path.exists():
            print(f"Warning: {file_path} not found")
            return {}

        timing = {}

        with open(file_path, 'r') as f:
            content = f.read()

            # 解析 WNS (Worst Negative Slack)
            wns_match = re.search(r'WNS\s*\(\s*ns\s*\)\s*:\s*(-?\d+\.\d+)', content)
            if wns_match:
                timing['WNS'] = float(wns_match.group(1))

            # 解析 TNS (Total Negative Slack)
            tns_match = re.search(r'TNS\s*\(\s*ns\s*\)\s*:\s*(-?\d+\.\d+)', content)
            if tns_match:
                timing['TNS'] = float(tns_match.group(1))

            # 解析最大频率
            freq_match = re.search(r'Maximum Frequency\s*:\s*(\d+\.\d+)\s*MHz', content)
            if freq_match:
                timing['Max Freq (MHz)'] = float(freq_match.group(1))

        return timing

    def parse_power(self, dataflow: str) -> Dict[str, float]:
        """解析功耗报告"""
        file_path = self.reports_dir / f"power_{dataflow}.rpt"

        if not file_path.exists():
            print(f"Warning: {file_path} not found")
            return {}

        power = {}

        with open(file_path, 'r') as f:
            content = f.read()

            # 解析总功耗
            total_match = re.search(r'Total Power\s*\([\w\s]+\)\s*([\d.]+)\s*W', content)
            if total_match:
                power['Total (W)'] = float(total_match.group(1))

            # 解析动态功耗
            dynamic_match = re.search(r'Dynamic Power\s*([\d.]+)\s*W', content)
            if dynamic_match:
                power['Dynamic (W)'] = float(dynamic_match.group(1))

            # 解析静态功耗
            static_match = re.search(r'Leakage Power\s*([\d.]+)\s*W', content)
            if static_match:
                power['Static (W)'] = float(static_match.group(1))

        return power


def calculate_performance_metrics(utilization: Dict, power: Dict) -> Dict:
    """计算性能指标"""

    metrics = {}

    # 假设 100 MHz 时钟频率
    clock_freq = 100.0  # MHz

    # 计算 GMAC/s (16 MAC/cycle × 100 MHz × 4 PEs = 0.64 GMAC/s)
    # 但实际可以流水线，所以 16 MAC/cycle × 100 MHz = 1.6 GMAC/s
    metrics['Throughput (GMAC/s)'] = 1.6

    # 计算能效 (GMAC/W)
    if 'Total (W)' in power and power['Total (W)'] > 0:
        metrics['Energy Efficiency (GMAC/W)'] = \
            metrics['Throughput (GMAC/s)'] / power['Total (W)']

    # 计算资源效率 (GMAC/KLUT)
    if 'LUT' in utilization and utilization['LUT'] > 0:
        metrics['Area Efficiency (GMAC/KLUT)'] = \
            metrics['Throughput (GMAC/s)'] / (utilization['LUT'] / 1000.0)

    return metrics


def print_comparison_table(dataflows: List[str], parser: ReportParser):
    """打印对比表格"""

    print("\n" + "="*80)
    print("SYSTOLIC ARRAY DATAFLOW COMPARISON")
    print("="*80)

    # 资源利用率对比
    print("\n1. Resource Utilization")
    print("-"*80)
    print(f"{'Resource':<15} {'WS':<15} {'IS':<15} {'OS':<15}")
    print("-"*80)

    all_util = {}
    for df in dataflows:
        all_util[df] = parser.parse_utilization(df)

    resources = ['LUT', 'FF', 'DSP', 'BRAM']
    for res in resources:
        row = [res]
        for df in dataflows:
            value = all_util[df].get(res, 'N/A')
            row.append(str(value))
        print(f"{row[0]:<15} {row[1]:<15} {row[2]:<15} {row[3]:<15}")

    # 时序对比
    print("\n2. Timing Performance")
    print("-"*80)
    print(f"{'Metric':<20} {'WS':<15} {'IS':<15} {'OS':<15}")
    print("-"*80)

    all_timing = {}
    for df in dataflows:
        all_timing[df] = parser.parse_timing(df)

    metrics = ['WNS', 'TNS', 'Max Freq (MHz)']
    for metric in metrics:
        row = [metric]
        for df in dataflows:
            value = all_timing[df].get(metric, 'N/A')
            row.append(str(value))
        print(f"{row[0]:<20} {row[1]:<15} {row[2]:<15} {row[3]:<15}")

    # 功耗对比
    print("\n3. Power Consumption")
    print("-"*80)
    print(f"{'Metric':<20} {'WS':<15} {'IS':<15} {'OS':<15}")
    print("-"*80)

    all_power = {}
    for df in dataflows:
        all_power[df] = parser.parse_power(df)

    power_metrics = ['Total (W)', 'Dynamic (W)', 'Static (W)']
    for metric in power_metrics:
        row = [metric]
        for df in dataflows:
            value = all_power[df].get(metric, 'N/A')
            row.append(str(value))
        print(f"{row[0]:<20} {row[1]:<15} {row[2]:<15} {row[3]:<15}")

    # 性能指标对比
    print("\n4. Performance Metrics")
    print("-"*80)
    print(f"{'Metric':<30} {'WS':<20} {'IS':<20} {'OS':<20}")
    print("-"*80)

    for df in dataflows:
        all_perf[df] = calculate_performance_metrics(all_util[df], all_power[df])

    perf_metrics = ['Throughput (GMAC/s)', 'Energy Efficiency (GMAC/W)',
                    'Area Efficiency (GMAC/KLUT)']
    for metric in perf_metrics:
        row = [metric]
        for df in dataflows:
            value = all_perf[df].get(metric, 'N/A')
            if value != 'N/A':
                row.append(f"{value:.3f}")
            else:
                row.append('N/A')
        print(f"{row[0]:<30} {row[1]:<20} {row[2]:<20} {row[3]:<20}")

    print("\n" + "="*80)


def generate_json_report(dataflows: List[str], parser: ReportParser, output_file: str = "dataflow_comparison.json"):
    """生成 JSON 格式的对比报告"""

    report = {
        'dataflows': {}
    }

    for df in dataflows:
        report['dataflows'][df] = {
            'utilization': parser.parse_utilization(df),
            'timing': parser.parse_timing(df),
            'power': parser.parse_power(df)
        }

        # 计算性能指标
        util = report['dataflows'][df]['utilization']
        power = report['dataflows'][df]['power']
        report['dataflows'][df]['performance'] = \
            calculate_performance_metrics(util, power)

    # 保存 JSON 文件
    with open(output_file, 'w') as f:
        json.dump(report, f, indent=2)

    print(f"\n✅ JSON report saved to: {output_file}")


def generate_recommendations(dataflows: List[str], parser: ReportParser):
    """生成推荐建议"""

    print("\n5. Recommendations")
    print("-"*80)

    # 获取所有数据
    all_data = {}
    for df in dataflows:
        all_data[df] = {
            'util': parser.parse_utilization(df),
            'timing': parser.parse_timing(df),
            'power': parser.parse_power(df)
        }

    # 功耗最低推荐
    print("\n💡 Lowest Power:")
    min_power_df = min(dataflows,
                       key=lambda x: all_data[x]['power'].get('Total (W)', float('inf')))
    print(f"   → {min_power_df} dataflow has the lowest power consumption")
    print(f"     ({all_data[min_power_df]['power'].get('Total (W)', 'N/A')} W)")

    # 资源最少推荐
    print("\n💡 Lowest Resource Usage:")
    min_lut_df = min(dataflows,
                     key=lambda x: all_data[x]['util'].get('LUT', float('inf')))
    print(f"   → {min_lut_df} dataflow uses the fewest LUTs")
    print(f"     ({all_data[min_lut_df]['util'].get('LUT', 'N/A')} LUTs)")

    # 最高能效推荐
    print("\n💡 Best Energy Efficiency:")
    best_eff_df = None
    best_eff = 0

    for df in dataflows:
        power = all_data[df]['power'].get('Total (W)', 0)
        if power > 0:
            eff = 1.6 / power  # GMAC/s / W
            if eff > best_eff:
                best_eff = eff
                best_eff_df = df

    if best_eff_df:
        print(f"   → {best_eff_df} dataflow has the best energy efficiency")
        print(f"     ({best_eff:.3f} GMAC/W)")

    print("\n6. Application Recommendations")
    print("-"*80)
    print("   • CNN Inference    → WS (Weights Stationary)")
    print("   • RNN/LSTM         → IS (Input Stationary)")
    print("   • Fully Connected  → OS (Output Stationary)")
    print("   • General Purpose  → OS (Output Stationary)")


def main():
    """主函数"""

    print("="*80)
    print("SYSTOLIC ARRAY DATAFLOW PERFORMANCE COMPARISON")
    print("="*80)

    # 数据流类型
    dataflows = ['ws', 'is', 'os']

    # 创建报告解析器
    parser = ReportParser()

    # 打印对比表格
    print_comparison_table(dataflows, parser)

    # 生成 JSON 报告
    generate_json_report(dataflows, parser)

    # 生成推荐建议
    generate_recommendations(dataflows, parser)

    print("\n" + "="*80)
    print("✅ Comparison complete!")
    print("="*80 + "\n")


if __name__ == "__main__":
    main()
