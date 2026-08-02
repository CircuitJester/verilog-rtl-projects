# Project 17 – SPI Master Controller (Modular IP Design)

## Overview

This project implemented a modular SPI (Serial Peripheral Interface) Master Controller in Verilog HDL.

Unlike a basic SPI implementation where all functionality is placed inside a single module, this project follows a professional RTL design methodology by dividing the controller into reusable hardware IP blocks. Each block is independently designed, verified, and integrated into the final SPI Master.

The design demonstrates hierarchical RTL development, modular verification, and system-level integration commonly used in FPGA and ASIC projects.


## Features

- Parameterized SPI Clock Divider
- 8-bit Full-Duplex Data Transfer
- Independent SPI Shift Register
- Dedicated SPI Master FSM
- Active-Low Chip Select Controller
- Modular Top-Level Integration
- Individual Testbenches for Every Module
- Complete System-Level Verification
- Timing Analysis


## Modules

### 1. SPI Clock Divider

Generates the SPI serial clock from the system clock.


### 2. SPI Shift Register

Responsible for:

- Parallel-to-Serial Conversion
- Serial-to-Parallel Conversion
- Bit Counter
- Shift Completion Detection


### 3. SPI Master FSM

Controls the SPI transaction sequence.

State Flow:

```
IDLE

↓

LOAD

↓

TRANSFER

↓

COMPLETE

↓

IDLE
```



### 4. SPI Chip Select Controller

Generates the active-low Chip Select signal (`CS_n`) for the selected SPI slave.


### 5. SPI Master Top

Integrates all submodules into one reusable SPI Master IP.


## Verification

Each module has been verified individually.

- Clock Divider Testbench
- Shift Register Testbench
- FSM Testbench
- Chip Select Testbench
- Top-Level System Testbench


## Skills Demonstrated

- Verilog HDL
- RTL Design
- FSM Design
- Shift Register Design
- Clock Division
- Modular IP Development
- Hierarchical Design
- Testbench Development
- Functional Verification


## Future Improvements

- SPI Modes (CPOL/CPHA)
- Variable Data Width
- Configurable Clock Frequency
- Multiple Chip Select Outputs
- FIFO Support
- Interrupt Generation
- DMA Interface
- AXI/APB Wrapper


## Learning Outcomes

This project focuses on professional RTL architecture rather than only implementing the SPI protocol.

Key concepts learned:

- Control Path vs Data Path
- Hierarchical Module Design
- Modular Verification
- Reusable Hardware IP Development
- System-Level Integration
