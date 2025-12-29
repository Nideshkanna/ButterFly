//============================================================
// File      : butterfly_core.sv
// Project   : ButterFly RV32IM Core
// Author    : Nidesh Kanna R
// Description:
//   Top-level core integration
//   Phase C4.3: Branch hazard flush of ID/EX
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
        else pc_q <= pc_d;

    assign imem_addr_o = pc_q;

    // =========================================================
    // IF/ID pipeline register
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
    // ID/EX (for hazard detect)
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
            if_id_instr <= 32'b0;   // FLUSH
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
    // ID/EX register (stall + branch bubble)
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
    // Branch unit (EX)
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
    logic [1:0] fwd_a_sel, fwd_b_sel;
    logic [31:0] alu_op_a, alu_op_b;

    always_comb begin
        fwd_a_sel = 2'b00;
        fwd_b_sel = 2'b00;

        if (ex_mem_reg_we && (ex_mem_rd != 0)) begin
            if (ex_mem_rd == rs1) fwd_a_sel = 2'b10;
            if (ex_mem_rd == rs2) fwd_b_sel = 2'b10;
        end

        if (wb_we && (wb_rd != 0)) begin
            if ((wb_rd == rs1) && (fwd_a_sel == 0)) fwd_a_sel = 2'b01;
            if ((wb_rd == rs2) && (fwd_b_sel == 0)) fwd_b_sel = 2'b01;
        end
    end

    always_comb begin
        alu_op_a = (fwd_a_sel == 2'b10) ? ex_mem_alu_result :
                   (fwd_a_sel == 2'b01) ? wb_data :
                   rs1_data;

        alu_op_b = (fwd_b_sel == 2'b10) ? ex_mem_alu_result :
                   (fwd_b_sel == 2'b01) ? wb_data :
                   imm;
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
    // EX/MEM
    // =========================================================
    logic [31:0] ex_mem_alu_result;
    logic [31:0] ex_mem_rs2_data;
    logic [4:0]  ex_mem_rd;
    logic        ex_mem_reg_we;
    logic        ex_mem_mem_read;
    logic        ex_mem_mem_write;

    always_ff @(posedge clk_i or negedge rst_n_i)
        if (!rst_n_i) begin
            ex_mem_alu_result <= 0;
            ex_mem_rs2_data   <= 0;
            ex_mem_rd         <= 0;
            ex_mem_reg_we     <= 0;
            ex_mem_mem_read   <= 0;
            ex_mem_mem_write  <= 0;
        end else begin
            ex_mem_alu_result <= alu_result;
            ex_mem_rs2_data   <= rs2_data;
            ex_mem_rd         <= id_ex_rd;
            ex_mem_reg_we     <= id_ex_reg_we;
            ex_mem_mem_read   <= id_ex_mem_read;
            ex_mem_mem_write  <= mem_write;
        end

    // =========================================================
    // MEM
    // =========================================================
    mem_if u_mem_if (
        .clk_i        (clk_i),
        .rst_n_i      (rst_n_i),
        .mem_req_i    (ex_mem_mem_read | ex_mem_mem_write),
        .mem_we_i     (ex_mem_mem_write),
        .mem_addr_i   (ex_mem_alu_result),
        .mem_wdata_i  (ex_mem_rs2_data),
        .mem_size_i   (2'b10),
        .mem_rdata_o  (wb_data),
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
    // PC update
    // =========================================================
    assign pc_d = branch_taken ? branch_target :
                  stall        ? pc_q :
                                pc_q + 32'd4;

endmodule

