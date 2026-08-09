# Project 15 – SDRAM Controller

## Overview

This project implements a modular SDRAM Controller in Verilog HDL. The design demonstrates the control architecture required to interface with synchronous DRAM, including initialization, command generation, timing control, read and write operations, refresh management, and centralized FSM-based control.

The project follows a hierarchical RTL architecture where individual controller blocks are developed and verified independently before being integrated into the complete SDRAM Controller.

## Features

- SDRAM Command Generator
- SDRAM Initialization FSM
- SDRAM Main FSM
- SDRAM Read Controller
- SDRAM Write Controller
- SDRAM Refresh Controller
- SDRAM Timing Generator
- Top-Level SDRAM Controller
- Modular RTL Architecture
- Individual Module Verification
- System-Level Verification
- GTKWave Waveform Analysis
- Yosys RTL Synthesis
- Synthesized Netlist Generation
- RTL Schematic Generation

## Implemented Modules

### SDRAM Command Generator

Generates the control commands required for SDRAM operations.

### SDRAM Initialization FSM

Controls the SDRAM startup and initialization sequence.

### SDRAM Main FSM

Coordinates the overall SDRAM controller operation.

### SDRAM Read Controller

Manages the sequence required to perform SDRAM read operations.

### SDRAM Write Controller

Manages the sequence required to perform SDRAM write operations.

### SDRAM Refresh Controller

Generates and manages periodic SDRAM refresh operations.

### SDRAM Timing Generator

Provides the timing and control signals required by the SDRAM control architecture.

### SDRAM Top

Integrates all controller blocks into the complete SDRAM Controller.

## Verification

Each major RTL component was verified using a dedicated Verilog testbench.

System-level verification was performed using the integrated SDRAM top-level design.

Verification includes:

- SDRAM Initialization
- Command Generation
- Timing Control
- Read Control
- Write Control
- Refresh Control
- FSM State Transitions
- Top-Level Integration
- GTKWave Waveform Analysis

## Synthesis

The complete SDRAM Controller hierarchy was synthesized using Yosys.

The synthesis flow includes:

- RTL elaboration
- Hierarchy analysis
- Process conversion
- Logic optimization
- Cell statistics
- Synthesized netlist generation
- RTL schematic generation

The top-level SDRAM controller was synthesized as an integrated multi-module RTL design.

## Learning Outcomes

During this project I learned:

- SDRAM controller architecture
- Memory initialization sequences
- SDRAM command generation
- Memory read and write control
- Refresh management
- Hardware timing control
- FSM-based memory controller design
- Modular RTL architecture
- Hierarchical hardware integration
- Functional verification
- GTKWave waveform debugging
- RTL synthesis using Yosys
- Synthesized netlist analysis