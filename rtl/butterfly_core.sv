//============================================================
// File      : butterfly_core.sv
// Project   : ButterFly RV32IM Core
// Author    : Nidesh Kanna R
// Description:
//   Top-level core integration (IF/ID stage)
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
    // Program Counter (IF stage)
    // ---------------------------------------------------------
    logic [31:0] pc_q;
    logic [31:0] pc_d;

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i)
            pc_q <= 32'h0000_0000;
        else
            pc_q <= pc_d;
    end

    assign pc_d = pc_q + 32'd4;
    assign imem_addr_o = pc_q;

    // ---------------------------------------------------------
    // IF/ID Pipeline Register
    // ---------------------------------------------------------
    logic [31:0] if_id_pc;
    logic [31:0] if_id_instr;

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            if_id_pc    <= 32'b0;
            if_id_instr <= 32'b0;
        end else begin
            if_id_pc    <= pc_q;
            if_id_instr <= imem_rdata_i;
        end
    end

    // ---------------------------------------------------------
    // Instruction Decode Stage
    // ---------------------------------------------------------
    logic [4:0]  rs1, rs2, rd;
    logic [31:0] imm;
    logic [3:0]  alu_op;
    logic        reg_we;
    logic        mem_we;
    logic        branch_en;

    decoder u_decoder (
    .instr_i        (if_id_instr),

    .rs1_addr_o     (rs1),
    .rs2_addr_o     (rs2),
    .rd_addr_o      (rd),

    .imm_o          (imm),

    .reg_write_o    (reg_we),
    .mem_read_o     (),        // unused in C1
    .mem_write_o    (mem_we),
    .branch_o       (branch_en),
    .jump_o         (),

    .alu_op_o       (alu_op),
    .branch_type_o  ()
    );


    // ---------------------------------------------------------
    // TEMPORARY: Disable data memory
    // ---------------------------------------------------------
    assign dmem_valid_o = 1'b0;
    assign dmem_we_o    = 1'b0;
    assign dmem_addr_o  = 32'b0;
    assign dmem_wdata_o = 32'b0;
    assign dmem_wstrb_o = 4'b0;

endmodule

