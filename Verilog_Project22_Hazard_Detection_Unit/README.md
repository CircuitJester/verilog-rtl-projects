# Project 22 — Hazard Detection Unit

## Overview

The Hazard Detection Unit is a fundamental processor subsystem responsible for identifying data hazards in a pipelined CPU and preventing incorrect instruction execution. This project implements a modular RTL design capable of detecting Read After Write (RAW) dependencies, generating pipeline stall signals, and controlling pipeline execution through an FSM-based hazard controller.

The design follows a hierarchical architecture where individual modules are independently verified before being integrated into a complete Hazard Detection Unit.

---

# Architecture

```
                 Hazard Detection Unit

         rs1
          │
         rs2
          │
          ▼

 +-------------------------+
 | Register Comparator     |
 +-------------------------+
             │
             ▼

 +-------------------------+
 | Pipeline Stall Generator|
 +-------------------------+
             │
             ▼

 +-------------------------+
 | Hazard Detection Logic  |
 +-------------------------+
             │
             ▼

 +-------------------------+
 | Hazard Controller FSM   |
 +-------------------------+
             │
      ┌──────┴────────┐
      ▼               ▼

Pipeline Hold      Busy
```

---

# Project Structure

```
Project22_Hazard_Detection_Unit/

│── verilogcode/
│   ├── register_comparator.v
│   ├── pipeline_stall_generator.v
│   ├── hazard_detection_logic.v
│   ├── hazard_controller_fsm.v
│   └── hazard_detection_unit.v
│
│── tb/
│   ├── tb_register_comparator.v
│   ├── tb_pipeline_stall_generator.v
│   ├── tb_hazard_detection_logic.v
│   ├── tb_hazard_controller_fsm.v
│   └── tb_hazard_detection_unit.v
│
│── waves/
│
│── build/
│
└── README.md
```

---

# Modules

## Register Comparator

Compares source registers (`rs1` and `rs2`) against the destination register (`rd`) to detect RAW data dependencies while ignoring writes to register x0.

---

## Pipeline Stall Generator

Generates pipeline control signals based on detected hazards.

Outputs:

- Stall Signal
- Program Counter Write Enable
- IF/ID Pipeline Register Write Enable

---

## Hazard Detection Logic

Integrates the comparator and stall generator into a reusable combinational hazard detection block.

---

## Hazard Controller FSM

Implements a Moore Finite State Machine to manage hazard recovery using three states:

- IDLE
- WAIT
- RESUME

The controller freezes and resumes the processor pipeline in a controlled manner.

---

## Hazard Detection Unit

Top-level module integrating every subsystem into a complete processor hazard detection IP.

---

# Features

- Register Dependency Detection
- RAW Hazard Detection
- Pipeline Stall Generation
- Program Counter Control
- IF/ID Pipeline Register Control
- FSM-Based Hazard Management
- Structural RTL Design
- Hierarchical Integration
- Independent Module Verification
- Top-Level Functional Verification

---

# Verification

Every RTL module was independently verified using custom Verilog testbenches.

Verification includes:

- Register Comparison
- Hazard Detection
- Stall Generation
- FSM State Transitions
- Pipeline Hold Logic
- Hazard Recovery
- Top-Level Integration

Waveforms were analyzed using GTKWave.

---

# Concepts Covered

- Verilog HDL
- RTL Design
- Structural Hardware Design
- Hierarchical Integration
- Processor Pipeline
- Data Hazards
- RAW Dependency Detection
- Pipeline Stall Logic
- Pipeline Control
- Moore FSM
- Control Path Design
- Functional Verification
- GTKWave Analysis

---

# Applications

This Hazard Detection Unit can be integrated into:

- RISC-V Processors
- MIPS Processors
- Five-Stage Pipelines
- FPGA CPU Designs
- Educational Processor Projects
- ASIC Processor Designs

---

# Tools Used

- Verilog HDL
- Icarus Verilog
- GTKWave
- Visual Studio Code
- Ubuntu (WSL)
- Git
- GitHub

---

# Learning Outcomes

After completing this project, the following concepts were practiced:

- Processor Pipeline Architecture
- Hazard Detection
- Pipeline Stall Mechanisms
- Control Path Design
- FSM-Based Controller Design
- Hierarchical RTL Development
- System Integration
- Hardware Verification

---
