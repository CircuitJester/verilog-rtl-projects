# Project 13 – I²C Master Controller

## Overview

This project implements a modular I²C Master Controller in Verilog HDL. The design demonstrates the fundamental operation of an I²C master including clock generation, START and STOP condition handling, serial data shifting, acknowledgement detection, and FSM-based transaction control.

The design follows a hierarchical RTL architecture where individual communication blocks are developed and verified independently before being integrated into the complete I²C Master Controller.

## Features

- I²C Clock Generator
- START/STOP Condition Generator
- ACK Detector
- Serial Shift Register
- I²C Master FSM
- Top-Level I²C Master Integration
- Modular RTL Architecture
- Individual Module Verification
- System-Level Verification
- GTKWave Waveform Analysis
- Yosys RTL Synthesis
- Synthesized Netlist Generation
- RTL Schematic Generation

## Implemented Modules

### I²C Clock Generator

Generates the timing required for I²C serial communication.

### I²C START/STOP Generator

Controls the generation of I²C START and STOP conditions.

### I²C Shift Register

Handles serial transmission and reception of I²C data.

### I²C ACK Detector

Detects the acknowledgement response from the connected slave device.

### I²C Master FSM

Controls the complete sequence of an I²C transaction.

### I²C Master Top

Integrates all functional blocks into the complete I²C Master Controller.

## Verification

Each major RTL component was verified using dedicated Verilog testbenches.

The complete system was also verified through top-level simulation.

Verification includes:

- I²C Clock Generation
- START Condition Generation
- STOP Condition Generation
- Serial Data Transfer
- ACK Detection
- FSM State Transitions
- Transaction Control
- Top-Level Integration
- GTKWave Waveform Analysis

## Synthesis

The complete RTL hierarchy was synthesized using Yosys.

The synthesis workflow includes:

- RTL elaboration
- Hierarchy analysis
- Process conversion
- Logic optimization
- Cell statistics
- Synthesized netlist generation
- RTL schematic generation

The top-level I²C Master hierarchy was synthesized as an integrated design using Yosys.

## Learning Outcomes

During this project I learned:

- I²C protocol fundamentals
- START and STOP conditions
- ACK-based communication
- Serial data transfer
- Clock generation
- FSM-controlled protocol design
- Modular RTL architecture
- Hierarchical hardware integration
- Functional verification
- GTKWave waveform debugging
- RTL synthesis using Yosys
- Synthesized netlist analysis