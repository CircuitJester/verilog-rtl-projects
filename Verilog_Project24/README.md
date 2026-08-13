# Project 24 — 5-Stage Pipelined ALU

## Overview

This project implements a modular **32-bit 5-stage pipelined ALU datapath** in Verilog HDL.

The design demonstrates how processor instruction execution can be divided into multiple clocked stages using dedicated pipeline registers to transfer data and control information between stages.

The architecture includes pipeline registers for the major processor stages, a pipeline control unit, and a top-level pipelined datapath.

The project focuses on understanding pipeline organization, control-signal propagation, pipeline stalls, pipeline flushing, and hierarchical RTL integration.

The RTL is also synthesized using **Yosys**, with module-level and top-level synthesized netlists and RTL schematics generated as part of the hardware design workflow.

---


# Architecture

The processor datapath is organized around the conventional five-stage pipeline:

```text
        ┌──────────────┐
        │ Instruction  │
        │    Fetch     │
        └──────┬───────┘
               │
               ▼
        ┌──────────────┐
        │    IF/ID     │
        │   Register   │
        └──────┬───────┘
               │
               ▼
        ┌──────────────┐
        │   Decode /   │
        │ Register Read│
        └──────┬───────┘
               │
               ▼
        ┌──────────────┐
        │    ID/EX     │
        │   Register   │
        └──────┬───────┘
               │
               ▼
        ┌──────────────┐
        │   Execute /  │
        │      ALU     │
        └──────┬───────┘
               │
               ▼
        ┌──────────────┐
        │    EX/MEM    │
        │   Register   │
        └──────┬───────┘
               │
               ▼
        ┌──────────────┐
        │    Memory    │
        │    Stage     │
        └──────┬───────┘
               │
               ▼
        ┌──────────────┐
        │    MEM/WB    │
        │   Register   │
        └──────┬───────┘
               │
               ▼
        ┌──────────────┐
        │  Write Back  │
        └──────────────┘
```

---


# Pipeline Stages

## Instruction Fetch

The first stage represents instruction fetching and transfers instruction-related information into the IF/ID pipeline register.

---


## Instruction Decode

The decode stage represents instruction decoding and register-read operations.

Control and data information are transferred into the ID/EX pipeline register before entering the execution stage.

---


## Execute

The execute stage represents the ALU processing stage.

Arithmetic and logical operations are performed using the control information and operands propagated through the pipeline.

---


## Memory

The memory stage represents the portion of the datapath where memory-related operations would be handled.

The EX/MEM pipeline register separates the execution stage from the memory stage.

---


## Write Back

The final stage represents the write-back portion of the processor pipeline.

The MEM/WB pipeline register transfers the required information toward the final write-back stage.

---


# Pipeline Registers

The design uses dedicated registers between major pipeline stages.


## IF/ID Pipeline Register

Transfers instruction-fetch information into the instruction-decode stage.

```text
IF Stage
   │
   ▼
IF/ID Register
   │
   ▼
ID Stage
```

---


## ID/EX Pipeline Register

Transfers decoded data and control information into the execution stage.

```text
ID Stage
   │
   ▼
ID/EX Register
   │
   ▼
EX Stage
```

---


## EX/MEM Pipeline Register

Transfers execution results and associated control information toward the memory stage.

```text
EX Stage
   │
   ▼
EX/MEM Register
   │
   ▼
MEM Stage
```

---


## MEM/WB Pipeline Register

Transfers memory-stage information toward the final write-back stage.

```text
MEM Stage
   │
   ▼
MEM/WB Register
   │
   ▼
WB Stage
```

---



# Pipeline Control

The `pipeline_control_unit` manages control information associated with pipeline operation.

The control architecture provides the foundation for handling conditions such as:

- Pipeline stalls
- Pipeline flushing
- Pipeline control propagation
- Clocked pipeline operation

The control unit works with the pipeline registers to maintain controlled movement of data and control information through the processor datapath.

---



# Project Structure

