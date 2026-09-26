# Arithmetic Logic Unit — 32 bits

A combinational SystemVerilog ALU with ten operations. The working `alu.sv` is copied without RTL changes from the supplied **`alu.sv.bak`**, because the supplied file named `alu.sv` actually contains the BRC module.

## Interface

| Port | Direction | Width | Meaning |
|---|---|---|---|
| `i_op_a` | Input | 32 | First operand |
| `i_op_b` | Input | 32 | Second operand; low five bits are the shift amount |
| `i_alu_op` | Input | 4 | Operation selector |
| `o_alu_data` | Output | 32 | Combinational result |

No clock or reset is required.

## Operation encoding

| Selector | Operation | Result |
|---|---|---|
| `0000` | ADD | A + B, low 32 bits |
| `0001` | SUB | A − B, low 32 bits |
| `0010` | SLT | Signed A < B, zero-extended to 32 bits |
| `0011` | SLTU | Unsigned A < B, zero-extended to 32 bits |
| `0100` | XOR | Bitwise A XOR B |
| `0101` | OR | Bitwise A OR B |
| `0110` | AND | Bitwise A AND B |
| `0111` | SLL | Logical left shift by B[4:0] |
| `1000` | SRL | Logical right shift by B[4:0] |
| `1001` | SRA | Arithmetic right shift by B[4:0] |
| `1010`–`1111` | Reserved | Zero |

Arithmetic overflow wraps to 32 bits; there is no overflow flag output. Shift amounts are 0–31 because only five bits are used.

## Implementation

- ADD, SUB, SLT, and SLTU share an extended arithmetic expression. Subtraction uses A + ~B + 1.
- Unsigned less-than uses the inverse subtraction carry-out. Signed less-than selects the sign of A when operand signs differ, otherwise the subtraction-result sign.
- Shifts use five conditional stages for shifts of 1, 2, 4, 8, and 16 bits. SRA replicates the sign bit. SLL reverses the input bits, uses the right-shift network, then reverses the output.
- A combinational `unique case` selects the final result and supplies a zero default.

## Active design versus support modules

The recovered `alu.sv` is **self-contained**: it declares its own operation enum and implements arithmetic, reversal, and shifting internally. It does **not** instantiate `barrel_shifter`, `bit_reverser`, or `mux16to1`, and does **not** import `alu_pkg`.

The separate helper files are retained as alternative structural building blocks:

| File | Dependencies / limitation |
|---|---|
| `alu_pkg.sv` | Shared enum matching the current operation encoding; not imported by active ALU |
| `barrel_shifter.sv` | `bit_reverser.sv`, `../common/mux2to1.sv`; intended modes SLL/SRL/SRA |
| `bit_reverser.sv` | Exposes `WIDTH`, but concatenation is hard-coded to 32 bits; use WIDTH=32 |
| `mux16to1.sv` | `../common/mux2to1.sv`; tree of 15 multiplexers |

Do not claim these helpers are integrated into the active ALU until the RTL is updated and verified.

## Compile with ModelSim/Questa

From the repository root, after creating/mapping a `work` library:

```tcl
vlog -sv alu/alu.sv
```

To compile the optional helper modules as well:

```tcl
vlog -sv common/mux2to1.sv alu/alu_pkg.sv alu/bit_reverser.sv alu/barrel_shifter.sv alu/mux16to1.sv
```

These are compile commands, not functional tests. No ALU testbench was supplied, and no simulation was run during preparation.

## Verification still needed

Test all operation selectors; ADD/SUB carry and overflow boundaries; SLT versus SLTU for opposite signs; every shift amount including 0 and 31; and negative SRA operands. Compare results against independent behavioral expressions. No synthesis area, maximum frequency, or hardware result is currently claimed.

The original `alu_nativelink_simulation.rpt` records a failure to locate/launch ModelSim-Altera. It does not establish whether the ALU function is correct.
