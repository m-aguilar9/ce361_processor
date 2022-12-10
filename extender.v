`include "and_gate.v"

// sign-extend a 16-bit value to a 32-bit value
module extender (imm16, ext_op, imm32);
    // can be sign-extended (ext=1) or zero-extended (ext=0)
    input   [15:0] imm16;
    input   ext_op; 
    output  [31:0] imm32;

    wire    msb;
    
    and_gate ag1 (imm16[15], ext_op, msb);
    assign imm32 = {{16{msb}},{imm16[15:0]}};

endmodule
