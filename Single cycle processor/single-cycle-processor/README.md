# Single-Cycle Processor — SystemVerilog Building Blocks

An ongoing digital design project by **Phạm Viết Nhật Huy**, an Integrated Circuit Design student at **Ho Chi Minh City University of Technology (HCMUT)**.

This repository currently contains a 32 × 32-bit register file, a 32-bit ALU, and a branch comparator (BRC). **It is not yet a complete, integrated single-cycle CPU.** The supplied files do not include the processor top level, instruction decoder/control unit, PC integration, or instruction/data memory integration.

## Modules

| Folder | Contents | Status |
|---|---|---|
| [regfile](regfile/README.md) | Two asynchronous read ports, one synchronous write port, hardwired zero register | RTL, scoreboard testbench, simulation script |
| [alu](alu/README.md) | Arithmetic, comparison, logic, and shift operations | ALU recovered from the supplied `.bak` file; no supplied ALU testbench |
| [brc](brc/README.md) | Signed/unsigned less-than and equality comparison | RTL; no supplied BRC testbench |
| `common/` | Full adder and parameterized 2:1 multiplexer | Shared dependencies |
| `docs/` | Supplied register-file report, source manifest, preparation notes | Reference material |
| `originals/` | All 20 supplied files, byte-for-byte | Preserved source snapshot; do not compile this entire folder |

## Important source-file correction

The supplied **`alu.sv` declares `module brc`**, while **`alu.sv.bak` declares `module alu`**. The organized files are therefore:

- `brc/brc.sv` ← original `alu.sv`.
- `alu/alu.sv` ← original `alu.sv.bak`.

This is a file organization correction, not a rewrite of the RTL. The ALU version comes from a backup and should be confirmed as the intended version. Files with `(1)` and `(2)` suffixes have normalized names in the working folders. Original names and bytes remain in `originals/`.

## Getting started

Use a SystemVerilog-capable simulator such as ModelSim/Questa. In its Transcript window, change to the repository root and run:

```tcl
do regfile/run.do
```

The script compiles the register-file dependencies, opens its testbench, adds waveforms, and runs to completion. It changes to its own directory and recreates the local `work` simulation library. See each module README for ports, behavior, and compile instructions.

The original Quartus project metadata is retained for reference. It is incomplete: the supplied register-file QSF does not list the RTL sources, and the BRC QPF has no corresponding BRC QSF. Create a project with the intended FPGA device and explicitly add the organized sources; the original metadata alone is not a ready-to-build project.

## Verification status

The supplied [register-file report](docs/single_cycle_processor.pdf) reports **1,074 checks with zero errors**, including **500 randomized write transactions**. That is a result reported in the supplied document, not a new simulator run performed during repository preparation.

The supplied testbench matches that check count by inspection. No simulator was available in the preparation environment, so simulations and synthesis were not rerun. No ALU/BRC verification result is claimed. The original NativeLink log records a simulator-launch failure, not a functional pass or RTL failure.

## Next steps

- Confirm the recovered ALU version and test all ten operations, including signed boundaries and all shift amounts.
- Add a BRC testbench covering equality and signed/unsigned boundaries.
- Integrate the register file, ALU, BRC, PC, control logic, and memory interfaces.
- Add instruction-level tests before claiming a complete processor implementation.

## Author

Phạm Viết Nhật Huy — HCMUT  
GitHub: [bacxiuda-hcmut](https://github.com/bacxiuda-hcmut)

No license has been selected for this repository. Existing notices in supplied tool-generated files are retained.
