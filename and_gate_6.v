`timescale 1ns/10ps

module and_gate_6 (x, y, z);
  //parameter 6;
  input [5:0] x;
  input [5:0] y;
  output [5:0] z;
  
  assign z = (x&y) ;
  
  
endmodule
