//-------------------------------------------------
//main for project part 2
//-------------------------------------------------



//=================================================================
//
//Breadboard
//
//=================================================================
module breadboard(A,B,C,opcode,error);
//=======================================================
//
// Parameter Definitions
//
//========================================================
input [15:0] A;
input [15:0] B;
input [3:0] opcode;
wire clk;
wire rst;
wire [15:0] A;
wire [15:0] B;
wire [3:0] opcode;

output [1:0]error;
reg [1:0]error;
//----------------------------------
output [31:0] C;
reg [31:0] C;
//----------------------------------


//=======================================================
//
// CONTROL
//
//========================================================
wire [15:0][31:0]channels;
wire [15:0] select;
wire [31:0] b;
wire [31:0] unknown;

Dec4x16 dec1(opcode,select);
StructMux mux1(channels,select,b);

//=======================================================
//
// OPERATIONS
//
//=======================================================
wire [31:0] outputADDSUB;
wire ADDerror;
wire [31:0] outputMUL;
wire [31:0] outputDIV;
wire DIVerror;
wire [31:0] outputMOD;
wire MODerror;

SixteenBitAddSub     add1(B,A,modeSUB,outputADDSUB,Carry,ADDerror);
SixteenBitMultiplier mul1(B,A,outputMUL);
SixteenBitDivision   div1(B,A,outputDIV,DIVerror);
SixteenBitModulus    mod1(B,A,outputMOD,MODerror); 

//=======================================================
//
// Error Reporting
//
//=======================================================
reg modeADD;
reg modeSUB;
reg modeDIV;
reg modeMOD;

//=======================================================
//
// Connect the MUX to the OpCodes
//
// Channel 4, Opcode 0100, Addition
// Channel 5, Opcode 0101, Subtraction
// Channel 6, Opcode 0110, Mulitplication
// Channel 7, Opcode 0111, Division (Behavioral)
// Channel 8, Opcode 1000, Modulus (Behavioral)
//
//=======================================================
assign channels[ 0]=unknown;
assign channels[ 1]=unknown;
assign channels[ 2]=unknown;
assign channels[ 3]=unknown;
assign channels[ 4]=outputADDSUB;
assign channels[ 5]=outputADDSUB;
assign channels[ 6]=outputMUL;
assign channels[ 7]=outputDIV;
assign channels[ 8]=outputMOD;
assign channels[ 9]=unknown;
assign channels[10]=unknown;
assign channels[11]=unknown;
assign channels[12]=unknown;
assign channels[13]=unknown;
assign channels[14]=unknown;
assign channels[15]=unknown;

//====================================================
//
//Perform the gate-level operations in the Breadboard
//
//====================================================
always@(*)
begin
   modeADD=~opcode[3]& opcode[2]&~opcode[1]&~opcode[0];//0100, Channel 4
   modeSUB=~opcode[3]& opcode[2]&~opcode[1]& opcode[0];//0101, Channel 5
   modeDIV=~opcode[3]& opcode[2]& opcode[1]& opcode[0];//0111, Channel 7
   modeMOD= opcode[3]&~opcode[2]&~opcode[1]&~opcode[0];//1000, Channel 8
   C=b; //Just a jumper
   error[0]=ADDerror&(modeADD|modeSUB);//Only show overflow if in add or subtract operation
   error[1]=(DIVerror|MODerror)&(modeDIV|modeMOD);//only show divide by zero if in division or modulus operation
end


endmodule

//=============================================
//
// Full Adder
//
//=============================================
module FullAdder(A,B,C,carry,sum);
	input A;
	input B;
	input C;
	output carry;
	output sum;
	reg carry;
	reg sum;
//---------------------------------------------	
 
	always @(*) 
	  begin
		sum= A^B^C;
		carry= ((A^B)&C)|(A&B);  
	  end
//---------------------------------------------
endmodule

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

