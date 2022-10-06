//-------------------------------------------------
//
// Sample 4-Bit Adder/Subtractor with padded 4 bits
// Eric William Becker
// September 25, 2022
//
// For my students this semester.
//
//-------------------------------------------------


module EightBitAddSub(inputA,inputB,mode,sum,carry,overflow);
    input [7:0] inputA;
	input [7:0] inputB;
    input mode;
    output [15:0] sum;
	output carry;
    output overflow;

	wire c0; //MOde assigned to C0

    wire b0,b1,b2,b3,b4,b5,b6,b7; //XOR Interfaces
	wire c1,c2,c3,c4,c5,c6,c7,c8; //Carry Interfaces
	
	assign c0=mode;//Mode=0, Addition; Mode=1, Subtraction
	
    assign b0 = inputB[0] ^ mode;//Flip the Bit if Subtraction
    assign b1 = inputB[1] ^ mode;//Flip the Bit if Subtraction
    assign b2 = inputB[2] ^ mode;//Flip the Bit if Subtraction
    assign b3 = inputB[3] ^ mode;//Flip the Bit if Subtraction
    assign b4 = inputB[4] ^ mode;
    assign b5 = inputB[5] ^ mode;
    assign b6 = inputB[6] ^ mode;
    assign b7 = inputB[7] ^ mode;
    assign b8 = inputB[8] ^ mode;

	
 
	FullAdder FA0(inputA[0],b0,  c0,c1,sum[0]);
	FullAdder FA1(inputA[1],b1,  c1,c2,sum[1]);
	FullAdder FA2(inputA[2],b2,  c2,c3,sum[2]);
	FullAdder FA3(inputA[3],b3,  c3,c4,sum[3]);

	assign sum[4]=sum[3];
	assign sum[5]=sum[3];
	assign sum[6]=sum[3];
	assign sum[7]=sum[3];
	
	assign carry=c4;
	assign overflow=c4^c3;
 
endmodule



module testbench();


//Data Inputs
reg [3:0]dataA;
reg [3:0]dataB;
reg mode;

//Outputs
wire[7:0]result;
wire carry;
wire err;

//Instantiate the Modules
FourBitAddSub addsub(dataA,dataB,mode,result,carry,err);


initial
begin
//        0123456789ABCDEF
$display("Addition");
mode=0; 
dataA=4'b0010; 
dataB=4'b0010;
#100;
 
$write("mode=%b;",mode);
$write("%b+%b=[%b];",dataA,dataB,result);
$display("err=%b",err);

 
mode=0; 
dataA=4'b0100;
dataB=4'b0100;
#100;
$write("mode=%b;",mode);
$write("%b+%b=[%b];",dataA,dataB,result); 
$display("err=%b",err);

mode=0; 
dataA=4'b0010;
dataB=4'b1100;
#100;
 
$write("mode=%b;",mode);
$write("%b+%b=[%b];",dataA,dataB,result);
$display("err=%b",err);



mode=0; 
dataA=4'b0100;
dataB=4'b1110;
#100;
$write("mode=%b;",mode);
$write("%b+%b=[%b];",dataA,dataB,result);
$display("err=%b",err);


$display("Subtraction");
mode=1; 
dataA=4'b1110; 
dataB=4'b1100;
#100;
$write("mode=%b;",mode);
$write("%b-%b=[%b];",dataA,dataB,result);
$display("err=%b",err);


mode=1; 
dataA=4'b1100;
dataB=4'b0010;
#100;
$write("mode=%b;",mode);
$write("%b-%b=[%b];",dataA,dataB,result);
 
$display("err=%b",err);


mode=1; 
dataA=4'b1100;
dataB=4'b0111;
#100;
$write("mode=%b;",mode);
$write("%b-%b=[%b];",dataA,dataB,result);
 
$display("err=%b",err);

mode=1; 
dataA=4'b1100;
dataB=4'b1110;
#100;
$write("mode=%b;",mode);
$write("%b-%b=[%b];",dataA,dataB,result);
 
$display("err=%b",err);




end




endmodule
