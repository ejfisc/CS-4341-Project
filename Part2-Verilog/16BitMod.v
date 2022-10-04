//-------------------------------------------------
// 16 Bit Modulus
//-------------------------------------------------


module SixteenBitModulus(numerator,denominator,modulus,error);
input [15:0] numerator;
input [15:0] denominator;
output [31:0] modulus;
output error;

wire [15:0] numerator;
wire [15:0] denominator;
reg [31:0] modulus;
reg error;

always @(numerator,denominator)
begin
modulus=numerator%denominator;
modulus[16]=modulus[15];
modulus[17]=modulus[15];
modulus[18]=modulus[15];
modulus[19]=modulus[15];
modulus[20]=modulus[15];
modulus[21]=modulus[15];
modulus[22]=modulus[15];
modulus[23]=modulus[15];
modulus[24]=modulus[15];
modulus[25]=modulus[15];
modulus[26]=modulus[15];
modulus[27]=modulus[15];
modulus[28]=modulus[15];
modulus[29]=modulus[15];
modulus[30]=modulus[15];
modulus[31]=modulus[15];

error=~(denominator[15]|denominator[14]|denominator[13]|denominator[12]|
        denominator[11]|denominator[10]|denominator[ 9]|denominator[ 8]|
        denominator[ 7]|denominator[ 6]|denominator[ 5]|denominator[ 4]|
        denominator[ 3]|denominator[ 2]|denominator[ 1]|denominator[ 0]);
end

endmodule;


/*
module testbench();

reg [15:0]inputA;
reg [15:0]inputB;
wire [15:0] modulus;
wire error;

SixteenBitModulus M40(inputB,inputA,modulus,error);

initial begin
	inputB=16'b0000000000010000;
	inputA=16'b0000000000000010;
	#60;
	$display("%d,%d,%d,%d",inputB,inputA,modulus,error);

	inputB=16'b1111000000000000;
	inputA=16'b0000000000000000;
	#60;
	$display("%d,%d,%d,%d",inputB,inputA,modulus,error);

end
endmodule
 */
