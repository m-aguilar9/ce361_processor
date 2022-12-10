`timescale 1ns/10ps

module and_gate_16 (x, y, z);
  //parameter 16;
  input [15:0] x;
  input [15:0] y;
  output [15:0] z;
  
  assign z = (x&y) ;
  
  
endmodule
