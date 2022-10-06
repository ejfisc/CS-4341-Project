//=================================================================
//
// FourBitMultiplier
//
// Inputs:
// A, a 4-Bit Integer Input
// B, a 4-Bit Integer Input
// C, an 8-Bit Integer Output
//=================================================================
module EightBitMultiplier(A,B,C);
input  [7:0] A;
input  [7:0] B;
output [15:0] C;

reg [15:0] C;

//Local Variables
reg  [3:0] Augend0;
reg  [3:0] Adend0;
wire [3:0] Sum0;
wire  Carry0;

reg  [3:0] Augend1;
reg  [3:0] Adend1;
wire [3:0] Sum1;
wire  Carry1;

reg  [3:0] Augend2;
reg  [3:0] Adend2;
wire [3:0] Sum2;
wire  Carry2;

reg  [3:0] Augend3;
reg  [3:0] Adend3;
wire [3:0] Sum3;
wire  Carry3;


FourBitFullAdder add0(Augend0,Adend0,1'b0,Carry0,Sum0);
FourBitFullAdder add1(Augend1,Adend1,1'b0,Carry1,Sum1);
FourBitFullAdder add2(Augend2,Adend2,1'b0,Carry2,Sum2);
FourBitFullAdder add3(Augend3,Adend3,1'b0,Carry3,Sum3);

always@(*)
begin

  
  Augend0={     1'b0,A[0]&B[3],A[0]&B[2],A[0]&B[1]}; //A[0] by B
   Adend0={A[1]&B[3],A[1]&B[2],A[1]&B[1],A[1]&B[0]}; //A[1] by B

  Augend1={Carry0 ,  Sum0[3],  Sum0[2],  Sum0[1]};
   Adend1={A[2]&B[3],A[2]&B[2],A[2]&B[1],A[2]&B[0]}; //A[2] by B

  Augend2={Carry1 ,  Sum1[3],  Sum1[2],  Sum1[1]};
   Adend2={A[3]&B[3],A[3]&B[2],A[3]&B[1],A[3]&B[0]}; //A[3] by B
   

  
   
  C[0]=  A[0]&B[0];//From Gates
//=================================  
  C[1]=  Sum0[0];//From Adder0
 //=================================
  C[2]=  Sum1[0];//From Adder1
 //=================================
  C[3] = Sum2[0];//From Adder2
  C[4] = Sum2[1];//From Adder2
  C[5] = Sum2[2];//From Adder2
  C[6] = Sum2[3];//From Adder2
  C[7] = Carry2 ;//From Adder2
 end
endmodule


/*

module testbench();

reg [5:0]row;
reg [5:0]col;
reg [15:0] mark;

//Data Inputs
reg [5:0]dataA;
reg [5:0]dataB;
 

//Outputs
wire[7:0]result;
 

//Instantiate the Modules
FourBitMultiplier F4M(row[3:0],col[3:0],result);
initial
begin
//        0123456789ABCDEF
 

 
for (row=0;row<16;row++)
begin
	for (col=0;col<16;col++)
	begin
		#60;
		$write("%4d",result);
	end
$display();
end



end

endmodule
*/