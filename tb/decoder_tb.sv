module decoder_tb;
    logic [31:0] instr;
    logic [4:0] rs1, rs2, rd;
    logic [31:0] imm;
    logic reg_w, mem_r, mem_w, branch, jump;
    logic [3:0] alu_op;
    logic [2:0] br_type;

    decoder dut (
        .instr_i(instr),
        .rs1_addr_o(rs1),
        .rs2_addr_o(rs2),
        .rd_addr_o(rd),
        .imm_o(imm),
        .reg_write_o(reg_w),
        .mem_read_o(mem_r),
        .mem_write_o(mem_w),
        .branch_o(branch),
        .jump_o(jump),
        .alu_op_o(alu_op),
        .branch_type_o(br_type)
    );

    initial begin
        // ADDI x1, x0, 10
        instr = 32'b000000001010_00000_000_00001_0010011;
        #1;

        // ADD x3, x1, x2
        instr = 32'b0000000_00010_00001_000_00011_0110011;
        #1;

        // BEQ x1, x2, offset
        instr = 32'b0000000_00010_00001_000_00000_1100011;
        #1;

        $finish;
    end
endmodule

