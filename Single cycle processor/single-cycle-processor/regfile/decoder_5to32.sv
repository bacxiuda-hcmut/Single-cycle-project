module decoder_5to32 (
    input  logic [4:0]  i_addr,
    input  logic        i_en,
    output logic [31:0] o_dec
);
    // One-hot write select. 32'b1 fixes the expression width at 32 bits.
    always_comb begin
        o_dec = 32'b0;
        if (i_en)
            o_dec[i_addr] = 1'b1;
    end
endmodule
