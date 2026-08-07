# Project 02 – Sequential Logic Design using Verilog HDL

A collection of sequential digital circuits implemented in Verilog HDL.

Each design was developed following a complete RTL design workflow including simulation, functional verification, waveform analysis, RTL synthesis, schematic generation, gate-level netlist generation, and synthesis report analysis.

---

## Modules

- D Flip-Flop
- D Flip-Flop with Asynchronous Reset
- 4-bit Register
- 4-bit Shift Register
- 4-bit Binary Counter
- 4-bit Up/Down Counter
- 4-bit Ring Counter
- 4-bit Johnson Counter
- Clock Divider by 2

---

## Design Flow

RTL Design

↓

Testbench Development

↓

Simulation (Icarus Verilog)

↓

Waveform Verification (GTKWave)

↓

RTL Synthesis (Yosys)

↓

Schematic Generation

↓

Gate-Level Netlist

↓

Synthesis Report Analysis

---

## Repository Structure

```text
Verilog_Project02/
│
├── RTL/
├── tb/
├── sim/
│
├── waveforms/
│   ├── screenshots/
│   ├── *.vcd
│   └── *.gtkw
│
├── synth/
│   ├── scripts/
│   ├── netlists/
│   └── schematics/
│
├── reports/
├── docs/
├── images/
└── README.md
```

---

## Tools Used

- Verilog HDL
- Icarus Verilog
- GTKWave
- Yosys

---

## Generated Artifacts

Each module contains:

- Functional simulation
- VCD waveform
- GTKWave session
- Waveform screenshot
- RTL synthesis script
- Synthesis statistics
- SVG schematic
- Gate-level Verilog netlist
- Synthesis log

---

## Learning Outcomes

- Sequential logic design
- Edge-triggered storage elements
- Register design
- Shift register operation
- Counter architectures
- Clock division
- Functional verification
- RTL synthesis using Yosys
- Reading synthesis reports
- Understanding synthesized schematics