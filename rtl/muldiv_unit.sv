//============================================================
// File      : muldiv_unit.sv
// Project   : ButterFly RV32IM Core
// Author    : Nidesh Kanna R
// Description:
//   RV32M Multiply/Divide execution unit.
//   Multi-cycle operation with start/done handshake.
//============================================================

`include "butterfly_pkg.sv"

module muldiv_unit (
    input  logic        clk_i,
    input  logic        rst_n_i,

    input  logic        start_i,
    input  logic [31:0] operand_a_i,
    input  logic [31:0] operand_b_i,
    input  logic [2:0]  muldiv_op_i,   // MUL, DIV, REM, etc.

    output logic [31:0] result_o,
    output logic        busy_o,
    output logic        done_o
);

    // TODO:
    // - Iterative multiply/divide logic
    // - Busy/done control

endmodule

