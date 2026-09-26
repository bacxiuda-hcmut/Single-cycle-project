# Register File — 32 × 32 bits

A structural SystemVerilog register file with **two combinational read ports** and **one rising-edge write port**, suitable as a building block in a 32-bit processor datapath.

## Interface

| Port | Direction | Width | Meaning |
|---|---|---|---|
| `i_clk` | Input | 1 | Write clock, rising edge |
| `i_reset` | Input | 1 | Asynchronous, active-high reset |
| `i_rs1_addr`, `i_rs2_addr` | Input | 5 each | Source-register addresses |
| `o_rs1_data`, `o_rs2_data` | Output | 32 each | Combinational read data |
| `i_rd_addr` | Input | 5 | Destination-register address |
| `i_rd_data` | Input | 32 | Write data |
| `i_rd_wren` | Input | 1 | Write enable |

## Organization and behavior

`decoder_5to32` converts the destination address into one-hot write enables. `regfile` instantiates 31 `reg_32bit` blocks, and each block instantiates 32 enabled D flip-flops (`dff_en`). This describes **992 one-bit storage elements** before synthesis optimization. Register 0 is a constant zero wire and has no storage element.

- Reset clears R1–R31 without waiting for a clock edge and takes priority over writes.
- At a rising clock edge, a write occurs only when `i_rd_wren = 1` and the destination is nonzero.
- Writes to R0 have no effect; reads of R0 always return zero.
- With write enable low, stored values are retained.
- Both read addresses select data independently through combinational indexing.
- Reading the write destination gives the old value before the edge and the updated value after the nonblocking update and combinational settling. There is no explicit write-through bypass.

The current decoder uses indexed assignment (`o_dec[i_addr] = 1'b1`). The PDF describes a grouped decoder decomposition, which differs from this RTL expression; use the current source as the implementation reference.

## Files

| File | Purpose |
|---|---|
| `dff_en.sv` | One-bit storage with reset and enable |
| `reg_32bit.sv` | Structural 32-bit register |
| `decoder_5to32.sv` | One-hot write decoder |
| `regfile.sv` | Register bank and dual read selection |
| `tb_regfile.sv` | Self-checking scoreboard testbench |
| `run.do` | ModelSim/Questa compilation and waveform script |

## Simulation

From the repository root in ModelSim/Questa:

```tcl
do regfile/run.do
```

The supplied testbench uses a 10 ns clock and tests reset, R1/R31, ignored R0 writes, disabled writes, dual-port reads, 500 random writes, and reset after activity. It compares results against an independent 32-entry model using case inequality to detect X/Z mismatches. The expected success message is:

```text
PASS: 1074 checks completed with no errors
```

The supplied report records this result; it was **not rerun during repository preparation**. Test coverage is not exhaustive: same-cycle bypass behavior, all four-state inputs, and implementation timing are not established by these checks.

The script removes and recreates its local `work` library, so keep unrelated simulator builds elsewhere.
