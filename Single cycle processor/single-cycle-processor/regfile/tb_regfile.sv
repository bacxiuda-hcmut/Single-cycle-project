`timescale 1ns/1ps

module tb_regfile;
    localparam integer CLK_PERIOD = 10;
    localparam integer RANDOM_TESTS = 500;

    logic        i_clk;
    logic        i_reset;
    logic [4:0]  i_rs1_addr;
    logic [4:0]  i_rs2_addr;
    logic [31:0] o_rs1_data;
    logic [31:0] o_rs2_data;
    logic [4:0]  i_rd_addr;
    logic [31:0] i_rd_data;
    logic        i_rd_wren;

    logic [31:0] model [0:31];
    integer errors;
    integer tests;
    integer k;

    regfile dut (.*);

    initial i_clk = 1'b0;
    always #(CLK_PERIOD/2) i_clk = ~i_clk;

    task automatic check_reads(input [4:0] a1, input [4:0] a2);
        begin
            i_rs1_addr = a1;
            i_rs2_addr = a2;
            #1;
            tests = tests + 2;
            if (o_rs1_data !== model[a1]) begin
                $error("RS1 mismatch: addr=%0d expected=%08h actual=%08h",
                       a1, model[a1], o_rs1_data);
                errors = errors + 1;
            end
            if (o_rs2_data !== model[a2]) begin
                $error("RS2 mismatch: addr=%0d expected=%08h actual=%08h",
                       a2, model[a2], o_rs2_data);
                errors = errors + 1;
            end
        end
    endtask

    task automatic write_reg(input [4:0] addr, input [31:0] data);
        begin
            @(negedge i_clk);
            i_rd_addr = addr;
            i_rd_data = data;
            i_rd_wren = 1'b1;
            @(posedge i_clk);
            #1;
            if (addr != 0)
                model[addr] = data;
            @(negedge i_clk);
            i_rd_wren = 1'b0;
        end
    endtask

    initial begin
        errors = 0;
        tests = 0;
        i_reset = 1'b0;
        i_rs1_addr = 5'd0;
        i_rs2_addr = 5'd0;
        i_rd_addr = 5'd0;
        i_rd_data = 32'd0;
        i_rd_wren = 1'b0;
        for (k = 0; k < 32; k = k + 1)
            model[k] = 32'd0;

        // Asynchronous reset must clear R1..R31 without a clock edge.
        #2 i_reset = 1'b1;
        #1 check_reads(5'd0, 5'd31);
        #2 i_reset = 1'b0;

        // Directed corner cases.
        write_reg(5'd1, 32'h1234_5678);
        check_reads(5'd1, 5'd0);
        write_reg(5'd31, 32'hDEAD_BEEF);
        check_reads(5'd31, 5'd1);

        // R0 must ignore writes.
        write_reg(5'd0, 32'hFFFF_FFFF);
        check_reads(5'd0, 5'd31);

        // Disabled write must preserve the previous value.
        @(negedge i_clk);
        i_rd_addr = 5'd1;
        i_rd_data = 32'hAAAA_5555;
        i_rd_wren = 1'b0;
        @(posedge i_clk);
        #1 check_reads(5'd1, 5'd31);

        // Randomized writes and simultaneous dual-port reads.
        for (k = 0; k < RANDOM_TESTS; k = k + 1) begin
            write_reg($urandom_range(0,31), $urandom);
            check_reads($urandom_range(0,31), $urandom_range(0,31));
        end

        // Reset after activity.
        #2 i_reset = 1'b1;
        for (k = 0; k < 32; k = k + 1)
            model[k] = 32'd0;
        #1;
        for (k = 0; k < 32; k = k + 1)
            check_reads(k[4:0], (31-k));
        i_reset = 1'b0;

        if (errors == 0)
            $display("PASS: %0d checks completed with no errors", tests);
        else
            $fatal(1, "FAIL: %0d of %0d checks failed", errors, tests);
        $finish;
    end
endmodule
