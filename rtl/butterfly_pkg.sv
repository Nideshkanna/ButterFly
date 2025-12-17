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

  // TODO:
  // - Opcode enums
  // - funct3 / funct7 definitions
  // - ALU operation encoding
  // - Branch type encoding

endpackage
