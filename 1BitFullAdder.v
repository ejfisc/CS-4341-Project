// 1 Bit Full Adder

module FullAdder(A, B, C, carry, sum);
    input A, B, C;
    output carry, sum;
    reg carry, sum;

    always @(*) begin
        sum = A^B^C;
        carry = ((A^B)&C)|(A&B);
    end
endmodule

/*
module testbench();
    reg inputA, inputB, inputC;
    wire outputC, outputS;
    FullAdder add(inputB, inputA, inputC, outputC, outputS);

    initial begin
        inputA = 1'b1;
        inputB = 1'b1;
        inputC = 1'b1;
        #60;
        $display("%b+%b+%b= %b%b",inputA,inputB,inputC,outputC,outputS);
        $display("%d+%d+%d= %2d",inputA,inputB,inputC,2*outputC+outputS);
    end
endmodule
*/