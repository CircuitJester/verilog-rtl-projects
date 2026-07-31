# Project 15 – SDRAM Controller

## Overview

This project implements a simplified SDRAM (Synchronous Dynamic Random Access Memory) Controller in Verilog. The controller demonstrates the fundamental architecture of SDRAM control logic, including initialization, timing generation, refresh management, read/write sequencing, command generation, and top-level integration.
This project is for learning RTL design, finite state machines (FSMs), timing control, and hierarchical hardware design.


## Features

- SDRAM Initialization Sequence
- Timing Generator
- SDRAM Command Generator
- Automatic Refresh Controller
- Read Controller
- Write Controller
- Main Control FSM
- Top-Level Integration
- Individual Testbenches
- System-Level Verification


## Modules

### 1. SDRAM Timing Generator

Generates programmable timing delays used by all SDRAM operations.


### 2. SDRAM Initialization FSM

Implements the SDRAM power-up initialization sequence.


### 3. SDRAM Command Generator

Generates SDRAM command signals:

- ACTIVE
- READ
- WRITE
- PRECHARGE
- REFRESH
- LOAD MODE REGISTER


### 4. SDRAM Refresh Controller

Generates periodic refresh requests to preserve memory contents.


### 5. SDRAM Read Controller

Implements:

- ACTIVATE
- Wait tRCD
- READ
- DONE


### 6. SDRAM Write Controller

Implements:

- ACTIVATE
- Wait tRCD
- WRITE
- DONE


### 7. SDRAM Main FSM

Coordinates every subsystem.

Priority:

```
Refresh

↓

Read

↓

Write
```


### 8. SDRAM Top Module

Integrates all modules into one controller.


## Skills Demonstrated

- RTL Design
- Finite State Machines
- Timing Control
- SDRAM Protocol Basics
- Modular Hardware Design
- Hierarchical Design
- System Integration
- Functional Verification
- Testbench Development


## Learning Outcome

This project demonstrates the architecture of a simplified SDRAM controller and serves as a foundation for building industrial memory controllers used in FPGA and ASIC designs.