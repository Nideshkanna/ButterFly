//============================================================
// File      : butterfly_pkg.sv
// Project   : ButterFly RV32IM Core
// Description:
//   Global definitions (include-guarded, portable)
//============================================================

`ifndef BUTTERFLY_PKG_SV
`define BUTTERFLY_PKG_SV

// ------------------------------------------------------------
// ALU operation encoding
// ------------------------------------------------------------
localparam [3:0]
    ALU_ADD  = 4'd0,
    ALU_SUB  = 4'd1,
    ALU_AND  = 4'd2,
    ALU_OR   = 4'd3,
    ALU_XOR  = 4'd4,
    ALU_SLL  = 4'd5,
    ALU_SRL  = 4'd6,
    ALU_SRA  = 4'd7,
    ALU_SLT  = 4'd8,
    ALU_SLTU = 4'd9;

// ------------------------------------------------------------
// Branch types
// ------------------------------------------------------------
localparam [2:0]
    BR_NONE = 3'd0,
    BR_BEQ  = 3'd1,
    BR_BNE  = 3'd2,
    BR_BLT  = 3'd3,
    BR_BGE  = 3'd4,
    BR_BLTU = 3'd5,
    BR_BGEU = 3'd6;

// ------------------------------------------------------------
// RV32M mul/div operations
// ------------------------------------------------------------
localparam [2:0]
    MULDIV_MUL  = 3'd0,
    MULDIV_DIV  = 3'd1,
    MULDIV_DIVU = 3'd2,
    MULDIV_REM  = 3'd3,
    MULDIV_REMU = 3'd4;

// ------------------------------------------------------------
// RISC-V opcodes
// ------------------------------------------------------------
localparam [6:0]
    OPCODE_OP       = 7'b0110011,
    OPCODE_OP_IMM   = 7'b0010011,
    OPCODE_LOAD     = 7'b0000011,
    OPCODE_STORE    = 7'b0100011,
    OPCODE_BRANCH   = 7'b1100011,
    OPCODE_JALR     = 7'b1100111,
    OPCODE_JAL      = 7'b1101111,
    OPCODE_LUI      = 7'b0110111,
    OPCODE_AUIPC    = 7'b0010111,
    OPCODE_SYSTEM   = 7'b1110011;

// ------------------------------------------------------------
// funct3 encodings
// ------------------------------------------------------------
localparam [2:0]
    F3_ADD_SUB  = 3'b000,
    F3_SLL      = 3'b001,
    F3_SLT      = 3'b010,
    F3_SLTU     = 3'b011,
    F3_XOR      = 3'b100,
    F3_SRL_SRA  = 3'b101,
    F3_OR       = 3'b110,
    F3_AND      = 3'b111;



`endif // BUTTERFLY_PKG_SV

