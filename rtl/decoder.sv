//============================================================
// File      : decoder.sv
// Project   : ButterFly RV32IM Core
// Author    : Nidesh Kanna R
// Description:
//   RV32I Instruction Decoder
//   - Decodes instruction fields
//   - Generates immediates
//   - Generates control signals
//============================================================

`include "butterfly_pkg.sv"

module decoder (
    input  logic [31:0] instr_i,

    output logic [4:0]  rs1_addr_o,
    output logic [4:0]  rs2_addr_o,
    output logic [4:0]  rd_addr_o,

    output logic [31:0] imm_o,

    output logic        reg_write_o,
    output logic        mem_read_o,
    output logic        mem_write_o,
    output logic        branch_o,
    output logic        jump_o,

    output logic [3:0]  alu_op_o,
    output logic [2:0]  branch_type_o
);


    // ---------------------------------------------------------
    // Instruction fields
    // ---------------------------------------------------------
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    assign opcode = instr_i[6:0];
    assign funct3 = instr_i[14:12];
    assign funct7 = instr_i[31:25];

    assign rs1_addr_o = instr_i[19:15];
    assign rs2_addr_o = instr_i[24:20];
    assign rd_addr_o  = instr_i[11:7];

    // ---------------------------------------------------------
    // Immediate generation
    // ---------------------------------------------------------
    always_comb begin
        imm_o = 32'b0;

        case (opcode)
            OPCODE_OP_IMM,
            OPCODE_LOAD,
            OPCODE_JALR,
            OPCODE_SYSTEM: // I-type
                imm_o = {{20{instr_i[31]}}, instr_i[31:20]};

            OPCODE_STORE: // S-type
                imm_o = {{20{instr_i[31]}}, instr_i[31:25], instr_i[11:7]};

            OPCODE_BRANCH: // B-type
                imm_o = {{19{instr_i[31]}}, instr_i[31], instr_i[7],
                         instr_i[30:25], instr_i[11:8], 1'b0};

            OPCODE_LUI,
            OPCODE_AUIPC: // U-type
                imm_o = {instr_i[31:12], 12'b0};

            OPCODE_JAL: // J-type
                imm_o = {{11{instr_i[31]}}, instr_i[31], instr_i[19:12],
                         instr_i[20], instr_i[30:21], 1'b0};

            default:
                imm_o = 32'b0;
        endcase
    end

    // ---------------------------------------------------------
    // Control signal generation
    // ---------------------------------------------------------
    always_comb begin
        // Safe defaults
        reg_write_o   = 1'b0;
        mem_read_o    = 1'b0;
        mem_write_o   = 1'b0;
        branch_o      = 1'b0;
        jump_o        = 1'b0;
        alu_op_o      = ALU_ADD;
        branch_type_o = BR_NONE;

        case (opcode)

            OPCODE_OP: begin
                reg_write_o = 1'b1;
                case (funct3)
                    F3_ADD_SUB:
                        alu_op_o = (funct7 == 7'b0100000) ? ALU_SUB : ALU_ADD;
                    F3_AND:  alu_op_o = ALU_AND;
                    F3_OR:   alu_op_o = ALU_OR;
                    F3_XOR:  alu_op_o = ALU_XOR;
                    F3_SLT:  alu_op_o = ALU_SLT;
                    F3_SLTU: alu_op_o = ALU_SLTU;
                    F3_SLL:  alu_op_o = ALU_SLL;
                    F3_SRL_SRA:
                        alu_op_o = (funct7 == 7'b0100000) ? ALU_SRA : ALU_SRL;
                    default: alu_op_o = ALU_ADD;
                endcase
            end

            OPCODE_OP_IMM: begin
                reg_write_o = 1'b1;
                case (funct3)
                    F3_ADD_SUB: alu_op_o = ALU_ADD;
                    F3_AND:     alu_op_o = ALU_AND;
                    F3_OR:      alu_op_o = ALU_OR;
                    F3_XOR:     alu_op_o = ALU_XOR;
                    F3_SLT:     alu_op_o = ALU_SLT;
                    F3_SLTU:    alu_op_o = ALU_SLTU;
                    F3_SLL:     alu_op_o = ALU_SLL;
                    F3_SRL_SRA:
                        alu_op_o = instr_i[30] ? ALU_SRA : ALU_SRL;
                   default: alu_op_o = ALU_ADD;
                endcase
            end

            OPCODE_LOAD: begin
                reg_write_o = 1'b1;
                mem_read_o  = 1'b1;
                alu_op_o    = ALU_ADD;
            end

            OPCODE_STORE: begin
                mem_write_o = 1'b1;
                alu_op_o    = ALU_ADD;
            end

            OPCODE_BRANCH: begin
                branch_o = 1'b1;
                case (funct3)
                    3'b000: branch_type_o = BR_BEQ;
                    3'b001: branch_type_o = BR_BNE;
                    3'b100: branch_type_o = BR_BLT;
                    3'b101: branch_type_o = BR_BGE;
                    3'b110: branch_type_o = BR_BLTU;
                    3'b111: branch_type_o = BR_BGEU;
                    default: branch_type_o = BR_NONE;
                endcase
            end

            OPCODE_JAL,
            OPCODE_JALR: begin
                jump_o      = 1'b1;
                reg_write_o = 1'b1;
                alu_op_o    = ALU_ADD;
            end

            default: begin
                // Illegal or unsupported instruction
            end

        endcase
    end

endmodule
 
