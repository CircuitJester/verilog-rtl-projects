# DMA Controller (Direct Memory Access)

A modular DMA (Direct Memory Access) Controller implemented in Verilog HDL. The design demonstrates how a hardware engine autonomously transfers data by coordinating address generation, transfer counting, and finite state machine (FSM) control without continuous CPU intervention.


## Project Overview

The DMA Controller is a fundamental building block of modern microcontrollers, processors, and SoCs. Instead of requiring the CPU to move every data word individually, the DMA engine performs block transfers autonomously after receiving an initial configuration from software.

This project implements a simplified memory-to-memory DMA architecture using a modular RTL design approach.


## Features

- Modular RTL architecture
- Memory-to-Memory DMA operation
- CPU-controlled DMA start
- Automatic source address generation
- Automatic destination address generation
- Configurable transfer length
- Transfer counter with completion detection
- FSM-based DMA control
- Busy and Done status generation
- Complete RTL simulation and verification


## Project Architecture

```
                 CPU
                  │
          Configuration
                  │
                  ▼
      +----------------------+
      | DMA Control Register |
      +----------------------+
                  │
                  ▼
      +----------------------+
      | DMA Controller FSM   |
      +----------------------+
        │      │       │
        ▼      ▼       ▼
 Address Generator  Transfer Counter
        │              │
        └──────┬───────┘
               ▼
          DMA Completion
```



## Modules

### DMA Control Register

- Captures CPU start command
- Generates Busy status
- Generates Done status


### DMA Address Generator

- Loads initial source address
- Loads initial destination address
- Automatically increments addresses after each transfer


### DMA Transfer Counter

- Loads transfer length
- Counts remaining transfers
- Generates Transfer Complete signal


### DMA Controller FSM

Implements the complete DMA control sequence.

States:

- IDLE
- LOAD
- READ
- WRITE
- UPDATE
- DONE


### DMA Top

Integrates every DMA module into one reusable IP core.


## Verification

Every module was verified independently before complete system integration.

Verification includes:

- Individual RTL verification
- Module-level testbenches
- Top-level testbench
- Functional simulation
- verification


## Concepts Covered

- Verilog HDL
- RTL Design
- Hierarchical Design
- Finite State Machines (FSM)
- Control Path & Data Path Separation
- DMA Architecture
- Address Generation
- Transfer Counter Design
- Hardware Control Logic
- Parameterized RTL
- Hardware Verification


## Learning Outcomes

Through this project, the following concepts were explored:

- DMA controller architecture
- Hardware state machine design
- Autonomous hardware operation
- Memory address generation
- Transfer management
- Modular RTL development
- System-level integration
- Hardware verification workflow



## Future Improvements

Possible enhancements include:

- Burst transfer support
- Memory-to-Peripheral DMA
- Peripheral-to-Memory DMA
- Circular Buffer Mode
- Scatter-Gather DMA
- Multi-Channel DMA
- AXI/AHB Bus Interface
- Interrupt Generation
- Priority Arbitration


