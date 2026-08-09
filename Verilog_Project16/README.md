# Project 16 – Multi-Port SDRAM Arbiter

## Overview

This project implements a modular Multi-Port SDRAM Arbitration system in Verilog HDL. The design demonstrates how multiple independent request sources can share a common SDRAM interface through arbitration, request buffering, priority selection, and bus multiplexing.

The architecture uses dedicated arbitration and control blocks to manage shared memory access while preventing conflicting requests from simultaneously controlling the memory interface.

## Features

- Request FIFO
- Priority Encoder
- Round-Robin Arbiter
- Arbitration FSM
- Bus Multiplexer
- Multi-Port SDRAM Top-Level Integration
- Modular RTL Architecture
- Individual Module Verification
- System-Level Verification
- GTKWave Waveform Analysis
- Yosys RTL Synthesis
- Synthesized Netlist Generation
- RTL Schematic Generation

## Implemented Modules

### Request FIFO

Buffers incoming memory access requests before they are processed by the arbitration logic.

### Priority Encoder

Determines the highest-priority active request when priority-based selection is required.

### Round-Robin Arbiter

Provides fair access to the shared SDRAM resource by rotating arbitration priority between request sources.

### Arbiter FSM

Controls the arbitration sequence and manages transitions between request, grant, and transfer states.

### Bus Multiplexer

Selects the active requester's address, data, and control signals for connection to the shared memory interface.

### Multi-Port SDRAM Top

Integrates the arbitration, buffering, selection, and shared-bus logic into the complete multi-port memory access architecture.

## Arbitration Flow

```text
Multiple Request Sources
          |
          v
     Request FIFO
          |
          v
   Priority / Round-Robin
       Arbitration
          |
          v
      Arbiter FSM
          |
          v
     Bus Multiplexer
          |
          v
    Shared SDRAM Bus