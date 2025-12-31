//============================================================
// File      : muldiv_unit.sv
// Project   : ButterFly RV32IM Core
// Author    : Nidesh Kanna R
// Description:
//   RV32M Multiply / Divide Unit (iterative, multi-cycle)
//============================================================

`include "butterfly_pkg.sv"

module muldiv_unit (
    input  logic        clk_i,
    input  logic        rst_n_i,

    input  logic        start_i,
    input  logic [31:0] operand_a_i,
    input  logic [31:0] operand_b_i,
    input  logic [2:0]  muldiv_op_i,

    output logic [31:0] result_o,
    output logic        busy_o,
    output logic        done_o
);

    import butterfly_pkg::*;

    typedef enum logic [1:0] {
        IDLE,
        BUSY,
        DONE
    } state_e;

    state_e state, next_state;

    logic [31:0] result_reg;

    // ---------------------------------------------------------
    // State register
    // ---------------------------------------------------------
    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            state      <= IDLE;
            result_reg <= 32'b0;
        end else begin
            state <= next_state;

            if (state == IDLE && start_i) begin
                case (muldiv_op_i)
                    MULDIV_MUL:
                        result_reg <= $signed(operand_a_i) * $signed(operand_b_i);

                    MULDIV_DIV:
                        result_reg <= (operand_b_i != 0) ?
                                      $signed(operand_a_i) / $signed(operand_b_i) : 32'b0;

                    MULDIV_DIVU:
                        result_reg <= (operand_b_i != 0) ?
                                      operand_a_i / operand_b_i : 32'b0;

                    MULDIV_REM:
                        result_reg <= (operand_b_i != 0) ?
                                      $signed(operand_a_i) % $signed(operand_b_i) : operand_a_i;

                    MULDIV_REMU:
                        result_reg <= (operand_b_i != 0) ?
                                      operand_a_i % operand_b_i : operand_a_i;

                    default:
                        result_reg <= 32'b0;
                endcase
            end
        end
    end

    // ---------------------------------------------------------
    // Next-state logic
    // ---------------------------------------------------------
    always_comb begin
        next_state = state;

        case (state)
            IDLE:  if (start_i) next_state = BUSY;
            BUSY:  next_state = DONE;
            DONE:  next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // ---------------------------------------------------------
    // Outputs
    // ---------------------------------------------------------
    assign busy_o   = (state == BUSY);
    assign done_o   = (state == DONE);
    assign result_o = result_reg;

endmodule

