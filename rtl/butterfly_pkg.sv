//============================================================
//  File      : butterfly_pkg.sv
//  Project   : ButterFly RV32IM Core
//  Author    : Nidesh Kanna R
//  Description:
//    Common package file containing global parameters,
//    typedefs, enums, opcodes, and constants shared
//    across the ButterFly core RTL.
//============================================================

package butterfly_pkg;

  // Global parameters
  parameter int XLEN = 32;
  parameter int REG_COUNT = 32;

  // Common types
  typedef logic [XLEN-1:0] word_t;
  typedef logic [4:0]      reg_addr_t;

  // ---------------------------------------------------------
  // ALU Operation Encoding
  // ---------------------------------------------------------
  typedef enum logic [3:0] {
    ALU_ADD  = 4'd0,
    ALU_SUB  = 4'd1,
    ALU_AND  = 4'd2,
    ALU_OR   = 4'd3,
    ALU_XOR  = 4'd4,
    ALU_SLT  = 4'd5,
    ALU_SLTU = 4'd6,
    ALU_SLL  = 4'd7,
    ALU_SRL  = 4'd8,
    ALU_SRA  = 4'd9
  } alu_op_e;

  // TODO:
  // - Opcode enums
  // - funct3 / funct7 definitions
  // - ALU operation encoding
  // - Branch type encoding

endpackage
