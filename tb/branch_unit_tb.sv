module branch_unit_tb;

    logic [31:0] pc, rs1, rs2, imm;
    logic [2:0]  br_type;
    logic        br_en;
    logic        taken;
    logic [31:0] target;

    branch_unit dut (
        .pc_i(pc),
        .rs1_data_i(rs1),
        .rs2_data_i(rs2),
        .imm_i(imm),
        .branch_type_i(br_type),
        .branch_en_i(br_en),
        .branch_taken_o(taken),
        .branch_target_o(target)
    );

    initial begin
        pc  = 32'h1000;
        imm = 32'd16;
        br_en = 1'b1;

        // BEQ taken
        rs1 = 10; rs2 = 10; br_type = 3'd1; #1;

        // BNE taken
        rs1 = 10; rs2 = 5; br_type = 3'd2; #1;

        // BLT taken
        rs1 = -5; rs2 = 3; br_type = 3'd3; #1;

        // BLTU taken
        rs1 = 5; rs2 = 10; br_type = 3'd5; #1;

        // Branch disabled
        br_en = 1'b0; #1;

        $finish;
    end
endmodule

