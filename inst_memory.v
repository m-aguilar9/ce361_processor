`include "pc.v"
`include "sram.v"


module inst_memory(clk, imm16,pc_sel,inst);
    input clk,pc_sel;
    input [15:0] imm16;

    output [31:0] inst;


    wire [31:0] pc_addr;


    program_counter pc( .inst_addr(pc_addr), 
			.imm(imm16), 
			.sel(pc_sel), 
			.clk(clk)
			);
                        

  /*  .clk(clk),
                .nPC_sel(nPC_sel),
                .imm16(imm16),
                .pc_fin(pc_addr),
                .read_val(dump));
      */          
    sram sram1(.cs(1'b1),
                    .oe(1'b1),
                    .we(1'b0),
                    .addr(pc_addr),
                    .din(32'hFFFFFFFF),
                    .dout(inst));
endmodule
