//============================================================
// File      : branch_unit.sv
// Project   : ButterFly RV32IM Core
// Author    : Nidesh Kanna R
// Description:
//   Branch decision and target calculation unit
//============================================================

`include "butterfly_pkg.sv"

module branch_unit (
    input  logic [31:0] pc_i,
    input  logic [31:0] rs1_data_i,
    input  logic [31:0] rs2_data_i,
    input  logic [31:0] imm_i,

    input  logic [2:0]  branch_type_i,
    input  logic        branch_en_i,

    output logic        branch_taken_o,
    output logic [31:0] branch_target_o
);

    // ---------------------------------------------------------
    // Branch target calculation
    // ---------------------------------------------------------
    assign branch_target_o = pc_i + imm_i;

    // ---------------------------------------------------------
    // Branch condition evaluation
    // ---------------------------------------------------------
    always_comb begin
        branch_taken_o = 1'b0;

        if (branch_en_i) begin
            case (branch_type_i)
                BR_BEQ:  branch_taken_o = (rs1_data_i == rs2_data_i);
                BR_BNE:  branch_taken_o = (rs1_data_i != rs2_data_i);
                BR_BLT:  branch_taken_o = ($signed(rs1_data_i) < $signed(rs2_data_i));
                BR_BGE:  branch_taken_o = ($signed(rs1_data_i) >= $signed(rs2_data_i));
                BR_BLTU: branch_taken_o = (rs1_data_i < rs2_data_i);
                BR_BGEU: branch_taken_o = (rs1_data_i >= rs2_data_i);
                default: branch_taken_o = 1'b0;
            endcase
        end
    end

endmodule

