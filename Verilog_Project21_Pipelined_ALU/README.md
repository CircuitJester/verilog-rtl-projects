# Project 21 – Pipelined ALU

## Overview

This project implements a modular 32-bit Pipelined Arithmetic Logic Unit (ALU) in Verilog HDL. The design demonstrates how arithmetic and logic operations can be organized into a pipelined execution datapath using dedicated control, execution, flag-generation, and pipeline-register stages.

The architecture separates instruction control from ALU execution and status generation while using pipeline registers to establish a synchronous execution stage.

The project follows a structured RTL development methodology including modular RTL design, dedicated verification, hierarchical integration, Yosys synthesis, synthesized netlist generation, and RTL schematic analysis.



## Features

- 32-bit ALU Execution Unit
- ALU Control Unit
- Arithmetic and Logic Operations
- Processor Status Flag Generation
- Pipeline Register
- Synchronous Pipeline Architecture
- Modular RTL Design
- Top-Level Pipelined ALU Integration
- Dedicated Verification Environment
- System-Level Verification
- Yosys RTL Synthesis
- Synthesized Netlist Generation
- RTL Schematic Generation




## ALU Processing Flow

```text
Instruction / Control
        |
        v
+------------------+
|   ALU Control    |
+--------+---------+
         |
         v
+------------------+
|   ALU Execute    |
+--------+---------+
         |
         +----------------+
         |                |
         v                v
+------------------+  +----------------+
| ALU Pipeline Reg |  |   ALU Flags   |
+--------+---------+  +----------------+
         |
         v
     ALU Result
```



## Pipeline Architecture

```text
             Pipeline Execution Stage
                       |
                       v
              +----------------+
              |  ALU Control   |
              +-------+--------+
                      |
                      v
              +----------------+
              |  ALU Execute   |
              +-------+--------+
                      |
                +-----+-----+
                |           |
                v           v
        +-------------+  +-------------+
        |   Pipeline  |  |    Flags    |
        |   Register  |  |   Generator |
        +------+------+  +-------------+
               |
               v
          Registered
          ALU Result
```



## ALU Operations

The execution unit supports the arithmetic and logical operations defined by the RTL control logic.

Typical operation classes include:

- Addition
- Subtraction
- Bitwise AND
- Bitwise OR
- Bitwise XOR
- Comparison / relational operations
- Logical operations

The exact operation encoding is defined by the ALU control module.



## Verification

The RTL modules are accompanied by dedicated Verilog testbenches.

The verification environment covers:

- ALU Control Operation
- Arithmetic Operations
- Logic Operations
- ALU Result Generation
- Status Flag Generation
- Pipeline Register Operation
- Clocked Pipeline Behavior
- Top-Level Pipelined ALU Integration



## Synthesis

The RTL design was synthesized using Yosys.

The synthesis workflow includes:

- RTL elaboration
- Hierarchy analysis
- Process conversion
- Logic optimization
- Design statistics
- Synthesized netlist generation
- RTL schematic generation



## Project Structure

```text
Verilog_Project21_Pipelined_ALU/
│
├── build/
│
├── RTL/
│   ├── alu_control.v
│   ├── alu_execute.v
│   ├── alu_flags.v
│   ├── alu_pipeline_register.v
│   └── pipelined_alu_top.v
│
├── tb/
│   ├── tb_alu_control.v
│   ├── tb_alu_execute.v
│   ├── tb_alu_flags.v
│   ├── tb_alu_pipeline_register.v
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


## Learning Outcomes

During this project I learned:

- Pipelined ALU architecture
- 32-bit arithmetic and logic datapath design
- ALU operation control
- Arithmetic and logical execution
- Processor flag generation
- Pipeline register design
- Synchronous datapath architecture
- Modular RTL design
- Hierarchical hardware integration
- Dedicated RTL verification
- Yosys synthesis
- Synthesized netlist generation
- RTL schematic analysis