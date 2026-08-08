# I²C Master Controller

## Overview

This project implements a modular I²C (Inter-Integrated Circuit) Master Controller in Verilog HDL.

The design is developed using a modular RTL approach where each functional block is designed, simulated, verified independently, and finally integrated into a complete I²C Master Controller.

The implementation focuses on understanding the internal architecture of an I²C Master while following a professional RTL design workflow including RTL simulation, GTKWave waveform analysis, and Yosys-based synthesis.

Each major RTL block is synthesized independently to generate a synthesized Verilog netlist and structural SVG schematic. The complete I²C Master is also synthesized as a hierarchical top-level design.

---

## Features

- I²C Master Interface
- Configurable Clock Divider
- START Condition Generation
- STOP Condition Generation
- Shift Register Based Data Transmission
- Bit Counter
- ACK/NACK Detection
- FSM Based Controller
- Modular RTL Architecture
- Independent Module Verification
- GTKWave Waveform Analysis
- Yosys RTL Synthesis
- Synthesized Verilog Netlists
- Structural SVG Schematics
- Synthesis Reports

---

## Modules

- I²C Clock Generator
- START / STOP Generator
- Shift Register
- Bit Counter
- ACK Detector
- FSM Controller
- I²C Master Top Module
- System Testbench

### Verified Components

- Clock Generation
- START Condition
- STOP Condition
- Shift Register Operation
- Bit Counting
- ACK Detection
- FSM Operation
- Complete Module Integration

Each RTL module was simulated independently using dedicated Verilog testbenches.

The generated VCD files were analyzed using GTKWave to verify signal transitions and functional behavior.

---

## Verification

The verification flow follows:

```text
RTL Design
    ↓
Verilog Simulation
    ↓
VCD Generation
    ↓
GTKWave Analysis
    ↓
Waveform Screenshots
    ↓
Yosys Synthesis
    ↓
Synthesized Netlist
    ↓
Structural SVG Schematic