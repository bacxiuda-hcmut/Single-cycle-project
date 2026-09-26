module alu (
  input  logic [31:0] i_op_a,
  input  logic [31:0] i_op_b,
  input  logic [3:0]  i_alu_op,
  output logic [31:0] o_alu_data
);

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

  logic is_sub;
  assign is_sub = (i_alu_op == SUB)  ||
                  (i_alu_op == SLT)  ||
                  (i_alu_op == SLTU);

  logic [31:0] b_operand;
  assign b_operand = is_sub ? ~i_op_b : i_op_b;

  logic [32:0] adder_ext;
  assign adder_ext = {1'b0, i_op_a} + {1'b0, b_operand} + {32'b0, is_sub};

  logic [31:0] sum;
  logic        carry_out;
  assign sum       = adder_ext[31:0];
  assign carry_out = adder_ext[32];

  logic slt_res;
  logic sltu_res;
  logic sign_a;
  logic sign_b;

  assign sign_a   = i_op_a[31];
  assign sign_b   = i_op_b[31];
  assign sltu_res = ~carry_out;
  assign slt_res  = (sign_a == sign_b) ? sum[31] : sign_a;

  logic [31:0] a_reversed;
  always_comb begin
    for (int i = 0; i < 32; i++) begin
      a_reversed[i] = i_op_a[31 - i];
    end
  end

  logic [31:0] shift_in;
  logic        fill_bit;
  logic [4:0]  shamt;

  assign shamt    = i_op_b[4:0];
  assign shift_in = (i_alu_op == SLL) ? a_reversed : i_op_a;
  assign fill_bit = (i_alu_op == SRA) ? i_op_a[31] : 1'b0;

  logic [31:0] shift_st0;
  logic [31:0] shift_st1;
  logic [31:0] shift_st2;
  logic [31:0] shift_st3;
  logic [31:0] shift_st4;

  assign shift_st0 = shamt[0] ? { {1{fill_bit}},  shift_in[31:1] }  : shift_in;
  assign shift_st1 = shamt[1] ? { {2{fill_bit}},  shift_st0[31:2] } : shift_st0;
  assign shift_st2 = shamt[2] ? { {4{fill_bit}},  shift_st1[31:4] } : shift_st1;
  assign shift_st3 = shamt[3] ? { {8{fill_bit}},  shift_st2[31:8] } : shift_st2;
  assign shift_st4 = shamt[4] ? { {16{fill_bit}}, shift_st3[31:16]} : shift_st3;

  logic [31:0] shift_res_reversed;
  always_comb begin
    for (int i = 0; i < 32; i++) begin
      shift_res_reversed[i] = shift_st4[31 - i];
    end
  end

  logic [31:0] shift_res;
  assign shift_res = (i_alu_op == SLL) ? shift_res_reversed : shift_st4;

  always_comb begin
    unique case (i_alu_op)
      ADD:     o_alu_data = sum;
      SUB:     o_alu_data = sum;
      SLT:     o_alu_data = {31'b0, slt_res};
      SLTU:    o_alu_data = {31'b0, sltu_res};
      XOR:     o_alu_data = i_op_a ^ i_op_b;
      OR:      o_alu_data = i_op_a | i_op_b;
      AND:     o_alu_data = i_op_a & i_op_b;
      SLL:     o_alu_data = shift_res;
      SRL:     o_alu_data = shift_res;
      SRA:     o_alu_data = shift_res;
      default: o_alu_data = 32'b0;
    endcase
  end

endmodule