# Project 10 – AXI4-Lite Master IP

## Overview

This project implements a complete **AXI4-Lite Master IP Core** in Verilog HDL. The design demonstrates how an AXI master initiates and controls read and write transactions using the AXI4-Lite protocol. The implementation is modular, with each protocol channel designed, verified, and integrated independently before building the complete system.
The project follows an industry-style RTL design methodology consisting of modular development, finite state machine control, protocol verification, and system-level integration.


## Features

- AXI4-Lite Write Address Channel
- AXI4-Lite Write Data Channel
- AXI4-Lite Write Response Channel
- AXI4-Lite Read Address Channel
- AXI4-Lite Read Data Channel
- Master Transaction Finite State Machine
- Top-Level AXI Master Integration
- Complete System-Level Verification
- Simulation Support

## Implemented Modules

### Write Address Channel

- Generates AWADDR
- Generates AWVALID
- Waits for AWREADY handshake

### Write Data Channel

- Generates WDATA
- Generates WVALID
- Waits for WREADY handshake

### Write Response Channel

- Receives BRESP
- Waits for BVALID
- Generates BREADY

### Read Address Channel

- Generates ARADDR
- Generates ARVALID
- Waits for ARREADY handshake

### Read Data Channel

- Receives RDATA
- Waits for RVALID
- Generates RREADY

## Verification

Each RTL module was verified independently using dedicated Verilog testbenches.
Final verification was performed using a complete AXI Master Top-Level simulation.

## Learning Outcomes

- AXI4-Lite protocol fundamentals
- Ready/Valid handshake mechanism
- Modular RTL design
- Finite State Machine implementation
- Hierarchical module integration
- RTL verification methodology
- System-level verification

