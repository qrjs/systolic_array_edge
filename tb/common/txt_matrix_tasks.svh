// ANSI 颜色码：用于在支持彩色输出的终端中高亮 PASS / FAIL。
localparam string ANSI_GREEN = "\033[32m";
localparam string ANSI_RED   = "\033[31m";
localparam string ANSI_CYAN  = "\033[36m";
localparam string ANSI_BOLD  = "\033[1m";
localparam string ANSI_RESET = "\033[0m";
localparam integer MATRIX_CELL_W = 12;

// 读取输入 txt 中的 A、B 矩阵。
// 文件格式约定为：先出现 A 段，再出现 B 段，中间允许用 # 开头的注释行。
task automatic read_input_txt(input string path);
    integer fd;
    integer row_idx;
    integer col_idx;
    integer scan_rc;
    integer value;
    string token;
    reg [8*256-1:0] rest;
    fd = $fopen(path, "r");
    if (fd == 0) begin
        $fatal(1, "Failed to open input txt: %s", path);
    end

    scan_rc = 1;
    while (scan_rc == 1) begin
        scan_rc = $fscanf(fd, "%s", token);
        if (scan_rc == 1) begin
        if (token == "#") begin
            void'($fgets(rest, fd));
        end else if (token == "A") begin
            for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
                for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                    if ($fscanf(fd, "%d", value) != 1) begin
                        $fatal(1, "Malformed A section in %s", path);
                    end
                    a_matrix[row_idx][col_idx] = value;
                end
            end
        end else if (token == "B") begin
            for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
                for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                    if ($fscanf(fd, "%d", value) != 1) begin
                        $fatal(1, "Malformed B section in %s", path);
                    end
                    b_matrix[row_idx][col_idx] = value;
                end
            end
        end else begin
            void'($fgets(rest, fd));
        end
        end
    end

    $fclose(fd);
endtask

// 读取标准答案 txt 中的 C 矩阵。
task automatic read_expected_txt(input string path);
    integer fd;
    integer row_idx;
    integer col_idx;
    integer scan_rc;
    integer value;
    string token;
    reg [8*256-1:0] rest;
    fd = $fopen(path, "r");
    if (fd == 0) begin
        $fatal(1, "Failed to open expected txt: %s", path);
    end

    scan_rc = 1;
    while (scan_rc == 1) begin
        scan_rc = $fscanf(fd, "%s", token);
        if (scan_rc == 1) begin
        if (token == "#") begin
            void'($fgets(rest, fd));
        end else if (token == "C") begin
            for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
                for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                    if ($fscanf(fd, "%d", value) != 1) begin
                        $fatal(1, "Malformed C section in %s", path);
                    end
                    expected_matrix[row_idx][col_idx] = value;
                end
            end
        end else begin
            void'($fgets(rest, fd));
        end
        end
    end

    $fclose(fd);
endtask

// 打印矩阵表头，让 c0/c1/c2/c3 与后续数值列对齐。
task automatic print_matrix_header(input string tag, input string title);
    integer col_idx;
    string col_label;
    $display("%0s[%0s][%0s]%0s", ANSI_CYAN, tag, title, ANSI_RESET);
    $write("  %8s", "");
    for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
        col_label = $sformatf("c%0d", col_idx);
        $write("%12s", col_label);
    end
    $write("\n");
    $write("  %8s", "--------");
    for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
        $write("%12s", "------------");
    end
    $write("\n");
endtask

// 每个文件用例开始前打印关键上下文：
// 1) 输入文件路径与标准答案路径
// 2) A、B、EXPECTED_C 三个矩阵，并按行列对齐展示
task automatic print_case_context(input string tag, input string input_path, input string expected_path);
    integer row_idx;
    integer col_idx;
    $display("%0s[%0s][CASE]%0s input=%0s expected=%0s", ANSI_CYAN, tag, ANSI_RESET, input_path, expected_path);

    print_matrix_header(tag, "MATRIX_A");
    for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
        $write("  row%-5d", row_idx);
        for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
            $write("%12d", a_matrix[row_idx][col_idx]);
        end
        $write("\n");
    end

    print_matrix_header(tag, "MATRIX_B");
    for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
        $write("  row%-5d", row_idx);
        for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
            $write("%12d", b_matrix[row_idx][col_idx]);
        end
        $write("\n");
    end

    print_matrix_header(tag, "EXPECTED_C");
    for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
        $write("  row%-5d", row_idx);
        for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
            $write("%12d", expected_matrix[row_idx][col_idx]);
        end
        $write("\n");
    end
