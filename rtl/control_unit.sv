//============================================================
// File      : control_unit.sv
// Project   : ButterFly RV32IM Core
// Author    : Nidesh Kanna R
// Description:
//   Pipeline control logic.
//   Handles stalls, flushes, forwarding, and hazards.
//============================================================

`include "butterfly_pkg.sv"

module control_unit (
    // Inputs from pipeline stages
    input  logic        branch_taken_i,
    input  logic        muldiv_busy_i,
    input  logic        mem_busy_i,

    // Hazard inputs
    input  logic        load_use_hazard_i,

    // Control outputs
    output logic        stall_if_o,
    output logic        stall_id_o,
    output logic        stall_ex_o,

    output logic        flush_if_o,
    output logic        flush_id_o,
    output logic        flush_ex_o
);

    // TODO:
    // - Stall logic
    // - Flush logic
    // - Priority resolution

endmodule

