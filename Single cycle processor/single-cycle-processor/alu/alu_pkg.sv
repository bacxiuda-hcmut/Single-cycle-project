// File: alu_pkg.sv
package alu_pkg;
  typedef enum logic [3:0] {
    ADD  = 4'b0000,
    SUB  = 4'b0001,
    SLT  = 4'b0010,
    SLTU = 4'b0011,
    XOR  = 4'b0100,
    OR   = 4'b0101,
    AND  = 4'b0110,
    SLL  = 4'b0111,
    SRL  = 4'b1000,
    SRA  = 4'b1001
  } alu_op_e;
endpackage