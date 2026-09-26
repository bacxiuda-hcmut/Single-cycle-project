module regfile (
    input  logic        i_clk,
    input  logic        i_reset,
    input  logic [4:0]  i_rs1_addr,
    input  logic [4:0]  i_rs2_addr,
    output logic [31:0] o_rs1_data,
    output logic [31:0] o_rs2_data,
    input  logic [4:0]  i_rd_addr,
    input  logic [31:0] i_rd_data,
    input  logic        i_rd_wren
);

    logic [31:0] write_enables;
    logic [31:0] reg_outputs [0:31];

    // 1. Khối giải mã địa chỉ ghi
    decoder_5to32 u_dec (
        .i_addr(i_rd_addr),
        .i_en  (i_rd_wren),
        .o_dec (write_enables)
    );

    // R0 is hardwired to zero; writes to address 0 have no state element.
    assign reg_outputs[0] = 32'h0000_0000;

    genvar reg_idx;
    generate
        for (reg_idx = 1; reg_idx < 32; reg_idx = reg_idx + 1) begin : gen_reg
            reg_32bit u_reg (
                .i_clk  (i_clk),
                .i_reset(i_reset),
                .i_en   (write_enables[reg_idx]),
                .i_d    (i_rd_data),
                .o_q    (reg_outputs[reg_idx])
            );
        end
    endgenerate

    // 4. Đọc dữ liệu qua địa chỉ (Tự động tổng hợp thành bộ MUX 32:1)
    assign o_rs1_data = reg_outputs[i_rs1_addr];
    assign o_rs2_data = reg_outputs[i_rs2_addr];

endmodule
