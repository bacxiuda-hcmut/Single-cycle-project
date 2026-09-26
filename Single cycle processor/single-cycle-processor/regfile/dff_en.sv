// D Flip-Flop 1-bit có Reset bất đồng bộ và Write Enable
module dff_en (
    input  logic i_clk,
    input  logic i_reset,
    input  logic i_en,
    input  logic i_d,
    output logic o_q
);
    always_ff @(posedge i_clk or posedge i_reset) begin
        if (i_reset)
            o_q <= 1'b0;
        else if (i_en)
            o_q <= i_d;
    end
endmodule