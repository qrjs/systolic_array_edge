//==============================================================================
// Golden Model for Systolic Array Matrix Multiplication
// 功能：提供参考结果用于验证
// 支持：IS, WS, OS 三种数据流架构
//==============================================================================

#include <iostream>
#include <vector>
#include <iomanip>
#include <fstream>
#include <string>
#include <cmath>
#include <cstdint>

class GoldenModel {
public:
    //==========================================================================
    // 矩阵乘法：C = A × B
    //==========================================================================
    static std::vector<std::vector<int32_t>> matrix_multiply(
        const std::vector<std::vector<int16_t>>& A,
        const std::vector<std::vector<int16_t>>& B) {

        int M = A.size();
        int K = A[0].size();
        int N = B[0].size();

        std::vector<std::vector<int32_t>> C(M, std::vector<int32_t>(N, 0));

        for (int i = 0; i < M; i++) {
            for (int j = 0; j < N; j++) {
                int32_t sum = 0;
                for (int k = 0; k < K; k++) {
                    sum += static_cast<int32_t>(A[i][k]) * static_cast<int32_t>(B[k][j]);
                }
                C[i][j] = sum;
            }
        }

        return C;
    }

    //==========================================================================
    // 生成测试矩阵
    //==========================================================================
    static std::vector<std::vector<int16_t>> generate_identity_matrix(int size, int16_t value = 1) {
        std::vector<std::vector<int16_t>> mat(size, std::vector<int16_t>(size, 0));
        for (int i = 0; i < size; i++) {
            mat[i][i] = value;
        }
        return mat;
    }

    static std::vector<std::vector<int16_t>> generate_constant_matrix(int rows, int cols, int16_t value) {
        std::vector<std::vector<int16_t>> mat(rows, std::vector<int16_t>(cols, value));
        return mat;
    }

    static std::vector<std::vector<int16_t>> generate_zero_matrix(int rows, int cols) {
        return generate_constant_matrix(rows, cols, 0);
    }

    static std::vector<std::vector<int16_t>> generate_diagonal_matrix(int size, int16_t value) {
        std::vector<std::vector<int16_t>> mat(size, std::vector<int16_t>(size, 0));
        for (int i = 0; i < size; i++) {
            mat[i][i] = value;
        }
        return mat;
    }

    static std::vector<std::vector<int16_t>> generate_random_matrix(int rows, int cols, int16_t min_val, int16_t max_val) {
        std::vector<std::vector<int16_t>> mat(rows, std::vector<int16_t>(cols));
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                mat[i][j] = min_val + (rand() % (max_val - min_val + 1));
            }
        }
        return mat;
    }

    static std::vector<std::vector<int16_t>> generate_sparse_matrix(int size, int16_t value, int num_nonzero) {
        std::vector<std::vector<int16_t>> mat = generate_zero_matrix(size, size);
        int count = 0;
        while (count < num_nonzero) {
            int i = rand() % size;
            int j = rand() % size;
            if (mat[i][j] == 0) {
                mat[i][j] = value;
                count++;
            }
        }
        return mat;
    }

    static std::vector<std::vector<int16_t>> generate_alternating_matrix(int rows, int cols, int16_t val1, int16_t val2) {
        std::vector<std::vector<int16_t>> mat(rows, std::vector<int16_t>(cols));
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                mat[i][j] = ((i + j) % 2 == 0) ? val1 : val2;
            }
        }
        return mat;
    }

    //==========================================================================
    // 输出矩阵到文件（用于测试向量生成）
    //==========================================================================
    static void export_matrix_hex(const std::vector<std::vector<int16_t>>& mat,
                                   const std::string& filename) {
        std::ofstream f(filename);
        f << "// Matrix " << mat.size() << "x" << mat[0].size() << "\n";
        for (size_t i = 0; i < mat.size(); i++) {
            for (size_t j = 0; j < mat[i].size(); j++) {
                f << std::hex << std::setfill('0') << std::setw(4) << (mat[i][j] & 0xFFFF) << " ";
            }
            f << "\n";
        }
        f.close();
    }

    static void export_results_hex(const std::vector<std::vector<int32_t>>& mat,
                                    const std::string& filename) {
        std::ofstream f(filename);
        f << "// Results " << mat.size() << "x" << mat[0].size() << "\n";
        for (size_t i = 0; i < mat.size(); i++) {
            for (size_t j = 0; j < mat[i].size(); j++) {
                f << "0x" << std::hex << std::setfill('0') << std::setw(8)
                  << (static_cast<uint32_t>(mat[i][j]) & 0xFFFFFFFF) << " ";
            }
            f << "\n";
        }
        f.close();
    }

    //==========================================================================
    // 生成 Verilog 测试向量文件
    //==========================================================================
    static void generate_verilog_testvector(const std::string& test_name,
                                             const std::vector<std::vector<int16_t>>& A,
                                             const std::vector<std::vector<int16_t>>& B,
                                             const std::vector<std::vector<int32_t>>& C) {
        std::string filename = "../tb/test_vectors/" + test_name + "_tv.v";
        std::ofstream f(filename);

        f << "//==============================================================================\n";
        f << "// Test Vector: " << test_name << "\n";
        f << "// Auto-generated by golden_model.cpp\n";
        f << "//==============================================================================\n\n";

        f << "`define MATRIX_A_" << test_name << " {\n";
        for (size_t i = 0; i < A.size(); i++) {
            f << "    ";
            for (size_t j = 0; j < A[i].size(); j++) {
                f << std::dec << A[i][j];
                if (j < A[i].size() - 1) f << ", ";
            }
            f << "\n";
        }
        f << "}\n\n";

        f << "`define MATRIX_B_" << test_name << " {\n";
        for (size_t i = 0; i < B.size(); i++) {
            f << "    ";
            for (size_t j = 0; j < B[i].size(); j++) {
                f << std::dec << B[i][j];
                if (j < B[i].size() - 1) f << ", ";
            }
            f << "\n";
        }
        f << "}\n\n";

        f << "`define MATRIX_C_" << test_name << " {\n";
        for (size_t i = 0; i < C.size(); i++) {
            f << "    ";
            for (size_t j = 0; j < C[i].size(); j++) {
                f << std::dec << C[i][j];
                if (j < C[i].size() - 1) f << ", ";
            }
            f << "\n";
        }
        f << "}\n";

        f.close();
        std::cout << "Generated test vector: " << filename << std::endl;
    }
};

