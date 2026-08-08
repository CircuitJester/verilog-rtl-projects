# Project 9 – CAN Bus Controller

## Overview

This project implements a modular CAN (Controller Area Network) Bus Controller in Verilog HDL.

The design follows a structured RTL architecture where individual CAN transmission functions are implemented as independent hardware modules and then integrated into a top-level CAN Controller.

The project demonstrates the fundamental internal architecture of a CAN transmitter, including CAN frame generation, bit timing, bit stuffing, CRC generation, acknowledgement handling, and FSM-based transmission control.

Each functional block was developed and verified independently before being integrated into the complete CAN transmission path.

The project is intended for learning RTL design, digital communication protocols, FPGA development, ASIC-oriented synthesis, and hardware verification.

---

## Features

- CAN Bit Timing Generator
- CAN Frame Generator
- CAN Bit Stuffing Unit
- CAN CRC Generator
- CAN ACK Generator
- CAN Transmit FSM
- Top-Level CAN Controller Integration
- Modular RTL Architecture
- Parameterized / Reusable RTL Components
- Functional Simulation
- GTKWave Verification
- Yosys RTL Synthesis
- Synthesized Verilog Netlists
- RTL Schematic Generation
- System-Level Module Integration

---

## Modules

### can_bit_timing_generator

Generates the timing required for CAN bit transmission.

Responsibilities include:

- CAN bit timing control
- Transmission timing generation
- Synchronization of CAN transmission events

---

### can_frame_generator

Constructs the CAN transmission frame.

Responsibilities include:

- Frame field generation
- Sequential frame construction
- Transmission data organization
- Frame-level control

---

### can_bit_stuffing

Implements the CAN bit-stuffing mechanism.

Responsibilities include:

- Monitoring consecutive transmitted bits
- Detecting consecutive identical bits
- Inserting the required complementary bit
- Maintaining the CAN transmission sequence

This demonstrates one of the important physical-layer rules used by CAN for synchronization.

---

### can_crc_generator

Implements the CRC generation logic used for CAN frame error detection.

Responsibilities include:

- Processing transmitted frame data
- Generating the CRC sequence
- Supporting frame integrity checking

The current implementation is an educational RTL representation of CAN CRC functionality.

---

### can_ack_generator

Generates the acknowledgement response.

Responsibilities include:

- Monitoring frame reception status
- Checking CRC validity
- Generating the ACK response
- Representing dominant and recessive CAN logic

---

### can_tx_fsm

Implements the finite state machine responsible for controlling the CAN transmission sequence.

Responsibilities include:

- Transmission state control
- Frame sequencing
- Coordination of CAN transmission operations
- Controlling the transition between different transmission stages

---

### can_controller

Top-level CAN Controller module.

This module integrates the major CAN transmission components:

- Bit timing generator
- Frame generator
- Bit stuffing unit
- CRC generator
- ACK generator
- TX FSM

It provides the overall control structure for the CAN transmission architecture.

---

## Architecture

The project follows a modular hierarchical architecture.

```text
                         CAN Controller
                               |
             +-----------------+-----------------+
             |                 |                 |
             v                 v                 v
      Frame Generator    Bit Timing       TX FSM
             |
             v
       Bit Stuffing
             |
             v
       CRC Generator
             |
             v
       ACK Generator