//=================================================================
//
// DECODER
//
//=================================================================
module Dec4x16(binary,onehot);

	input [3:0] binary;
	output [15:0]onehot;
	
	assign onehot[ 0]=~binary[3]&~binary[2]&~binary[1]&~binary[0];
	assign onehot[ 1]=~binary[3]&~binary[2]&~binary[1]& binary[0];
	assign onehot[ 2]=~binary[3]&~binary[2]& binary[1]&~binary[0];
	assign onehot[ 3]=~binary[3]&~binary[2]& binary[1]& binary[0];
	assign onehot[ 4]=~binary[3]& binary[2]&~binary[1]&~binary[0];
	assign onehot[ 5]=~binary[3]& binary[2]&~binary[1]& binary[0];
	assign onehot[ 6]=~binary[3]& binary[2]& binary[1]&~binary[0];
	assign onehot[ 7]=~binary[3]& binary[2]& binary[1]& binary[0];
	assign onehot[ 8]= binary[3]&~binary[2]&~binary[1]&~binary[0];
	assign onehot[ 9]= binary[3]&~binary[2]&~binary[1]& binary[0];
	assign onehot[10]= binary[3]&~binary[2]& binary[1]&~binary[0];
	assign onehot[11]= binary[3]&~binary[2]& binary[1]& binary[0];
	assign onehot[12]= binary[3]& binary[2]&~binary[1]&~binary[0];
	assign onehot[13]= binary[3]& binary[2]&~binary[1]& binary[0];
	assign onehot[14]= binary[3]& binary[2]& binary[1]&~binary[0];
	assign onehot[15]= binary[3]& binary[2]& binary[1]& binary[0];
	
endmodule

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

//=============================================
//
// SixteenBitFullAddSub
//
//=============================================
module SixteenBitAddSub(inputA,inputB,mode, sum, carry, overflow);
input [15:0] inputA;
input [15:0] inputB;
input mode;
output [31:0] sum;
output carry;
output overflow;
 
wire c0; //MOde assigned to C0
wire b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15; //XOR Interfaces
wire c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16; //Carry Interfaces
	
assign c0=mode;//Mode=0, Addition; Mode=1, Subtraction

assign b0 = inputB[0] ^ mode;
assign b1 = inputB[1] ^ mode;
assign b2 = inputB[2] ^ mode;
assign b3 = inputB[3] ^ mode;
assign b4 = inputB[4] ^ mode;
assign b5 = inputB[5] ^ mode;
assign b6 = inputB[6] ^ mode;
assign b7 = inputB[7] ^ mode;
assign b8 = inputB[8] ^ mode;
assign b9 = inputB[9] ^ mode;
assign b10 = inputB[10] ^ mode;
assign b11 = inputB[11] ^ mode;
assign b12 = inputB[12] ^ mode;
assign b13 = inputB[13] ^ mode;
assign b14 = inputB[14] ^ mode;
assign b15 = inputB[15] ^ mode;

FullAdder FA0(inputA[0],b0, c0, c1,sum[0]);
FullAdder FA1(inputA[1],b1, c1, c2,sum[1]);
FullAdder FA2(inputA[2],b2, c2, c3,sum[2]);
FullAdder FA3(inputA[3],b3, c3, c4,sum[3]);
FullAdder FA4(inputA[4],b4, c4, c5,sum[4]);
FullAdder FA5(inputA[5],b5, c5, c6,sum[5]);
FullAdder FA6(inputA[6],b6, c6, c7,sum[6]);
FullAdder FA7(inputA[7],b7, c7, c8,sum[7]);
FullAdder FA8(inputA[8],b8, c8, c9,sum[8]);
FullAdder FA9(inputA[9],b9, c9, c10,sum[9]);
FullAdder FA10(inputA[10],b10, c10, c11,sum[10]);
FullAdder FA11(inputA[11],b11, c11, c12,sum[11]);
FullAdder FA12(inputA[12],b12, c12, c13,sum[12]);
FullAdder FA13(inputA[13],b13, c13, c14,sum[13]);
FullAdder FA14(inputA[14],b14, c14, c15,sum[14]);
FullAdder FA15(inputA[15],b15, c15, c16,sum[15]);

