//============================================================
// File      : alu.sv
// Project   : ButterFly RV32IM Core
// Author    : Nidesh Kanna R
// Description:
//   Arithmetic Logic Unit for RV32I instructions.
//   Combinational execution unit.
//============================================================

`include "butterfly_pkg.sv"

module alu (
    input  logic [31:0] operand_a_i,
    input  logic [31:0] operand_b_i,
    input  logic [3:0]  alu_op_i,

    output logic [31:0] alu_result_o,
    output logic        zero_o
);

    // ---------------------------------------------------------
    // Combinational ALU logic
    // ---------------------------------------------------------
    always_comb begin
        alu_result_o = 32'b0;

        case (alu_op_i)
            ALU_ADD:  alu_result_o = operand_a_i + operand_b_i;
            ALU_SUB:  alu_result_o = operand_a_i - operand_b_i;
            ALU_AND:  alu_result_o = operand_a_i & operand_b_i;
            ALU_OR:   alu_result_o = operand_a_i | operand_b_i;
            ALU_XOR:  alu_result_o = operand_a_i ^ operand_b_i;
            ALU_SLT:  alu_result_o = ($signed(operand_a_i) < $signed(operand_b_i)) ? 32'd1 : 32'd0;
            ALU_SLTU: alu_result_o = (operand_a_i < operand_b_i) ? 32'd1 : 32'd0;
            ALU_SLL:  alu_result_o = operand_a_i << operand_b_i[4:0];
            ALU_SRL:  alu_result_o = operand_a_i >> operand_b_i[4:0];
            ALU_SRA:  alu_result_o = $signed(operand_a_i) >>> operand_b_i[4:0];
            default:  alu_result_o = 32'b0;
        endcase
    end

    // ---------------------------------------------------------
    // Zero flag
    // ---------------------------------------------------------
    assign zero_o = (alu_result_o == 32'b0);

endmodule

