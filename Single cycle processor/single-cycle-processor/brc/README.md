# Branch Comparator (BRC) — 32 bits

A combinational SystemVerilog comparator producing equality and less-than flags for processor branch decisions. `brc.sv` is a byte-for-byte copy of the supplied file named `alu.sv`, whose declared top-level module is `brc`.

## Interface

| Port | Direction | Width | Meaning |
|---|---|---|---|
| `i_rs1_data` | Input | 32 | First source operand A |
| `i_rs2_data` | Input | 32 | Second source operand B |
| `i_br_un` | Input | 1 | 1 = unsigned; 0 = signed |
| `o_br_less` | Output | 1 | A < B in the selected interpretation |
| `o_br_equal` | Output | 1 | A equals B bit-for-bit |

The block has no clock, reset, instruction decoder, branch enable, or target-address output.

## Comparison method

For unsigned comparison, operands pass through unchanged. For signed comparison, the most significant bit of each operand is inverted before unsigned subtraction. Flipping the sign bit maps the signed ordering into unsigned ordering.

Two 1-bit multiplexers select the effective MSBs. An array of 32 `full_adder` instances computes:

```text
A_effective + NOT(B_effective) + 1
```

`carry[0]` is set to 1. The final carry indicates no borrow, so `o_br_less = ~carry[32]`. Equality is computed independently as a reduction NOR of operand XOR:

```systemverilog
assign o_br_equal = ~|(i_rs1_data ^ i_rs2_data);
```

Equality does not depend on signed/unsigned mode. This is a ripple-carry structure; no timing result is claimed.

## Intended branch-control use

The following mapping belongs in the eventual control logic, which is not included here:

| Branch condition | `i_br_un` | Condition from BRC |
|---|---|---|
| BEQ | Either | `o_br_equal` |
| BNE | Either | `!o_br_equal` |
| BLT | 0 | `o_br_less` |
| BGE | 0 | `!o_br_less` |
| BLTU | 1 | `o_br_less` |
| BGEU | 1 | `!o_br_less` |

A separate decoder must also qualify these conditions with a valid branch instruction.

## Compile with ModelSim/Questa

From the repository root, after creating/mapping a `work` library:

```tcl
vlog -sv common/mux2to1.sv common/full_adder.sv brc/brc.sv
```

The supplied BRC QPF and workspace file are preserved under `originals/`; the associated BRC QSF was not supplied. They are not a complete Quartus project.

## Verification status

No BRC testbench was supplied, and this module was not simulated during preparation. Useful directed expectations include:

| A | B | Signed less-than | Unsigned less-than | Equal |
|---|---|---|---|---|
| `00000000` | `00000000` | 0 | 0 | 1 |
| `00000000` | `00000001` | 1 | 1 | 0 |
| `FFFFFFFF` | `00000000` | 1 | 0 | 0 |
| `80000000` | `7FFFFFFF` | 1 | 0 | 0 |
| `7FFFFFFF` | `80000000` | 0 | 1 | 0 |

These are test specifications, not recorded simulation results. A future testbench should also compare randomized operands against signed and unsigned reference comparisons.
