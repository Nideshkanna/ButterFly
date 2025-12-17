//============================================================
// File      : regfile.sv
// Project   : ButterFly RV32IM Core
// Author    : Nidesh Kanna R
// Description:
//   Integer Register File (32 x 32-bit)
//   - Two combinational read ports
//   - One synchronous write port
//   - Register x0 is hardwired to zero
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
    // Register array
    // ---------------------------------------------------------
    logic [31:0] reg_array [31:0];

    integer i;

    // ---------------------------------------------------------
    // Synchronous write logic
    // ---------------------------------------------------------
    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            // Clear registers on reset (x0 remains zero)
            for (i = 0; i < 32; i = i + 1) begin
                reg_array[i] <= 32'b0;
            end
        end else begin
            if (rd_we_i && (rd_addr_i != 5'd0)) begin
                reg_array[rd_addr_i] <= rd_data_i;
            end
        end
    end

    // ---------------------------------------------------------
    // Combinational read logic
    // ---------------------------------------------------------
    always_comb begin
        // Read port 1
        if (rs1_addr_i == 5'd0)
            rs1_data_o = 32'b0;
        else
            rs1_data_o = reg_array[rs1_addr_i];

        // Read port 2
        if (rs2_addr_i == 5'd0)
            rs2_data_o = 32'b0;
        else
            rs2_data_o = reg_array[rs2_addr_i];
    end

endmodule

