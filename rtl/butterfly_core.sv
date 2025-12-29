//============================================================
// File      : butterfly_core.sv
// Project   : ButterFly RV32IM Core
// Author    : Nidesh Kanna R
// Description:
//   Top-level core integration
//   Phase C3: Branch & Jump support
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

    // =========================================================
    // IF stage
    // =========================================================
    logic [31:0] pc_q, pc_d;

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i)
            pc_q <= 32'h0;
        else
            pc_q <= pc_d;
    end

    assign imem_addr_o = pc_q;

    // =========================================================
    // IF/ID pipeline register (flush on branch)
    // =========================================================
    logic [31:0] if_id_instr;
    logic [31:0] if_id_pc;

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            if_id_instr <= 32'b0;
            if_id_pc    <= 32'b0;
        end else if (branch_taken) begin
            if_id_instr <= 32'b0; // flush
            if_id_pc    <= 32'b0;
        end else begin
            if_id_instr <= imem_rdata_i;
            if_id_pc    <= pc_q;
        end
    end

    // =========================================================
    // ID stage
    // =========================================================
    logic [4:0]  rs1, rs2, rd;
    logic [31:0] imm;
    logic [3:0]  alu_op;
    logic        reg_we;
    logic        mem_read;
    logic        mem_write;
    logic        branch;
    logic        jump;
    logic [2:0]  branch_type;

    decoder u_decoder (
        .instr_i        (if_id_instr),
        .rs1_addr_o     (rs1),
        .rs2_addr_o     (rs2),
        .rd_addr_o      (rd),
        .imm_o          (imm),
        .reg_write_o    (reg_we),
        .mem_read_o     (mem_read),
        .mem_write_o    (mem_write),
        .branch_o       (branch),
        .jump_o         (jump),
        .alu_op_o       (alu_op),
        .branch_type_o  (branch_type)
    );

    // =========================================================
    // Register File
    // =========================================================
    logic [31:0] rs1_data, rs2_data;
    logic [31:0] wb_data;
    logic [4:0]  wb_rd;
    logic        wb_we;

    regfile u_regfile (
        .clk_i      (clk_i),
        .rst_n_i    (rst_n_i),
        .rs1_addr_i (rs1),
        .rs2_addr_i (rs2),
        .rs1_data_o (rs1_data),
        .rs2_data_o (rs2_data),
        .rd_addr_i  (wb_rd),
        .rd_data_i  (wb_data),
        .rd_we_i    (wb_we)
    );

    // =========================================================
    // EX stage
    // =========================================================
    logic [31:0] alu_result;

    alu u_alu (
        .operand_a_i  (rs1_data),
        .operand_b_i  (imm),
        .alu_op_i     (alu_op),
        .alu_result_o (alu_result),
        .zero_o       ()
    );

    // =========================================================
    // Branch Unit (EX stage)
    // =========================================================
    logic branch_taken;
    logic [31:0] branch_target;

    branch_unit u_branch (
        .pc_i            (if_id_pc),
        .rs1_data_i      (rs1_data),
        .rs2_data_i      (rs2_data),
        .imm_i           (imm),
        .branch_type_i   (branch_type),
        .branch_en_i     (branch),
        .branch_taken_o  (branch_taken),
        .branch_target_o (branch_target)
    );

    // =========================================================
    // PC update logic
    // =========================================================
    assign pc_d = branch_taken ? branch_target : (pc_q + 32'd4);

    // =========================================================
    // EX/MEM pipeline register
    // =========================================================
    logic [31:0] ex_mem_alu_result;
    logic [31:0] ex_mem_rs2_data;
    logic [4:0]  ex_mem_rd;
    logic        ex_mem_reg_we;
    logic        ex_mem_mem_read;
    logic        ex_mem_mem_write;

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            ex_mem_alu_result <= 32'b0;
            ex_mem_rs2_data   <= 32'b0;
            ex_mem_rd         <= 5'b0;
            ex_mem_reg_we     <= 1'b0;
            ex_mem_mem_read   <= 1'b0;
            ex_mem_mem_write  <= 1'b0;
        end else begin
            ex_mem_alu_result <= alu_result;
            ex_mem_rs2_data   <= rs2_data;
            ex_mem_rd         <= rd;
            ex_mem_reg_we     <= reg_we;
            ex_mem_mem_read   <= mem_read;
            ex_mem_mem_write  <= mem_write;
        end
    end

    // =========================================================
    // MEM stage
    // =========================================================
    logic [31:0] mem_rdata;
    logic        mem_ready;

    mem_if u_mem_if (
        .clk_i        (clk_i),
        .rst_n_i      (rst_n_i),
        .mem_req_i    (ex_mem_mem_read | ex_mem_mem_write),
        .mem_we_i     (ex_mem_mem_write),
        .mem_addr_i  (ex_mem_alu_result),
        .mem_wdata_i (ex_mem_rs2_data),
        .mem_size_i  (2'b10),
        .mem_rdata_o (mem_rdata),
        .mem_ready_o (mem_ready),
        .mem_valid_o (dmem_valid_o),
        .mem_write_o (dmem_we_o),
        .mem_addr_o  (dmem_addr_o),
        .mem_wdata_o (dmem_wdata_o),
        .mem_wstrb_o (dmem_wstrb_o),
        .mem_rdata_i (dmem_rdata_i),
        .mem_ready_i (dmem_ready_i)
    );

    // =========================================================
    // MEM/WB pipeline register
    // =========================================================
    logic        wb_mem_read;
    logic [31:0] wb_mem_data;

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            wb_rd        <= 5'b0;
            wb_we        <= 1'b0;
            wb_mem_read <= 1'b0;
            wb_mem_data <= 32'b0;
        end else begin
            wb_rd        <= ex_mem_rd;
            wb_we        <= ex_mem_reg_we;
            wb_mem_read <= ex_mem_mem_read;
            wb_mem_data <= mem_rdata;
        end
    end

    // =========================================================
    // Writeback stage
    // =========================================================
    assign wb_data = wb_mem_read ? wb_mem_data : ex_mem_alu_result;

endmodule

