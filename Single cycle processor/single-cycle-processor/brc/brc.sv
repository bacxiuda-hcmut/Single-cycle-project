module brc (
    input  logic [31:0] i_rs1_data,
    input  logic [31:0] i_rs2_data,
    input  logic        i_br_un,     // 1: Unsigned, 0: Signed
    output logic        o_br_less,
    output logic        o_br_equal
);

    // -------------------------------------------------------------------------
    // Bước 1: Đảo bit MSB cho phép so sánh Signed bằng MUX2to1
    // -------------------------------------------------------------------------
    wire msb_a, msb_b;

    mux2to1 #(.WIDTH(1)) u_mux_msb_a (
        .i_sel0 (~i_rs1_data[31]),
        .i_sel1 (i_rs1_data[31]),
        .i_sel  (i_br_un),
        .o_out  (msb_a)
    );

    mux2to1 #(.WIDTH(1)) u_mux_msb_b (
        .i_sel0 (~i_rs2_data[31]),
        .i_sel1 (i_rs2_data[31]),
        .i_sel  (i_br_un),
        .o_out  (msb_b)
    );

    wire [31:0] a_eff = {msb_a, i_rs1_data[30:0]};
    wire [31:0] b_eff = {msb_b, i_rs2_data[30:0]};

    // -------------------------------------------------------------------------
    // Bước 2: Nối 32 Full Adder dạng Array of Instances (Không dùng vong lặp)
    // -------------------------------------------------------------------------
    wire [31:0] sum;
    wire [32:0] carry;

    assign carry[0] = 1'b1; // C_in ban đầu = 1 cho phép trừ Bù 2 (A + ~B + 1)

    // Tạo mảng 32 instance full_adder và map vector tự động
    full_adder u_fa [31:0] (
        .A    (a_eff),
        .B    (~b_eff),
        .C_in (carry[31:0]),
        .S    (sum),
        .C_out(carry[32:1])
    );

    wire cout = carry[32];

    // -------------------------------------------------------------------------
    // Bước 3: Tín hiệu ngõ ra
    // -------------------------------------------------------------------------
    assign o_br_less  = ~cout;
    assign o_br_equal = ~|(i_rs1_data ^ i_rs2_data);

endmodule