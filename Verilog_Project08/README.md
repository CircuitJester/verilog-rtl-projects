# I²C Slave Controller (Version 1)

## Overview

This project implements a modular I²C Slave Controller in Verilog HDL.The design follows a hierarchical RTL approach where each functional block is developed, verified independently and finally integrated into a complete slave controller.
The project demonstrates the fundamental operation of an I²C slave including address matching, serial data reception, ACK generation, and FSM-based control.


## Features

- 7-bit Address Comparator
- Serial-to-Parallel Shift Register
- ACK Generator
- Bit Counter
- FSM Based Controller
- Top Module Integration
- Modular RTL Architecture
- Verification


## Modules

- Address Comparator
- Slave Shift Register
- ACK Generator
- Bit Counter
- FSM Controller
- Top Module
- Complete System Testbench

## Verification

Verified Features

- Address Matching
- Serial Data Reception
- Bit Counting
- ACK Generation
- FSM State Transitions
- Busy Signal
- Complete System Integration

## Learning Outcomes

During this project I learned:

- I²C Slave Architecture
- Address-Based Communication
- Serial-to-Parallel Data Conversion
- ACK/NACK Generation
- FSM Controlled Communication
- Modular RTL Design
- Integration of Multiple Hardware Blocks
- Functional Verification using GTKWave


## Current Limitations

This project is an educational Version 1 implementation.
Current simplifications include:-

- Simplified START and STOP detection
- Behavioral testbench
- No real open-drain SDA implementation
- No clock stretching
- No repeated START support
- No multi-master arbitration
- No FIFO buffering
