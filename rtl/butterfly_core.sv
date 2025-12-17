//============================================================
// File      : butterfly_core.sv
// Project   : ButterFly RV32IM Core
// Author    : Nidesh Kanna R
// Description:
//   Top-level ButterFly RV32IM processor core.
//   Integrates all pipeline stages and units.
//============================================================

`include "butterfly_pkg.sv"

module butterfly_core (
    input  logic        clk_i,
    input  logic        rst_n_i,

    // Instruction memory interface
    output logic        imem_valid_o,
    output logic [31:0] imem_addr_o,
    input  logic [31:0] imem_rdata_i,
    input  logic        imem_ready_i,

    // Data memory interface
    output logic        dmem_valid_o,
    output logic        dmem_write_o,
    output logic [31:0] dmem_addr_o,
    output logic [31:0] dmem_wdata_o,
    output logic [3:0]  dmem_wstrb_o,
    input  logic [31:0] dmem_rdata_i,
    input  logic        dmem_ready_i,

    // Interrupt
    input  logic        ext_irq_i
);

    // TODO:
    // - Instantiate pipeline stages
    // - Connect control, CSR, memory
    // - Handle reset and trap flow

endmodule

