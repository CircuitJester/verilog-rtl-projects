# Project 14 – UART Controller

## Overview

This project implements a modular UART Controller in Verilog HDL. The design demonstrates asynchronous serial communication through dedicated transmitter and receiver datapaths, baud-rate generation, and FSM-based control logic.

The project separates the transmit and receive paths into reusable RTL modules and integrates them through a top-level UART controller.

## Features

- UART Baud Rate Generator
- UART Transmitter
- UART Receiver
- UART TX FSM
- UART RX FSM
- Top-Level UART Integration
- Modular RTL Architecture
- Individual Module Verification
- System-Level Verification
- GTKWave Waveform Analysis
- Yosys RTL Synthesis
- Synthesized Netlist Generation
- RTL Schematic Generation

## Implemented Modules

### UART Baud Generator

Generates the timing required for UART transmission and reception.

### UART Transmitter

Converts parallel transmit data into a serial UART data stream.

### UART Receiver

Samples and reconstructs serial UART data into parallel data.

### UART TX FSM

Controls the UART transmission sequence including idle, start, data, and stop phases.

### UART RX FSM

Controls the UART reception sequence and manages serial data sampling.

### UART Top

Integrates the transmitter, receiver, baud generator, and control logic into the complete UART system.

## Verification

Individual RTL modules were verified using dedicated Verilog testbenches.

System-level verification was performed on the integrated UART controller.

Verification includes:

- Baud Timing Generation
- UART Transmission
- UART Reception
- Start Bit Handling
- Data Bit Transfer
- Stop Bit Handling
- TX FSM Operation
- RX FSM Operation
- Top-Level Integration
- GTKWave Waveform Analysis

## Synthesis

The UART RTL hierarchy was synthesized using Yosys.

The synthesis flow includes:

- RTL elaboration
- Hierarchy checking
- Process conversion
- Logic optimization
- Design statistics
- Synthesized netlist generation
- RTL schematic generation

The top-level UART controller was synthesized as an integrated RTL design.

## Learning Outcomes

During this project I learned:

- UART communication fundamentals
- Asynchronous serial communication
- Baud-rate generation
- UART transmitter architecture
- UART receiver architecture
- FSM-based communication control
- Modular RTL design
- Hierarchical integration
- Functional verification
- GTKWave waveform debugging
- RTL synthesis using Yosys
- Synthesized netlist analysis