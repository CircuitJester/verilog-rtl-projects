# Project 13 – I²C Master Controller (Verilog)

## Overview

This project implements a modular I²C Master Controller in Verilog HDL. The design follows the I²C protocol by generating START and STOP conditions, transmitting and receiving serial data, detecting ACK/NACK responses, and coordinating the complete transaction using a Finite State Machine (FSM).

## Features

- I²C Clock Generation
- START Condition Generator
- STOP Condition Generator
- Serial Shift Register
- Data Transmission
- Data Reception
- ACK/NACK Detection
- Master Finite State Machine
- Modular RTL Architecture
- Complete System Integration
- Testbench Verification
- Simulation

## Modules

### 1. I²C Clock Generator

Generates the SCL clock from the FPGA system clock.


### 2. Start/Stop Generator

Generates the START and STOP conditions required by the I²C protocol.


### 3. Shift Register

- Loads transmit data
- Sends serial data
- Receives serial data
- Generates transfer complete signal


### 4. ACK Detector

Samples the SDA line after every byte to determine whether the slave acknowledged the transfer.


## Verification

Each module was verified independently using dedicated testbenches.

Verified modules include:

- Clock Generator
- Start/Stop Generator
- Shift Register
- ACK Detector
- FSM
- Complete Top Module

## Learning Outcomes

Through this project, I learned:

- I²C Protocol Fundamentals
- Serial Communication Design
- Shift Register Implementation
- Finite State Machine Design
- Clock Division
- Modular RTL Design
- Top-Level Integration
- Digital Verification
- FPGA-Oriented RTL Development