endtask

// 基于 A、B 两个输入矩阵统计“零值感知门控”可跳过的乘加次数。
// 对 4x4 GEMM 而言，总乘加机会恒为 4*4*4=64 次；
// 当 A[row][k] == 0 或 B[k][col] == 0 时，该次 MAC 对最终结果贡献为 0，
// 在硬件里可以直接旁路乘法器与加法器，减少无效翻转功耗。
task automatic report_zero_skip_stats(input string tag);
    integer row_idx;
    integer col_idx;
    integer k_idx;
    integer total_mac;
    integer active_mac;
    integer skipped_zero_mac;
    integer a_nonzero;
    integer b_nonzero;
    integer skip_permille;
    integer skip_int;
    integer skip_frac;
    begin
        total_mac = 0;
        active_mac = 0;
        skipped_zero_mac = 0;
        a_nonzero = 0;
        b_nonzero = 0;

        for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
            for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                if (a_matrix[row_idx][col_idx] != 0) begin
                    a_nonzero = a_nonzero + 1;
                end
                if (b_matrix[row_idx][col_idx] != 0) begin
                    b_nonzero = b_nonzero + 1;
                end
            end
        end

        for (row_idx = 0; row_idx < ARRAY_SIZE; row_idx = row_idx + 1) begin
            for (col_idx = 0; col_idx < ARRAY_SIZE; col_idx = col_idx + 1) begin
                for (k_idx = 0; k_idx < ARRAY_SIZE; k_idx = k_idx + 1) begin
                    total_mac = total_mac + 1;
                    if ((a_matrix[row_idx][k_idx] != 0) && (b_matrix[k_idx][col_idx] != 0)) begin
                        active_mac = active_mac + 1;
                    end else begin
                        skipped_zero_mac = skipped_zero_mac + 1;
                    end
                end
            end
        end

        skip_permille = (total_mac == 0) ? 0 : ((skipped_zero_mac * 1000) / total_mac);
        skip_int = skip_permille / 10;
        skip_frac = skip_permille % 10;

        $display(
            "%0s[%0s][POWER]%0s A_nz=%0d/%0d B_nz=%0d/%0d active_mac=%0d/%0d zero_gated=%0d skip_ratio=%0d.%0d%%",
            ANSI_CYAN,
            tag,
            ANSI_RESET,
            a_nonzero,
            ARRAY_SIZE * ARRAY_SIZE,
            b_nonzero,
            ARRAY_SIZE * ARRAY_SIZE,
            active_mac,
            total_mac,
            skipped_zero_mac,
            skip_int,
            skip_frac
        );
    end
endtask

// 逐元素打印 expected / actual / PASS|FAIL。
// failures 的累计由调用方自己控制，这个任务只负责把关键信息打印清楚。
task automatic report_cell_compare(
    input string tag,
    input integer row_idx,
    input integer col_idx,
    input signed [ACC_WIDTH-1:0] expected_value,
    input signed [ACC_WIDTH-1:0] actual_value
);
    string verdict;
    if (actual_value === expected_value) begin
        verdict = {ANSI_GREEN, ANSI_BOLD, "PASS", ANSI_RESET};
    end else begin
        verdict = {ANSI_RED, ANSI_BOLD, "FAIL", ANSI_RESET};
    end
    $display(
        "[%0s][CHECK] row=%-2d col=%-2d expected=%12d actual=%12d => %0s",
        tag, row_idx, col_idx, expected_value, actual_value, verdict
    );
endtask
