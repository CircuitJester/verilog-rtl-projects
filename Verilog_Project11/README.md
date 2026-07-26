# AXI4-Lite Slave IP Core (Verilog)

## Overview

This project implements a complete AXI4-Lite Slave Interface in Verilog HDL.
The design is built using a modular architecture where every AXI channel is implemented as an independent RTL module and verified using dedicated testbenches before final integration.
The project demonstrates memory-mapped register design, finite state machine implementation, AXI transaction handling, and hierarchical RTL integration.


## Features

- AXI4-Lite Write Address Channel
- AXI4-Lite Write Data Channel
- AXI4-Lite Write Response Channel
- AXI4-Lite Read Address Channel
- AXI4-Lite Read Data Channel
- 32-bit Memory Mapped Register File
- AXI Slave Controller FSM
- Top-Level Integration
- Individual Testbenches
- Verification


## AXI Write Flow

```
Write Address
      ↓
Write Data
      ↓
Register File
      ↓
Write Response
```


## AXI Read Flow

```
Read Address
      ↓
Register File
      ↓
Read Data
```

## Simulation

Compile

```bash
iverilog -o build/output.out verilogcode/*.v tb/*.v
```

Run

```bash
vvp build/output.out
```

View Waveform

```bash
gtkwave waves/output.vcd
```

## Learning Outcomes

- AXI4-Lite Protocol
- Memory Mapped Peripherals
- Register File Design
- Address Decoding
- Finite State Machines
- RTL Design
- Modular Hardware Architecture
- Testbench Development
- Waveform Debugging
- Top-Level Integration

