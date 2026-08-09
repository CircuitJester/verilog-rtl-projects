# Project 12 – SPI Master Controller

## Overview

This project implements a modular SPI Master Controller in Verilog HDL. The design demonstrates synchronous serial communication using a structured RTL architecture consisting of clock generation, chip-select control, shift-register based data transfer, and FSM-based transaction control.

The project follows a modular RTL development methodology where individual functional blocks are verified independently before being integrated into the complete SPI Master system.

## Features

- SPI Clock Generator
- SPI Chip Select Controller
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

### SPI Clock Generator

Generates the SPI serial clock required for synchronous data transfer.

### SPI Chip Select

Controls the slave-select signal during SPI transactions.

### SPI Shift Register

Handles serial transmission and reception of SPI data.

### SPI Master FSM

Controls the sequence of SPI operations including transaction start, clocking, data transfer, and completion.

### SPI Master Top

Integrates the individual SPI components into the complete master controller.

## Verification

Each major RTL module was verified using dedicated Verilog testbenches.

System-level verification was performed on the integrated SPI Master design.

Verification includes:

- SPI Clock Generation
- Chip Select Control
- Serial Data Shifting
- FSM State Transitions
- Transaction Control
- Top-Level Integration
- Waveform Analysis using GTKWave

## Synthesis

The RTL design was synthesized using Yosys.

The synthesis flow includes:

- RTL elaboration
- Hierarchy checking
- Process conversion
- Logic optimization
- Design statistics
- Synthesized netlist generation
- RTL schematic generation

The top-level SPI Master synthesis uses the complete module hierarchy and generates a corresponding synthesized netlist and schematic representation.

## Learning Outcomes

During this project I learned:

- SPI communication architecture
- Synchronous serial communication
- SPI clock generation
- Chip-select control
- Shift-register based data transfer
- FSM-based protocol control
- Modular RTL design
- Hierarchical module integration
- Functional verification
- GTKWave waveform debugging
- RTL synthesis using Yosys
- Synthesized netlist analysis