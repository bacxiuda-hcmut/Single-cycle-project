// File: mux2to1.sv
module mux2to1 #(
  parameter int WIDTH = 32
) (
  input  logic [WIDTH-1:0] i_sel0,
  input  logic [WIDTH-1:0] i_sel1,
  input  logic             i_sel,
  output logic [WIDTH-1:0] o_out
);

  assign o_out = (i_sel1 & {WIDTH{i_sel}}) | (i_sel0 & {WIDTH{~i_sel}});

endmodule