//============================================================
// File      : decoder.sv
// Project   : ButterFly RV32IM Core
// Author    : Nidesh Kanna R
// Description:
//   Instruction decoder for RV32IM.
//   Decodes opcode, funct3, funct7, and generates control signals.
//============================================================

`include "butterfly_pkg.sv"

module decoder (
    // Input instruction
    input  logic [31:0] instr_i,

    // Register addresses
    output logic [4:0]  rs1_addr_o,
    output logic [4:0]  rs2_addr_o,
    output logic [4:0]  rd_addr_o,

    // Immediate
    output logic [31:0] imm_o,

    // Control signals
    output logic        reg_write_o,
    output logic        mem_read_o,
    output logic        mem_write_o,
    output logic        branch_o,
    output logic        jump_o,

    // ALU control
    output logic [3:0]  alu_op_o
);

    // TODO:
    // - Extract instruction fields
    // - Immediate generation
    // - Control signal decode

endmodule
