# Project 20 – DMA Controller

## Overview

This project implements a modular Direct Memory Access (DMA) Controller in Verilog HDL. The design demonstrates how dedicated hardware can autonomously control memory-to-memory data transfers without requiring continuous processor intervention.

The DMA architecture is divided into independent RTL modules for control-register handling, source and destination address generation, transfer counting, and transaction sequencing. These modules are integrated through a top-level DMA controller.

The project follows a structured RTL development methodology including modular RTL design, dedicated verification, hierarchical integration, Yosys synthesis, synthesized netlist generation, and RTL schematic analysis.



## Features

- DMA Control Register
- DMA Address Generator
- DMA Transfer Counter
- DMA Controller FSM
- Top-Level DMA Integration
- Memory-to-Memory Transfer Control
- Source and Destination Address Management
- Transfer Length Tracking
- DMA Start and Completion Control
- Modular RTL Architecture
- Dedicated Verification Environment
- System-Level Verification
- Yosys RTL Synthesis
- Synthesized Netlist Generation
- RTL Schematic Generation



## DMA Transfer Flow

```text
DMA Start
    |
    v
Control Register
    |
    v
Controller FSM
    |
    +-------------------+
    |                   |
    v                   v
Source Address     Destination Address
    |                   |
    +---------+---------+
              |
              v
        Data Transfer
              |
              v
       Transfer Counter
              |
        +-----+-----+
        |           |
     More Data    Complete
        |           |
        |           v
        +------> DMA Done
```



## DMA Architecture

```text
                  +----------------------+
                  |   DMA Control Reg    |
                  +----------+-----------+
                             |
                             v
                  +----------------------+
                  |   DMA Controller FSM |
                  +----+------------+----+
                       |            |
                       v            v
             +-------------+  +-------------+
             |   Address   |  |   Transfer  |
             |  Generator  |  |   Counter   |
             +------+------+  +------+------+
                    |                |
                    +-------+--------+
                            |
                            v
                     DMA Transfer
                            |
                            v
                       DMA Done
```


## Verification

The RTL modules are accompanied by dedicated Verilog testbenches.

The verification environment covers:

- DMA Control Register Operation
- Source Address Generation
- Destination Address Generation
- Transfer Counter Operation
- DMA Controller FSM
- Start and Completion Handling
- Transfer Sequencing
- Top-Level DMA Integration



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

Each major RTL module was synthesized independently, followed by synthesis of the complete `dma_top` design.

The synthesis flow explicitly selects the intended top-level module before schematic generation to ensure that the generated schematic represents the correct DMA hierarchy.



## Project Structure

```text
Verilog_Project20/
│
├── build/
│
├── RTL/
│   ├── dma_address_generator.v
│   ├── dma_control_register.v
│   ├── dma_controller_fsm.v
│   ├── dma_top.v
│   └── dma_transfer_counter.v
│
├── tb/
│   ├── tb_dma_address_generator.v
│   ├── tb_dma_control_register.v
│   ├── tb_dma_controller_fsm.v
│   ├── tb_dma_top.v
│   └── tb_dma_transfer_counter.v
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

- DMA controller architecture
- Autonomous hardware data transfer
- DMA control-register design
- Source and destination address generation
- Transfer-count management
- FSM-based transaction sequencing
- Modular RTL design
- Hierarchical hardware integration
- Dedicated RTL verification
- Yosys synthesis
- Synthesized netlist generation
- RTL schematic analysis