//============================================================
// File      : soc_top.sv
// Project   : ButterFly RV32IM Core
// Description:
//   Minimal SoC wrapper for simulation
//============================================================

module soc_top (
    input logic clk_i,
    input logic rst_n_i
);

    logic [31:0] pc;
    logic [31:0] instr;

    // -------------------------------
    // Instruction ROM (combinational)
    // -------------------------------
    instr_rom u_rom (
        .addr_i  (pc),
        .instr_o (instr)
    );

    // -------------------------------
    // Core
    // -------------------------------
    butterfly_core u_core (
        .clk_i        (clk_i),
        .rst_n_i      (rst_n_i),

        .imem_addr_o  (pc),
        .imem_rdata_i (instr),

        // Data memory (stubbed for now)
        .dmem_valid_o (),
        .dmem_we_o    (),
        .dmem_addr_o  (),
        .dmem_wdata_o (),
        .dmem_wstrb_o (),
        .dmem_rdata_i (32'b0),
        .dmem_ready_i (1'b1)
    );

endmodule

