//============================================================
// File      : pipeline_regs.sv
// Project   : ButterFly RV32IM Core
// Author    : Nidesh Kanna R
// Description:
//   Pipeline register definitions for the 5-stage pipeline.
//   Includes IF/ID, ID/EX, EX/MEM, MEM/WB registers.
//============================================================

`include "butterfly_pkg.sv"

//////////////////////////////////////////////////////////////
// IF / ID Pipeline Register
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
    // TODO: register logic
endmodule


//////////////////////////////////////////////////////////////
// ID / EX Pipeline Register
//////////////////////////////////////////////////////////////
module id_ex_reg (
    input  logic        clk_i,
    input  logic        rst_n_i,
    input  logic        stall_i,
    input  logic        flush_i,

    // Data
    input  logic [31:0] pc_i,
    input  logic [31:0] rs1_data_i,
    input  logic [31:0] rs2_data_i,
    input  logic [31:0] imm_i,

    // Control
    input  logic [3:0]  alu_op_i,
    input  logic        reg_write_i,
    input  logic        mem_read_i,
    input  logic        mem_write_i,
    input  logic        branch_i,
    input  logic        jump_i,

    input  logic [4:0]  rd_addr_i,

    // Outputs
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
    // TODO: register logic
endmodule


//////////////////////////////////////////////////////////////
// EX / MEM Pipeline Register
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
    // TODO: register logic
endmodule


//////////////////////////////////////////////////////////////
// MEM / WB Pipeline Register
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
    // TODO: register logic
endmodule

