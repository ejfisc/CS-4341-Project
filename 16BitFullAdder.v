// Sixteen Bit Full Adder
module SixteenBitFullAdder(A, B, C, carry, sum);
    input [15:0]A;
    input [15:0]B; 
    input C;
    output carry; 
    output [15:0]sum;

    wire tempC[2:0];

    FourBitFullAdder FA40(A[3:0], B[3:0], C, tempC[0], sum[3:0]);
    FourBitFullAdder FA41(A[7:4], B[7:4], tempC[0], tempC[1], sum[7:4]);
    FourBitFullAdder FA42(A[11:8], B[11:8], tempC[1], tempC[2], sum[11:8]);
    FourBitFullAdder FA43(A[15:12], B[15:12], tempC[2], carry, sum[15:12]);

endmodule

module testbench();
    reg [15:0]inputA; 
    reg [15:0]inputB; 
    reg inputC;
    wire [15:0]result; 
    wire carry;

    SixteenBitFullAdder F16A(inputA, inputB, inputC, carry, result);

    initial begin
        $display("Addition");
        inputA = 16'b0000000000001111;
        inputB = 16'b0000111100001111;
        inputC = 0;
        #100;

        $display("%b+%b+%b=%b:%b", inputA, inputB, inputC, carry, result);
    end
endmodule
