# Project 27 — RISC-V Pipeline Forwarding Unit

## Overview

This project implements a modular **RISC-V pipeline forwarding unit** for a 5-stage pipelined processor datapath using Verilog HDL.

The forwarding unit resolves **Read After Write (RAW) data hazards** that occur when an instruction in the Execute stage requires a register value that is still being produced by an earlier instruction in the pipeline.

Instead of stalling the pipeline whenever a dependency occurs, the forwarding unit detects when the required result is already available in the **EX/MEM** or **MEM/WB** pipeline stages and generates control signals that allow the datapath to select the most recent available value.

The design focuses on operand forwarding, forwarding priority, register-write qualification, and RISC-V register `x0` handling.

The project is implemented as a standalone RTL block that can later be integrated into a larger RISC-V pipelined processor.

The RTL is also synthesized using **Yosys**, with a synthesized netlist and RTL schematic generated for the forwarding unit.

---


# Objective

The primary objective is to resolve data dependencies between pipeline stages without unnecessarily stalling the processor.

The forwarding unit monitors:

- `ID/EX.rs1`
- `ID/EX.rs2`
- `EX/MEM.rd`
- `EX/MEM.reg_write`
- `MEM/WB.rd`
- `MEM/WB.reg_write`

and generates:

- `forward_a`
- `forward_b`

These control signals determine which value should be supplied to the ALU operands.

---


# Data Hazard Example

Consider the instruction sequence:

```text
ADD x5, x1, x2
SUB x6, x5, x3
```

The `SUB` instruction requires the newly generated value of `x5`.

However, the result of the `ADD` instruction may still be present in a later pipeline stage rather than in the register file.

Without forwarding:

```text
ADD
 │
 ▼
Pipeline
 │
 ▼
Stall
 │
 ▼
Register Write-Back
 │
 ▼
SUB continues
```

With forwarding:

```text
ADD Result
    │
    ▼
 EX/MEM
    │
    ▼
Forwarding Unit
    │
    ▼
 ALU Operand
```

The dependent instruction can therefore continue without waiting for normal register-file write-back.

---


# Architecture

```text
                         Forwarding Unit
                                │
              ┌─────────────────┴─────────────────┐
              │                                   │
              ▼                                   ▼
      ID/EX.rs1 Dependency                 ID/EX.rs2 Dependency
              │                                   │
              ▼                                   ▼
      ┌───────────────┐                   ┌───────────────┐
      │ Register      │                   │ Register      │
      │ Comparison A  │                   │ Comparison B  │
      └───────┬───────┘                   └───────┬───────┘
              │                                   │
              └─────────────────┬─────────────────┘
                                │
                                ▼
                    Forwarding Control Logic
                                │
                     ┌──────────┴──────────┐
                     │                     │
                     ▼                     ▼
                 forward_a             forward_b
                     │                     │
                     ▼                     ▼
                Forwarding MUX        Forwarding MUX
                     │                     │
                     ▼                     ▼
                ALU Operand A         ALU Operand B
```

---


# RISC-V Register x0 Handling

RISC-V register `x0` is hardwired to zero.

Because `x0` never represents a writable architectural result, it must not generate a forwarding condition.

The forwarding logic therefore excludes register zero from dependency matching.

Conceptually:

```text
rd != 0
```

must be true before a register-write dependency can produce a forwarding decision.

This prevents false forwarding when the source register is `x0`.

---


# Features

- RISC-V Pipeline Forwarding
- RAW Hazard Resolution
- EX/MEM Forwarding
- MEM/WB Forwarding
- Independent Operand A Forwarding
- Independent Operand B Forwarding
- EX/MEM Priority Handling
- Register-Write Qualification
- RISC-V `x0` Protection
- Combinational Forwarding Logic
- ALU Operand Source Selection
- Modular RTL Design
- Dedicated Functional Verification
- Top-Level Verification
- Yosys RTL Synthesis
- Synthesized Netlist Generation
- RTL Schematic Generation

---


# Project Structure

```text
Verilog_Project27/
│
├── build/
│
├── RTL/
│   └── forwarding_unit.v
│
├── tb/
│   └── tb_forwarding_unit.v
│
├── verification/
│
├── synth/
│   ├── netlists/
│   ├── schematics/
│   └── scripts/
│
├── verilogcode/
│   └── forwarding_unit.v
│
├── waves/
│
├── README.md
└── command.md
```

---


# Verification

The forwarding unit is verified using a dedicated Verilog testbench.

The verification scenarios include:

