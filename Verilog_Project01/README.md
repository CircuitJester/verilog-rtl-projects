# Verilog Project 01 – Combinational Logic Design

## Overview

This project introduces the fundamentals of combinational digital logic using Verilog HDL. The designs were verified through simulation using Icarus Verilog and GTKWave, and synthesized using Yosys to generate hardware schematics, gate-level netlists, and synthesis reports.

## Modules

- AND Gate
- Half Adder
- Full Adder
- 4-bit Carry Look Ahead Adder
- 4-bit Ripple Carry Adder
- 4-bit ALU

## Development Flow

RTL Design
→ Testbench Development
→ Functional Simulation (Icarus Verilog)
→ Waveform Analysis (GTKWave)
→ RTL Synthesis (Yosys)
→ Schematic Generation
→ Gate-Level Netlist Generation
→ Synthesis Report Analysis

## Repository Structure

```text
RTL/
tb/
sim/

waveforms/
├── screenshots/
├── *.vcd
└── *.gtkw

synth/
├── scripts/
├── netlists/
└── schematics/

reports/

docs/

images/