# Run safely from any working directory.
cd [file dirname [file normalize [info script]]]
transcript on
if {[file exists work]} {vdel -lib work -all}
vlib work
vmap work work
vlog -sv dff_en.sv reg_32bit.sv decoder_5to32.sv regfile.sv tb_regfile.sv
vsim -voptargs=+acc work.tb_regfile
add wave -divider {Clock and control}
add wave sim:/tb_regfile/i_clk sim:/tb_regfile/i_reset sim:/tb_regfile/i_rd_wren
add wave -radix unsigned sim:/tb_regfile/i_rd_addr
add wave -radix hexadecimal sim:/tb_regfile/i_rd_data
add wave -divider {Read port 1}
add wave -radix unsigned sim:/tb_regfile/i_rs1_addr
add wave -radix hexadecimal sim:/tb_regfile/o_rs1_data
add wave -divider {Read port 2}
add wave -radix unsigned sim:/tb_regfile/i_rs2_addr
add wave -radix hexadecimal sim:/tb_regfile/o_rs2_data
add wave -divider {Internal}
add wave -radix hexadecimal sim:/tb_regfile/dut/write_enables
run -all
wave zoom full
