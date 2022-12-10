`include "and_gate_32.v"
`include "adder_32.v"
`include "shiftextender.v"
`include "mux_32.v"

module program_counter (imm, sel, clk, inst_addr);	

	input	sel;
	input  	[15:0] imm;
	input	clk;
	output reg  [31:0] inst_addr;	
	
	reg   	[31:0]pcin;		
	reg 	[31:0]branch;
	reg 	[31:0]pc_updta,pc_updtb;
	wire 	[31:0]extended;
	wire	[31:0] pc_addr_out;   
	
initial begin
	//and_gate_32 initialize(.x(32'hFFFFFFFF),.y(32'h0040001C),.z(pcin));//initialize program counter
    pcin = 32'h00400018;
    //inst_addr = pcin;
end

/*	adder_32 plus4(
			.a(pcin),
			.b(32'd4),
			.z(pc_updta)
			);//pc+4

	adder_32 plus4_1(
			.a(pcin),
			.b(32'd4),
			.z(pc_updtb)
			);//pc+4

	adder_32 brnch_imm(
			.a(pc_updtb),
			.b(extended),
			.z(branch)
			);//add the immediate to pc+4
	
	mux_32 instruction(
			.sel	 ({31'b0,sel}),
			.src0 	 (pc_updta),
			.src1	 (branch),
			.z	 (inst_addr)
		);
	and_gate_32 update(.x(pc_updta), .y(32'hFFFFFFFF), .z(pcin));
*/

	shiftextender shift_imm(.imm16(imm),.imm32(extended));
    
	always @(posedge clk) begin
	    	pc_updta  = pcin + 32'd4; 
		pc_updtb = pcin + 32'd4;
		branch = pc_updtb + extended;	
	    if (sel == 1'b0) begin
		inst_addr = pc_updta;
	    end else begin
		inst_addr = branch;
	    end
		pcin = pc_updta;
	end

	always @(posedge clk) begin
 
	end
	

	

//	dffr_32 dffr1(.clk(clk),.d_32(pc_updta),.q_32(pcin));
	
endmodule 



