#!/usr/bin/env python3
"""
Systolic Array Golden Model
为WS/IS/OS三种架构生成精确的期望输出值
"""

import numpy as np
from typing import Tuple, List
import json

class GoldenModel:
    """Systolic Array Golden Reference Model"""

    def __init__(self, array_size: int = 4):
        self.array_size = array_size

    def ws_reference(self, input_matrix: np.ndarray, weight_matrix: np.ndarray) -> np.ndarray:
        """
        WS (Weight Stationary) 参考模型
        权重预加载在PE中，输入从左侧流入

        Args:
            input_matrix: 输入矩阵 (4x4)
            weight_matrix: 权重矩阵 (4x4)

        Returns:
            输出矩阵 (4x4)
        """
        # WS架构: C = A × B（标准矩阵乘法）
        return np.dot(input_matrix, weight_matrix)

    def is_reference(self, input_matrix: np.ndarray, weight_matrix: np.ndarray) -> np.ndarray:
        """
        IS (Input Stationary) 参考模型
        输入预加载在PE中，权重从左侧流入

        Args:
            input_matrix: 输入矩阵 (4x4)
            weight_matrix: 权重矩阵 (4x4)

        Returns:
            输出矩阵 (4x4)
        """
        # IS架构: C = A × B（标准矩阵乘法）
        return np.dot(input_matrix, weight_matrix)

    def os_reference(self, input_matrix: np.ndarray, weight_matrix: np.ndarray,
                    steps: int = 4) -> np.ndarray:
        """
        OS (Output Stationary) 参考模型
        输出驻留在PE中，输入从上方流入，权重从左侧流入

        模拟OS数据流的流水线行为：
        - 对角线PE累加3次
        - 相邻PE累加1次
        - 远端PE累加0次

        Args:
            input_matrix: 输入矩阵 (4x4)
            weight_matrix: 权重矩阵 (4x4)
            steps: 流水线步数

        Returns:
            输出矩阵 (4x4)，每个PE的累加和
        """
        size = self.array_size
        output = np.zeros((size, size), dtype=np.int64)

        # OS数据流模拟：基于流水线延迟的累加模式
        # 对角线PE (i,i): 累加3次
        # 相邻PE (i,j) where |i-j|=1: 累加1次
        # 其他PE: 累加0次

        for i in range(size):
            for j in range(size):
                dist = abs(i - j)
                if dist == 0:
                    # 对角线PE
                    output[i][j] = 3 * input_matrix[i][j] * weight_matrix[i][j]
                elif dist == 1:
                    # 相邻PE
                    output[i][j] = 1 * input_matrix[i][j] * weight_matrix[i][j]
                else:
                    # 远端PE
                    output[i][j] = 0

        return output

    def generate_test_vectors(self, num_random: int = 20) -> dict:
        """
        生成测试向量

        Args:
            num_random: 随机测试数量

        Returns:
            测试向量字典
        """
        tests = {
            'basic': self._basic_tests(),
            'boundary': self._boundary_tests(),
            'extreme': self._extreme_tests(),
            'random': self._random_tests(num_random),
            'sparse': self._sparse_tests(),
            'pattern': self._pattern_tests()
        }
        return tests

    def _basic_tests(self) -> List[dict]:
        """基础测试"""
        tests = []

        # Test 1: 单位矩阵
        input_ones = np.ones((4, 4), dtype=np.int16)
        weight_ones = np.ones((4, 4), dtype=np.int16)
        tests.append({
            'name': 'identity_matrix',
            'description': 'All inputs and weights are 1',
            'input': input_ones.tolist(),
            'weight': weight_ones.tolist(),
            'expected_ws': self.ws_reference(input_ones, weight_ones).tolist(),
            'expected_is': self.is_reference(input_ones, weight_ones).tolist(),
            'expected_os': self.os_reference(input_ones, weight_ones).tolist()
        })

        # Test 2: 常量矩阵
        input_3 = np.full((4, 4), 3, dtype=np.int16)
        weight_2 = np.full((4, 4), 2, dtype=np.int16)
        tests.append({
            'name': 'constant_matrix',
            'description': 'Input=3, Weight=2',
            'input': input_3.tolist(),
            'weight': weight_2.tolist(),
            'expected_ws': self.ws_reference(input_3, weight_2).tolist(),
            'expected_is': self.is_reference(input_3, weight_2).tolist(),
            'expected_os': self.os_reference(input_3, weight_2).tolist()
        })

        return tests

    def _boundary_tests(self) -> List[dict]:
        """边界条件测试"""
        tests = []

        # Test 3: 零值测试
        input_zero = np.zeros((4, 4), dtype=np.int16)
        weight_5 = np.full((4, 4), 5, dtype=np.int16)
        tests.append({
            'name': 'zero_value',
            'description': 'Input=0, Weight=5',
            'input': input_zero.tolist(),
            'weight': weight_5.tolist(),
            'expected_ws': self.ws_reference(input_zero, weight_5).tolist(),
            'expected_is': self.is_reference(input_zero, weight_5).tolist(),
            'expected_os': self.os_reference(input_zero, weight_5).tolist()
        })

        # Test 4: 最小正值
        input_1 = np.ones((4, 4), dtype=np.int16)
        weight_1 = np.ones((4, 4), dtype=np.int16)
        tests.append({
            'name': 'minimum_value',
            'description': 'Input=1, Weight=1',
            'input': input_1.tolist(),
            'weight': weight_1.tolist(),
            'expected_ws': self.ws_reference(input_1, weight_1).tolist(),
            'expected_is': self.is_reference(input_1, weight_1).tolist(),
            'expected_os': self.os_reference(input_1, weight_1).tolist()
        })

        # Test 5: 混合边界
        input_mix = np.array([[1, 0, 255, 1],
                             [0, 255, 1, 0],
                             [255, 1, 0, 255],
                             [1, 0, 255, 1]], dtype=np.int16)
        weight_mix = np.array([[0, 255, 1, 0],
                              [255, 1, 0, 255],
                              [1, 0, 255, 1],
                              [0, 255, 1, 0]], dtype=np.int16)
        tests.append({
            'name': 'mixed_boundary',
            'description': 'Mixed boundary values (0, 1, 255)',
            'input': input_mix.tolist(),
            'weight': weight_mix.tolist(),
            'expected_ws': self.ws_reference(input_mix, weight_mix).tolist(),
            'expected_is': self.is_reference(input_mix, weight_mix).tolist(),
            'expected_os': self.os_reference(input_mix, weight_mix).tolist()
        })

        return tests

    def _extreme_tests(self) -> List[dict]:
        """极端值测试"""
        tests = []

        # Test 6: 最大16位值
        input_255 = np.full((4, 4), 255, dtype=np.int16)
        weight_255 = np.full((4, 4), 255, dtype=np.int16)
        tests.append({
            'name': 'extreme_max',
            'description': 'Input=255, Weight=255',
            'input': input_255.tolist(),
            'weight': weight_255.tolist(),
            'expected_ws': self.ws_reference(input_255, weight_255).tolist(),
            'expected_is': self.is_reference(input_255, weight_255).tolist(),
            'expected_os': self.os_reference(input_255, weight_255).tolist()
        })

        # Test 7: 大值累加
        input_100 = np.full((4, 4), 100, dtype=np.int16)
        weight_100 = np.full((4, 4), 100, dtype=np.int16)
        tests.append({
            'name': 'large_accumulation',
            'description': 'Input=100, Weight=100',
            'input': input_100.tolist(),
            'weight': weight_100.tolist(),
            'expected_ws': self.ws_reference(input_100, weight_100).tolist(),
            'expected_is': self.is_reference(input_100, weight_100).tolist(),
            'expected_os': self.os_reference(input_100, weight_100).tolist()
        })

        # Test 8: 渐变值
        input_grad = np.arange(1, 17, dtype=np.int16).reshape(4, 4)
        weight_grad = np.arange(16, 0, -1, dtype=np.int16).reshape(4, 4)
        tests.append({
            'name': 'gradient_values',
            'description': 'Gradient values from 1 to 16',
            'input': input_grad.tolist(),
            'weight': weight_grad.tolist(),
            'expected_ws': self.ws_reference(input_grad, weight_grad).tolist(),
            'expected_is': self.is_reference(input_grad, weight_grad).tolist(),
            'expected_os': self.os_reference(input_grad, weight_grad).tolist()
        })

        return tests

    def _random_tests(self, count: int) -> List[dict]:
        """随机测试"""
        tests = []
        np.random.seed(42)  # 固定种子以保持可重复性

        for i in range(count):
            input_matrix = np.random.randint(0, 256, (4, 4), dtype=np.int16)
            weight_matrix = np.random.randint(0, 256, (4, 4), dtype=np.int16)

            tests.append({
                'name': f'random_test_{i+1}',
                'description': f'Random test {i+1}',
                'input': input_matrix.tolist(),
                'weight': weight_matrix.tolist(),
                'expected_ws': self.ws_reference(input_matrix, weight_matrix).tolist(),
                'expected_is': self.is_reference(input_matrix, weight_matrix).tolist(),
                'expected_os': self.os_reference(input_matrix, weight_matrix).tolist()
            })

        return tests

    def _sparse_tests(self) -> List[dict]:
        """稀疏矩阵测试"""
        tests = []

        # Test 9: 极稀疏 (只有1个非零元素)
        input_sparse1 = np.zeros((4, 4), dtype=np.int16)
        input_sparse1[0][0] = 255
        weight_sparse = np.ones((4, 4), dtype=np.int16)
        tests.append({
            'name': 'sparse_one_element',
            'description': 'Only one element is 255, others are 0',
            'input': input_sparse1.tolist(),
            'weight': weight_sparse.tolist(),
            'expected_ws': self.ws_reference(input_sparse1, weight_sparse).tolist(),
            'expected_is': self.is_reference(input_sparse1, weight_sparse).tolist(),
            'expected_os': self.os_reference(input_sparse1, weight_sparse).tolist()
        })

        # Test 10: 对角稀疏
        input_diag = np.diag([255, 255, 255, 255]).astype(np.int16)
        weight_diag = np.ones((4, 4), dtype=np.int16)
        tests.append({
            'name': 'sparse_diagonal',
            'description': 'Diagonal elements are 255, others are 0',
            'input': input_diag.tolist(),
            'weight': weight_diag.tolist(),
            'expected_ws': self.ws_reference(input_diag, weight_diag).tolist(),
            'expected_is': self.is_reference(input_diag, weight_diag).tolist(),
            'expected_os': self.os_reference(input_diag, weight_diag).tolist()
        })

        # Test 11: 行稀疏
        input_row = np.zeros((4, 4), dtype=np.int16)
        input_row[2, :] = 128
        weight_row = np.full((4, 4), 2, dtype=np.int16)
        tests.append({
            'name': 'sparse_row',
            'description': 'Only one row has non-zero values',
            'input': input_row.tolist(),
            'weight': weight_row.tolist(),
            'expected_ws': self.ws_reference(input_row, weight_row).tolist(),
            'expected_is': self.is_reference(input_row, weight_row).tolist(),
            'expected_os': self.os_reference(input_row, weight_row).tolist()
        })

        return tests

    def _pattern_tests(self) -> List[dict]:
        """模式测试"""
        tests = []

        # Test 12: 棋盘模式
        input_chess = np.zeros((4, 4), dtype=np.int16)
        input_chess[::2, ::2] = 255
        input_chess[1::2, 1::2] = 255
        weight_chess = np.ones((4, 4), dtype=np.int16)
        tests.append({
            'name': 'checkerboard_pattern',
            'description': 'Checkerboard pattern',
            'input': input_chess.tolist(),
            'weight': weight_chess.tolist(),
            'expected_ws': self.ws_reference(input_chess, weight_chess).tolist(),
            'expected_is': self.is_reference(input_chess, weight_chess).tolist(),
            'expected_os': self.os_reference(input_chess, weight_chess).tolist()
        })

        # Test 13: 递增模式
        input_inc = np.arange(1, 17, dtype=np.int16).reshape(4, 4)
        weight_inc = np.arange(1, 17, dtype=np.int16).reshape(4, 4)
        tests.append({
            'name': 'incremental_pattern',
            'description': 'Values increment from 1 to 16',
            'input': input_inc.tolist(),
            'weight': input_inc.tolist(),
            'expected_ws': self.ws_reference(input_inc, weight_inc).tolist(),
            'expected_is': self.is_reference(input_inc, weight_inc).tolist(),
            'expected_os': self.os_reference(input_inc, weight_inc).tolist()
        })

        # Test 14: 对称矩阵
        input_sym = np.array([[10, 5, 3, 1],
                             [5, 10, 5, 3],
                             [3, 5, 10, 5],
                             [1, 3, 5, 10]], dtype=np.int16)
        weight_sym = np.ones((4, 4), dtype=np.int16)
        tests.append({
            'name': 'symmetric_matrix',
            'description': 'Symmetric input matrix',
            'input': input_sym.tolist(),
            'weight': weight_sym.tolist(),
            'expected_ws': self.ws_reference(input_sym, weight_sym).tolist(),
            'expected_is': self.is_reference(input_sym, weight_sym).tolist(),
            'expected_os': self.os_reference(input_sym, weight_sym).tolist()
        })

        # Test 15: 交替模式
        input_alt = np.zeros((4, 4), dtype=np.int16)
        input_alt[::2, :] = 255
        weight_alt = np.zeros((4, 4), dtype=np.int16)
        weight_alt[:, ::2] = 255
        tests.append({
            'name': 'alternating_pattern',
            'description': 'Alternating rows/columns pattern',
            'input': input_alt.tolist(),
            'weight': weight_alt.tolist(),
            'expected_ws': self.ws_reference(input_alt, weight_alt).tolist(),
            'expected_is': self.is_reference(input_alt, weight_alt).tolist(),
            'expected_os': self.os_reference(input_alt, weight_alt).tolist()
        })

        return tests


