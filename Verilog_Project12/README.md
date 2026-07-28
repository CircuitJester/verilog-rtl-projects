# SPI Master Controller (Verilog)

A modular SPI (Serial Peripheral Interface) Master Controller designed in Verilog HDL. This project demonstrates the complete implementation of an SPI Master using a hierarchical RTL design approach with independent, reusable modules.


## Overview

This SPI Master supports:

- 8-bit full-duplex communication
- Configurable SPI clock divider
- Active-Low Chip Select (CS_N)
- Modular architecture
- FSM-based transaction control
- Independent verification of every module
- Complete top-level integration

The project is written for learning FPGA/ASIC digital design practices and follows an IP-core development methodology.


## Features

- Parameterized design
- Configurable SPI clock divider
- Full-duplex serial communication
- Separate transmit and receive paths
- Active-low chip select
- FSM-controlled transfer sequencing
- Easy integration into larger FPGA projects


## Modules

### SPI Clock Generator

Generates the SPI serial clock by dividing the system clock.

### SPI Shift Register

Handles

- Parallel-to-Serial transmission
- Serial-to-Parallel reception

Supports simultaneous transmit and receive.

### SPI Chip Select Controller

Controls the active-low chip select signal.
Responsible for enabling and disabling the SPI slave.

### SPI Master Top

Integrates all modules into a complete SPI Master IP.


## Learning Outcomes

Through this project I learned:

- SPI protocol fundamentals
- Full-duplex communication
- Shift register implementation
- Clock division
- Finite State Machine (FSM) design
- Hierarchical RTL development
- Modular hardware architecture
- Testbench creation
- Functional verification using GTKWave
- FPGA IP core design methodology


