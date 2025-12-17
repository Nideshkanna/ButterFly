//============================================================
// File      : alu.sv
// Project   : ButterFly RV32IM Core
// Author    : Nidesh Kanna R
// Description:
//   Arithmetic Logic Unit for RV32I instructions.
//   Implements arithmetic, logical, shift, and compare ops.
//============================================================

`include "butterfly_pkg.sv"

module alu (
    // Inputs
    input  logic [31:0]  operand_a_i,
    input  logic [31:0]  operand_b_i,
    input  logic [3:0]   alu_op_i,      // Encoded ALU operation

    // Outputs
    output logic [31:0]  alu_result_o,
    output logic         zero_o          // Result == 0
);

    // TODO:
    // - Implement combinational ALU logic
    // - Define alu_op_i encoding in butterfly_pkg.sv

endmodule
