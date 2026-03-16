#!/usr/bin/env python3
"""
Systolic Array 自动验证脚本
对比 DUT 输出与 Golden Model 输出
"""

import re
import sys
import subprocess
from pathlib import Path
from typing import List, Tuple, Dict
import json

class TestResult:
    def __init__(self, test_name: str, passed: bool, details: str = ""):
        self.test_name = test_name
        self.passed = passed
        self.details = details
        self.errors = []

    def to_dict(self):
        return {
            "test_name": self.test_name,
            "passed": self.passed,
            "details": self.details,
            "errors": self.errors
        }

class AutoChecker:
    def __init__(self, arch: str):
        """
        arch: "is", "ws", or "os"
        """
        self.arch = arch.upper()
        self.project_root = Path(__file__).parent.parent
        self.test_results = []

    def parse_output(self, output_file: str) -> List[int]:
        """解析仿真输出文件，提取输出数据"""
        outputs = []
        try:
            with open(output_file, 'r') as f:
                content = f.read()
                # 查找所有 output[i] = value
                matches = re.findall(r'output\[\d+\]\s*=\s*(-?\d+)', content)
                if matches:
                    outputs = [int(m) for m in matches]
                else:
                    # 尝试匹配 output[i][j] = value (OS架构)
                    matches = re.findall(r'output\[\d+\]\[\d+\]\s*=\s*(-?\d+)', content)
                    if matches:
                        outputs = [int(m) for m in matches]
        except FileNotFoundError:
            print(f"  ⚠️  Output file not found: {output_file}")
        return outputs

    def get_expected_output(self, test_case: str) -> List[int]:
        """从 golden model 获取期望输出"""
        # 从 golden model 生成的测试向量文件中读取
        tv_file = self.project_root / "tb" / "test_vectors" / f"{test_case}_tv.v"

        expected = []
        try:
            with open(tv_file, 'r') as f:
                in_result_block = False
                for line in f:
                    if '`define MATRIX_C' in line:
                        in_result_block = True
                        continue
                    if in_result_block:
                        if '}' in line:
                            break
                        # 提取数字
                        numbers = re.findall(r'-?\d+', line)
                        expected.extend([int(n) for n in numbers])
        except FileNotFoundError:
            print(f"  ⚠️  Test vector file not found: {tv_file}")

        return expected

    def compare_outputs(self, actual: List[int], expected: List[int]) -> Tuple[bool, str]:
        """对比实际输出和期望输出"""
        if len(actual) != len(expected):
            return False, f"Length mismatch: actual={len(actual)}, expected={len(expected)}"

        errors = []
        for i, (a, e) in enumerate(zip(actual, expected)):
            if a != e:
                errors.append(f"  [{i}] actual={a}, expected={e}")

        if errors:
            return False, "\n".join(errors)
        return True, "All outputs match"

    def run_simulation(self, testbench: str) -> Tuple[int, str, str]:
        """运行仿真"""
        arch_dir = self.project_root / self.arch.lower()
        tb_file = arch_dir / "tb" / testbench
        src_files = list((arch_dir / "src").glob("*.v"))

        # 编译
        cmd_compile = [
            "iverilog", "-g2012", "-o", "sim.vvp",
        ] + [str(f) for f in src_files] + [str(tb_file)]

        result = subprocess.run(cmd_compile, capture_output=True, text=True)
        if result.returncode != 0:
            return 1, "", result.stderr

        # 运行仿真
        cmd_sim = ["vvp", "sim.vvp"]
        result = subprocess.run(cmd_sim, capture_output=True, text=True)

        return result.returncode, result.stdout, result.stderr

    def run_test_case(self, test_name: str, testbench: str) -> TestResult:
        """运行单个测试用例"""
        print(f"\n{'='*60}")
        print(f"Test: {test_name} ({self.arch})")
        print('='*60)

        # 运行仿真
        returncode, stdout, stderr = self.run_simulation(testbench)

        if returncode != 0:
            error_msg = stderr if stderr else "Unknown error"
            print(f"  ❌ Simulation failed: {error_msg}")
            return TestResult(test_name, False, f"Simulation error: {error_msg}")

        # 解析输出
        # 保存输出到临时文件
        temp_output = f"/tmp/{self.arch}_{test_name}_output.txt"
        with open(temp_output, 'w') as f:
            f.write(stdout)

        actual_outputs = self.parse_output(temp_output)
        expected_outputs = self.get_expected_output(test_name)

        if not actual_outputs:
            return TestResult(test_name, False, "No outputs found")

        if not expected_outputs:
            return TestResult(test_name, False, "No expected outputs defined")

        # 对比
        passed, details = self.compare_outputs(actual_outputs, expected_outputs)

        if passed:
            print(f"  ✅ PASS: {details}")
        else:
            print(f"  ❌ FAIL:\n{details}")
            print(f"\n  Actual outputs:   {actual_outputs}")
            print(f"  Expected outputs: {expected_outputs}")

        result = TestResult(test_name, passed, details)
        if not passed:
            result.errors = details.split('\n')

        return result

    def generate_report(self, output_file: str = None):
        """生成测试报告"""
        total = len(self.test_results)
        passed = sum(1 for r in self.test_results if r.passed)
        failed = total - passed

        report = {
            "architecture": self.arch,
            "total_tests": total,
            "passed": passed,
            "failed": failed,
            "pass_rate": f"{(passed/total*100):.1f}%" if total > 0 else "0%",
            "results": [r.to_dict() for r in self.test_results]
        }

        if output_file:
            with open(output_file, 'w') as f:
                json.dump(report, f, indent=2)
            print(f"\n报告已保存到: {output_file}")

        return report

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 auto_check.py <arch> [test_name]")
        print("  arch: is, ws, or os")
        print("  test_name: optional, run specific test")
        sys.exit(1)

    arch = sys.argv[1].lower()
    if arch not in ['is', 'ws', 'os']:
        print(f"Unknown architecture: {arch}")
        sys.exit(1)

    checker = AutoChecker(arch)

    # 定义测试用例
    test_cases = {
        'is': [
            ('identity_4x4', 'systolic_array_is_tb.v'),
            ('constant_4x4', 'systolic_array_is_tb.v'),
            ('zero_4x4', 'systolic_array_is_tb.v'),
            ('large_4x4', 'systolic_array_is_tb.v'),
            ('max_4x4', 'systolic_array_is_tb.v'),
            ('alternating_4x4', 'systolic_array_is_tb.v'),
            ('sparse_4x4', 'systolic_array_is_tb.v'),
            ('mixed_small_4x4', 'systolic_array_is_tb.v'),
            ('nonsym_4x4', 'systolic_array_is_tb.v'),
            ('random_4x4', 'systolic_array_is_tb.v'),
        ],
        'ws': [
            ('identity_4x4', 'systolic_array_ws_tb.v'),
            ('constant_4x4', 'systolic_array_ws_tb.v'),
            ('zero_4x4', 'systolic_array_ws_tb.v'),
            ('large_4x4', 'systolic_array_ws_tb.v'),
            ('max_4x4', 'systolic_array_ws_tb.v'),
            ('alternating_4x4', 'systolic_array_ws_tb.v'),
            ('sparse_4x4', 'systolic_array_ws_tb.v'),
            ('mixed_small_4x4', 'systolic_array_ws_tb.v'),
            ('nonsym_4x4', 'systolic_array_ws_tb.v'),
            ('random_4x4', 'systolic_array_ws_tb.v'),
        ],
        'os': [
            ('identity_4x4', 'systolic_array_os_tb.v'),
            ('constant_4x4', 'systolic_array_os_tb.v'),
            ('zero_4x4', 'systolic_array_os_tb.v'),
            ('large_4x4', 'systolic_array_os_tb.v'),
            ('max_4x4', 'systolic_array_os_tb.v'),
            ('alternating_4x4', 'systolic_array_os_tb.v'),
            ('sparse_4x4', 'systolic_array_os_tb.v'),
            ('mixed_small_4x4', 'systolic_array_os_tb.v'),
            ('nonsym_4x4', 'systolic_array_os_tb.v'),
            ('random_4x4', 'systolic_array_os_tb.v'),
        ],
    }

    # 运行测试
    tests = test_cases.get(arch, [])

    for test_name, testbench in tests:
        result = checker.run_test_case(test_name, testbench)
        checker.test_results.append(result)

    # 生成报告
    print("\n" + "="*60)
    print("测试总结")
    print("="*60)

    report = checker.generate_report(f"test_results_{arch}.json")

    print(f"架构: {report['architecture']}")
    print(f"总测试数: {report['total_tests']}")
    print(f"通过: {report['passed']}")
    print(f"失败: {report['failed']}")
    print(f"通过率: {report['pass_rate']}")

    if report['failed'] > 0:
        print("\n失败的测试:")
        for r in checker.test_results:
            if not r.passed:
                print(f"  - {r.test_name}: {r.details}")
        sys.exit(1)
    else:
        print("\n✅ 所有测试通过!")
        sys.exit(0)

if __name__ == "__main__":
    main()
