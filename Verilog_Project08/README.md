# I²C Slave Controller 

## Overview

This project implements a modular I²C (Inter-Integrated Circuit) Slave Controller in Verilog HDL.

The design follows a hierarchical RTL architecture where each functional block is developed, simulated, verified independently, and finally integrated into a complete I²C Slave Controller.

The implementation demonstrates the fundamental operation of an I²C slave, including device address matching, serial data reception, bit counting, ACK generation, and FSM-based control.

The project also follows a structured RTL-to-synthesis workflow using GTKWave for functional verification and Yosys for RTL synthesis and netlist generation.

## Features

- I²C Slave Architecture
- 7-bit Address Comparator
- Serial-to-Parallel Shift Register
- ACK Generation
- Bit Counter
- FSM Based Controller
- Modular RTL Architecture
- Hierarchical Module Integration
- Functional Verification
- GTKWave Waveform Analysis
- Yosys RTL Synthesis
- Synthesized Netlist Generation
- RTL Schematic Generation

## Modules

### i2c_address_comparator

Compares the received 7-bit I²C address with the configured slave address.

Main functions:

- Address matching
- Device selection
- Address validation

### i2c_slave_shift_register

Handles serial data reception from the SDA line.

Main functions:

- Serial data shifting
- Serial-to-parallel conversion
- Data storage

### i2c_ack_generator

Generates the acknowledgement signal after successful address or data reception.

Main functions:

- ACK generation
- ACK timing control
- Communication response

### i2c_slave_bit_counter

Tracks the number of received I²C bits during a transfer.

Main functions:

- Bit counting
- Transfer progress tracking
- Completion detection

### i2c_slave_fsm

Controls the overall slave communication sequence using a finite state machine.

Main functions:

- Idle control
- Address reception
- Data reception
- ACK control
- Transfer sequencing

### i2c_slave

Top-level module integrating all I²C slave components.

The top-level design connects:

- Address Comparator
- Shift Register
- ACK Generator
- Bit Counter
- FSM Controller

into a complete I²C Slave Controller.

## Verification

Each functional module was independently simulated using Verilog testbenches.

The complete slave controller was then verified at the system level.

### Verified Features

- Address Matching
- Serial Data Reception
- Serial-to-Parallel Conversion
- Bit Counting
- ACK Generation
- FSM State Transitions
- Slave Control Logic
- Top-Level Module Integration

### Verification Tools

- Icarus Verilog
- GTKWave

Waveform captures are stored in:

```text
waveforms/screenshots/