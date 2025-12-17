//============================================================
// File      : mem_if.sv
// Project   : ButterFly RV32IM Core
// Author    : Nidesh Kanna R
// Description:
//   Data memory interface for load/store instructions.
//   Abstract handshake-based interface.
//============================================================

`include "butterfly_pkg.sv"

module mem_if (
    input  logic        clk_i,
    input  logic        rst_n_i,

    // Request from EX/MEM stage
    input  logic        mem_req_i,
    input  logic        mem_we_i,        // 1 = store, 0 = load
    input  logic [31:0] mem_addr_i,
    input  logic [31:0] mem_wdata_i,
    input  logic [1:0]  mem_size_i,      // byte, half, word

    // Response to MEM/WB stage
    output logic [31:0] mem_rdata_o,
    output logic        mem_ready_o,

    // External memory interface
    output logic        mem_valid_o,
    output logic        mem_write_o,
    output logic [31:0] mem_addr_o,
    output logic [31:0] mem_wdata_o,
    output logic [3:0]  mem_wstrb_o,
    input  logic [31:0] mem_rdata_i,
    input  logic        mem_ready_i
);

    // TODO:
    // - Alignment handling
    // - Byte enable generation
    // - Load sign extension

endmodule

