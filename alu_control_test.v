`timescale 1ns/10ps

module alu_control_test();
	reg	[5:0] func;
	reg	[1:0] alu_op;
	wire	[2:0] alu_ctrl;

	alu_control ac1 (func, alu_op, alu_ctrl);

	initial begin
// itype	
	// add
		// should be 010
		func = 	6'b101010;
		alu_op = 2'b00;
		#10
		// should be 010 for add
		func = 	6'b111111;
		alu_op = 2'b00;
		#10
		// should be 010 for add
		func = 	6'b000000;
		alu_op = 2'b00;
		#10
	//sub
		// should be 110 for sub
		func = 	6'b100100;
		alu_op = 2'b01;
		#10
		// should be 110 for sub
		func = 	6'b111111;
		alu_op = 2'b01;
		#10
		// should be 110 for sub
		func = 	6'b000000;
		alu_op = 2'b01;
		#10
// rtype
	// and
		// should be 000 
		func = 	6'b100100;
		alu_op = 2'b10;
		#10
		// should be 000 
		func = 	6'b100100;
		alu_op = 2'b10;
		#10
		// should be 000 
		func = 	6'b100100;
		alu_op = 2'b11;
		#10
	// or
		// should be 001
		func = 	6'b100101;
		alu_op = 2'b10;
		#10
		// should be 001
		func = 	6'b100101;
		alu_op = 2'b10;
		#10
		// should be 001
		func = 	6'b100101;
		alu_op = 2'b11;
		#10
	// add
		// should be 010
		func = 	6'b100000;
		alu_op = 2'b10;
		#10
		// should be 010
		func = 	6'b100000;
		alu_op = 2'b10;
		#10
		// should be 010
		func = 	6'b100000;
		alu_op = 2'b11;
		#10
	// addu
		// should be 010
		func = 	6'b100001;
		alu_op = 2'b10;
		#10
		// should be 010
		func = 	6'b100001;
		alu_op = 2'b10;
		#10
		// should be 010
		func = 	6'b100001;
		alu_op = 2'b11;
		#10
	// sub
		// should be 110
		func = 	6'b100010;
		alu_op = 2'b10;
		#10
		// should be 110
		func = 	6'b100010;
		alu_op = 2'b10;
		#10
		// should be 110
		func = 	6'b100010;
		alu_op = 2'b11;
		#10
	// subu
		// should be 110
		func = 	6'b100011;
		alu_op = 2'b10;
		#10
		// should be 110
		func = 	6'b100011;
		alu_op = 2'b11;
		#10
		// should be 110
		func = 	6'b100011;
		alu_op = 2'b11;
		#10
	// slt
		// should be 011
		func = 	6'b101010;
		alu_op = 2'b10;
		#10
		// should be 011
		func = 	6'b101010;
		alu_op = 2'b11;
		#10
		// should be 011
		func = 	6'b101010;
		alu_op = 2'b11;
		#10
	// sltu
		// should be 111
		func = 	6'b101011;
		alu_op = 2'b10;
		#10
		// should be 111
		func = 	6'b101011;
		alu_op = 2'b11;
		#10
		// should be 111
		func = 	6'b101011;
		alu_op = 2'b11;
		#10
	// sll
		// should be 101
		func = 	6'b000000;
		alu_op = 2'b10;
		#10
		// should be 101
		func = 	6'b000000;
		alu_op = 2'b11;
		#10
		// should be 101
		func = 	6'b000000;
		alu_op = 2'b11;
		#10 $finish;
	end

endmodule


