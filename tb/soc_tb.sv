module soc_tb;

    logic clk;
    logic rst_n;

    soc_top dut (
        .clk_i  (clk),
        .rst_n_i(rst_n)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("soc.vcd");
        $dumpvars(0, dut);   // <<<<<< IMPORTANT

        clk   = 0;
        rst_n = 0;

        #20 rst_n = 1;

        #500;

        $display("x1 = %0d", dut.u_core.u_regfile.regs[1]);
        $display("x2 = %0d", dut.u_core.u_regfile.regs[2]);
        $display("x3 = %0d", dut.u_core.u_regfile.regs[3]);
        $display("x4 = %0d", dut.u_core.u_regfile.regs[4]);

        $finish;
    end

endmodule

