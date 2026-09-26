module full_adder(A, B, C_in, S, C_out);

  input A, B, C_in;
  output S, C_out;

  wire x1, a1, a2;

  xor G1(x1, A, B),
      G2(S, x1, C_in);

  and G3(a1, A, B),
      G4(a2, x1, C_in);

  or G5(C_out, a1, a2);

endmodule
