//============================================================
// File      : butterfly_core.sv
// Project   : ButterFly RV32IM Core
// Author    : Nidesh Kanna R
// Description:
//   Top-level core integration
//   FIXED: Correct WB + Store forwarding
//============================================================

`include "butterfly_pkg.sv"

module butterfly_core (
    input  logic        clk_i,
    input  logic        rst_n_i,

    // Instruction memory
    output logic [31:0]  imem_addr_o,
    input  logic [31:0]  imem_rdata_i,

    // Data memory
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

    always_ff @(posedge clk_i or negedge rst_n_i)
        if (!rst_n_i) pc_q <= 32'h0;
        else          pc_q <= pc_d;

    assign imem_addr_o = pc_q;

    // =========================================================
    // IF/ID
    // =========================================================
    logic [31:0] if_id_instr, if_id_pc;

    // =========================================================
    // ID signals
    // =========================================================
    logic [4:0]  rs1, rs2, rd;
    logic [31:0] imm;
    logic [3:0]  alu_op;
    logic        reg_we, mem_read, mem_write;
    logic        branch;
    logic [2:0]  branch_type;

    // =========================================================
    // ID/EX (for hazard detection)
    // =========================================================
    logic [4:0]  id_ex_rd;
    logic        id_ex_mem_read;
    logic        id_ex_reg_we;

    // =========================================================
    // Load-use stall
    // =========================================================
    logic stall;

    always_comb begin
        stall = id_ex_mem_read &&
                (id_ex_rd != 5'd0) &&
                ((id_ex_rd == rs1) || (id_ex_rd == rs2));
    end

    // =========================================================
    // IF/ID register (stall + branch flush)
    // =========================================================
    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            if_id_instr <= 32'b0;
            if_id_pc    <= 32'b0;
        end else if (branch_taken) begin
            if_id_instr <= 32'b0; // FLUSH
            if_id_pc    <= 32'b0;
        end else if (!stall) begin
            if_id_instr <= imem_rdata_i;
            if_id_pc    <= pc_q;
        end
    end

    // =========================================================
    // Decoder
    // =========================================================
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
        .jump_o         (),
        .alu_op_o       (alu_op),
        .branch_type_o  (branch_type)
    );

    // =========================================================
    // ID/EX register (bubble on stall / branch)
    // =========================================================
    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i || stall || branch_taken) begin
            id_ex_rd       <= 5'b0;
            id_ex_mem_read <= 1'b0;
            id_ex_reg_we   <= 1'b0;
        end else begin
            id_ex_rd       <= rd;
            id_ex_mem_read <= mem_read;
            id_ex_reg_we   <= reg_we;
        end
    end

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
    // Branch unit
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
    // EX-stage forwarding
    // =========================================================
    logic [31:0] alu_op_a, alu_op_b;

    always_comb begin
        alu_op_a = rs1_data;
        alu_op_b = imm;

        if (ex_mem_reg_we && (ex_mem_rd != 0)) begin
            if (ex_mem_rd == rs1) alu_op_a = ex_mem_alu_result;
            if (ex_mem_rd == rs2) alu_op_b = ex_mem_alu_result;
        end

        if (wb_we && (wb_rd != 0)) begin
            if (wb_rd == rs1) alu_op_a = wb_data;
            if (wb_rd == rs2) alu_op_b = wb_data;
        end
    end

    // =========================================================
    // ALU
    // =========================================================
    logic [31:0] alu_result;

    alu u_alu (
        .operand_a_i  (alu_op_a),
        .operand_b_i  (alu_op_b),
        .alu_op_i     (alu_op),
        .alu_result_o (alu_result),
        .zero_o       ()
    );

    // =========================================================
    // Store-data forwarding (CRITICAL FIX)
    // =========================================================
    logic [31:0] store_data_fwd;

    always_comb begin
        store_data_fwd = rs2_data;

        if (ex_mem_reg_we && (ex_mem_rd != 0) && (ex_mem_rd == rs2))
            store_data_fwd = ex_mem_alu_result;
        else if (wb_we && (wb_rd != 0) && (wb_rd == rs2))
            store_data_fwd = wb_data;
    end

    // =========================================================
    // EX/MEM
    // =========================================================
    logic [31:0] ex_mem_alu_result;
    logic [31:0] ex_mem_rs2_data;
    logic [4:0]  ex_mem_rd;
    logic        ex_mem_reg_we;
    logic        ex_mem_mem_read;
    logic        ex_mem_mem_write;

    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            ex_mem_alu_result <= 0;
            ex_mem_rs2_data   <= 0;
            ex_mem_rd         <= 0;
            ex_mem_reg_we     <= 0;
            ex_mem_mem_read   <= 0;
            ex_mem_mem_write  <= 0;
        end else begin
            ex_mem_alu_result <= alu_result;
            ex_mem_rs2_data   <= store_data_fwd;
            ex_mem_rd         <= id_ex_rd;
            ex_mem_reg_we     <= id_ex_reg_we;
            ex_mem_mem_read   <= id_ex_mem_read;
            ex_mem_mem_write  <= mem_write;
        end
    end

    // =========================================================
    // MEM stage
    // =========================================================
    logic [31:0] mem_rdata;

    mem_if u_mem_if (
        .clk_i        (clk_i),
        .rst_n_i      (rst_n_i),
        .mem_req_i    (ex_mem_mem_read | ex_mem_mem_write),
        .mem_we_i     (ex_mem_mem_write),
        .mem_addr_i   (ex_mem_alu_result),
        .mem_wdata_i  (ex_mem_rs2_data),
        .mem_size_i   (2'b10),
        .mem_rdata_o  (mem_rdata),
        .mem_ready_o  (),
        .mem_valid_o  (dmem_valid_o),
        .mem_write_o  (dmem_we_o),
        .mem_addr_o   (dmem_addr_o),
        .mem_wdata_o  (dmem_wdata_o),
        .mem_wstrb_o  (dmem_wstrb_o),
        .mem_rdata_i  (dmem_rdata_i),
        .mem_ready_i  (dmem_ready_i)
    );

    // =========================================================
    // MEM/WB (WRITEBACK FIX)
    // =========================================================
    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            wb_data <= 0;
            wb_rd   <= 0;
            wb_we   <= 0;
        end else begin
            wb_data <= ex_mem_mem_read ? mem_rdata : ex_mem_alu_result;
            wb_rd   <= ex_mem_rd;
            wb_we   <= ex_mem_reg_we;
        end
    end

    // =========================================================
    // PC update
    // =========================================================
    assign pc_d = branch_taken ? branch_target :
                  stall        ? pc_q :
                                pc_q + 32'd4;

endmodule

