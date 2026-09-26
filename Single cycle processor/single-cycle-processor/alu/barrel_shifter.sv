// File: barrel_shifter.sv (Đóng gói bộ dịch tổ hợp 5 tầng riêng biệt)
module barrel_shifter (
  input  logic [31:0] i_data,
  input  logic [4:0]  i_shamt,
  input  logic        i_is_sll,
  input  logic        i_is_sra,
  output logic [31:0] o_data
);

  logic [31:0] data_rev, shift_in, st0, st1, st2, st3, st4, st4_rev;
  logic        fill_bit;

  assign fill_bit = i_is_sra & i_data[31];

  // Đảo chuỗi bit đầu vào nếu thực hiện Dịch Trái (SLL)
  bit_reverser u_rev_in (
    .i_data(i_data),
    .o_data(data_rev)
  );

  mux2to1 #(.WIDTH(32)) u_mux_in (
    .i_sel0(i_data),
    .i_sel1(data_rev),
    .i_sel (i_is_sll),
    .o_out (shift_in)
  );

  // Mạch Barrel Shifter dịch phải tổ hợp 5 tầng
  mux2to1 #(.WIDTH(32)) u_m0 (.i_sel0(shift_in), .i_sel1({{1{fill_bit}},  shift_in[31:1]}), .i_sel(i_shamt[0]), .o_out(st0));
  mux2to1 #(.WIDTH(32)) u_m1 (.i_sel0(st0),      .i_sel1({{2{fill_bit}},  st0[31:2]}),      .i_sel(i_shamt[1]), .o_out(st1));
  mux2to1 #(.WIDTH(32)) u_m2 (.i_sel0(st1),      .i_sel1({{4{fill_bit}},  st1[31:4]}),      .i_sel(i_shamt[2]), .o_out(st2));
  mux2to1 #(.WIDTH(32)) u_m3 (.i_sel0(st2),      .i_sel1({{8{fill_bit}},  st2[31:8]}),      .i_sel(i_shamt[3]), .o_out(st3));
  mux2to1 #(.WIDTH(32)) u_m4 (.i_sel0(st3),      .i_sel1({{16{fill_bit}}, st3[31:16]}),     .i_sel(i_shamt[4]), .o_out(st4));

  // Đảo lại kết quả đầu ra nếu là lệnh SLL
  bit_reverser u_rev_out (
    .i_data(st4),
    .o_data(st4_rev)
  );

  mux2to1 #(.WIDTH(32)) u_mux_out (
    .i_sel0(st4),
    .i_sel1(st4_rev),
    .i_sel (i_is_sll),
    .o_out (o_data)
  );

endmodule