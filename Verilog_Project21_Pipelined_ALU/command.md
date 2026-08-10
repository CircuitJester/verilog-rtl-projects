# Project 21 – Yosys Synthesis Commands

## ALU Control

```bash
rm -f synth/schematics/alu_control.dot
rm -f synth/schematics/alu_control.svg
rm -f synth/netlists/alu_control_netlist.v
yosys synth/scripts/synth_alu_control.ys
rm -f synth/schematics/alu_control.dot
```

## ALU Execute

```bash
rm -f synth/schematics/alu_execute.dot
rm -f synth/schematics/alu_execute.svg
rm -f synth/netlists/alu_execute_netlist.v
yosys synth/scripts/synth_alu_execute.ys
rm -f synth/schematics/alu_execute.dot
```

## ALU Flags

```bash
rm -f synth/schematics/alu_flags.dot
rm -f synth/schematics/alu_flags.svg
rm -f synth/netlists/alu_flags_netlist.v
yosys synth/scripts/synth_alu_flags.ys
rm -f synth/schematics/alu_flags.dot
```

## ALU Pipeline Register

```bash
rm -f synth/schematics/alu_pipeline_register.dot
rm -f synth/schematics/alu_pipeline_register.svg
rm -f synth/netlists/alu_pipeline_register_netlist.v
yosys synth/scripts/synth_alu_pipeline_register.ys
rm -f synth/schematics/alu_pipeline_register.dot
```

## Pipelined ALU Top-Level

```bash
rm -f synth/schematics/pipelined_alu_top.dot
rm -f synth/schematics/pipelined_alu_top.svg
rm -f synth/netlists/pipelined_alu_top_netlist.v
yosys synth/scripts/synth_pipelined_alu_top.ys
rm -f synth/schematics/pipelined_alu_top.dot
```

