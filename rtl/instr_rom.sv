//============================================================
// File      : instr_rom.sv
// Project   : ButterFly RV32IM Core
// Description:
//   Instruction ROM (combinational, NOP-filled)
//============================================================

module instr_rom (
    input  logic [31:0] addr_i,
    output logic [31:0] instr_o
);

    logic [31:0] mem [0:255];

    initial begin : init_rom
        integer i;

        // Fill with NOPs (ADDI x0, x0, 0)
        for (i = 0; i < 256; i = i + 1)
            mem[i] = 32'h00000013;

        // Load program (safe overlay)
        $readmemh("programs/test_prog.hex", mem);
    end

    // Word-aligned fetch
    assign instr_o = mem[addr_i[9:2]];

endmodule