//==============================================================================
// 测试用例生成器
//==============================================================================
class TestCaseGenerator {
public:
    static void generate_all_test_cases() {
        std::cout << "\n========================================\n";
        std::cout << "Generating Golden Model Test Cases\n";
        std::cout << "========================================\n\n";

        // Test 1: Identity Matrix
        std::cout << "Test 1: Identity Matrix 4x4\n";
        auto A1 = GoldenModel::generate_identity_matrix(4, 1);
        auto B1 = GoldenModel::generate_identity_matrix(4, 1);
        auto C1 = GoldenModel::matrix_multiply(A1, B1);
        print_result("Identity 4x4", A1, B1, C1);
        GoldenModel::generate_verilog_testvector("identity_4x4", A1, B1, C1);

        // Test 2: Constant Matrix
        std::cout << "\nTest 2: Constant Matrix (all 3s)\n";
        auto A2 = GoldenModel::generate_constant_matrix(4, 4, 3);
        auto B2 = GoldenModel::generate_constant_matrix(4, 4, 2);
        auto C2 = GoldenModel::matrix_multiply(A2, B2);
        print_result("Constant", A2, B2, C2);
        GoldenModel::generate_verilog_testvector("constant_4x4", A2, B2, C2);

        // Test 3: Zero Matrix
        std::cout << "\nTest 3: Zero Matrix\n";
        auto A3 = GoldenModel::generate_zero_matrix(4, 4);
        auto B3 = GoldenModel::generate_constant_matrix(4, 4, 5);
        auto C3 = GoldenModel::matrix_multiply(A3, B3);
        print_result("Zero", A3, B3, C3);
        GoldenModel::generate_verilog_testvector("zero_4x4", A3, B3, C3);

        // Test 4: Large Values
        std::cout << "\nTest 4: Large Values (100 * 4 = 400)\n";
        auto A4 = GoldenModel::generate_constant_matrix(4, 4, 20);
        auto B4 = GoldenModel::generate_constant_matrix(4, 4, 20);
        auto C4 = GoldenModel::matrix_multiply(A4, B4);
        print_result("Large Values", A4, B4, C4);
        GoldenModel::generate_verilog_testvector("large_4x4", A4, B4, C4);

        // Test 5: Maximum Values
        std::cout << "\nTest 5: Maximum Values (255 * 4 = 1020)\n";
        auto A5 = GoldenModel::generate_constant_matrix(4, 4, 255);
        auto B5 = GoldenModel::generate_constant_matrix(4, 4, 1);
        auto C5 = GoldenModel::matrix_multiply(A5, B5);
        print_result("Max Values", A5, B5, C5);
        GoldenModel::generate_verilog_testvector("max_4x4", A5, B5, C5);

        // Test 6: Alternating Pattern
        std::cout << "\nTest 6: Alternating Pattern\n";
        auto A6 = GoldenModel::generate_alternating_matrix(4, 4, 1, 2);
        auto B6 = GoldenModel::generate_alternating_matrix(4, 4, 3, 1);
        auto C6 = GoldenModel::matrix_multiply(A6, B6);
        print_result("Alternating", A6, B6, C6);
        GoldenModel::generate_verilog_testvector("alternating_4x4", A6, B6, C6);

        // Test 7: Sparse Matrix
        std::cout << "\nTest 7: Sparse Matrix\n";
        auto A7 = GoldenModel::generate_sparse_matrix(4, 5, 8);
        auto B7 = GoldenModel::generate_sparse_matrix(4, 3, 6);
        auto C7 = GoldenModel::matrix_multiply(A7, B7);
        print_result("Sparse", A7, B7, C7);
        GoldenModel::generate_verilog_testvector("sparse_4x4", A7, B7, C7);

        // Test 8: Random Matrix
        std::cout << "\nTest 8: Random Matrix\n";
        srand(42); // Fixed seed for reproducibility
        auto A8 = GoldenModel::generate_random_matrix(4, 4, -10, 10);
        auto B8 = GoldenModel::generate_random_matrix(4, 4, -5, 15);
        auto C8 = GoldenModel::matrix_multiply(A8, B8);
        print_result("Random", A8, B8, C8);
        GoldenModel::generate_verilog_testvector("random_4x4", A8, B8, C8);

        // Test 9: Mixed Small Values
        std::cout << "\nTest 9: Mixed Small Values\n";
        std::vector<std::vector<int16_t>> A9 = {
            {1, 0, 2, 1},
            {0, 3, 1, 2},
            {2, 1, 0, 3},
            {1, 2, 3, 0}
        };
        std::vector<std::vector<int16_t>> B9 = {
            {2, 1, 0, 1},
            {1, 2, 3, 0},
            {0, 1, 2, 1},
            {3, 0, 1, 2}
        };
        auto C9 = GoldenModel::matrix_multiply(A9, B9);
        print_result("Mixed Small", A9, B9, C9);
        GoldenModel::generate_verilog_testvector("mixed_small_4x4", A9, B9, C9);

        // Test 10: Non-Symmetric
        std::cout << "\nTest 10: Non-Symmetric Matrix\n";
        std::vector<std::vector<int16_t>> A10 = {
            {1, 2, 3, 4},
            {5, 6, 7, 8},
            {9, 10, 11, 12},
            {13, 14, 15, 16}
        };
        std::vector<std::vector<int16_t>> B10 = {
            {16, 15, 14, 13},
            {12, 11, 10, 9},
            {8, 7, 6, 5},
            {4, 3, 2, 1}
        };
        auto C10 = GoldenModel::matrix_multiply(A10, B10);
        print_result("Non-Symmetric", A10, B10, C10);
        GoldenModel::generate_verilog_testvector("nonsym_4x4", A10, B10, C10);

        std::cout << "\n========================================\n";
        std::cout << "All test cases generated successfully!\n";
        std::cout << "========================================\n";
    }

private:
    static void print_result(const std::string& name,
                            const std::vector<std::vector<int16_t>>& A,
                            const std::vector<std::vector<int16_t>>& B,
                            const std::vector<std::vector<int32_t>>& C) {
        std::cout << "Matrix A (" << A.size() << "x" << A[0].size() << "):\n";
        print_matrix(A);
        std::cout << "\nMatrix B (" << B.size() << "x" << B[0].size() << "):\n";
        print_matrix(B);
        std::cout << "\nResult C = A × B:\n";
        print_matrix_int32(C);
        std::cout << "\n";
    }

    static void print_matrix(const std::vector<std::vector<int16_t>>& mat) {
        for (const auto& row : mat) {
            std::cout << "  [";
            for (size_t i = 0; i < row.size(); i++) {
                std::cout << std::setw(4) << row[i];
                if (i < row.size() - 1) std::cout << ", ";
            }
            std::cout << "]\n";
        }
    }

    static void print_matrix_int32(const std::vector<std::vector<int32_t>>& mat) {
        for (const auto& row : mat) {
            std::cout << "  [";
            for (size_t i = 0; i < row.size(); i++) {
                std::cout << std::setw(6) << row[i];
                if (i < row.size() - 1) std::cout << ", ";
            }
            std::cout << "]\n";
        }
    }
};

//==============================================================================
// Main
//==============================================================================
int main(int argc, char* argv[]) {
    std::cout << "\n";
    std::cout << "//==============================================================================\n";
    std::cout << "// Systolic Array Golden Model\n";
    std::cout << "// 用于生成测试向量和参考结果\n";
    std::cout << "//==============================================================================\n";

    TestCaseGenerator::generate_all_test_cases();

    return 0;
}
