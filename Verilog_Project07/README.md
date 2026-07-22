# I²C Master Controller (Version 1)

## Overview

This project implements a modular I²C (Inter-Integrated Circuit) Master Controller in Verilog HDL. The design is developed using a modular RTL approach where each functional block is designed, simulated, verified independently, and finally integrated into a complete I²C Master Controller.
The implementation focuses on understanding the internal architecture of an I²C Master while following a professional RTL design workflow.

## Features

- I²C Master Interface
- Configurable Clock Divider
- START Condition Generation
- STOP Condition Generation
- Shift Register Based Data Transmission
- Bit Counter
- ACK/NACK Detection
- FSM Based Controller
- Modular RTL Architecture
- Verification

## Modules

- I²C Clock Generator
- START / STOP Generator
- Shift Register
- Bit Counter
- ACK Detector
- FSM Controller
- I²C Master Top Module
- System Testbench


Verified Components:-

- Clock Generation
- START Condition
- STOP Condition
- Shift Register Operation
- Bit Counting
- ACK Detection
- FSM Operation
- Complete Module Integration

## Learning Outcomes

- I²C Bus Architecture
- Open-Drain Communication Concept
- START and STOP Conditions
- ACK / NACK Mechanism
- FSM Design
- Modular RTL Development
- Hardware Verification
- Digital Communication Protocols

## Current Limitations (Version 1)

This project is an educational implementation intended to understand I²C architecture.

The following advanced features are planned for a future version:-

- True Open-Drain SDA Implementation
- Bidirectional SDA Control
- 7-bit Address Transmission
- Read/Write Transactions
- Repeated START Support
- Clock Stretching
- Multi-Master Arbitration
- Error Detection and Recovery
- Multi-Byte Transfers
- FIFO Integration

## Future Improvements

Future versions will extend this design toward an industry-style I²C controller by adding:-

- Full I²C Specification Compliance
- Industrial Timing Implementation
- Complete Address + Data Transactions
- I²C Slave Integration
- End-to-End Master-Slave Verification

## Status

This project is part of a structured RTL Design focused on developing reusable digital IP cores for FPGA and ASIC applications.