assign sum[16]=sum[15];
assign sum[17]=sum[15];
assign sum[18]=sum[15];
assign sum[19]=sum[15];
assign sum[20]=sum[15];
assign sum[21]=sum[15];
assign sum[22]=sum[15];
assign sum[23]=sum[15];
assign sum[24]=sum[15];
assign sum[25]=sum[15];
assign sum[26]=sum[15];
assign sum[27]=sum[15];
assign sum[28]=sum[15];
assign sum[29]=sum[15];
assign sum[30]=sum[15];
assign sum[31]=sum[15];


assign carry = c16;
assign overflow = c16^c15;
endmodule
//====================================================
//
//16 Bit Division
//
//====================================================
module SixteenBitDivision(numerator,denominator,quotient,error);
input [15:0] numerator;
input [15:0] denominator;
output [31:0] quotient;
output error;

wire [15:0] numerator;
wire [15:0] denominator;
reg [31:0] quotient;
reg error;

always @(numerator,denominator)
begin
quotient=numerator/denominator;
quotient[16]=quotient[15];
quotient[17]=quotient[15];
quotient[18]=quotient[15];
quotient[19]=quotient[15];
quotient[20]=quotient[15];
quotient[21]=quotient[15];
quotient[22]=quotient[15];
quotient[23]=quotient[15];
quotient[24]=quotient[15];
quotient[25]=quotient[15];
quotient[26]=quotient[15];
quotient[27]=quotient[15];
quotient[28]=quotient[15];
quotient[29]=quotient[15];
quotient[30]=quotient[15];
quotient[31]=quotient[15];
error=~(denominator[15]|denominator[14]|denominator[13]|denominator[12]|
        denominator[11]|denominator[10]|denominator[ 9]|denominator[ 8]|
        denominator[ 7]|denominator[ 6]|denominator[ 5]|denominator[ 4]|
        denominator[ 3]|denominator[ 2]|denominator[ 1]|denominator[ 0]);
end

endmodule;

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

//=================================================================
//
// SixteenBitMultiplier
//  currently not working
// Inputs:
// A, a 16-Bit Integer Input
// B, a 16-Bit Integer Input
// C, an 32-Bit Integer Output
//=================================================================
module SixteenBitMultiplier(A,B,C);
input  [15:0] A;
input  [15:0] B;
output [31:0] C;

reg [31:0] C;

//Local Variables
reg  [15:0] Augend0;
reg  [15:0] Adend0;
wire [15:0] Sum0;
wire  Carry0;

reg  [15:0] Augend1;
reg  [15:0] Adend1;
wire [15:0] Sum1;
wire  Carry1;

reg  [15:0] Augend2;
reg  [15:0] Adend2;
wire [15:0] Sum2;
wire  Carry2;

reg  [15:0] Augend3;
reg  [15:0] Adend3;
wire [15:0] Sum3;
wire  Carry3;

reg [15:0] Augend4;
reg [15:0] Adend4;
wire [15:0] Sum4;
wire Carry4;

reg [15:0] Augend5;
reg [15:0] Adend5;
wire [15:0] Sum5;
wire Carry5;

reg [15:0] Augend6;
reg [15:0] Adend6;
wire [15:0] Sum6;
wire Carry6;

reg [15:0] Augend7;
reg [15:0] Adend7;
wire [15:0] Sum7;
wire Carry7;

reg [15:0] Augend8;
reg [15:0] Adend8;
wire [15:0] Sum8;
wire Carry8;

reg [15:0] Augend9;
reg [15:0] Adend9;
wire [15:0] Sum9;
wire Carry9;

reg [15:0] Augend10;
reg [15:0] Adend10;
wire [15:0] Sum10;
wire Carry10;

reg [15:0] Augend11;
reg [15:0] Adend11;
wire [15:0] Sum11;
wire Carry11;

reg [15:0] Augend12;
reg [15:0] Adend12;
wire [15:0] Sum12;
wire Carry12;

reg [15:0] Augend13;
reg [15:0] Adend13;
wire [15:0] Sum13;
wire Carry13;

reg [15:0] Augend14;
reg [15:0] Adend14;
wire [15:0] Sum14;
wire Carry14;

reg [15:0] Augend15;
reg [15:0] Adend15;
wire [15:0] Sum15;
wire Carry15;


