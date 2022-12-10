`timescale 1ns/10ps

module and_gate_5 (x, y, z);
  //parameter 5;
  input [4:0] x;
  input [4:0] y;
  output [4:0] z;
  
  assign z = (x&y) ;
  
  
endmodule
