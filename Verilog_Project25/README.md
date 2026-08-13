# Project 25 — Hazard Detection Unit

## Overview

This project implements a modular **Hazard Detection Unit** for a 5-stage pipelined processor using Verilog HDL.

The design detects **load-use data hazards** between an instruction currently progressing through the EX stage and the instruction waiting in the ID stage.

In a pipelined processor, a load instruction does not produce its memory data immediately. If the following instruction attempts to use the destination register of that load, allowing it to continue into the execution stage can result in incorrect data being used.

The Hazard Detection Unit identifies this dependency and generates pipeline control signals that temporarily hold the program counter and IF/ID pipeline register while flushing the ID/EX control path to insert a pipeline bubble.

This project builds directly on the 5-stage pipelined datapath developed in **Project 24** and introduces a dedicated mechanism for controlling load-use hazards.

The RTL design is also synthesized using **Yosys**, with a synthesized netlist and RTL schematic generated for the complete Hazard Detection Unit.

---


# Objective

The primary objective is to detect load-use dependencies and generate the control signals required to safely stall the processor pipeline.

The unit monitors:

- Destination register of the instruction in the EX stage
- Memory-read status of the EX-stage instruction
- Source register 1 of the instruction in the ID stage
- Source register 2 of the instruction in the ID stage

When a dependency is detected, the pipeline is temporarily controlled to allow the required data to become available.

---


# Architecture

```text
        Instruction in EX Stage
                 │
        ┌────────┴────────┐
        │                 │
   id_ex_mem_read     id_ex_rd
        │                 │
        └────────┬────────┘
                 │
                 │ Compare with
                 │ ID source registers
                 ▼
        ┌───────────────────────┐
        │ Hazard Detection Unit │
        │                       │
        │ Compare rd with       │
        │ rs1 and rs2           │
        └───────────┬───────────┘
                    │
          ┌─────────┼─────────┐
          │         │         │
          ▼         ▼         ▼
      PC Write   IF/ID      ID/EX
       Control   Write      Flush
          │         │         │
          ▼         ▼         ▼
        Hold      Hold      Bubble
```

---


# Load-Use Hazard

Consider the following instruction sequence:

```text
LW  x10, 0(x5)
ADD x12, x10, x7
```

The `ADD` instruction depends on the result produced by the preceding `LW` instruction.

At the point where the `ADD` instruction reaches the ID stage, the load result is not yet available for normal execution.

The Hazard Detection Unit therefore generates a stall condition.

```text
        LW
        │
        ▼
      EX Stage
        │
        │ Pending load result
        ▼
  Hazard Detection
        │
        ▼
     Stall Pipeline
        │
   ┌────┼────┐
   ▼    ▼    ▼
   PC   IF/ID ID/EX
  Hold  Hold  Flush
```

The ID/EX flush effectively inserts a bubble into the execution path.

---


# Hazard Detection Logic

The load-use hazard condition is:

```text
id_ex_mem_read &&
id_ex_rd != 0 &&
(
    id_ex_rd == if_id_rs1 ||
    id_ex_rd == if_id_rs2
)
```

When this condition is true, the unit generates:

```text
pc_write    = 0
if_id_write = 0
id_ex_flush = 1
```

Otherwise:

```text
pc_write    = 1
if_id_write = 1
id_ex_flush = 0
```

The destination register is compared against both source registers of the instruction waiting in the ID stage.

Register zero is excluded from the comparison so that dependencies involving the architectural zero register do not generate a false hazard.

---

# Pipeline Control Response

When a load-use hazard is detected:

```text
PC Write Enable      = 0
IF/ID Write Enable   = 0
ID/EX Flush          = 1
```

This produces the following behavior:

```text
PC
 │
 ├── Hold
 │
 ▼
IF/ID
 │
 ├── Hold
 │
 ▼
ID/EX
 │
 ├── Flush
 │
 ▼
Bubble
```

The processor therefore prevents the dependent instruction from advancing into the execution stage until the hazard has been resolved.

---


# Project Structure