SixteenBitFullAdder add0(Augend0,Adend0,1'b0,Carry0,Sum0);
SixteenBitFullAdder add1(Augend1,Adend1,1'b0,Carry1,Sum1);
SixteenBitFullAdder add2(Augend2,Adend2,1'b0,Carry2,Sum2);
SixteenBitFullAdder add3(Augend3,Adend3,1'b0,Carry3,Sum3);
SixteenBitFullAdder add4(Augend4,Adend4,1'b0,Carry4,Sum4);
SixteenBitFullAdder add5(Augend5,Adend5,1'b0,Carry5,Sum5);
SixteenBitFullAdder add6(Augend6,Adend6,1'b0,Carry6,Sum6);
SixteenBitFullAdder add7(Augend7,Adend7,1'b0,Carry7,Sum7);
SixteenBitFullAdder add8(Augend8,Adend8,1'b0,Carry8,Sum8);
SixteenBitFullAdder add9(Augend9,Adend9,1'b0,Carry9,Sum9);
SixteenBitFullAdder add10(Augend10,Adend10,1'b0,Carry10,Sum10);
SixteenBitFullAdder add11(Augend11,Adend11,1'b0,Carry11,Sum11);
SixteenBitFullAdder add12(Augend12,Adend12,1'b0,Carry12,Sum12);
SixteenBitFullAdder add13(Augend13,Adend13,1'b0,Carry13,Sum13);
SixteenBitFullAdder add14(Augend14,Adend14,1'b0,Carry14,Sum14);
SixteenBitFullAdder add15(Augend15,Adend15,1'b0,Carry15,Sum15);

always@(*)
begin

  
  Augend0={     1'b0,A[0]&B[15],A[0]&B[14],A[0]&B[13],
          A[0]&B[12],A[0]&B[11],A[0]&B[10],A[0]&B[ 9],
          A[0]&B[ 8],A[0]&B[ 7],A[0]&B[ 6],A[0]&B[ 5],
          A[0]&B[ 4],A[0]&B[ 3],A[0]&B[ 2],A[0]&B[ 1]}; //A[0] by B

   Adend0={ A[1]&B[15],A[1]&B[14],A[1]&B[13], A[1]&B[12],
            A[1]&B[11],A[1]&B[10],A[1]&B[ 9], A[1]&B[ 8],
            A[1]&B[ 7],A[1]&B[ 6],A[1]&B[ 5], A[1]&B[ 4],
            A[1]&B[ 3],A[1]&B[ 2],A[1]&B[ 1], A[1]&B[ 0]}; //A[1] by B

  Augend1={Carry0, Sum0[15], Sum0[14], Sum0[13],
			Sum0[12], Sum0[11], Sum0[10], Sum0[9],
			Sum0[8], Sum0[7], Sum0[6], Sum0[5],
			Sum0[4], Sum0[3], Sum0[2], Sum0[1]};
Adend1={ A[2]&B[15],A[2]&B[14],A[2]&B[13], A[2]&B[12],
			A[2]&B[11],A[2]&B[10],A[2]&B[ 9], A[2]&B[ 8],
			A[2]&B[ 7],A[2]&B[ 6],A[2]&B[ 5], A[2]&B[ 4],
			A[2]&B[ 3],A[2]&B[ 2],A[2]&B[ 1], A[2]&B[ 0]};

Augend2={Carry1, Sum1[15], Sum1[14], Sum1[13],
			Sum1[12], Sum1[11], Sum1[10], Sum1[9],
			Sum1[8], Sum1[7], Sum1[6], Sum1[5],
			Sum1[4], Sum1[3], Sum1[2], Sum1[1]};
Adend2={ A[3]&B[15],A[3]&B[14],A[3]&B[13], A[3]&B[12],
			A[3]&B[11],A[3]&B[10],A[3]&B[ 9], A[3]&B[ 8],
			A[3]&B[ 7],A[3]&B[ 6],A[3]&B[ 5], A[3]&B[ 4],
			A[3]&B[ 3],A[3]&B[ 2],A[3]&B[ 1], A[3]&B[ 0]};

Augend3={Carry2, Sum2[15], Sum2[14], Sum2[13],
			Sum2[12], Sum2[11], Sum2[10], Sum2[9],
			Sum2[8], Sum2[7], Sum2[6], Sum2[5],
			Sum2[4], Sum2[3], Sum2[2], Sum2[1]};
Adend3={ A[4]&B[15],A[4]&B[14],A[4]&B[13], A[4]&B[12],
			A[4]&B[11],A[4]&B[10],A[4]&B[ 9], A[4]&B[ 8],
			A[4]&B[ 7],A[4]&B[ 6],A[4]&B[ 5], A[4]&B[ 4],
			A[4]&B[ 3],A[4]&B[ 2],A[4]&B[ 1], A[4]&B[ 0]};

Augend4={Carry3, Sum3[15], Sum3[14], Sum3[13],
			Sum3[12], Sum3[11], Sum3[10], Sum3[9],
			Sum3[8], Sum3[7], Sum3[6], Sum3[5],
			Sum3[4], Sum3[3], Sum3[2], Sum3[1]};
Adend4={ A[5]&B[15],A[5]&B[14],A[5]&B[13], A[5]&B[12],
			A[5]&B[11],A[5]&B[10],A[5]&B[ 9], A[5]&B[ 8],
			A[5]&B[ 7],A[5]&B[ 6],A[5]&B[ 5], A[5]&B[ 4],
			A[5]&B[ 3],A[5]&B[ 2],A[5]&B[ 1], A[5]&B[ 0]};

Augend5={Carry4, Sum4[15], Sum4[14], Sum4[13],
			Sum4[12], Sum4[11], Sum4[10], Sum4[9],
			Sum4[8], Sum4[7], Sum4[6], Sum4[5],
			Sum4[4], Sum4[3], Sum4[2], Sum4[1]};
Adend5={ A[6]&B[15],A[6]&B[14],A[6]&B[13], A[6]&B[12],
			A[6]&B[11],A[6]&B[10],A[6]&B[ 9], A[6]&B[ 8],
			A[6]&B[ 7],A[6]&B[ 6],A[6]&B[ 5], A[6]&B[ 4],
			A[6]&B[ 3],A[6]&B[ 2],A[6]&B[ 1], A[6]&B[ 0]};

Augend6={Carry5, Sum5[15], Sum5[14], Sum5[13],
			Sum5[12], Sum5[11], Sum5[10], Sum5[9],
			Sum5[8], Sum5[7], Sum5[6], Sum5[5],
			Sum5[4], Sum5[3], Sum5[2], Sum5[1]};
Adend6={ A[7]&B[15],A[7]&B[14],A[7]&B[13], A[7]&B[12],
			A[7]&B[11],A[7]&B[10],A[7]&B[ 9], A[7]&B[ 8],
			A[7]&B[ 7],A[7]&B[ 6],A[7]&B[ 5], A[7]&B[ 4],
			A[7]&B[ 3],A[7]&B[ 2],A[7]&B[ 1], A[7]&B[ 0]};

Augend7={Carry6, Sum6[15], Sum6[14], Sum6[13],
			Sum6[12], Sum6[11], Sum6[10], Sum6[9],
			Sum6[8], Sum6[7], Sum6[6], Sum6[5],
			Sum6[4], Sum6[3], Sum6[2], Sum6[1]};
Adend7={ A[8]&B[15],A[8]&B[14],A[8]&B[13], A[8]&B[12],
			A[8]&B[11],A[8]&B[10],A[8]&B[ 9], A[8]&B[ 8],
			A[8]&B[ 7],A[8]&B[ 6],A[8]&B[ 5], A[8]&B[ 4],
			A[8]&B[ 3],A[8]&B[ 2],A[8]&B[ 1], A[8]&B[ 0]};

Augend8={Carry7, Sum7[15], Sum7[14], Sum7[13],
			Sum7[12], Sum7[11], Sum7[10], Sum7[9],
			Sum7[8], Sum7[7], Sum7[6], Sum7[5],
			Sum7[4], Sum7[3], Sum7[2], Sum7[1]};
Adend8={ A[9]&B[15],A[9]&B[14],A[9]&B[13], A[9]&B[12],
			A[9]&B[11],A[9]&B[10],A[9]&B[ 9], A[9]&B[ 8],
			A[9]&B[ 7],A[9]&B[ 6],A[9]&B[ 5], A[9]&B[ 4],
			A[9]&B[ 3],A[9]&B[ 2],A[9]&B[ 1], A[9]&B[ 0]};

Augend9={Carry8, Sum8[15], Sum8[14], Sum8[13],
			Sum8[12], Sum8[11], Sum8[10], Sum8[9],
			Sum8[8], Sum8[7], Sum8[6], Sum8[5],
			Sum8[4], Sum8[3], Sum8[2], Sum8[1]};
Adend9={ A[10]&B[15],A[10]&B[14],A[10]&B[13], A[10]&B[12],
			A[10]&B[11],A[10]&B[10],A[10]&B[ 9], A[10]&B[ 8],
			A[10]&B[ 7],A[10]&B[ 6],A[10]&B[ 5], A[10]&B[ 4],
			A[10]&B[ 3],A[10]&B[ 2],A[10]&B[ 1], A[10]&B[ 0]};

Augend10={Carry9, Sum9[15], Sum9[14], Sum9[13],
			Sum9[12], Sum9[11], Sum9[10], Sum9[9],
			Sum9[8], Sum9[7], Sum9[6], Sum9[5],
			Sum9[4], Sum9[3], Sum9[2], Sum9[1]};
Adend10={ A[11]&B[15],A[11]&B[14],A[11]&B[13], A[11]&B[12],
			A[11]&B[11],A[11]&B[10],A[11]&B[ 9], A[11]&B[ 8],
			A[11]&B[ 7],A[11]&B[ 6],A[11]&B[ 5], A[11]&B[ 4],
			A[11]&B[ 3],A[11]&B[ 2],A[11]&B[ 1], A[11]&B[ 0]};

Augend11={Carry10, Sum10[15], Sum10[14], Sum10[13],
			Sum10[12], Sum10[11], Sum10[10], Sum10[9],
			Sum10[8], Sum10[7], Sum10[6], Sum10[5],
			Sum10[4], Sum10[3], Sum10[2], Sum10[1]};
Adend11={ A[12]&B[15],A[12]&B[14],A[12]&B[13], A[12]&B[12],
			A[12]&B[11],A[12]&B[10],A[12]&B[ 9], A[12]&B[ 8],
			A[12]&B[ 7],A[12]&B[ 6],A[12]&B[ 5], A[12]&B[ 4],
			A[12]&B[ 3],A[12]&B[ 2],A[12]&B[ 1], A[12]&B[ 0]};

Augend12={Carry11, Sum11[15], Sum11[14], Sum11[13],
			Sum11[12], Sum11[11], Sum11[10], Sum11[9],
			Sum11[8], Sum11[7], Sum11[6], Sum11[5],
			Sum11[4], Sum11[3], Sum11[2], Sum11[1]};
Adend12={ A[13]&B[15],A[13]&B[14],A[13]&B[13], A[13]&B[12],
			A[13]&B[11],A[13]&B[10],A[13]&B[ 9], A[13]&B[ 8],
			A[13]&B[ 7],A[13]&B[ 6],A[13]&B[ 5], A[13]&B[ 4],
			A[13]&B[ 3],A[13]&B[ 2],A[13]&B[ 1], A[13]&B[ 0]};

Augend13={Carry12, Sum12[15], Sum12[14], Sum12[13],
			Sum12[12], Sum12[11], Sum12[10], Sum12[9],
			Sum12[8], Sum12[7], Sum12[6], Sum12[5],
			Sum12[4], Sum12[3], Sum12[2], Sum12[1]};
Adend13={ A[14]&B[15],A[14]&B[14],A[14]&B[13], A[14]&B[12],
			A[14]&B[11],A[14]&B[10],A[14]&B[ 9], A[14]&B[ 8],
			A[14]&B[ 7],A[14]&B[ 6],A[14]&B[ 5], A[14]&B[ 4],
			A[14]&B[ 3],A[14]&B[ 2],A[14]&B[ 1], A[14]&B[ 0]};

Augend14={Carry13, Sum13[15], Sum13[14], Sum13[13],
			Sum13[12], Sum13[11], Sum13[10], Sum13[9],
			Sum13[8], Sum13[7], Sum13[6], Sum13[5],
			Sum13[4], Sum13[3], Sum13[2], Sum13[1]};
Adend14={ A[15]&B[15],A[15]&B[14],A[15]&B[13], A[15]&B[12],
			A[15]&B[11],A[15]&B[10],A[15]&B[ 9], A[15]&B[ 8],
			A[15]&B[ 7],A[15]&B[ 6],A[15]&B[ 5], A[15]&B[ 4],
			A[15]&B[ 3],A[15]&B[ 2],A[15]&B[ 1], A[15]&B[ 0]};

  C[0] = A[0]&B[0];
  C[1] = Sum0[0];
  C[2] = Sum1[0];
  C[3] = Sum2[0];
  C[4] = Sum3[0];
  C[5] = Sum4[0];
  C[6] = Sum5[0];
  C[7] = Sum6[0];
  C[8] = Sum7[0];
  C[9] = Sum8[0];
  C[10] = Sum9[0];
  C[11] = Sum10[0];
  C[12] = Sum11[0];
  C[13] = Sum12[0];
  C[14] = Sum13[0];
  //-----//
  C[15] = Sum14[0];
  C[16] = Sum14[1];
  C[17] = Sum14[2];
  C[18] = Sum14[3];
  C[19] = Sum14[4];
  C[20] = Sum14[5];
  C[21] = Sum14[6];
  C[22] = Sum14[7];
  C[23] = Sum14[8];
  C[24] = Sum14[9];
  C[25] = Sum14[10];
  C[26] = Sum14[11];
  C[27] = Sum14[12];
  C[28] = Sum14[13];
  C[29] = Sum14[14];
  C[30] = Sum14[15];
  C[31] = Carry14;
 end
endmodule

//=================================================================
//
// 32-bit, 16 channel Multiplexer
//
//=================================================================

module StructMux(channels, select, b);
input [15:0][31:0] channels;
input      [15:0] select;
output      [31:0] b;


	assign b = ({32{select[15]}} & channels[15]) | 
               ({32{select[14]}} & channels[14]) |
			   ({32{select[13]}} & channels[13]) |
			   ({32{select[12]}} & channels[12]) |
			   ({32{select[11]}} & channels[11]) |
			   ({32{select[10]}} & channels[10]) |
			   ({32{select[ 9]}} & channels[ 9]) | 
			   ({32{select[ 8]}} & channels[ 8]) |
			   ({32{select[ 7]}} & channels[ 7]) |
			   ({32{select[ 6]}} & channels[ 6]) |
			   ({32{select[ 5]}} & channels[ 5]) |  
			   ({32{select[ 4]}} & channels[ 4]) |  
			   ({32{select[ 3]}} & channels[ 3]) |  
			   ({32{select[ 2]}} & channels[ 2]) |  
               ({32{select[ 1]}} & channels[ 1]) |  
               ({32{select[ 0]}} & channels[ 0]) ;
endmodule

//====================================================
//
//TEST BENCH
//
//====================================================
module testbench();

//====================================================
//
//Local Variables
//
//====================================================
   reg  [15:0] inputB;
   reg  [15:0] inputA;
   reg  [3:0] opcode;
   wire [31:0] outputC;
   wire [1:0] error;
   
//====================================================
//
// Create Breadboard
//
//====================================================
	breadboard bb8(inputA,inputB,outputC,opcode,error);

//====================================================
//
// STIMULOUS
//
//====================================================


	initial begin//Start Stimulous Thread
	#2;	
	
	//---------------------------------
	$write("[    B]");
	$write("[    A]");
	$write("[  OP]");
	$write("[         C]");
	$write("[ E]");
	$display(";");
	//---------------------------------
	inputB=16'b0000000010000000;
	inputA=16'b0000000001100100;
	opcode=4'b0100;//ADD (Input less than 250)
	#10	

	$write("[%d]",inputB);
	$write("[%d]",inputA);
	$write("[%4b]",opcode);
	$write("[%d]",outputC);
	$write("[%2b]",error);		
	$write(":Addition (Input less than 250)");
	$display(";");
	//---------------------------------
	inputB=16'b0000000010000000;
	inputA=16'b0000000001100100;
	opcode=4'b0101;//SUB (Input less than 250)
	#10	

	$write("[%d]",inputB);
	$write("[%d]",inputA);
	$write("[%4b]",opcode);
	$write("[%d]",outputC);
	$write("[%2b]",error);		
	$write(":Subtraction (Input less than 250)");
	$display(";");
	//---------------------------------
	
	inputB=16'b0000000000010000;
	inputA=16'b0000000000001000;
	opcode=4'b0110;//MUL (Input less than 250)
	#10	

	$write("[%d]",inputB);
	$write("[%d]",inputA);
	$write("[%4b]",opcode);
	$write("[%d]",outputC);
	$write("[%2b]",error);		
	$write(":Multipy (Input less than 250)");
	$display(";");
	
	//---------------------------------
	inputB=16'b0000000010000000;
	inputA=16'b0000000000001000;
	opcode=4'b0111;//DIV (Input less than 250)
	#10	

	$write("[%d]",inputB);
	$write("[%d]",inputA);
	$write("[%4b]",opcode);
	$write("[%d]",outputC);
	$write("[%2b]",error);		
	$write(":Divide (Input less than 250)");
	$display(";");
	//---------------------------------
	inputB=16'b0000000000010000;
	inputA=16'b0000000000001000;
	opcode=4'b1000;//MOD (Input less than 250)
	#10	

	$write("[%d]",inputB);
	$write("[%d]",inputA);
	$write("[%4b]",opcode);
	$write("[%d]",outputC);
	$write("[%2b]",error);	
	$write(":Modulus (Input less than 250)");
	$display(";");
	//---------------------------------
	inputB=16'b0100000000000000;
	inputA=16'b0100000000000000;
	opcode=4'b0100;//Addition (Input greater than 16000)
	#10	

	$write("[%d]",inputB);
	$write("[%d]",inputA);
	$write("[%4b]",opcode);
	$write("[%d]",outputC);
	$write("[%2b]",error);	
	$write(":Addition (Input greater than 16000)");
	$display(";");

	//---------------------------------
	inputB=16'b0100000001110100;
	inputA=16'b0100000000010000;
	opcode=4'b0101;//Subtraction (Input greater than 16000)
	#10	

	$write("[%d]",inputB);
	$write("[%d]",inputA);
	$write("[%4b]",opcode);
	$write("[%d]",outputC);
	$write("[%2b]",error);		
	$write(":Subtraction (Input greater than 16000)");
	$display(";");

	//---------------------------------
	inputB=16'b0100000001110100;
	inputA=16'b0100000000010000;
	opcode=4'b0111;//Division (Input greater than 16000)
	#10	

	$write("[%d]",inputB);
	$write("[%d]",inputA);
	$write("[%4b]",opcode);
	$write("[%d]",outputC);
	$write("[%2b]",error);		
	$write(":Division (Input greater than 16000)");
	$display(";");
	
	//---------------------------------
	inputB=16'b0100000001110100;
	inputA=16'b0100000000010000;
	opcode=4'b1000;//Modulus (Input greater than 16000)
	#10	
	$write("[%d]",inputB);
	$write("[%d]",inputA);
	$write("[%4b]",opcode);
	$write("[%d]",outputC);
	$write("[%2b]",error);			
	$write(":Modulus(Input greater than 16000)");
	$display(";");
		
	//---------------------------------
	
	inputB=16'b0100000001110100;
	inputA=16'b0100000000010000;
	opcode=4'b0110;//Multiply (Input greater than 16000)
	#10	
	
	$write("[%d]",inputB);
	$write("[%d]",inputA);
	$write("[%4b]",opcode);
	$write("[%d]",outputC);
	$write("[%2b]",error);		
	$write(":Multiply (Input greater than 16000)");
	$display(";");
	//---------------------------------		
	



	$finish;
	end

endmodule