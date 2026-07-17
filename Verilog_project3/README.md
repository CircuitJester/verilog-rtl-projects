# Project 03 - Finite State Machines (FSM)

## Overview
This project introduces Finite State Machines (FSMs) and communication protocol design using Verilog RTL.

## Implemented Designs

### 1. Traffic Light Controller FSM
Implements a four-state traffic controller:
- North Green / South Red
- North Yellow / South Red
- North Red / South Green
- North Red / South Yellow

### 2. Sequence Detector FSM
Detects the serial bit pattern:
1011

Concepts:
- State encoding
- Pattern recognition
- Overlapping sequence detection

### 3. Vending Machine FSM
A simple vending machine accepting:
- ₹5 coin
- ₹10 coin

Dispenses product once ₹10 is accumulated.

### 4. UART Transmitter FSM
Implements UART transmission:
- Idle State
- Start Bit
- Data Bits
- Stop Bit

Features:
- LSB first transmission
- Busy signal generation
- Shift register based serialization

### 5. UART Receiver FSM
Implements UART reception:
- Start bit detection
- Serial-to-parallel conversion
- Stop bit verification
- Receive complete flag

## Concepts Learned
- Moore and Mealy FSMs
- State Encoding
- State Transition Logic
- Output Logic
- Serial Communication
- Serialization
- Deserialization

## Tools Used
- Verilog HDL
- Icarus Verilog
- GTKWave
- VS Code


Omm Prakash Sahoo