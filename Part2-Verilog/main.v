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
	$write("[        C]");
	$write("[ E]");
	$display(";");
	//---------------------------------
	inputB=16'b0000000000010000;
	inputA=16'b0000000000001000;
	opcode=4'b0100;//ADD (Input less than 250)
	#10	

	$write("[%d]",inputB);
	$write("[%d]",inputA);
	$write("[%4b]",opcode);
	$write("[%d]",outputC);
	$write("[%2b]",error);		
	$write(":Addition");
	$display(";");
	//---------------------------------
	inputB=16'b0000000000010000;
	inputA=16'b0000000000001000;
	opcode=4'b0101;//SUB (Input less than 250)
	#10	

	$write("[%d]",inputB);
	$write("[%d]",inputA);
	$write("[%4b]",opcode);
	$write("[%d]",outputC);
	$write("[%2b]",error);		
	$write(":Subtraction");
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
	$write(":Multipy");
	$display(";");
	
	//---------------------------------
	inputB=16'b0000000000010000;
	inputA=16'b0000000000001000;
	opcode=4'b0111;//DIV (Input less than 250)
	#10	

	$write("[%d]",inputB);
	$write("[%d]",inputA);
	$write("[%4b]",opcode);
	$write("[%d]",outputC);
	$write("[%2b]",error);		
	$write(":Divide");
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
	$write(":Modulus");
	$display(";");
	//---------------------------------
	inputB=16'b1001000000001111;
	inputA=16'b1000000111100000;
	opcode=4'b0100;//Addition (Input greater than 16000)
	#10	

	$write("[%d]",inputB);
	$write("[%d]",inputA);
	$write("[%4b]",opcode);
	$write("[%d]",outputC);
	$write("[%2b]",error);	
	$write(":Addition with Error");
	$display(";");

	//---------------------------------
	inputB=16'b1001000000001111;
	inputA=16'b1000000111100000;
	opcode=4'b0101;//Subtraction (Input greater than 16000)
	#10	

	$write("[%d]",inputB);
	$write("[%d]",inputA);
	$write("[%4b]",opcode);
	$write("[%d]",outputC);
	$write("[%2b]",error);		
	$write(":Subtraction with Error");
	$display(";");

	//---------------------------------
	inputB=16'b1001000000001111;
	inputA=16'b1000000111100000;
	opcode=4'b0111;//Division (Input greater than 16000)
	#10	

	$write("[%d]",inputB);
	$write("[%d]",inputA);
	$write("[%4b]",opcode);
	$write("[%d]",outputC);
	$write("[%2b]",error);		
	$write(":Division with Error");
	$display(";");
	
	//---------------------------------
	inputB=16'b1001000000001111;
	inputA=16'b1000000111100000;
	opcode=4'b1000;//Modulus (Input greater than 16000)
	#10	
	$write("[%d]",inputB);
	$write("[%d]",inputA);
	$write("[%4b]",opcode);
	$write("[%d]",outputC);
	$write("[%2b]",error);			
	$write(":Modulus with Error");
	$display(";");
		
	//---------------------------------
	
	inputB=16'b1000000000000000;
	inputA=16'b0100000000000000;
	opcode=4'b0110;//Multiply (Input greater than 16000)
	#10	
	
	$write("[%d]",inputB);
	$write("[%d]",inputA);
	$write("[%4b]",opcode);
	$write("[%d]",outputC);
	$write("[%2b]",error);		
	$write(":Multiply with 0");
	$display(";");
	//---------------------------------		
	



	$finish;
	end

endmodule