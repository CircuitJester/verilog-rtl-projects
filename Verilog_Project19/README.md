# Project 19 – AXI4-Lite Slave Peripheral (Simplified)

## Overview

This project implements a simplified AXI4-Lite Slave Peripheral in Verilog HDL. The design demonstrates how a processor communicates with memory-mapped hardware registers through separate read and write channels using VALID/READY handshakes.

The project is organized using a modular architecture, where each functional block is designed, verified, and then integrated into a complete single module.



## Objectives

- Learn memory-mapped peripheral design
- Understand AXI4-Lite communication fundamentals
- Implement register-based hardware interfaces
- Design reusable RTL modules
- Practice hierarchical system integration
- Verify complete functionality using simulation


## Architecture

```
                AXI Master (CPU)
                       │
      ┌────────────────┼────────────────┐
      │                │                │
      ▼                ▼                ▼
 Write Channel    Read Channel      Address Bus
      │                │                │
      └────────────┬───┴────────────────┘
                   ▼
          Address Decoder
                   │
             Register Select
                   │
                   ▼
             Register File
                   │
                   ▼
               Read Data
```



## Project Modules

### 1. Register File

- Four 32-bit programmable registers
- Synchronous write operation
- Combinational read operation
- Parameterized design



### 2. Address Decoder

- Converts CPU addresses into register indices
- Supports four memory-mapped registers
- Detects invalid addresses

| Address | Register |
|----------|----------|
| 0x00 | REG0 |
| 0x04 | REG1 |
| 0x08 | REG2 |
| 0x0C | REG3 |



### 3. AXI Write Channel

Implements simplified AXI write protocol.

Features:

- AWVALID
- AWREADY
- WVALID
- WREADY
- BVALID
- BREADY
- Write Enable Generation


### 4. AXI Read Channel

Implements simplified AXI read protocol.

Features:

- ARVALID
- ARREADY
- RVALID
- RREADY
- Read Enable Generation


### 5. AXI Slave Top

Integrates all modules into one complete AXI4-Lite slave peripheral.


## Verification

Every module was verified individually before complete system integration.

### Module Verification

- Register File
- Address Decoder
- AXI Write Channel
- AXI Read Channel

### System Verification

Verified:

- Reset
- Register writes
- Register reads
- Address decoding
- Read handshake
- Write handshake
- Data retention
- Invalid address handling
- End-to-end AXI transactions


## Concepts Learned

- AXI4-Lite Fundamentals
- Memory-Mapped Registers
- Register File Design
- Address Decoding
- VALID/READY Handshake
- Synchronous RTL
- Combinational RTL
- Modular RTL Design
- Hierarchical Integration
- Top-Level Verification


## Learning Outcomes

After completing this project I understand:

- How processors access hardware peripherals
- Memory-mapped register architecture
- AXI read/write transactions
- VALID/READY handshake protocol
- Modular RTL development
- RTL integration methodology
- Complete subsystem verification



## Future Improvements

- Full AXI4-Lite compliance
- BRESP and RRESP support
- WSTRB (Byte Enables)
- Independent address/data buffering
- Back-to-back transaction support
- Formal Verification
- FPGA implementation