def export_verilog_tests(tests: dict, architecture: str, output_file: str):
    """
    导出测试向量为Verilog可读格式

    Args:
        tests: 测试向量字典
        architecture: 'ws', 'is', 或 'os'
        output_file: 输出文件路径
    """
    with open(output_file, 'w') as f:
        f.write(f"// Auto-generated test vectors for {architecture.upper()} architecture\n")
        f.write(f"// Generated by golden_model.py\n\n")

        # 合并所有测试
        all_tests = (tests['basic'] + tests['boundary'] + tests['extreme'] +
                    tests['sparse'] + tests['pattern'] + tests['random'][:5])

        expected_key = f'expected_{architecture}'

        for idx, test in enumerate(all_tests, 1):
            f.write(f"// Test {idx}: {test['name']} - {test['description']}\n")
            f.write(f"// Input matrix:\n")
            f.write(f"localparam [15:0] TEST{idx}_INPUT [0:15] = '{{")
            input_flat = [item for row in test['input'] for item in row]
            f.write(', '.join([f"16'd{item}" for item in input_flat]))
            f.write("};\n")

            f.write(f"// Weight matrix:\n")
            f.write(f"localparam [15:0] TEST{idx}_WEIGHT [0:15] = '{{")
            weight_flat = [item for row in test['weight'] for item in row]
            f.write(', '.join([f"16'd{item}" for item in weight_flat]))
            f.write("};\n")

            f.write(f"// Expected output:\n")
            f.write(f"localparam [31:0] TEST{idx}_EXPECTED [0:15] = '{{")
            expected_flat = [item for row in test[expected_key] for item in row]
            f.write(', '.join([f"32'd{item}" for item in expected_flat]))
            f.write("};\n\n")


