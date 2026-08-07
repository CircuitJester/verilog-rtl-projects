# Project 05 — SPI Master Controller

## Overview

This project implements a parameterized SPI Master Controller in Verilog HDL.

The design is built using a modular RTL architecture where the SPI Master is constructed from reusable hardware blocks including a clock generator, bit counter, finite state machine, and shift register.

The controller supports full-duplex SPI communication with programmable clock division and configurable clock polarity.

---

# Features

- Parameterized data width
- Configurable SPI clock divider
- CPOL support
- Chip Select (CS) generation
- MOSI transmit path
- MISO receive path
- Full-duplex communication
- Modular RTL implementation
- Synthesized using Yosys
- Verified using GTKWave

---

# Design Architecture

Top-Level IP

- SPI Master Controller

Internal RTL Modules

- SPI Clock Generator
- SPI Bit Counter
- SPI Shift Register
- SPI Master FSM

---

# Folder Structure

```
Project05
│
├── RTL/
├── tb/
├── sim/
├── reports/
├── synth/
│   ├── scripts/
│   ├── schematics/
│   └── netlists/
│
├── waveforms/
└── README.md
```

---

# Verification

Simulation Tool

- Icarus Verilog

Waveform Viewer

- GTKWave

---

# Synthesis

Tool

- Yosys Open Synthesis Suite

Outputs

- Synthesized RTL Netlist
- RTL Schematic
- Resource Utilization Report

---

# Learning Outcomes

- Hierarchical RTL Design
- Modular Hardware Architecture
- SPI Protocol Fundamentals
- Parameterized Verilog Design
- RTL Verification Workflow
- Yosys RTL Synthesis
- RTL Netlist Generation