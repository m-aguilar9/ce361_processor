`include "extend.v"
`include "mux_32.v"

module pc_clk(clk, nPC_sel, imm16, pc_fin, read_val);
   input clk;
   input nPC_sel;
   input [15:0] imm16;
   output [31:0] pc_fin;
   output [31:0] read_val; // also for debug
   wire [31:0] 	 temp_pc;
   wire [31:0] 	 prev_pc;
   wire [31:0] 	 imm16ext;

   // start by extending
   extender18 immext(.in({imm16, 2'b0}), .ext(1'b1), .out(imm16ext));
   
   // read pc and store in prev
   pc_register pc(.in(prev_pc),
		  .clk(clk),
		  .nPC_sel(nPC_sel),
		  .imm16(imm16ext),
		  .out(temp_pc));

   assign read_val = temp_pc;
   assign pc_fin = temp_pc;

endmodule // pc_clk

module extender18(in, ext, out);
   input [17:0] in;
   input 	ext;
   output [31:0] out;
   wire 	 sign;

   and_gate si(.x(ext), .y(in[17]), .z(sign));
   assign out = {{14{sign}},{in[17:0]}};

endmodule // extender

// register for the pc. if rw = 0 read, if rw = 1 write
module pc_register(in, clk, nPC_sel, imm16, out);
   input [31:0] in;
   input 	nPC_sel;
   input [31:0] imm16;
   input 	clk;
   output reg [31:0] out;
   reg [31:0] 	     pc = 32'h00400020;	
     
   initial begin
      out <= 32'h00400020;
   end
   
   always @(negedge clk)
     begin
        if (nPC_sel == 0) begin
	   pc <= pc + 4;
	   out <= pc + 4;
	end
	else begin
	  if (nPC_sel == 1) begin
	     pc <= pc + 4 + imm16;
	     out <= pc + 4 + imm16;
	  end	   
	end
     end // always @ (negedge clk)
   
endmodule // pc_register

 
