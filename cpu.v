`include "controlb.v"
`include "Registers.v"
`include "inst_memory.v"
`include "alu_control.v"
`include "np_selb.v"
`include "data_path.v"

module cpu (clk);
 
  input clk;

  wire [31:0] inst;
  wire [2:0] alu_ctrl;
  wire [1:0] alu_op;
  wire ext_op, reg_dst,alu_src, mem_wr, reg_wr, mem_to_reg;
  wire res_msb,zero,ovflw,cout, pc_sel;
  wire [5:0] func, opcode;
  wire [4:0] shamt, rs, rt, rd;
  wire [15:0] imm;


controlb decode(
			.inst(inst),
			.alu_op(alu_op),
			.reg_dst(reg_dst),
			.alu_src(alu_src),
			.mem_wr(mem_wr),
			.mem_to_reg(mem_to_reg),
			.reg_wr(reg_wr),
			.ext_op(ext_op),
			.func(func),
			.opcode(opcode),
			.shamt(shamt),
			.rs(rs),
			.rt(rt),
			.rd(rd),
			.imm(imm)
			);

inst_memory imem(
			.clk(clk), 
			.imm16(imm),
			.pc_sel(pc_sel),
			.inst(inst)
			);

alu_control alu_ctrl1(
			.func(func),
			.alu_op(alu_op),
			.alu_ctrl(alu_ctrl)
			);

data_path dp1(
			 .rd(rd), 
			 .rt(rt), 
			 .rs(rs), 
			 .reg_wr(reg_wr), 
			 .shamt(shamt), 
			 .reg_dst(reg_dst), 
			 .imm(imm), 
			 .alu_src(alu_src), 
			 .ext_op(ext_op), 
			 .alu_ctrl(alu_ctrl), 
			 .mem_wr(mem_wr), 
			 .mem_to_reg(mem_to_reg), 
			 .zero(zero),
			 .ovflw(ovflw),
			 .cout(cout),
			 .res_msb(res_msb),
			 .clk(clk)
		 );

np_sel select(
			.zero(zero),
			.res_msb(res_msb),
			.branch(inst[28:26]),
			.sel(pc_sel)
		);

