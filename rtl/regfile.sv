//============================================================
// File      : regfile.sv
// Project   : ButterFly RV32IM Core
// Author    : Nidesh Kanna R
// Description:
//   Integer Register File (32 x 32-bit)
//   Two read ports, one write port.
//============================================================

`include "butterfly_pkg.sv"

module regfile (
    // Clock and reset
    input  logic         clk_i,
    input  logic         rst_n_i,

    // Read port 1
    input  logic [4:0]   rs1_addr_i,
    output logic [31:0]  rs1_data_o,

    // Read port 2
    input  logic [4:0]   rs2_addr_i,
    output logic [31:0]  rs2_data_o,

    // Write port
    input  logic         rd_we_i,
    input  logic [4:0]   rd_addr_i,
    input  logic [31:0]  rd_data_i
);

    // TODO:
    // - Implement 32x32 register array
    // - x0 must always read as zero
    // - Writes synchronous to clk_i

endmodule
