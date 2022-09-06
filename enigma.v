//----------------------------------------------------------------------------------------------------------------------------------------
module Breadboard (w,x,y,z,r0,r1,r2,r3,r4,r5,r6,r7,r8,r9); //breadboard module
input w,x,y,z;
output r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
reg r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
wire w,x,y,z;

always @ (w,x,y,x,r0,r1,r2,r3,r4,r5,r6,r7,r8,r9) begin

  //minterm equations

  //f0 = w'x'yz'   + w'x'yz    + w'xy'z'    + w'xy'z    + w'xyz'    + wx'y'z'    + wx'y'z    + wx'yz'    + wxy'z'    + wxy'z    + wxyz'
  r0 = (~w&~x&y&~z)|(~w&~x&y&z)|(~w&x&~y&~z)|(~w&x&~y&z)|(~w&x&y&~z)|(w&~x&~y&~z)|(w&~x&~y&z)|(w&~x&y&~z)|(w&x&~y&~z)|(w&x&~y&z)|(w&x&y&~z);

  //f1 = w'x'y'z   + w'x'yz    + w'xy'z'    + w'xyz'    + w'xyz    + wx'y'z    + wxy'z'    + wxyz
  r1 = (~w&~x&~y&z)|(~w&~x&y&z)|(~w&x&~y&~z)|(~w&x&y&~z)|(~w&x&y&z)|(w&~x&~y&z)|(w&x&~y&~z)|(w&x&y&z);

  //f2 = w'x'y'z'   + w'x'yz'    + w'x'yz    + w'xy'z    + w'xyz'    + wx'y'z'    + wx'y'z    + wx'yz'    + wxyz
  r2 = (~w&~x&~y&~z)|(~w&~x&y&~z)|(~w&~x&y&z)|(~w&x&~y&z)|(~w&x&y&~z)|(w&~x&~y&~z)|(w&~x&~y&z)|(w&~x&y&~z)|(w&x&y&z);

  //f3 = w'x'y'z   + w'x'yz'    + w'x'yz    + w'xy'z'    + w'xy'z    + wx'y'z'    + wx'yz    + wxy'z'    + wxy'z    + wxyz'
  r3 = (~w&~x&~y&z)|(~w&~x&y&~z)|(~w&~x&y&z)|(~w&x&~y&~z)|(~w&x&~y&z)|(w&~x&~y&~z)|(w&~x&y&z)|(w&x&~y&~z)|(w&x&~y&z)|(w&x&y&~z);

  //f4 = w'x'y'z   + w'x'yz'    + w'xy'z'    + w'xyz'    + wx'y'z'    + wx'y'z    + wx'yz'    + wx'yz    + wxy'z'    + wxyz'    + wxyz
  r4 = (~w&~x&~y&z)|(~w&~x&y&~z)|(~w&x&~y&~z)|(~w&x&y&~z)|(w&~x&~y&~z)|(w&~x&~y&z)|(w&~x&y&~z)|(w&~x&y&z)|(w&x&~y&~z)|(w&x&y&~z)|(w&x&y&z);

  //f5 = w'x'y'z'   + w'x'y'z    + w'xy'z'    + w'xyz'    + w'xyz    + wx'yz    + wxyz
  r5 = (~w&~x&~y&~z)|(~w&~x&~y&z)|(~w&x&~y&~z)|(~w&x&y&~z)|(~w&x&y&z)|(w&~x&y&z)|(w&x&y&z);

  //f6 = w'x'y'z'   + w'x'yz'    + w'x'yz    + w'xy'z    + wx'yz'    + wx'yz    + wxy'z    + wxyz
  r6 = (~w&~x&~y&~z)|(~w&~x&y&~z)|(~w&~x&y&z)|(~w&x&~y&z)|(w&~x&y&~z)|(w&~x&y&z)|(w&x&~y&z)|(w&x&y&z);

  //f7 = w'x'y'z   + w'x'yz    + w'xy'z'    + w'xy'z    + w'xyz    + wx'y'z'    + wx'y'z    + wxy'z    + wxyz'    + wxyz
  r7 = (~w&~x&~y&z)|(~w&~x&y&z)|(~w&x&~y&~z)|(~w&x&~y&z)|(~w&x&y&z)|(w&~x&~y&~z)|(w&~x&~y&z)|(w&x&~y&z)|(w&x&y&~z)|(w&x&y&z);

  //f8 = w'x'y'z'   + w'x'y'z    + w'xy'z    + w'xyz    + wx'yz'    + wx'yz    + wxy'z'    + wxyz'    + wxyz
  r8 = (~w&~x&~y&~z)|(~w&~x&~y&z)|(~w&x&~y&z)|(~w&x&y&z)|(w&~x&y&~z)|(w&~x&y&z)|(w&x&~y&~z)|(w&x&y&~z)|(w&x&y&z);

  //f9 = w'xyz'   + w'xyz    + wx'y'z'    + wx'y'z     + wx'yz'    + wx'yz    + wxy'z'    + wxy'z
  r9 = (~w&x&y&~z)|(~w&x&y&z)|(w&~x&~y&~z)|(w&~x&~y&~z)|(w&~x&y&~z)|(w&~x&y&z)|(w&x&~y&~z)|(w&x&~y&z);

  end
endmodule
//------------------------------------------------------------------------------------------------------------------------------------------
module testbench(); //testbench module
  
  reg [4:0] i;
  reg a;
  reg b;
  reg c;
  reg d;

  wire f0,f1,f2,f3,f4,f5,f6,f7,f8,f9; //stores results from equations in minterm breadboard
  Breadboard minterm(a,b,c,d,f0,f1,f2,f3,f4,f5,f6,f7,f8,f9);

  initial begin
    
    $display("|##|A|B|C|D|F0|F1|F2|F3|F4|F5|F6|F7|F8|F9|");
    $display("|==+=+=+=+=+==+==+==+==+==+==+==+==+==+==|");
    
    for(i = 0; i <= 15; i = i + 1)
    begin
      a = (i/8)%2; //high bit
      b = (i/4)%2; 
      c = (i/2)%2;
      d = (i/1)%2; //low bit

      #20;

      $display("|%2d|%1d|%1d|%1d|%1d| %1d| %1d| %1d| %1d| %1d| %1d| %1d| %1d| %1d| %1d|",i,a,b,c,d,f0,f1,f2,f3,f4,f5,f6,f7,f8,f9);
      if(i%4==3)
	$write("|--+-+-+-+-+--+--+--+--+--+--+--+--+--+--|\n");

    end
    #20;
    $finish;
  end
endmodule
    
