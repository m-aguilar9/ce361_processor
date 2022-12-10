`include "and_gate.v"
`include "and_gate_n.v"
`include "and_gate_32.v"
`include "mux_32.v"
`include "mux_5.v"
`include "ALU.v"
`include "data_memory.v"
`include "Registers.v"
`include "extender.v"


module data_path(rd, 
		 rt, 
		 rs, 
		 reg_wr, 
		 shamt, 
		 reg_dst, 
		 imm, 
		 alu_src, 
		 ext_op, 
		 alu_ctrl, 
		 mem_wr, 
		 mem_to_reg, 
		 zero,
		 ovflw,
		 cout,
		 res_msb,
		 clk
		 );
    input [4:0] rd,rt,rs,shamt;
    input [2:0] alu_ctrl;
    input [15:0] imm;
    input reg_wr, reg_dst, ext_op, mem_wr, mem_to_reg, clk, alu_src;
    output zero,ovflw,cout,res_msb;

    wire [4:0] ra,rb,rw;
    wire [31:0] busa, busb, busw;
    wire [31:0] extended;
    wire [31:0] alu_res,alu_mux_res,data;

mux_5 reg_dest(
			.sel(reg_dst),
			.src0(rt),
			.src1(rd),
			.z(rw)
			);

/*registers regs (
			.r_reg1(rs),
			.r_reg2(rt),
			.w_reg(rw),
			.w_data(busw),
			.reg_w(reg_wr),
			.clk(clk),
			.r_data1(busa),
			.r_data2(busb)
		);*/

registers regs(
	.clk(clk),
	.RegWr(reg_wr),
	.busW(busw),
	.Rw(rw),
	.Ra(rs),
	.Rb(rt),
	.busA(busa),
	.busB(busb)
);



extender ext(
			.imm16(imm),
			.ext_op(ext_op),
			.imm32(extended)
			);


mux_32 alu_mux_in(
			.sel(alu_src),
			.src0(busb),
			.src1(extended),
			.z(alu_mux_res)
			);
ALU alu(
			.ctrl(alu_ctrl),
			.A(busa),
			.B(alu_mux_res),
			.shamt(shamt),
			.cout(cout),
			.ovf(ovflw),
			.ze(zero),
			.R(alu_res)
			);

and_gate and1(
			.x(1'b1), 
			.y(alu_res[31]), 
			.z(res_msb)
			);

data_memory data_mem(
			.clk(clk),
			.wr_enable(mem_wr),
			.address(alu_res),
			.data_in(busb),
			.data_out(data)
			);

mux_32 data_out(
			.sel(mem_to_reg),
			.src0(alu_res),
			.src1(data),
			.z(busw)
			);

endmodule
    
