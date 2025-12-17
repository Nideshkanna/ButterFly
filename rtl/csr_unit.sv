//============================================================
// File      : csr_unit.sv
// Project   : ButterFly RV32IM Core
// Author    : Nidesh Kanna R
// Description:
//   Machine-mode Control and Status Registers (CSR)
//============================================================

module csr_unit (
    input  logic        clk_i,
    input  logic        rst_n_i,

    // CSR access
    input  logic        csr_we_i,
    input  logic [11:0] csr_addr_i,
    input  logic [31:0] csr_wdata_i,
    output logic [31:0] csr_rdata_o,

    // Exception interface
    input  logic        exception_i,
    input  logic [31:0] exception_pc_i,
    input  logic [31:0] exception_cause_i,

    // MRET
    input  logic        mret_i,

    // Outputs
    output logic [31:0] trap_pc_o,
    output logic        trap_taken_o,
    output logic        mie_o
);

    // ---------------------------------------------------------
    // CSR registers
    // ---------------------------------------------------------
    logic [31:0] mstatus;
    logic [31:0] mtvec;
    logic [31:0] mepc;
    logic [31:0] mcause;

    // ---------------------------------------------------------
    // Reset & write logic
    // ---------------------------------------------------------
    always_ff @(posedge clk_i or negedge rst_n_i) begin
        if (!rst_n_i) begin
            mstatus <= 32'b0;
            mtvec   <= 32'b0;
            mepc    <= 32'b0;
            mcause  <= 32'b0;
        end else begin
            // CSR writes
            if (csr_we_i) begin
                case (csr_addr_i)
                    12'h300: mstatus <= csr_wdata_i;
                    12'h305: mtvec   <= csr_wdata_i;
                    12'h341: mepc    <= csr_wdata_i;
                    12'h342: mcause  <= csr_wdata_i;
                    default: ;
                endcase
            end

            // Exception entry
            if (exception_i) begin
                mepc   <= exception_pc_i;
                mcause <= exception_cause_i;
                mstatus[3] <= 1'b0; // MIE = 0
            end

            // MRET
            if (mret_i) begin
                mstatus[3] <= 1'b1; // MIE = 1
            end
        end
    end

    // ---------------------------------------------------------
    // CSR read mux
    // ---------------------------------------------------------
    always_comb begin
        case (csr_addr_i)
            12'h300: csr_rdata_o = mstatus;
            12'h305: csr_rdata_o = mtvec;
            12'h341: csr_rdata_o = mepc;
            12'h342: csr_rdata_o = mcause;
            default: csr_rdata_o = 32'b0;
        endcase
    end

    // ---------------------------------------------------------
    // Trap control
    // ---------------------------------------------------------
    assign trap_taken_o = exception_i;
    assign trap_pc_o    = exception_i ? mtvec : mepc;

    // Global interrupt enable
    assign mie_o = mstatus[3];

endmodule

