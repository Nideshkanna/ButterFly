//============================================================
// File      : csr_unit.sv
// Project   : ButterFly RV32IM Core
// Author    : Nidesh Kanna R
// Description:
//   Control and Status Register (CSR) unit.
//   Implements Machine-mode CSRs and trap handling.
//============================================================

`include "butterfly_pkg.sv"

module csr_unit (
    input  logic        clk_i,
    input  logic        rst_n_i,

    // CSR access from pipeline
    input  logic        csr_en_i,
    input  logic        csr_we_i,
    input  logic [11:0] csr_addr_i,
    input  logic [31:0] csr_wdata_i,

    output logic [31:0] csr_rdata_o,

    // Exception / interrupt inputs
    input  logic        exception_i,
    input  logic [31:0] exception_pc_i,
    input  logic [31:0] exception_cause_i,

    input  logic        mret_i,

    // Trap outputs
    output logic [31:0] trap_vector_o,
    output logic [31:0] mepc_o,
    output logic        trap_taken_o
);

    // TODO:
    // - CSR registers
    // - Trap entry/exit logic
    // - mret handling

endmodule

