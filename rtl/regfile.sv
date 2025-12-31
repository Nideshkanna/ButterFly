//============================================================
// File      : regfile.sv
// Project   : ButterFly RV32IM Core
// Author    : Nidesh Kanna R
// Description:
//   Integer Register File (32 x 32-bit)
//============================================================

`include "butterfly_pkg.sv"

module regfile (
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

    // ---------------------------------------------------------
    // Register array (EXPOSED FOR TB)
    // ---------------------------------------------------------
    logic [31:0] regs [31:0];

    integer i;

    // ---------------------------------------------------------
    // Synchronous write logic
    // ---------------------------------------------------------
    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'b0;
        end else if (rd_we_i && (rd_addr_i != 5'd0)) begin
            regs[rd_addr_i] <= rd_data_i;
        end
    end

    // ---------------------------------------------------------
    // Combinational read logic
    // ---------------------------------------------------------
    assign rs1_data_o = (rs1_addr_i == 5'd0) ? 32'b0 : regs[rs1_addr_i];
    assign rs2_data_o = (rs2_addr_i == 5'd0) ? 32'b0 : regs[rs2_addr_i];

endmodule

