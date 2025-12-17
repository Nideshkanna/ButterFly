module mem_if_tb;

    logic clk, rst_n;
    logic req, we;
    logic [31:0] addr, wdata;
    logic [1:0] size;
    logic [31:0] rdata;
    logic ready;

    logic mem_valid, mem_write;
    logic [31:0] mem_addr, mem_wdata;
    logic [3:0] mem_wstrb;
    logic [31:0] mem_rdata;
    logic mem_ready;

    mem_if dut (
        .clk_i(clk),
        .rst_n_i(rst_n),
        .mem_req_i(req),
        .mem_we_i(we),
        .mem_addr_i(addr),
        .mem_wdata_i(wdata),
        .mem_size_i(size),
        .mem_rdata_o(rdata),
        .mem_ready_o(ready),
        .mem_valid_o(mem_valid),
        .mem_write_o(mem_write),
        .mem_addr_o(mem_addr),
        .mem_wdata_o(mem_wdata),
        .mem_wstrb_o(mem_wstrb),
        .mem_rdata_i(mem_rdata),
        .mem_ready_i(mem_ready)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        req = 0;
        we = 0;
        addr = 0;
        wdata = 0;
        size = 0;
        mem_rdata = 32'hAABBCCDD;
        mem_ready = 1;

        #20 rst_n = 1;

        // Load byte
        addr = 32'h00000001;
        size = 2'b00;
        req = 1;
        #10;

        // Load halfword
        addr = 32'h00000002;
        size = 2'b01;
        #10;

        // Store word
        we = 1;
        addr = 32'h00000000;
        wdata = 32'h11223344;
        size = 2'b10;
        #10;

        $finish;
    end
endmodule
