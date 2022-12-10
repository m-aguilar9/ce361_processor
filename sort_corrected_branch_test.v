`timescale 1ns/10ps

module sort_corrected_branch_test();
	reg clk;
	cpu cpu1(clk);

	// get data from data files
	defparam cpu1.imem(instance in processor).sram1.mem_file = "data/unsigned_sum.dat";
	defparam cpu1.dmem(instance in processor).syncram1.mem_file= "data/unsigned_sum.dat";

	// run the test with time = 10ns
	initial begin
		clk = 1'b1;
		#10 $finish;
	end

	// making the clock: it starts on 0
	always begin
		#1 clk = ~clk;
	end

endmodule
