# Project 23 — Processor Forwarding Unit

## Overview

This project implements a modular **Processor Forwarding Unit** in Verilog HDL for resolving data hazards in a pipelined processor datapath.

The design detects register dependencies between the current instruction and results available from the **EX/MEM** and **MEM/WB** pipeline stages. Based on these dependencies, the forwarding logic generates control decisions that select the correct operand values for the ALU.

The project follows a hierarchical RTL architecture consisting of dedicated comparison, control, datapath, and multiplexer modules before integration into the complete Forwarding Unit.

The design is also synthesized using **Yosys**, with synthesized netlists and RTL schematics generated for the individual modules and the complete top-level design.

---


# Objective

In a pipelined processor, consecutive instructions may depend on results that have not yet been written back to the register file.

For example:

```text
ADD x10, x5, x6
SUB x12, x10, x7
```

The second instruction requires the result produced by the first instruction.

Instead of waiting for the result to be written back to the register file, the Forwarding Unit detects the dependency and forwards the required value directly from a later pipeline stage.

This reduces unnecessary pipeline stalls and improves processor execution efficiency.

---



# Architecture

```text
                    Forwarding Unit
                           │
             ┌─────────────┴─────────────┐
             │                           │
             ▼                           ▼
     Register Comparator          Register Comparator
           (RS1)                       (RS2)
             │                           │
             └─────────────┬─────────────┘
                           ▼
                Forwarding Control Logic
                           │
                    ┌──────┴──────┐
                    ▼             ▼
                forward_a     forward_b
                    │             │
                    ▼             ▼
                Forwarding     Forwarding
                  MUX A           MUX B
                    │             │
                    ▼             ▼
                ALU Operand A  ALU Operand B
```

---



# Forwarding Operation

The forwarding mechanism compares the source registers of the current instruction against destination registers from later pipeline stages.

```text
Current Instruction
        │
        ├── RS1 ──────────────┐
        │                     │
        └── RS2 ──────────────┤
                              ▼
                     Register Comparators
                              │
                              ▼
                    Forwarding Control Logic
                              │
                     ┌────────┴────────┐
                     ▼                 ▼
                 Forward A         Forward B
                     │                 │
                     ▼                 ▼
                  MUX A              MUX B
                     │                 │
                     ▼                 ▼
                 ALU Operand A     ALU Operand B
```

---



# Pipeline Dependency Sources

The forwarding logic considers results available from later pipeline stages.

```text
Current Instruction
        │
        ▼
      EX Stage
        │
        ├──────────────► EX/MEM Result
        │
        └──────────────► MEM/WB Result
                              │
                              ▼
                     Forwarding Decision
                              │
                              ▼
                         ALU Operands
```

The forwarding decision determines whether the ALU should use:

- The normal register-file operand
- A result forwarded from the EX/MEM stage
- A result forwarded from the MEM/WB stage

---



# Project Structure

```text
Verilog_Project23_Forwarding_Unit/
│
├── build/
│
├── RTL/
│   ├── forwarding_comparator.v
│   ├── forwarding_control_logic.v
│   ├── forwarding_datapath.v
│   ├── forwarding_mux.v
│   └── forwarding_unit.v
│
├── tb/
│   ├── tb_forwarding_comparator.v
│   ├── tb_forwarding_control_logic.v
│   ├── tb_forwarding_datapath.v
│   ├── tb_forwarding_mux.v
│   └── tb_forwarding_unit.v
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

- EX/MEM Dependency Detection
- MEM/WB Dependency Detection
- Register Dependency Comparison
- RAW Hazard Resolution
- Forward-A Control
- Forward-B Control
- Operand Forwarding
- Forwarding Multiplexers
- Modular RTL Architecture
- Hierarchical Module Integration
- Dedicated Module Verification
- Top-Level Functional Verification
- Yosys RTL Synthesis
- Synthesized Netlist Generation
- RTL Schematic Generation

---



# Hazard Resolution Flow

```text
Register Dependency
        │
        ▼
Compare Source and Destination Registers
        │
        ▼
Dependency Detected
        │
        ▼
Forwarding Control Logic
        │
        ├───────────────┐
        ▼               ▼
   Forward A        Forward B
        │               │
        ▼               ▼
      MUX A            MUX B
        │               │
        ▼               ▼
   ALU Operand A    ALU Operand B
```

---



# Verification

Each RTL module is accompanied by a dedicated Verilog testbench.

Verification covers:

- Forwarding Comparator
- Forwarding Control Logic
- Forwarding Datapath
- Forwarding MUX
- Forward-A Selection
- Forward-B Selection
- EX/MEM Dependency Handling
- MEM/WB Dependency Handling
- Top-Level Forwarding Unit Integration

---



# Synthesis

The RTL design was synthesized using **Yosys**.

The synthesis workflow includes:

- RTL elaboration
- Hierarchy analysis
- Process conversion
- Logic optimization
- Design statistics
- Synthesized netlist generation
- RTL schematic generation

The individual forwarding modules are synthesized independently, followed by synthesis of the complete `forwarding_unit` top-level design.

The top-level synthesis explicitly selects `forwarding_unit` as the design hierarchy root to generate the schematic and netlist for the complete forwarding architecture.

---



# Synthesis Flow

```text
Verilog RTL
     │
     ▼
   Yosys
     │
     ▼
Hierarchy Analysis
     │
     ▼
Process Conversion
     │
     ▼
Logic Optimization
     │
     ├───────────────┐
     ▼               ▼
Netlist          RTL Schematic
     │               │
     ▼               ▼
 .v Output        .svg Output
```

---


# Concepts Covered

- Verilog HDL
- RTL Design
- Processor Microarchitecture
- Pipeline Datapath
- Data Hazards
- RAW Dependency Detection
- Register Comparison
- EX/MEM Forwarding
- MEM/WB Forwarding
- Forwarding Control Logic
- Operand Selection
- Multiplexer Design
- Hierarchical RTL Integration
- Functional Verification
- RTL Synthesis
- Yosys
- Synthesized Netlist Generation
- RTL Schematic Analysis

---



# Applications

The Processor Forwarding Unit can be integrated into:

- RISC-V Processors
- MIPS Processors
- Five-Stage Pipeline CPUs
- FPGA Processor Designs
- Educational CPU Architectures
- Custom Processor Datapaths
- ASIC Processor Designs

---



# Tools Used

- Verilog HDL
- Icarus Verilog
- Yosys
- Visual Studio Code
- Ubuntu (WSL)
- Git
- GitHub

---



# Learning Outcomes

After completing this project, the following concepts were practiced:

- Processor Pipeline Architecture
- Data Hazard Resolution
- RAW Dependency Analysis
- EX/MEM Forwarding
- MEM/WB Forwarding
- Forwarding Control Generation
- Operand Selection
- Datapath Design
- Multiplexer-Based Data Routing
- Hierarchical RTL Development
- System Integration
- Hardware Verification
- RTL Synthesis
- Synthesized Netlist Generation
- RTL Schematic Analysis

---
