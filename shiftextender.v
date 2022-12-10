`timescale 1ns/10ps
`include "and_gate.v"
`include "and_gate_n.v"
`include "and_gate_32.v"

// sign-extend a 16-bit value after multiplying it by 2 to a 32-bit value 
module shiftextender (imm16, imm32);
    // can be sign-extended (ext=1) or zero-extended (ext=0)
	input	[15:0] imm16;
	output	[31:0] imm32;

	wire	[18:0] imm18;
	wire	msb;

	// multiply by 2, then sign extend to 32 bits
	
	and_gate_n #(.n(18)) ag1 ({imm16, 2'b0}, 18'h3FFFF, imm18);
	and_gate 	     ag2 (imm18[17], ext_op, msb);
	and_gate_32 	     ag3 ({{14{msb}}, {imm18[17:0]}}, 32'hFFFFFFFF, imm32);	
	
endmodule
