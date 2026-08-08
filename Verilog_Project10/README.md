# Project 10 – AXI4-Lite Master IP

## Overview

This project implements a complete **AXI4-Lite Master IP Core** in Verilog HDL. The design demonstrates how an AXI master initiates, controls, and completes read and write transactions using the AXI4-Lite protocol.

The implementation follows a modular RTL architecture where each AXI channel is developed and verified independently before being integrated into a complete AXI4-Lite Master.

The project follows a professional RTL design methodology consisting of modular hardware development, Ready/Valid handshake implementation, finite state machine control, functional verification, system-level integration, and RTL synthesis using Yosys.

## Features

- AXI4-Lite Write Address Channel
- AXI4-Lite Write Data Channel
- AXI4-Lite Write Response Channel
- AXI4-Lite Read Address Channel
- AXI4-Lite Read Data Channel
- Ready/Valid Handshake Logic
- Master Transaction FSM
- Parameterized RTL Architecture
- Modular Channel-Based Design
- Top-Level AXI Master Integration
- Dedicated Module Testbenches
- Complete System-Level Verification
- GTKWave Simulation Analysis
- Yosys RTL Synthesis
- Synthesized Netlist Generation
- RTL Schematic Generation

## Implemented Modules

### AXI Write Address Channel

The write address channel manages the AXI4-Lite address phase of a write transaction.

Responsibilities:

- Generates `AWADDR`
- Generates `AWVALID`
- Monitors `AWREADY`
- Performs the `AWVALID && AWREADY` handshake
- Completes the write address transfer

### AXI Write Data Channel

The write data channel transfers the actual data associated with a write transaction.

Responsibilities:

- Generates `WDATA`
- Generates `WSTRB` where applicable
- Generates `WVALID`
- Monitors `WREADY`
- Performs the `WVALID && WREADY` handshake

### AXI Write Response Channel

The write response channel receives the completion response from the AXI slave.

Responsibilities:

- Monitors `BVALID`
- Receives `BRESP`
- Generates `BREADY`
- Detects completion of the write transaction
- Handles the AXI response phase

### AXI Read Address Channel

The read address channel initiates an AXI4-Lite read transaction.

Responsibilities:

- Generates `ARADDR`
- Generates `ARVALID`
- Monitors `ARREADY`
- Performs the `ARVALID && ARREADY` handshake
- Completes the read address transfer

### AXI Read Data Channel

The read data channel receives data returned by the AXI slave.

Responsibilities:

- Monitors `RVALID`
- Receives `RDATA`
- Receives `RRESP`
- Generates `RREADY`
- Completes the read transaction

### AXI Master FSM

The transaction FSM coordinates the overall AXI4-Lite master operation.

It controls:

- Write transaction sequencing
- Read transaction sequencing
- Channel activation
- Handshake progression
- Transaction completion
- Control-state transitions

### AXI Master Top

The top-level module integrates all AXI4-Lite components into a single reusable master IP block.

It connects:

- AXI write address channel
- AXI write data channel
- AXI write response channel
- AXI read address channel
- AXI read data channel
- Master transaction FSM

## Architecture

The AXI4-Lite Master follows a channel-based architecture:

```text
                         AXI4-Lite MASTER
                               │
                ┌──────────────┴──────────────┐
                │                             │
          WRITE TRANSACTION             READ TRANSACTION
                │                             │
       ┌────────┼────────┐              ┌─────┴─────┐
       │        │        │              │           │
     AW       WDATA     BRESP          AR          RDATA
       │        │        │              │           │
       ▼        ▼        ▼              ▼           ▼
   Write     Write     Write          Read        Read
  Address     Data    Response       Address       Data
   Channel   Channel  Channel        Channel     Channel
       │        │        │              │           │
       └────────┴────────┘              └───────────┘
                │                             │
                └──────────┬──────────────────┘
                           ▼
                    AXI MASTER FSM
                           │
                           ▼
                    AXI MASTER TOP