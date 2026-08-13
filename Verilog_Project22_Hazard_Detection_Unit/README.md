# Project 22 — Hazard Detection Unit

## Overview

The Hazard Detection Unit is a fundamental processor subsystem responsible for identifying data hazards in a pipelined CPU and preventing incorrect instruction execution.

This project implements a modular RTL design capable of detecting **Read After Write (RAW)** dependencies, generating pipeline stall signals, and controlling pipeline execution through an FSM-based hazard controller.

The design follows a hierarchical architecture where individual hardware blocks are independently verified before being integrated into a complete Hazard Detection Unit.

The project also extends the RTL workflow into **Yosys synthesis**, including module-level synthesis, synthesized netlist generation, and RTL schematic generation.

---



# Architecture

```text
                    Hazard Detection Unit

                           rs1
                            |
                           rs2
                            |
                            v
                  +----------------------+
                  | Register Comparator  |
                  +----------+-----------+
                             |
                             v
                  +----------------------+
                  | Hazard Detection     |
                  | Logic                |
                  +----------+-----------+
                             |
                             v
                  +----------------------+
                  | Pipeline Stall       |
                  | Generator            |
                  +----------+-----------+
                             |
                             v
                  +----------------------+
                  | Hazard Controller    |
                  | FSM                  |
                  +----------+-----------+
                             |
                    +--------+--------+
                    |                 |
                    v                 v
              Pipeline Hold        Resume
```


---


# Project Structure

```text
Verilog_Project22_Hazard_Detection_Unit/
│
├── build/
│
├── RTL/
│   ├── register_comparator.v
│   ├── pipeline_stall_generator.v
│   ├── hazard_detection_logic.v
│   ├── hazard_controller_fsm.v
│   └── hazard_detection_unit.v
│
├── tb/
│   ├── tb_register_comparator.v
│   ├── tb_pipeline_stall_generator.v
│   ├── tb_hazard_detection_logic.v
│   ├── tb_hazard_controller_fsm.v
│   └── tb_hazard_detection_unit.v
│
├── Verification/
│
├── synth/
│   ├── netlists/
│   ├── schematics/
│   └── scripts/
│
├── waves/
│
├── README.md
└── command.md
```

---



# Features

* Register Dependency Detection
* RAW Hazard Detection
* Pipeline Stall Generation
* Program Counter Control
* IF/ID Pipeline Register Control
* FSM-Based Hazard Management
* Modular RTL Architecture
* Hierarchical Integration
* Independent Module Verification
* Top-Level Functional Verification
* Yosys RTL Synthesis
* Synthesized Netlist Generation
* RTL Schematic Generation

---



# Hazard Detection Flow

```text
Source Registers
      |
      v
Register Comparison
      |
      v
RAW Dependency Detected?
      |
   +--+--+
   |     |
  No    Yes
   |     |
   v     v
Continue  Stall Pipeline
         |
         v
   Controller FSM
         |
         v
   Hazard Recovery
         |
         v
      Resume
```

---



# Verification

Every RTL module was independently verified using dedicated Verilog testbenches.

Verification includes:

* Register Comparison
* RAW Hazard Detection
* Stall Generation
* FSM State Transitions
* Pipeline Hold Logic
* Hazard Recovery
* Top-Level Integration

---



# Synthesis

The RTL design was synthesized using **Yosys**.

The synthesis workflow includes:

* RTL elaboration
* Hierarchy analysis
* Process conversion
* Logic optimization
* Design statistics
* Synthesized netlist generation
* RTL schematic generation

Each major RTL module was synthesized independently, followed by synthesis of the complete `hazard_detection_unit` design.

The synthesis flow explicitly selects the intended top-level module before schematic generation to ensure that the generated schematic represents the correct processor hazard-control hierarchy.

---


# Concepts Covered

* Verilog HDL
* RTL Design
* Structural Hardware Design
* Hierarchical Integration
* Processor Pipeline
* Data Hazards
* RAW Dependency Detection
* Pipeline Stall Logic
* Pipeline Control
* Moore FSM
* Control Path Design
* Functional Verification
* RTL Synthesis
* Yosys
* Synthesized Netlist Analysis
* RTL Schematic Analysis

---


# Applications

This Hazard Detection Unit can be integrated into:

* RISC-V Processors
* MIPS Processors
* Five-Stage Pipelines
* FPGA CPU Designs
* Educational Processor Projects
* ASIC Processor Designs

---


# Tools Used

* Verilog HDL
* Icarus Verilog
* Yosys
* Visual Studio Code
* Ubuntu (WSL)
* Git
* GitHub

---


# Learning Outcomes

After completing this project, the following concepts were practiced:

* Processor Pipeline Architecture
* Hazard Detection
* RAW Dependency Analysis
* Pipeline Stall Mechanisms
* Control Path Design
* FSM-Based Controller Design
* Hierarchical RTL Development
* System Integration
* Hardware Verification
* RTL Synthesis
* Synthesized Netlist Generation
* RTL Schematic Analysis

---