endmodule
/*
module inst_decode_cntrl (inst,alu_op, reg_dst,alu_src,func,shamt,rs,rt,rd,imm);
  input [31:0] inst;
  output [2:0]alu_op;
  output reg_dst,alu_src;
  output [5:0]func;
  output [4:0] shamt, rs, rt, rd;
  output [15:0] imm;
  
always @(inst) begin
    if (inst[31:26] == 6'b000000) begin //if the opcode is an Rtype
        and_gate_n #(.n(5)) rtype_rs(.x(5'b11111),.y(inst[25:21]),.z(rs));
        and_gate_n #(.n(5)) rtype_rt(.x(5'b11111),.y(inst[20:16]),.z(rt));
        and_gate_n #(.n(5)) rtype_rd(.x(5'b11111),.y(inst[15:11]),.z(rd));
        and_gate_n #(.n(5)) rtype_shamt(.x(5'b11111),.y(inst[10:6]),.z(shamt));
        and_gate_n #(.n(6)) rtype_func(.x(6'b111111),.y(inst[5:0]),.z(func));
        and_gate  rtype_reg_dst(.x(1'b1),.y(1'b1),.z(reg_dst));
        and_gate  rtype_alu_src(.x(1'b1),.y(1'b0),.z(alu_src));
	and_gate_n #(.n(3)) beq_alu_opcode(.x(3'b000),.y(3'b000),.z(alu_op));
    end
    else begin //if the opcode is an immediate type
        case (inst[31:26])
            6'b000100: begin and_gate_n #(.n(5)) beq_rs(.x(5'b11111),.y(inst[25:21]),.z(rs));
                            and_gate_n #(.n(5)) beq_rt(.x(5'b11111),.y(inst[20:16]),.z(rt));
                            and_gate_n #(.n(5)) beq_imm(.x(16'hFFFF),.y(inst[15:0]),.z(imm));
                            and_gate  beq_reg_dst(.x(1'b1),.y(1'b0),.z(reg_dst));
                            and_gate  beq_alu_src(.x(1'b1),.y(1'b0),.z(alu_src));
			    and_gate_n #(.n(3)) beq_alu_opcode(.x(3'b110),.y(3'b111),.z(alu_op));
            end
            6'b000101: begin and_gate_n #(.n(5)) bne_rs(.x(5'b11111),.y(inst[25:21]),.z(rs));
                            and_gate_n #(.n(5)) bne_rt(.x(5'b11111),.y(inst[20:16]),.z(rt));
                            and_gate_n #(.n(16)) bne_imm(.x(16'hFFFF),.y(inst[15:0]),.z(imm));
                            and_gate  bne_reg_dst(.x(1'b1),.y(1'b0),.z(reg_dst));
                            and_gate  bne_alu_src(.x(1'b1),.y(1'b0),.z(alu_src));
			    and_gate_n #(.n(3)) bne_alu_opcode(.x(3'b110),.y(3'b111),.z(alu_op));
            end
            6'b000111: begin and_gate_n #(.n(5)) bgtz_rs(.x(5'b11111),.y(inst[25:21]),.z(rs));
                            and_gate_n #(.n(5)) bgtz_rt(.x(5'b00000),.y(inst[20:16]),.z(rt));
                            and_gate_n #(.n(16)) bgtz_imm(.x(16'hFFFF),.y(inst[15:0]),.z(imm));
                            and_gate  bgtz_reg_dst(.x(1'b1),.y(1'b0),.z(reg_dst));
                            and_gate  bgtz_alu_src(.x(1'b1),.y(1'b0),.z(alu_src));
			    and_gate_n #(.n(3)) bgtz_alu_opcode(.x(3'b110),.y(3'b111),.z(alu_op));
            end
            6'b001000: begin and_gate_n #(.n(5)) addi_rs(.x(5'b11111),.y(inst[25:21]),.z(rs));
                            and_gate_n #(.n(5)) addi_rt(.x(5'b11111),.y(inst[20:16]),.z(rt));
                            and_gate_n #(.n(16)) addi_imm(.x(16'hFFFF),.y(inst[15:0]),.z(imm));
                            and_gate  addi_reg_dst(.x(1'b1),.y(1'b0),.z(reg_dst));
                            and_gate  addi_alu_src(.x(1'b1),.y(1'b1),.z(alu_src));
			    and_gate_n #(.n(3)) addi_alu_opcode(.x(3'b010),.y(3'b111),.z(alu_op));
            end
            6'b101011: begin and_gate_n #(.n(5)) sw_rs(.x(5'b11111),.y(inst[25:21]),.z(rs));
                            and_gate_n #(.n(5)) sw_rt(.x(5'b11111),.y(inst[20:16]),.z(rt));
                            and_gate_n #(.n(16)) sw_imm(.x(16'hFFFF),.y(inst[15:0]),.z(imm));
                            and_gate  sw_reg_dst(.x(1'b1),.y(1'b0),.z(reg_dst));
                            and_gate  sw_alu_src(.x(1'b1),.y(1'b1),.z(alu_src));
			    and_gate_n #(.n(3)) sw_alu_opcode(.x(3'b010),.y(3'b111),.z(alu_op));
            end
            default: begin and_gate_n #(.n(5)) lw_rs(.x(5'b11111),.y(inst[25:21]),.z(rs));
                            and_gate_n #(.n(5)) lw_rt(.x(5'b11111),.y(inst[20:16]),.z(rt));
                            and_gate_n #(.n(16)) lw_imm(.x(16'hFFFF),.y(inst[15:0]),.z(imm));
                            and_gate  lw_reg_dst(.x(1'b1),.y(1'b0),.z(reg_dst));
                            and_gate  lw_alu_src(.x(1'b1),.y(1'b1),.z(alu_src));
			    and_gate_n #(.n(3)) lw_alu_opcode(.x(3'b010),.y(3'b111),.z(alu_op));
            end     
        endcase
    end 
end
    
endmodule
*/  
