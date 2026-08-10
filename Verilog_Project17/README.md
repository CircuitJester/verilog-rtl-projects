# Project 17 – SPI Master IP Core

## Overview

This project implements a modular SPI Master IP Core in Verilog HDL. The design provides a reusable SPI master architecture consisting of clock division, chip-select control, serial data shifting, and FSM-based transaction control.

The project follows a structured RTL development methodology where individual functional modules are implemented and verified independently before being integrated into the complete SPI Master IP.

## Features

- SPI Chip Select Controller
- SPI Clock Divider
- SPI Shift Register
- SPI Master FSM
- Top-Level SPI Master Integration
- Modular RTL Architecture
- Individual Module Verification
- System-Level Verification
- GTKWave Waveform Analysis
- Yosys RTL Synthesis
- Synthesized Netlist Generation
- RTL Schematic Generation

## Implemented Modules

### SPI Chip Select

Controls the slave-select signal during an SPI transaction and manages the active transaction window.

### SPI Clock Divider

Generates the SPI clock from the system clock according to the configured clock division logic.

### SPI Shift Register

Handles serial data transmission and reception by shifting data synchronously with the SPI clock.

### SPI Master FSM

Controls the SPI transaction sequence including idle, transfer, clocking, and completion states.

### SPI Master Top

Integrates the clock divider, chip-select controller, shift register, and FSM into the complete SPI Master IP.

## SPI Transaction Flow

```text
Transaction Request
        |
        v
   Master FSM
        |
        +------> Chip Select
        |
        +------> Clock Divider
        |
        +------> Shift Register
        |
        v
    SPI Transfer
        |
        v
 Transaction Complete

```

## Learning Outcomes

This project focuses on professional RTL architecture rather than only implementing the SPI protocol.

Key concepts learned:

- Control Path vs Data Path
- Hierarchical Module Design
- Modular Verification
- Reusable Hardware IP Development
- System-Level Integration
