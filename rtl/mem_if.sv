//============================================================
// File      : mem_if.sv
// Project   : ButterFly RV32IM Core
// Author    : Nidesh Kanna R
// Description:
//   Load / Store Memory Interface
//============================================================

`include "butterfly_pkg.sv"

module mem_if (
    input  logic        clk_i,
    input  logic        rst_n_i,

    // Request from pipeline
    input  logic        mem_req_i,
    input  logic        mem_we_i,        // 1 = store, 0 = load
    input  logic [31:0] mem_addr_i,
    input  logic [31:0] mem_wdata_i,
    input  logic [1:0]  mem_size_i,      // byte, half, word

    // Response to pipeline
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

    // ---------------------------------------------------------
    // Pass-through control
    // ---------------------------------------------------------
    assign mem_valid_o = mem_req_i;
    assign mem_write_o = mem_we_i;
    assign mem_addr_o  = mem_addr_i;
    assign mem_ready_o = mem_ready_i;

    // ---------------------------------------------------------
    // Write strobe + write data alignment
    // ---------------------------------------------------------
    always_comb begin
        mem_wstrb_o = 4'b0000;
        mem_wdata_o = mem_wdata_i;

        case (mem_size_i)
            2'b00: begin // BYTE
                mem_wstrb_o = 4'b0001 << mem_addr_i[1:0];
                mem_wdata_o = mem_wdata_i << (8 * mem_addr_i[1:0]);
            end

            2'b01: begin // HALFWORD
                mem_wstrb_o = (mem_addr_i[1]) ? 4'b1100 : 4'b0011;
                mem_wdata_o = mem_wdata_i << (16 * mem_addr_i[1]);
            end

            2'b10: begin // WORD
                mem_wstrb_o = 4'b1111;
                mem_wdata_o = mem_wdata_i;
            end

            default: begin
                mem_wstrb_o = 4'b0000;
                mem_wdata_o = mem_wdata_i;
            end
        endcase
    end

    // ---------------------------------------------------------
    // Load data alignment & sign extension
    // ---------------------------------------------------------
    always_comb begin
        mem_rdata_o = mem_rdata_i;

        case (mem_size_i)
            2'b00: begin // BYTE
                case (mem_addr_i[1:0])
                    2'b00: mem_rdata_o = {{24{mem_rdata_i[7]}},  mem_rdata_i[7:0]};
                    2'b01: mem_rdata_o = {{24{mem_rdata_i[15]}}, mem_rdata_i[15:8]};
                    2'b10: mem_rdata_o = {{24{mem_rdata_i[23]}}, mem_rdata_i[23:16]};
                    2'b11: mem_rdata_o = {{24{mem_rdata_i[31]}}, mem_rdata_i[31:24]};
                endcase
            end

            2'b01: begin // HALFWORD
                if (mem_addr_i[1])
                    mem_rdata_o = {{16{mem_rdata_i[31]}}, mem_rdata_i[31:16]};
                else
                    mem_rdata_o = {{16{mem_rdata_i[15]}}, mem_rdata_i[15:0]};
            end

            2'b10: begin // WORD
                mem_rdata_o = mem_rdata_i;
            end

            default: mem_rdata_o = mem_rdata_i;
        endcase
    end

endmodule

