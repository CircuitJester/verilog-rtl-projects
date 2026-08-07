# Verilog Project 04 – Timers, PWM & FIFO Designs

A collection of reusable digital hardware building blocks implemented in Verilog HDL.

This project focuses on commonly used IP cores found in embedded systems, FPGA designs, and ASIC development. Each module has been functionally verified using **Icarus Verilog** and **GTKWave**, followed by RTL synthesis using **Yosys**.

---

# Implemented Modules

- Timer
- PWM Generator
- FIFO

---

# Design Flow

RTL Design

↓

Testbench Development

↓

Functional Simulation (Icarus Verilog)

↓

Waveform Analysis (GTKWave)

↓

RTL Synthesis (Yosys)

↓

Gate-Level Netlist Generation

↓

Hardware Schematic Generation

↓

Synthesis Report Analysis

---

# Repository Structure

```text
RTL/
tb/
sim/

waveforms/
├── screenshots/

synth/
├── scripts/
├── netlists/
└── schematics/

reports/

docs/

images/

*.vcd
*.gtkw
```

---

# Tools Used

- Verilog HDL
- Icarus Verilog
- GTKWave
- Yosys

---

# Generated Artifacts

- Functional simulation waveforms
- GTKWave session files
- Waveform screenshots
- RTL synthesis scripts
- SVG hardware schematics
- Gate-level Verilog netlists
- Synthesis reports

---

# Learning Outcomes

- Timer Design
- PWM Signal Generation
- FIFO Buffer Design
- Sequential Logic Implementation
- RTL Synthesis
- Hardware Resource Analysis
- Gate-Level Netlist Understanding
- Synthesized Hardware Visualization

---

