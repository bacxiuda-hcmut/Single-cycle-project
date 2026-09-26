module reg_32bit (
    input  logic        i_clk,
    input  logic        i_reset,
    input  logic        i_en,
    input  logic [31:0] i_d,
    output logic [31:0] o_q
);
    // Explicit generate is portable across older Quartus/ModelSim versions.
    genvar bit_idx;
    generate
        for (bit_idx = 0; bit_idx < 32; bit_idx = bit_idx + 1) begin : gen_dff
            dff_en u_dff (
                .i_clk  (i_clk),
                .i_reset(i_reset),
                .i_en   (i_en),
                .i_d    (i_d[bit_idx]),
                .o_q    (o_q[bit_idx])
            );
        end
    endgenerate
endmodule
