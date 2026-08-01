# Project 16 – Multi-Port SDRAM Arbiter

## Overview

This project implements a simplified Multi-Port SDRAM Arbiter in Verilog. The design demonstrates how multiple bus masters can safely share a single SDRAM interface using arbitration, request buffering, finite state machines(FSM), and bus multiplexing.
The project is modular which helps us making each hardware block independently testable before integrating them into a complete system.


## Objectives

- Understand multi-master bus arbitration.
- Implement fair scheduling using Round Robin arbitration.
- Buffer incoming requests using a FIFO.
- Route selected master signals using a bus multiplexer.
- Control the arbitration sequence using an FSM.
- Integrate all modules into a complete SDRAM arbiter.


## Modules

### 1. Priority Encoder
Determines the highest-priority requester.

### 2. Round Robin Arbiter
Provides fair access by rotating priority after every successful transaction.

### 3. Request FIFO
Buffers pending requests to prevent data loss during busy memory periods.

### 4. Bus Multiplexer
Routes the selected master's address and data to the SDRAM interface.

### 5. Arbiter FSM
Controls the complete arbitration process through sequential states.

### 6. Multi-Port SDRAM Top
Integrates all individual modules into a complete subsystem.


## Verification

Each module was verified independently using dedicated Verilog testbenches.

Verified modules include:

- Priority Encoder
- Round Robin Arbiter
- Request FIFO
- Bus Multiplexer
- Arbiter FSM
- Complete Multi-Port SDRAM Arbiter


## Key Concepts

- Multi-Master Arbitration
- Round Robin Scheduling
- FIFO Buffer Design
- Bus Multiplexing
- Finite State Machines (FSM)
- Modular RTL Design
- System-Level Integration
- Digital System Verification


## Learning Outcomes

This project provided practical experience with:

- Designing modular RTL blocks
- Implementing fair bus arbitration
- FIFO-based request buffering
- FSM-based hardware control
- Hierarchical module integration
- Testbench development
- Waveform debugging
- FPGA/ASIC RTL verification workflows


