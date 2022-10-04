//-------------------------------------------------
//
// Sample 4-Bit Full Adder
// Eric William Becker
// September 25, 2022
//
// For my students this semester.
//
//-------------------------------------------------


//=============================================
//
// FourBitFullAdder
//
//=============================================
module FourBitFullAdder(A,B,C,Carry,Sum);
input [3:0] A;
input [3:0] B;
input C;
output Carry;
output [3:0] Sum;
 
wire temp[2:0];

FullAdder FA0(A[0],B[0],C      ,temp[0],Sum[0]);
FullAdder FA1(A[1],B[1],temp[0],temp[1],Sum[1]);
FullAdder FA2(A[2],B[2],temp[1],temp[2],Sum[2]);
FullAdder FA3(A[3],B[3],temp[2],Carry,Sum[3]);

endmodule

/*
module testbench();
//Data Inputs
reg [3:0]dataA;
reg [3:0]dataB;
reg dataC;
//Outputs
wire[3:0]result;
wire carry;
FourBitFullAdder F4A0(dataA,dataB,dataC,carry,result);
initial
begin
//        0123456789ABCDEF
$display("Addition");
dataA=4'b1111; 
dataB=4'b1111;
dataC=0;
#100;

$display("%b+%b+%b=%b:%b",dataA,dataB,dataC,carry,result);

end

endmodule;
*/