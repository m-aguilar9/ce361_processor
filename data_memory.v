`include "syncram.v"

module data_memory (clk, wr_enable, data_in, address, data_out);
	input	clk, wr_enable;
	input	[31:0] data_in, address;
	output	[31:0] data_out;

	syncram syncram1 (
	.clk(clk),
	.cs(1'b1),
	.oe(1'b1),
	.we(wr_enable),
	.addr(address),
	.din(data_in),
	.dout(data_out));

endmodule

