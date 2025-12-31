module regfile_tb;
    logic clk, rst_n;
    logic [4:0] rs1, rs2, rd;
    logic [31:0] rd_data;
    logic we;
    logic [31:0] rs1_data, rs2_data;

    regfile dut (
        .clk_i(clk),
        .rst_n_i(rst_n),
        .rs1_addr_i(rs1),
        .rs1_data_o(rs1_data),
        .rs2_addr_i(rs2),
        .rs2_data_o(rs2_data),
        .rd_we_i(we),
        .rd_addr_i(rd),
        .rd_data_i(rd_data)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        we = 0;
        rs1 = 0; rs2 = 0;

        #20 rst_n = 1;

        // Write x1 = 10
        rd = 5'd1; rd_data = 32'd10; we = 1;
        #10 we = 0;

        // Read x1
        rs1 = 5'd1;
        #10;

        // Try writing x0 (should fail)
        rd = 5'd0; rd_data = 32'hDEADBEEF; we = 1;
        #10 we = 0;

        // Read x0
        rs1 = 5'd0;
        #10;

        $finish;
    end
endmodule

