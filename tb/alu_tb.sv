module alu_tb;

    logic [31:0] a, b;
    logic [3:0]  op;
    logic [31:0] result;
    logic        zero;

    alu dut (
        .operand_a_i(a),
        .operand_b_i(b),
        .alu_op_i(op),
        .alu_result_o(result),
        .zero_o(zero)
    );

    initial begin
        // ADD
        a = 10; b = 5; op = 4'd0; #1;
        // SUB
        op = 4'd1; #1;
        // AND
        op = 4'd2; #1;
        // SLT
        a = -1; b = 1; op = 4'd5; #1;
        // SLL
        a = 1; b = 3; op = 4'd7; #1;

        $finish;
    end
endmodule

