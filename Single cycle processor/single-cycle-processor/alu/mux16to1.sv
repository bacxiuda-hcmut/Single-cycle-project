// File: mux16to1.sv
module mux16to1 #(
  parameter int WIDTH = 32
) (
  input  logic [WIDTH-1:0] i_in [16],
  input  logic [3:0]       i_sel,
  output logic [WIDTH-1:0] o_out
);

  logic [WIDTH-1:0] m0 [8];
  logic [WIDTH-1:0] m1 [4];
  logic [WIDTH-1:0] m2 [2];

  // Tầng 0: 8 bộ MUX 2-to-1 chọn theo i_sel[0]
  mux2to1 #(.WIDTH(WIDTH)) u_m00 (.i_sel0(i_in[0]),  .i_sel1(i_in[1]),  .i_sel(i_sel[0]), .o_out(m0[0]));
  mux2to1 #(.WIDTH(WIDTH)) u_m01 (.i_sel0(i_in[2]),  .i_sel1(i_in[3]),  .i_sel(i_sel[0]), .o_out(m0[1]));
  mux2to1 #(.WIDTH(WIDTH)) u_m02 (.i_sel0(i_in[4]),  .i_sel1(i_in[5]),  .i_sel(i_sel[0]), .o_out(m0[2]));
  mux2to1 #(.WIDTH(WIDTH)) u_m03 (.i_sel0(i_in[6]),  .i_sel1(i_in[7]),  .i_sel(i_sel[0]), .o_out(m0[3]));
  mux2to1 #(.WIDTH(WIDTH)) u_m04 (.i_sel0(i_in[8]),  .i_sel1(i_in[9]),  .i_sel(i_sel[0]), .o_out(m0[4]));
  mux2to1 #(.WIDTH(WIDTH)) u_m05 (.i_sel0(i_in[10]), .i_sel1(i_in[11]), .i_sel(i_sel[0]), .o_out(m0[5]));
  mux2to1 #(.WIDTH(WIDTH)) u_m06 (.i_sel0(i_in[12]), .i_sel1(i_in[13]), .i_sel(i_sel[0]), .o_out(m0[6]));
  mux2to1 #(.WIDTH(WIDTH)) u_m07 (.i_sel0(i_in[14]), .i_sel1(i_in[15]), .i_sel(i_sel[0]), .o_out(m0[7]));

  // Tầng 1: 4 bộ MUX 2-to-1 chọn theo i_sel[1]
  mux2to1 #(.WIDTH(WIDTH)) u_m10 (.i_sel0(m0[0]), .i_sel1(m0[1]), .i_sel(i_sel[1]), .o_out(m1[0]));
  mux2to1 #(.WIDTH(WIDTH)) u_m11 (.i_sel0(m0[2]), .i_sel1(m0[3]), .i_sel(i_sel[1]), .o_out(m1[1]));
  mux2to1 #(.WIDTH(WIDTH)) u_m12 (.i_sel0(m0[4]), .i_sel1(m0[5]), .i_sel(i_sel[1]), .o_out(m1[2]));
  mux2to1 #(.WIDTH(WIDTH)) u_m13 (.i_sel0(m0[6]), .i_sel1(m0[7]), .i_sel(i_sel[1]), .o_out(m1[3]));

  // Tầng 2: 2 bộ MUX 2-to-1 chọn theo i_sel[2]
  mux2to1 #(.WIDTH(WIDTH)) u_m20 (.i_sel0(m1[0]), .i_sel1(m1[1]), .i_sel(i_sel[2]), .o_out(m2[0]));
  mux2to1 #(.WIDTH(WIDTH)) u_m21 (.i_sel0(m1[2]), .i_sel1(m1[3]), .i_sel(i_sel[2]), .o_out(m2[1]));

  // Tầng 3: 1 bộ MUX 2-to-1 chọn theo i_sel[3]
  mux2to1 #(.WIDTH(WIDTH)) u_m30 (.i_sel0(m2[0]), .i_sel1(m2[1]), .i_sel(i_sel[3]), .o_out(o_out));

endmodule