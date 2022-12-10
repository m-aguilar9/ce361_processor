`timescale 1ns/10ps
`include "or_gate.v"
`include "and_gate.v"
`include "not_gate.v" 

module alu_control(func, alu_op, alu_ctrl);
 
	input	[5:0] func;
	input	[1:0] alu_op;
	output	[2:0] alu_ctrl;


	//// ALUctrl[2] -> e3 (a,b,c,d,e,s,t)
	// (!ALUop<1> & ALUop<0>) -> a2
	wire	t2, a2;
	not_gate ng2_2 (alu_op[1], t2);

	and_gate ag2_2 (t2, alu_op[0], a2);

	// (ALUop<1> & func<5> & !func<4> & !func<3> & !func<2> & func<1>) -> b5
	wire	t3, t4, t5, b1, b2, b3, b4, b5;
	not_gate ng2_3 (func[4], t3);
	not_gate ng2_4 (func[3], t4);
	not_gate ng2_5 (func[2], t5);

	and_gate ag2_3 (t3, t4, b1);
	and_gate ag2_4 (b1, t5, b2);
	and_gate ag2_5 (b2, func[5], b3);
	and_gate ag2_6 (b3, func[1], b4);
	and_gate ag2_7 (b4, alu_op[1], b5);

	// (ALUop<1> & func<5> & !func<4> & func<3> & !func<2> & func<1> & func<0>) -> c6
	wire	t6, t7, c1, c2, c3, c4, c5, c6;
	not_gate ng2_6 (func[4], t6);
	not_gate ng2_7 (func[2], t7);

	and_gate ag2_8 (t6, t7, c1);
	and_gate ag2_9 (func[3], c1, c2);
	and_gate ag2_10 (func[5], c2, c3);
	and_gate ag2_11 (func[1], c3, c4);
	and_gate ag2_12 (func[0], c4, c5);
	and_gate ag2_13 (alu_op[1], c5, c6);

	// (ALUop<1> & !func<5>) -> d1
	wire	s1, d1;
	not_gate ng2_8 (func[5], s1);
	and_gate ag2_14 (s1, alu_op[1], d1);	

	// add them up! -> alu_ctrl[2]
	wire	e1, e2, e3;
	or_gate og2_1 (a2, b5, e1);
	or_gate og2_2 (c6, d1, e2);
	or_gate og2_3 (e1, e2, alu_ctrl[2]);
	


	//// ALUctrl[1] -> (f, g, l, q)
	// (!ALUop<1> & !ALUop<0>) -> f1
	wire	q1, q2, f1;
	not_gate ng1_1 (alu_op[1], q1);
	not_gate ng1_2 (alu_op[0], q2);

	and_gate ag1_1 (q1, q2, f1);

	// (ALUop<1> & func<5> & !func<4> & !func<2>) -> g3
	wire	q3, q4, g1, g2, g3;
	not_gate ng1_3 (func[4], q3);
	not_gate ng1_4 (func[2], q4);

	and_gate ag1_2 (q3, q4, g1);
	and_gate ag1_3 (g1, alu_op[1], g2);
	and_gate ag1_4 (g2, func[5], g3);

	// (!ALUop<1> & ALUop<0>) -> l1
	wire	q5, l1;
	not_gate ng1_5 (alu_op[1], q5);

	and_gate ag1_5 (q5, alu_op[0], l1);
	
	// add them up! -> alu_ctrl[1]
	wire	q6;
	or_gate og1_1 (f1, g3, q6);
	or_gate og1_2 (l1, q6, alu_ctrl[1]);



	//// ALUctrl[0] -> (h, i, j, k, r)
	// (ALUop<1> & func<5> & !func<4> & !func<3> & func<2> & func<0>)  -> h5
	wire	r1, r2, h1, h2, h3, h4, h5;
	not_gate ng0_1 (func[4], r1);
	not_gate ng0_2 (func[3], r2);

	and_gate ag0_1 (alu_op[1], func[5], h1);
	and_gate ag0_2 (r1, r2, h2);
	and_gate ag0_3 (func[2], func[0], h3);
	and_gate ag0_4 (h1, h2, h4);
	and_gate ag0_5 (h3, h4, h5);

	// (ALUop<1> & func<5> & !func<4> & func<3>) -> i3
	wire	r3, i1, i2, i3;
	not_gate ng0_3 (func[4], r3);

	and_gate ag0_6 (alu_op[1], func[5], i1);
	and_gate ag0_7 (r3, func[3], i2);
	and_gate ag0_8 (i1, i2, i3);
	
	// (ALUop<1> & !<func<5>) -> j1
	wire	r4, j1;
	not_gate ng0_4 (func[5], r4);

	and_gate ag0_9 (alu_op[1], r4, j1);

	// add them up! -> alu_ctrl[0]
	wire k1;
	or_gate og0_1 (h5, i3, k1);
	or_gate og0_2 (k1, j1, alu_ctrl[0]);



endmodule
