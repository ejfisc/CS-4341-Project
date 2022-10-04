// 4 Bit Full Adder

module FourBitFullAdder(A, B, C, carry, sum);
    input [3:0]A;
    input [3:0]B; 
    input C;
    output carry;
    output [3:0]sum;

    wire [2:0]tempC;

    FullAdder FA0(A[0], B[0], C, tempC[0], sum[0]);
    FullAdder FA1(A[1], B[1], tempC[0], tempC[1], sum[1]);
    FullAdder FA2(A[2], B[2], tempC[1], tempC[2], sum[2]);
    FullAdder FA3(A[3], B[3], tempC[2], carry, sum[3]);

endmodule

/*
module testbench();
    reg [3:0]inputA; 
    reg [3:0]inputB; 
    reg inputC;
    wire [3:0]result; 
    wire carry;
    
    FourBitFullAdder F4A(inputA, inputB, inputC, carry, result);

    initial begin
        $display("Addition");
        inputA = 4'b0001;
        inputB = 4'b0101;
        inputC = 0;
        #100;

        $display("%b+%b+%b=%b:%b", inputA, inputB, inputC, carry, result);
    end
endmodule
*/