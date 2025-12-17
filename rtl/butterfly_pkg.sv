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

// ---------------------------------------------------------
// RISC-V Opcode Definitions (RV32I)
// ---------------------------------------------------------
  localparam logic [6:0]
    OPCODE_LUI    = 7'b0110111,
    OPCODE_AUIPC  = 7'b0010111,
    OPCODE_JAL    = 7'b1101111,
    OPCODE_JALR   = 7'b1100111,
    OPCODE_BRANCH= 7'b1100011,
    OPCODE_LOAD  = 7'b0000011,
    OPCODE_STORE = 7'b0100011,
    OPCODE_OP_IMM= 7'b0010011,
    OPCODE_OP    = 7'b0110011,
    OPCODE_SYSTEM= 7'b1110011;

// ---------------------------------------------------------
// funct3 definitions
// ---------------------------------------------------------
  localparam logic [2:0]
    F3_ADD_SUB = 3'b000,
    F3_SLL     = 3'b001,
    F3_SLT     = 3'b010,
    F3_SLTU    = 3'b011,
    F3_XOR     = 3'b100,
    F3_SRL_SRA = 3'b101,
    F3_OR      = 3'b110,
    F3_AND     = 3'b111;

// ---------------------------------------------------------
// Branch type encoding
// ---------------------------------------------------------
  typedef enum logic [2:0] {
    BR_NONE = 3'd0,
    BR_BEQ  = 3'd1,
    BR_BNE  = 3'd2,
    BR_BLT  = 3'd3,
    BR_BGE  = 3'd4,
    BR_BLTU = 3'd5,
    BR_BGEU = 3'd6
  } branch_e;

  // TODO:
  // - Opcode enums
  // - funct3 / funct7 definitions
  // - ALU operation encoding
  // - Branch type encoding

endpackage
