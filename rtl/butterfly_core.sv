//============================================================
// File      : butterfly_core.sv
// Project   : ButterFly RV32IM Core
// Author    : Nidesh Kanna R
// Description:
//   Top-level core integration
//============================================================

`include "butterfly_pkg.sv"

module butterfly_core (
    input  logic        clk_i,
    input  logic        rst_n_i,

    // Instruction memory interface
    output logic [31:0]  imem_addr_o,
    input  logic [31:0]  imem_rdata_i,

    // Data memory interface
    output logic        dmem_valid_o,
    output logic        dmem_we_o,
    output logic [31:0] dmem_addr_o,
    output logic [31:0] dmem_wdata_o,
    output logic [3:0]  dmem_wstrb_o,
    input  logic [31:0] dmem_rdata_i,
    input  logic        dmem_ready_i
);

    // ---------------------------------------------------------
    // Program Counter
    // ---------------------------------------------------------
    logic [31:0] pc_q;
    logic [31:0] pc_d;

    // PC register
    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i)
            pc_q <= 32'h0000_0000;
        else
            pc_q <= pc_d;
    end

    // Default PC increment
    assign pc_d = pc_q + 32'd4;

    // Instruction fetch address
    assign imem_addr_o = pc_q;

    // ---------------------------------------------------------
    // TEMPORARY: disable data memory
    // ---------------------------------------------------------
    assign dmem_valid_o = 1'b0;
    assign dmem_we_o    = 1'b0;
    assign dmem_addr_o  = 32'b0;
    assign dmem_wdata_o = 32'b0;
    assign dmem_wstrb_o = 4'b0;

endmodule

