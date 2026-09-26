# Repository preparation notes

## Scope

All 20 supplied files are preserved in `originals/`. The working folders contain normalized filenames and copies of the relevant RTL. No RTL behavior was intentionally changed. The register-file `run.do` gained a working-directory preamble so its relative paths resolve when launched from the repository root.

The supplied PDF is a register-file report, not a complete CPU specification. Its reported test result is attributed to that report throughout the documentation.

## Source mapping

See `source_manifest.json` for original filenames, byte sizes, SHA-256 checksums, and working-copy mappings. In particular, `alu/alu.sv` comes from `alu.sv.bak` and `brc/brc.sv` comes from `alu.sv`.

## Checks performed during preparation

- All 20 original files copied with matching SHA-256 checksums.
- All mapped working copies match their original bytes.
- Module names in the organized `.sv` files checked for duplicates.
- Relative Markdown links checked for existing local targets.
- Simulator availability checked: neither Icarus Verilog nor Verilator was available. ModelSim/Questa was not available through the provided environment. No simulation, synthesis, or timing analysis was run.

The package is ready for review and upload, but is not a claim of verified whole-CPU functionality. The original tool-generated project files and failed NativeLink report remain under `originals/` for traceability.
