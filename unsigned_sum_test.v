`timescale 1ns/10ps

module unsigned_sum_test();
	reg clk;
	cpu cpu1(clk);

	// get data from data files
	defparam cpu1.imem.sram1.mem_file = "data/unsigned_sum.dat";
	defparam cpu1.dp1.data_mem.syncram1.mem_file = "data/unsigned_sum.dat";


	// run the test with time = 10ns
	initial begin

		#1000 $finish;
	end

	// making the clock: it starts on 0
	always begin
		clk = 1'b1;
		#1;
		clk = 1'b0;
		#1;
	end


endmodule
