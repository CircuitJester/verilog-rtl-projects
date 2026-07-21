# SPI Slave Controller (Version 1)

## Overview

This project implements a modular SPI (Serial Peripheral Interface) Slave Controller in Verilog HDL. The design follows a reusable RTL architecture with independent modules for the controller, shift register, and bit counter. The project also includes end-to-end integration testing with the SPI Master developed in Project 5 there are no changes in it only the timing will be upgraded to get professional output.

## Features

- SPI Slave Architecture
- Full Duplex Communication
- Parameterized Data Width
- Shift Register based Data Transmission
- Shift Register based Data Reception
- Chip Select (Active LOW)
- Bit Counter
- FSM Based Controller
- Modular RTL Design
- Verification
- Master-Slave System Level Simulation


## Modules

### spi_slave_shift_register

- Loads transmit data
- Receives MOSI data
- Transmits MISO data
- Parameterized design

### spi_slave_bit_counter

- Counts received SPI bits
- Generates transfer completion signal

### spi_slave_controller

Finite State Machine with four states

- IDLE
- LOAD
- SHIFT
- COMPLETE

Controls

- Busy signal
- Load signal

### spi_slave

Top-level module integrating all slave components.


## Verification

- Reset operation
- Shift Register
- Bit Counter
- Controller FSM
- SPI Clock
- Chip Select
- MOSI transmission
- MISO transmission
- Master-Slave integration

## Current Limitations

Current implementation is intended for learning and portfolio purposes.

## Skills Demonstrated

- RTL Design
- FSM Design
- Communication Protocol Design
- Modular Hardware Architecture
- Digital Verification
- Testbench Development
- System Integration