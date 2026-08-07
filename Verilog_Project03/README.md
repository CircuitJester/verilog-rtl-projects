# Verilog Project 03 – Finite State Machines (FSM) & UART Controllers

A collection of industry-oriented Finite State Machine (FSM) designs implemented in Verilog HDL.

This project focuses on designing, simulating, verifying, and synthesizing control-oriented digital circuits that are commonly used in communication protocols, embedded systems, and digital controllers.

All modules were functionally verified using **Icarus Verilog** and **GTKWave**, followed by RTL synthesis using **Yosys** to generate gate-level netlists, synthesis reports, and hardware schematics.

---

# Implemented Modules

- Traffic Light Controller FSM
- Sequence Detector (1011)
- Vending Machine FSM
- UART Transmitter FSM
- UART Receiver FSM

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

- Finite State Machine (FSM) Design
- Mealy and Moore FSM Concepts
- UART Transmitter Architecture
- UART Receiver Architecture
- Sequence Detection Techniques
- Controller Design
- RTL Synthesis using Yosys
- Hardware Resource Analysis
- Reading Gate-Level Netlists
- Understanding Synthesized Schematics

---
