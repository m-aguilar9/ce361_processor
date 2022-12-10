`timescale 1ns/10ps

module groupmod_test();
	reg	[31:0] inst;
	wire	[2:0] alu_op;
 	wire	reg_dst, alu_src, mem_wr, mem_to_reg, reg_wr, ext_op;
	wire	[5:0] func;
	wire	[4:0] shamt, rs, rt, rd;
	wire	[15:0] imm;

	control c1 (inst,
		alu_op, 
		reg_dst,
		alu_src,
		mem_wr,
		mem_to_reg,
		reg_wr,
		ext_op,
		func,
		shamt,
		rs,
		rt,
		rd,
		imm
		);

	initial begin
		inst = 32'h20050001;
		#10 $finish;
	end

endmodule


