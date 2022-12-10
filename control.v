`include "mux.v"
`include "and_gate.v"
`include "and_gate_5.v"
`include "and_gate_6.v"
`include "and_gate_16.v"
`include "nor_gate.v"
`include "xor_gate.v"
`include "xnor_gate.v"
`include "or_gate.v"
module control (inst,
		alu_op, 
		reg_dst,
		alu_src,
		mem_wr,
		mem_to_reg,
		reg_wr,
		ext_op,
		func,
		opcode,
		shamt,
		rs,
		rt,
		rd,
		imm
		);
  input [31:0] inst;
  output [1:0]alu_op;
  output reg_dst,alu_src,mem_wr,mem_to_reg,reg_wr,ext_op;
  output [5:0]func,opcode;
  output [4:0] shamt, rs, rt, rd;
  output [15:0] imm;

  wire str_w_l_w, store_word, load_word_a, load_word_b, load_word;
  wire imm1, immw;

	and_gate_5 rtype_rs(.x(5'b11111),.y(inst[25:21]),.z(rs));//rs register
        and_gate_5 rtype_rt(.x(5'b11111),.y(inst[20:16]),.z(rt));//rt register
        and_gate_5 rtype_rd(.x(5'b11111),.y(inst[15:11]),.z(rd));//rd register
        and_gate_5 rtype_shamt(.x(5'b11111),.y(inst[10:6]),.z(shamt));//shamt
        and_gate_6 rtype_func(.x(6'b111111),.y(inst[5:0]),.z(func));//func
	and_gate_6 op_co(.x(6'b111111),.y(inst[31:26]),.z(opcode));//opcode
	and_gate_16 imm_inst(.x(16'hFFFF),.y(inst[15:0]),.z(imm));//imm

	or_gate immediate_1(	
				.x(inst[28]),
				.y(inst[29]),
				.z(imm1)//if there is a value of 1 in either instruction it's a branch or addi
				);
	or_gate immediate(	
				.x(imm1),
				.y(inst[31]), //31 indicates lw/sw and imm1 indicates the other immediate instructions
				.z(immw)
				);	
	and_gate sw(
				.x(inst[31]),
				.y(inst[29]),
				.z(store_word)//if these two bits are 1 then the instruction is sw
				);
	xor_gate lwa(
				.x(inst[31]),
				.y(1'b0),
				.z(load_word_a) //if bit 31 is 1
				);
	xor_gate lwb(
				.x(inst[31]),
				.y(inst[29]),
				.z(load_word_b)//and bit 31 and 29 are opposite
				);
	xor_gate lw(
				.x(load_word_a),
				.y(load_word_b),
				.z(load_word) //then the instruction is a lw
				);	

	xnor_gate reg_desti(
				.x(inst[31]), 
				.y(inst[29]), 
				.z(reg_dst)
				);//xor identify addi/lw, they're the only instructions that write back to rt (0 for rt, 1 for rd)
	or_gate alu_sourc(
				.x(inst[31]), 
				.y(inst[29]), 
				.z(alu_src)
				);//or identify addi/lw/sw; only instructions that have alu_src 1
	and_gate memor_wr(
				.x(store_word), 
				.y(1'b1), 
				.z(mem_wr)//mem_wr is only high for store word
				);
	nor_gate regis_wr(
				.x(store_word), 
				.y(inst[28]), 
				.z(reg_wr)//write back to reg for every instruction except branch(inst[28 ==1) and sw
				);
	and_gate memreg(
				.x(inst[31]), 
				.y(1'b1), 
				.z(mem_to_reg)//data memory feeds back to reg file (inst[31]==1)
				);
	mux extend_oper(
				.sel(inst[28]), 
				.src0(1'b1), 
				.src1(1'b0),
				.z(ext_op)//everything except branch is sign extended
				);
	
	and_gate aluop0(	
				.x(inst[21]),
				.y(1'b1),
				.z(alu_op[0])//1 if branch instruction, 0 for rtypes and other immediates
				);
	mux aluop1(	
				.sel(immw),
				.src0(1'b1),
				.src1(1'b0),//1 if rtype instructions, 0 for immediates
				.z(alu_op[1])
				);
endmodule
