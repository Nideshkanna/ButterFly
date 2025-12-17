//============================================================
// File      : pipeline_regs.sv
// Project   : ButterFly RV32IM Core
// Author    : Nidesh Kanna R
// Description:
//   Pipeline register implementations for 5-stage pipeline
//============================================================

`include "butterfly_pkg.sv"

//////////////////////////////////////////////////////////////
// IF / ID
//////////////////////////////////////////////////////////////
module if_id_reg (
    input  logic        clk_i,
    input  logic        rst_n_i,
    input  logic        stall_i,
    input  logic        flush_i,

    input  logic [31:0] pc_i,
    input  logic [31:0] instr_i,

    output logic [31:0] pc_o,
    output logic [31:0] instr_o
);

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            pc_o    <= 32'b0;
            instr_o<= 32'b0;
        end else if (flush_i) begin
            pc_o    <= 32'b0;
            instr_o<= 32'b0; // bubble
        end else if (!stall_i) begin
            pc_o    <= pc_i;
            instr_o<= instr_i;
        end
    end
endmodule


//////////////////////////////////////////////////////////////
// ID / EX
//////////////////////////////////////////////////////////////
module id_ex_reg (
    input  logic        clk_i,
    input  logic        rst_n_i,
    input  logic        stall_i,
    input  logic        flush_i,

    input  logic [31:0] pc_i,
    input  logic [31:0] rs1_data_i,
    input  logic [31:0] rs2_data_i,
    input  logic [31:0] imm_i,

    input  logic [3:0]  alu_op_i,
    input  logic        reg_write_i,
    input  logic        mem_read_i,
    input  logic        mem_write_i,
    input  logic        branch_i,
    input  logic        jump_i,

    input  logic [4:0]  rd_addr_i,

    output logic [31:0] pc_o,
    output logic [31:0] rs1_data_o,
    output logic [31:0] rs2_data_o,
    output logic [31:0] imm_o,

    output logic [3:0]  alu_op_o,
    output logic        reg_write_o,
    output logic        mem_read_o,
    output logic        mem_write_o,
    output logic        branch_o,
    output logic        jump_o,

    output logic [4:0]  rd_addr_o
);

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i || flush_i) begin
            pc_o         <= 32'b0;
            rs1_data_o   <= 32'b0;
            rs2_data_o   <= 32'b0;
            imm_o        <= 32'b0;
            alu_op_o     <= '0;
            reg_write_o  <= 1'b0;
            mem_read_o   <= 1'b0;
            mem_write_o  <= 1'b0;
            branch_o     <= 1'b0;
            jump_o       <= 1'b0;
            rd_addr_o    <= 5'b0;
        end else if (!stall_i) begin
            pc_o         <= pc_i;
            rs1_data_o   <= rs1_data_i;
            rs2_data_o   <= rs2_data_i;
            imm_o        <= imm_i;
            alu_op_o     <= alu_op_i;
            reg_write_o  <= reg_write_i;
            mem_read_o   <= mem_read_i;
            mem_write_o  <= mem_write_i;
            branch_o     <= branch_i;
            jump_o       <= jump_i;
            rd_addr_o    <= rd_addr_i;
        end
    end
endmodule


//////////////////////////////////////////////////////////////
// EX / MEM
//////////////////////////////////////////////////////////////
module ex_mem_reg (
    input  logic        clk_i,
    input  logic        rst_n_i,
    input  logic        stall_i,
    input  logic        flush_i,

    input  logic [31:0] alu_result_i,
    input  logic [31:0] rs2_data_i,

    input  logic        reg_write_i,
    input  logic        mem_read_i,
    input  logic        mem_write_i,

    input  logic [4:0]  rd_addr_i,

    output logic [31:0] alu_result_o,
    output logic [31:0] rs2_data_o,

    output logic        reg_write_o,
    output logic        mem_read_o,
    output logic        mem_write_o,

    output logic [4:0]  rd_addr_o
);

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i || flush_i) begin
            alu_result_o <= 32'b0;
            rs2_data_o   <= 32'b0;
            reg_write_o  <= 1'b0;
            mem_read_o   <= 1'b0;
            mem_write_o  <= 1'b0;
            rd_addr_o    <= 5'b0;
        end else if (!stall_i) begin
            alu_result_o <= alu_result_i;
            rs2_data_o   <= rs2_data_i;
            reg_write_o  <= reg_write_i;
            mem_read_o   <= mem_read_i;
            mem_write_o  <= mem_write_i;
            rd_addr_o    <= rd_addr_i;
        end
    end
endmodule


//////////////////////////////////////////////////////////////
// MEM / WB
//////////////////////////////////////////////////////////////
module mem_wb_reg (
    input  logic        clk_i,
    input  logic        rst_n_i,
    input  logic        stall_i,
    input  logic        flush_i,

    input  logic [31:0] mem_data_i,
    input  logic [31:0] alu_result_i,

    input  logic        reg_write_i,
    input  logic [4:0]  rd_addr_i,

    output logic [31:0] mem_data_o,
    output logic [31:0] alu_result_o,

    output logic        reg_write_o,
    output logic [4:0]  rd_addr_o
);

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i || flush_i) begin
            mem_data_o   <= 32'b0;
            alu_result_o <= 32'b0;
            reg_write_o  <= 1'b0;
            rd_addr_o    <= 5'b0;
        end else if (!stall_i) begin
            mem_data_o   <= mem_data_i;
            alu_result_o <= alu_result_i;
            reg_write_o  <= reg_write_i;
            rd_addr_o    <= rd_addr_i;
        end
    end
endmodule

