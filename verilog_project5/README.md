# SPI Master Controller (Version 2)

## Overview

A modular SPI (Serial Peripheral Interface) Master controller designed in Verilog HDL.
The project demonstrates RTL design methodology using reusable modules, FSM-based control, configurable timing, and parameterized architecture.

## Features

 -> SPI Clock Generator
 -> Configurable Clock Divider
 -> Chip Select (Active LOW)
 -> Full Duplex Communication
 -> MOSI Transmitter
 -> MISO Receiver
 -> Parameterized Data Width
 -> FSM Controller
 -> Bit Counter
 -> Modular RTL Design
 -> Verification

## Modules

spi_clock_generator.v
spi_shift_register.v
spi_bit_counter.v
spi_master_fsm.v
spi_master.v

## Verification

- Verilog Testbench
- Simulation
- MOSI verification
- MISO verification
- CS timing verification
- Busy signal verification

## Future Improvements

- SPI Modes 0–3
- Multi-byte transfer support
- FIFO integration
- Interrupt support

## Skills Demonstrated

- RTL Design
- FSM Design
- Parameterized Verilog
- Modular Design
- Communication Protocols
- Digital Verification