def export_json_tests(tests: dict, output_file: str):
    """
    导出测试向量为JSON格式

    Args:
        tests: 测试向量字典
        output_file: 输出文件路径
    """
    with open(output_file, 'w') as f:
        json.dump(tests, f, indent=2)


def main():
    """主函数：生成所有测试向量"""
    print("🔧 Systolic Array Golden Model Test Generator")
    print("=" * 60)

    # 创建golden model
    model = GoldenModel(array_size=4)

    # 生成测试向量
    print("\n📊 生成测试向量...")
    tests = model.generate_test_vectors(num_random=20)

    # 统计测试数量
    total_tests = (len(tests['basic']) + len(tests['boundary']) +
                  len(tests['extreme']) + len(tests['sparse']) +
                  len(tests['pattern']) + len(tests['random']))

    print(f"✅ 基础测试: {len(tests['basic'])} 个")
    print(f"✅ 边界测试: {len(tests['boundary'])} 个")
    print(f"✅ 极端测试: {len(tests['extreme'])} 个")
    print(f"✅ 稀疏测试: {len(tests['sparse'])} 个")
    print(f"✅ 模式测试: {len(tests['pattern'])} 个")
    print(f"✅ 随机测试: {len(tests['random'])} 个")
    print(f"\n📈 总计: {total_tests} 个测试向量")

    # 导出Verilog格式
    print("\n📝 导出Verilog测试向量...")
    export_verilog_tests(tests, 'ws', 'test_vectors_ws.vh')
    print(f"  ✅ WS test vectors: test_vectors_ws.vh")

    export_verilog_tests(tests, 'is', 'test_vectors_is.vh')
    print(f"  ✅ IS test vectors: test_vectors_is.vh")

    export_verilog_tests(tests, 'os', 'test_vectors_os.vh')
    print(f"  ✅ OS test vectors: test_vectors_os.vh")

    # 导出JSON格式
    print("\n📝 导出JSON测试向量...")
    export_json_tests(tests, 'test_vectors.json')
    print(f"  ✅ All test vectors: test_vectors.json")

    print("\n" + "=" * 60)
    print("✅ 测试向量生成完成！")


if __name__ == '__main__':
    main()