```text
Verilog_Project24/
│
├── build/
│
├── RTL/
│   ├── ex_mem_pipeline_register.v
│   ├── id_ex_pipeline_register.v
│   ├── if_id_pipeline_register.v
│   ├── mem_wb_pipeline_register.v
│   ├── pipeline_control_unit.v
│   └── pipelined_alu_top.v
│
├── tb/
│   ├── tb_ex_mem_pipeline_register.v
│   ├── tb_id_ex_pipeline_register.v
│   ├── tb_if_id_pipeline_register.v
│   ├── tb_mem_wb_pipeline_register.v
│   ├── tb_pipeline_control_unit.v
│   └── tb_pipelined_alu_top.v
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

- 32-bit Pipelined ALU Datapath
- Five-Stage Pipeline Architecture
- IF/ID Pipeline Register
- ID/EX Pipeline Register
- EX/MEM Pipeline Register
- MEM/WB Pipeline Register
- Pipeline Control Unit
- Control Signal Propagation
- Pipeline Stall Support
- Pipeline Flush Support
- Clocked RTL Architecture
- Modular Hardware Design
- Hierarchical RTL Integration
- Dedicated Module Verification
- Top-Level Functional Verification
- Yosys RTL Synthesis
- Synthesized Netlist Generation
- RTL Schematic Generation

---


# Pipeline Data Flow

```text
        Instruction
             │
             ▼
        ┌─────────┐
        │   IF    │
        └────┬────┘
             │
             ▼
        ┌─────────┐
        │ IF / ID │
        └────┬────┘
             │
             ▼
        ┌─────────┐
        │   ID    │
        └────┬────┘
             │
             ▼
        ┌─────────┐
        │ ID / EX │
        └────┬────┘
             │
             ▼
        ┌─────────┐
        │   EX    │
        │   ALU   │
        └────┬────┘
             │
             ▼
        ┌─────────┐
        │ EX / MEM│
        └────┬────┘
             │
             ▼
        ┌─────────┐
        │   MEM   │
        └────┬────┘
             │
             ▼
        ┌─────────┐
        │ MEM / WB│
        └────┬────┘
             │
             ▼
        ┌─────────┐
        │   WB    │
        └─────────┘
```

---


# Verification

Each major pipeline module is accompanied by a dedicated Verilog testbench.

Verification covers:

- IF/ID Pipeline Register
- ID/EX Pipeline Register
- EX/MEM Pipeline Register
- MEM/WB Pipeline Register
- Pipeline Control Unit
- Pipeline Control Behavior
- Stall Handling
- Flush Handling
- Top-Level Pipelined ALU Integration


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

Each major pipeline module was synthesized independently, followed by synthesis of the complete `pipelined_alu_top` design.

The top-level synthesis explicitly selects `pipelined_alu_top` as the hierarchy root to generate the complete pipeline datapath representation.

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
Synthesized       RTL Schematic
Netlist
     │               │
     ▼               ▼
   .v files        .svg files
```

---



# Concepts Covered

- Verilog HDL
- RTL Design
- Processor Datapath
- Five-Stage Pipeline
- Pipeline Registers
- Pipeline Control
- Clocked RTL Design
- Control Signal Propagation
- Pipeline Stalls
- Pipeline Flushing
- ALU Execution Stage
- Datapath and Control Separation
- Hierarchical Hardware Design
- Functional Verification
- RTL Synthesis
- Yosys
- Synthesized Netlist Generation
- RTL Schematic Analysis

---


# Applications

The 5-stage pipelined ALU architecture provides a foundation for:

- RISC-V Processor Designs
- MIPS Processor Designs
- FPGA CPU Architectures
- Educational Processor Implementations
- Custom Processor Datapaths
- ASIC Processor Designs
- SoC Processor Subsystems

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

- Five-Stage Processor Pipeline
- Pipeline Register Design
- Datapath Organization
- ALU Execution Stage
- Control Signal Propagation
- Pipeline Stall Mechanisms
- Pipeline Flush Mechanisms
- Clocked RTL Design
- Datapath and Control Separation
- Hierarchical RTL Development
- System Integration
- Hardware Verification
- RTL Synthesis
- Synthesized Netlist Generation
- RTL Schematic Analysis

---