- EX/MEM forwarding to operand A
- EX/MEM forwarding to operand B
- MEM/WB forwarding to operand A
- MEM/WB forwarding to operand B
- Simultaneous forwarding for both operands
- No dependency between pipeline stages
- Register-write disabled conditions
- Register `x0` dependency
- EX/MEM versus MEM/WB priority

The verification focuses on ensuring that the forwarding control outputs correctly respond to:

- Register dependencies
- Pipeline-stage write enables
- Source-register selection
- Forwarding priority

Verification artifacts are maintained in the `verification/` directory.

---


# Synthesis

The RTL design was synthesized using **Yosys**.

The synthesis flow includes:

- RTL elaboration
- Hierarchy analysis
- Process conversion
- Logic optimization
- Design statistics
- Synthesized netlist generation
- RTL schematic generation

The `forwarding_unit` is selected explicitly as the top-level module during synthesis.

Generated synthesis artifacts are maintained under:

```text
synth/
├── netlists/
├── schematics/
└── scripts/
```

---


# Synthesis Flow

```text
forwarding_unit.v
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
        ▼
Design Statistics
        │
     ┌──┴───┐
     ▼      ▼
  Netlist  Schematic
     │      │
     ▼      ▼
    .v     .svg
```

---


# Concepts Covered

- Verilog HDL
- RTL Design
- RISC-V Architecture
- Five-Stage Pipeline
- Data Hazards
- RAW Dependencies
- Forwarding Networks
- Operand Forwarding
- EX/MEM Pipeline Stage
- MEM/WB Pipeline Stage
- Forwarding Priority
- Register-Write Qualification
- RISC-V Register `x0`
- ALU Operand Selection
- Combinational Control Logic
- Processor Datapath Control
- Functional Verification
- RTL Synthesis
- Yosys
- Synthesized Netlist Generation
- RTL Schematic Analysis

---


# Applications

The forwarding unit can be integrated into:

- RISC-V Processors
- Five-Stage Pipeline CPUs
- FPGA Processor Designs
- Educational CPU Architectures
- Custom Processor Datapaths
- ASIC Processor Designs
- RISC-V SoC Architectures

---


# Tools Used

- Verilog HDL
- Icarus Verilog
- Yosys
- Visual Studio Code
- Ubuntu / WSL
- Git
- GitHub

---


# Learning Outcomes

After completing this project, the following concepts were practiced:

- RAW Hazard Resolution
- Pipeline Data Dependencies
- Forwarding Logic
- EX/MEM Data Forwarding
- MEM/WB Data Forwarding
- Forwarding Priority
- Operand Selection
- Register-Write Qualification
- RISC-V `x0` Handling
- Combinational Processor Control Logic
- RTL Module Design
- Functional Verification
- RTL Synthesis
- Synthesized Netlist Generation
- RTL Schematic Analysis

---


# Relation to Previous Projects

Project 24 established the structural foundation of a **5-stage pipelined processor datapath**.

Project 25 introduced **load-use hazard detection** and pipeline stall/bubble control.

Project 26 introduced **control hazard handling**, including branch flushing and program-counter redirection.

Project 27 adds **data forwarding**, allowing the processor to resolve many RAW dependencies without stalling.

```text
Project 24
5-Stage Pipeline
       │
       ▼
Pipeline Datapath
       │
       ├───────────────────┐
       │                   │
       ▼                   ▼
Project 25            Project 27
Hazard Detection      Forwarding Unit
       │                   │
       ▼                   ▼
Stall / Bubble        Operand Forwarding
       │                   │
       └─────────┬─────────┘
                 ▼
          Pipeline Control
                 │
                 ▼
Project 26 — Branch Control
                 │
                 ▼
       Flush / PC Redirect
```

These projects together form an increasingly complete pipeline-control foundation.

---


# Pipeline Data Hazard Resolution

The forwarding mechanism can be viewed as part of a larger hazard-resolution strategy:

```text
                Pipeline Data Dependency
                         │
                         ▼
                 Is result available?
                    │          │
                   Yes         No
                    │          │
                    ▼          ▼
               Forwarding    Stall
                    │          │
                    ▼          ▼
               Continue      Bubble
```

Forwarding therefore reduces the number of situations in which the processor must insert unnecessary pipeline stalls.

---


# Processor Development Progression

The recent processor projects now form a connected progression:

```text
Pipelined ALU
      │
      ▼
5-Stage Pipeline
      │
      ▼
Hazard Detection
      │
      ▼
Branch Control
      │
      ▼
Forwarding
      │
      ▼
Branch Prediction
      │
      ▼
RISC-V Pipeline Architecture
```

The forwarding unit is an important bridge between basic pipeline control and a more complete RISC-V processor datapath.

---