```text
Verilog_Project25/
│
├── build/
│
├── RTL/
│   └── hazard_detection_unit.v
│
├── tb/
│   └── tb_hazard_detection_unit.v
│
├── verification/
│
├── synth/
│   ├── netlists/
│   ├── schematics/
│   └── scripts/
│
├── verilogcode/
│   └── hazard_detection_unit.v
│
├── waves/
│
├── README.md
└── command.md
```

---


# Module

## Hazard Detection Unit

The `hazard_detection_unit` is the top-level RTL module responsible for detecting load-use dependencies and generating pipeline control signals.

The module compares the destination register of the pending load instruction against the source registers of the instruction currently in the ID stage.

Its primary control outputs are:

- `pc_write`
- `if_id_write`
- `id_ex_flush`

These signals control whether the pipeline continues normally or enters a temporary stall condition.

---


# Features

- Load-Use Hazard Detection
- RAW Dependency Detection
- Source Register Comparison
- Destination Register Comparison
- PC Hold Control
- IF/ID Pipeline Register Hold
- ID/EX Pipeline Flush
- Pipeline Bubble Generation
- Register Zero Protection
- Combinational Hazard Control Logic
- Modular RTL Design
- Dedicated Functional Verification
- Top-Level Verification
- Yosys RTL Synthesis
- Synthesized Netlist Generation
- RTL Schematic Generation

---


# Verification

A dedicated Verilog testbench is provided for the Hazard Detection Unit.

Verification covers:

- No memory-read instruction
- Load-use hazard through `rs1`
- Load-use hazard through `rs2`
- No dependency between source and destination registers
- Destination register equal to zero
- Both source registers depending on the pending load
- Dependency-free instruction following a load

The testbench uses a reusable transaction task to apply different register dependency combinations without duplicating large sections of stimulus code.


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

Since Project 25 contains a single RTL module, the `hazard_detection_unit` is synthesized directly as the top-level design.



# Synthesis Flow

```text
hazard_detection_unit.v
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
      ┌───┴────┐
      ▼        ▼
  Netlist    Schematic
      │        │
      ▼        ▼
     .v       .svg
```

---



# Concepts Covered

- Verilog HDL
- RTL Design
- Processor Microarchitecture
- Five-Stage Pipeline
- Data Hazards
- Load-Use Hazards
- RAW Dependency Detection
- Register Comparison
- Pipeline Stall Control
- Pipeline Bubble Generation
- PC Hold Logic
- IF/ID Register Control
- ID/EX Pipeline Flushing
- Control Path Design
- Combinational RTL Logic
- Hierarchical Processor Design
- Functional Verification
- RTL Synthesis
- Yosys
- Synthesized Netlist Generation
- RTL Schematic Analysis

---



# Applications

The Hazard Detection Unit can be integrated into:

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

- Load-Use Hazard Detection
- Pipeline Stall Mechanisms
- RAW Dependency Analysis
- Register Dependency Checking
- Pipeline Bubble Generation
- PC Hold Control
- IF/ID Pipeline Register Control
- ID/EX Pipeline Flushing
- Special Handling of Register Zero
- Datapath and Control Interaction
- Combinational RTL Control Logic
- Functional Verification
- RTL Synthesis
- Synthesized Netlist Generation
- RTL Schematic Analysis

---



# Relation to Previous Projects

Project 24 introduced the structural foundation of a **5-stage pipelined ALU datapath** with dedicated pipeline registers connecting the major stages.

Project 25 adds the first dedicated hazard-control mechanism to that pipeline.

```text
Project 24
5-Stage Pipeline
       │
       ▼
Pipeline Registers
       │
       ▼
Project 25
Hazard Detection
       │
       ▼
Stall / Bubble Control
```

The combination of these projects moves the processor architecture closer to a realistic pipelined CPU by introducing control logic capable of responding to data dependencies.

---


# Key Takeaway

A pipelined processor cannot always allow every instruction to advance on every clock cycle.

When a load instruction produces data that the following instruction immediately requires, the processor must temporarily control the pipeline to prevent incorrect execution.

This provides a fundamental mechanism for safe pipeline execution and establishes the foundation for more advanced processor hazard-management techniques.