module csr_unit_tb;

    logic clk, rst_n;
    logic csr_we;
    logic [11:0] csr_addr;
    logic [31:0] csr_wdata;
    logic [31:0] csr_rdata;
    logic exception;
    logic [31:0] epc, cause;
    logic mret;
    logic [31:0] trap_pc;
    logic trap_taken;
    logic mie;

    csr_unit dut (
        .clk_i(clk),
        .rst_n_i(rst_n),
        .csr_we_i(csr_we),
        .csr_addr_i(csr_addr),
        .csr_wdata_i(csr_wdata),
        .csr_rdata_o(csr_rdata),
        .exception_i(exception),
        .exception_pc_i(epc),
        .exception_cause_i(cause),
        .mret_i(mret),
        .trap_pc_o(trap_pc),
        .trap_taken_o(trap_taken),
        .mie_o(mie)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        csr_we = 0;
        exception = 0;
        mret = 0;

        #20 rst_n = 1;

        // Write mtvec
        csr_addr = 12'h305;
        csr_wdata = 32'h100;
        csr_we = 1;
        #10 csr_we = 0;

        // Trigger exception
        epc = 32'h200;
        cause = 32'd11;
        exception = 1;
        #10 exception = 0;

        // Return from exception
        mret = 1;
        #10 mret = 0;

        $finish;
    end
endmodule

