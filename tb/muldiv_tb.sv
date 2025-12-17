//============================================================
// File      : muldiv_tb.sv
// Project   : ButterFly RV32IM Core
// Author    : Nidesh Kanna R
// Description:
//   Testbench for RV32M Mul/Div Unit
//   - Clock-synchronous handshake
//   - Safe for 1-cycle done pulses
//============================================================

`timescale 1ns/1ps

module muldiv_tb;

    // ---------------------------------------------------------
    // Signals
    // ---------------------------------------------------------
    logic        clk;
    logic        rst_n;
    logic        start;
    logic [31:0] a;
    logic [31:0] b;
    logic [2:0]  op;
    logic [31:0] result;
    logic        busy;
    logic        done;

    // ---------------------------------------------------------
    // DUT instantiation
    // ---------------------------------------------------------
    muldiv_unit dut (
        .clk_i(clk),
        .rst_n_i(rst_n),
        .start_i(start),
        .operand_a_i(a),
        .operand_b_i(b),
        .muldiv_op_i(op),
        .result_o(result),
        .busy_o(busy),
        .done_o(done)
    );

    // ---------------------------------------------------------
    // Clock generation (10ns period)
    // ---------------------------------------------------------
    always #5 clk = ~clk;

    // ---------------------------------------------------------
    // Test sequence
    // ---------------------------------------------------------
    initial begin
        // Init
        clk   = 1'b0;
        rst_n = 1'b0;
        start = 1'b0;
        a     = 32'b0;
        b     = 32'b0;
        op    = 3'b0;

        // Apply reset
        repeat (3) @(posedge clk);
        rst_n = 1'b1;

        // -----------------------------------------------------
        // Test 1: MUL (6 * 7 = 42)
        // -----------------------------------------------------
        @(posedge clk);
        a  = 32'd6;
        b  = 32'd7;
        op = 3'd0; // MULDIV_MUL
        start = 1'b1;

        @(posedge clk);
        start = 1'b0;

        while (!done) @(posedge clk);

        $display("[MUL] result = %0d (expected 42)", result);

        // -----------------------------------------------------
        // Test 2: DIV (20 / 4 = 5)
        // -----------------------------------------------------
        @(posedge clk);
        a  = 32'd20;
        b  = 32'd4;
        op = 3'd1; // MULDIV_DIV
        start = 1'b1;

        @(posedge clk);
        start = 1'b0;

        while (!done) @(posedge clk);

        $display("[DIV] result = %0d (expected 5)", result);

        // -----------------------------------------------------
        // Test 3: REM (21 % 4 = 1)
        // -----------------------------------------------------
        @(posedge clk);
        a  = 32'd21;
        b  = 32'd4;
        op = 3'd3; // MULDIV_REM
        start = 1'b1;

        @(posedge clk);
        start = 1'b0;

        while (!done) @(posedge clk);

        $display("[REM] result = %0d (expected 1)", result);

        // -----------------------------------------------------
        // Finish simulation
        // -----------------------------------------------------
        $display("MulDiv TB completed successfully.");
        $finish;
    end

endmodule

