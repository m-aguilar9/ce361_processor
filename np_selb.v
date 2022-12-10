///*
`include "mux.v"
`include "and_gate.v"
`include "nand_gate.v"
`include "nor_gate.v"
`include "xor_gate.v"
`include "or_gate.v"
//*/

module np_sel(zero, res_msb, branch, sel);

	input zero,res_msb;//zero signal and MSB of the result from the ALU
	input [2:0] branch;//take the 3 LSB of the opcode
	output sel;//PC+4 or Branch Immediate + PC + 4

wire b1,b2,b3;
wire zerohigh, zerolow, greater_than;

mux zero_highr(	
		.sel(zero),
		.src0(1'b0),
		.src1(1'b1),
		.z(zerohigh)
		);

mux zero_lowr(	
		.sel(zero),
		.src0(1'b1),
		.src1(1'b0),
		.z(zerolow)
		);
mux greater_thanr(
		.sel(res_msb), 
		.src0(1'b1), 
		.src1(1'b0), 
		.z(greater_than)
		);

mux beq_bne(
		.sel(branch[0]), 
		.src0(zerohigh),//beq 
		.src1(zerolow),//bne 
		.z(b1)
		);

and_gate bgtz_gtr(
		.x(b1), 
		.y(greater_than), 
		.z(b2)
		);
mux bgt(
		.sel(branch[1]), 
		.src0(b1),//bne/beq 
		.src1(b2),//bgtz
		.z(b3)
		);
mux selc(
		.sel(branch[2]), 
		.src0(1'b0), 
		.src1(b3), 
		.z(sel)
		);

endmodule

