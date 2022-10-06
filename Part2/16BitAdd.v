
//=============================================
//
// SixteenBitFullAdder
//
//=============================================
module SixteenBitFullAdder(A,B,C,Carry,Sum);
input [15:0] A;
input [15:0] B;
input C;
output Carry;
output [15:0] Sum;
 
wire temp[2:0];

FourBitFullAdder FA0(A[3:0],B[3:0],C      ,temp[0],Sum[3:0]);
FourBitFullAdder FA1(A[7:4],B[7:4],temp[0],temp[1],Sum[7:4]);
FourBitFullAdder FA2(A[11:8],B[11:8],temp[1],temp[2],Sum[11:8]);
FourBitFullAdder FA3(A[15:12],B[15:12],temp[2],Carry,Sum[15:12]);

endmodule

/*
module testbench();
//Data Inputs
reg [15:0]dataA;
reg [15:0]dataB;
reg dataC;
//Outputs
wire[31:0]result;
wire carry;
SixteenBitFullAdder F4A0(dataA,dataB,dataC,carry,result);
initial
begin
//        0123456789ABCDEF
$display("Addition");
dataA=16'b1111111111111111; 
dataB=16'b1111111111111111;
dataC=0;
#100;

$display("%b+%b+%b=%b:%b",dataA,dataB,dataC,carry,result);

end

endmodule;
*/