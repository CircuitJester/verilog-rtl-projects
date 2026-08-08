# SPI Slave Controller (Version 1)

## Overview

This project implements a modular SPI (Serial Peripheral Interface) Slave Controller in Verilog HDL.

The design follows a reusable RTL architecture consisting of independent modules for SPI bit counting, serial data shifting, controller FSM logic, and the top-level SPI slave interface.

The project also integrates with the SPI Master developed in **Verilog Project 05**, enabling end-to-end Master–Slave communication verification.

The implementation has been verified through RTL simulation and GTKWave waveform analysis. The individual RTL blocks have also been synthesized using **Yosys** to generate synthesized netlists and structural schematics.

---

## Features

- SPI Slave Architecture
- Full-Duplex SPI Communication
- Parameterized Data Width
- Shift Register Based Data Transmission
- Shift Register Based Data Reception
- Chip Select (Active LOW)
- SPI Bit Counter
- FSM Based Controller
- Modular RTL Architecture
- RTL Simulation
- GTKWave Waveform Verification
- Yosys RTL Synthesis
- Synthesized Verilog Netlists
- Structural SVG Schematics
- Master–Slave System-Level Simulation

---

## Architecture

The SPI Slave is divided into multiple reusable RTL blocks:

```text
                    SPI Slave
                        │
          ┌─────────────┼─────────────┐
          │             │             │
          ▼             ▼             ▼
   Shift Register   Bit Counter   Controller FSM
          │             │             │
          └─────────────┼─────────────┘
                        │
                        ▼
                 SPI Slave Interface