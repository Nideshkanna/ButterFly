//============================================================
// File      : branch_unit.sv
// Project   : ButterFly RV32IM Core
// Author    : Nidesh Kanna R
// Description:
//   Branch decision and target address calculation unit.
//============================================================

`include "butterfly_pkg.sv"

module branch_unit (
    input  logic [31:0] pc_i,
    input  logic [31:0] rs1_data_i,
    input  logic [31:0] rs2_data_i,
    input  logic [31:0] imm_i,

    input  logic [2:0]  branch_type_i,   // BEQ, BNE, BLT, etc.
    input  logic        branch_en_i,

    output logic        branch_taken_o,
    output logic [31:0] branch_target_o
);

    // TODO:
    // - Branch comparison logic
    // - Target PC calculation

endmodule

