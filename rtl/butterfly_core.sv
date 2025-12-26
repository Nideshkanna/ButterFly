//============================================================
// File      : butterfly_core.sv
// Project   : ButterFly RV32IM Core
// Author    : Nidesh Kanna R
// Description:
//   Top-level core integration
//   Phase C1.5: IF + ID + EX + EX/MEM + MEM (store-only)
//============================================================

`include "butterfly_pkg.sv"

module butterfly_core (
    input  logic        clk_i,
    input  logic        rst_n_i,

    // Instruction memory interface
    output logic [31:0]  imem_addr_o,
    input  logic [31:0]  imem_rdata_i,

    // Data memory interface
    output logic        dmem_valid_o,
    output logic        dmem_we_o,
    output logic [31:0] dmem_addr_o,
    output logic [31:0] dmem_wdata_o,
    output logic [3:0]  dmem_wstrb_o,
    input  logic [31:0] dmem_rdata_i,
    input  logic        dmem_ready_i
);

    // ---------------------------------------------------------
    // IF stage
    // ---------------------------------------------------------
    logic [31:0] pc_q, pc_d;

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i)
            pc_q <= 32'h0;
        else
            pc_q <= pc_d;
    end

    assign pc_d        = pc_q + 32'd4;
    assign imem_addr_o = pc_q;

    // ---------------------------------------------------------
    // IF/ID pipeline
    // ---------------------------------------------------------
    logic [31:0] if_id_instr;

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i)
            if_id_instr <= 32'b0;
        else
            if_id_instr <= imem_rdata_i;
    end

    // ---------------------------------------------------------
    // ID stage
    // ---------------------------------------------------------
    logic [4:0]  rs1, rs2, rd;
    logic [31:0] imm;
    logic [3:0]  alu_op;
    logic        reg_we;
    logic        mem_we;

    decoder u_decoder (
        .instr_i        (if_id_instr),
        .rs1_addr_o     (rs1),
        .rs2_addr_o     (rs2),
        .rd_addr_o      (rd),
        .imm_o          (imm),
        .reg_write_o    (reg_we),
        .mem_read_o     (),
        .mem_write_o    (mem_we),
        .branch_o       (),
        .jump_o         (),
        .alu_op_o       (alu_op),
        .branch_type_o  ()
    );

    // ---------------------------------------------------------
    // Register File
    // ---------------------------------------------------------
    logic [31:0] rs1_data, rs2_data;

    regfile u_regfile (
        .clk_i      (clk_i),
        .rst_n_i    (rst_n_i),
        .rs1_addr_i (rs1),
        .rs2_addr_i (rs2),
        .rs1_data_o (rs1_data),
        .rs2_data_o (rs2_data),
        .rd_addr_i  (5'b0),
        .rd_data_i  (32'b0),
        .rd_we_i    (1'b0)
    );

    // ---------------------------------------------------------
    // EX stage
    // ---------------------------------------------------------
    logic [31:0] alu_result;

    alu u_alu (
        .operand_a_i  (rs1_data),
        .operand_b_i  (imm),
        .alu_op_i     (alu_op),
        .alu_result_o (alu_result),
        .zero_o       ()
    );

    // ---------------------------------------------------------
    // EX/MEM pipeline
    // ---------------------------------------------------------
    logic [31:0] ex_mem_addr;
    logic [31:0] ex_mem_wdata;
    logic        ex_mem_mem_we;

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            ex_mem_addr   <= 32'b0;
            ex_mem_wdata  <= 32'b0;
            ex_mem_mem_we <= 1'b0;
        end else begin
            ex_mem_addr   <= alu_result;
            ex_mem_wdata  <= rs2_data;
            ex_mem_mem_we <= mem_we;
        end
    end

    // ---------------------------------------------------------
    // MEM stage (direct store)
    // ---------------------------------------------------------
    assign dmem_valid_o = ex_mem_mem_we;
    assign dmem_we_o    = ex_mem_mem_we;
    assign dmem_addr_o  = ex_mem_addr;
    assign dmem_wdata_o = ex_mem_wdata;
    assign dmem_wstrb_o = 4'b1111; // word store (SW)

endmodule

