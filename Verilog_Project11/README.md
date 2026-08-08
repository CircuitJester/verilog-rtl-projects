# Project 11 – AXI4-Lite Slave IP Core

## Overview

This project implements a complete **AXI4-Lite Slave Interface** in Verilog HDL.

The design follows a modular RTL architecture where each AXI channel and supporting hardware block is implemented as an independent RTL module and verified using dedicated testbenches before being integrated into the complete AXI4-Lite Slave.

The project demonstrates memory-mapped register design, AXI Ready/Valid handshaking, address decoding, read/write transaction handling, finite state machine control, and hierarchical RTL integration.

The implementation follows a professional digital design workflow consisting of modular RTL development, functional simulation, GTKWave verification, top-level integration, and Yosys-based RTL synthesis.

## Features

- AXI4-Lite Write Address Channel
- AXI4-Lite Write Data Channel
- AXI4-Lite Write Response Channel
- AXI4-Lite Read Address Channel
- AXI4-Lite Read Data Channel
- 32-bit Memory-Mapped Register File
- Address Decoding
- AXI Slave Controller FSM
- Ready/Valid Handshake Logic
- Modular RTL Architecture
- Hierarchical Top-Level Integration
- Dedicated Module Testbenches
- Functional Simulation
- GTKWave Verification
- Yosys RTL Synthesis
- Synthesized Netlist Generation
- RTL Schematic Generation

## Implemented Modules

### AXI Register File

Implements the memory-mapped storage used by the AXI4-Lite Slave.

Responsibilities:

- Stores configuration and data registers
- Supports register read operations
- Supports register write operations
- Performs address-based register selection
- Provides the internal register interface to the AXI controller

### AXI Slave Read Address Channel

Handles the AXI read-address phase.

Responsibilities:

- Receives `ARADDR`
- Monitors `ARVALID`
- Generates `ARREADY`
- Performs the Ready/Valid handshake
- Transfers the requested read address to the slave logic

### AXI Slave Read Data Channel

Handles the AXI read-data response.

Responsibilities:

- Provides `RDATA`
- Generates `RVALID`
- Monitors `RREADY`
- Generates the read response
- Completes the read transaction

### AXI Slave Write Address Channel

Handles the AXI write-address phase.

Responsibilities:

- Receives `AWADDR`
- Monitors `AWVALID`
- Generates `AWREADY`
- Performs the Ready/Valid handshake
- Transfers the write address to the slave logic

### AXI Slave Write Data Channel

Handles the AXI write-data phase.

Responsibilities:

- Receives `WDATA`
- Receives write strobes where applicable
- Monitors `WVALID`
- Generates `WREADY`
- Transfers write data to the register interface

### AXI Slave Write Response Channel

Handles the response generated after a successful write.

Responsibilities:

- Generates `BVALID`
- Provides `BRESP`
- Monitors `BREADY`
- Completes the write response transaction

### AXI Slave Controller

Implements the main FSM responsible for coordinating AXI transactions.

Responsibilities:

- Controls read transactions
- Controls write transactions
- Coordinates AXI channel handshakes
- Controls register-file access
- Generates transaction control signals
- Manages transaction state transitions

### AXI Slave Top

Top-level integration module.

The module integrates:

- Register File
- Read Address Channel
- Read Data Channel
- Write Address Channel
- Write Data Channel
- Write Response Channel
- AXI Slave Controller

The result is a complete reusable AXI4-Lite Slave IP core.

## AXI Write Flow

```text
                 AXI WRITE TRANSACTION

                     Write Address
                          │
                          ▼
                AXI Write Address
                     Channel
                          │
                          ▼
                     Write Data
                          │
                          ▼
                AXI Write Data
                     Channel
                          │
                          ▼
                  Register File
                          │
                          ▼
                  Write Response
                          │
                          ▼
                AXI Write Response
                     Channel