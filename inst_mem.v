`include "branch_pc.v"
`include "sram.v"

module fetch_inst(clk, imm16, nPC_sel, inst);
   input clk;
   input [15:0] imm16;
   input 	nPC_sel;
   output [31:0] inst;
   wire [31:0] 	 pc_addr;
   wire [31:0] 	 dump;
   

   // Get pc first
   pc_clk rpc(.clk(clk),
	      .nPC_sel(nPC_sel),
	      .imm16(imm16),
	      .pc_fin(pc_addr),
	      .read_val(dump));

   // question: we should never be writing to instruction memory right?
 sram sram_get(.cs(1'b1),
	       .oe(1'b1),
	       .we(1'b0),
	       .addr(pc_addr),
	       .din(32'hFFFFFFFF),
	       .dout(inst));

endmodule // fetch_mem

