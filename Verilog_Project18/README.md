# Project 18 – Programmable Interrupt Controller

## Overview

This project implements a modular Programmable Interrupt Controller (PIC) in Verilog HDL. The design manages multiple interrupt sources, applies programmable masking, determines interrupt priority, and controls interrupt servicing using a dedicated finite state machine.

The project demonstrates how interrupt management logic can be organized into reusable RTL blocks and integrated into a complete hardware interrupt controller.

The design follows a structured RTL development methodology including modular implementation, individual module verification, system-level integration, GTKWave waveform analysis, and Yosys synthesis.

## Features

- Interrupt Request Register
- Programmable Interrupt Mask Register
- Fixed-Priority Interrupt Encoder
- Interrupt Controller FSM
- Top-Level Interrupt Controller Integration
- Multiple Interrupt Source Handling
- Interrupt Masking
- Priority-Based Interrupt Selection
- Modular RTL Architecture
- Individual Module Verification
- System-Level Verification
- GTKWave Waveform Analysis
- Yosys RTL Synthesis
- Synthesized Netlist Generation
- RTL Schematic Generation



## Interrupt Processing Flow

```text
Interrupt Sources
        |
        v
Interrupt Request Register
        |
        v
Interrupt Mask Register
        |
        v
Priority Encoder
        |
        v
Interrupt Controller FSM
        |
        v
Interrupt Output
        |
        v
CPU / Processor
```

## Interrupt Handling

The controller processes interrupt requests through the following stages:

```text
Interrupt Request
        |
        v
Request Capture
        |
        v
Apply Interrupt Mask
        |
        v
Priority Selection
        |
        v
Controller FSM
        |
        v
Interrupt Assertion
        |
        v
Interrupt Service
        |
        v
Interrupt Completion
```

## Verification

Each RTL module was verified using a dedicated Verilog testbench.

System-level verification was performed using the complete interrupt controller top-level testbench.

Verification covers:

- Interrupt Request Capture
- Interrupt Masking
- Priority Selection
- Controller FSM Operation
- Interrupt Assertion
- Interrupt Servicing
- Top-Level Module Integration
- GTKWave Waveform Analysis



## Synthesis

The RTL design was synthesized using Yosys.

The synthesis workflow includes:

- RTL elaboration
- Hierarchy analysis
- Process conversion
- Logic optimization
- Design statistics
- Synthesized netlist generation
- RTL schematic generation


## Project Structure

```text
Verilog_Project18/
│
├── build/
│
├── RTL/
│   ├── interrupt_controller_fsm.v
│   ├── interrupt_controller_top.v
│   ├── interrupt_mask_register.v
│   ├── interrupt_priority_encoder.v
│   └── interrupt_request_register.v
│
├── tb/
│   ├── tb_interrupt_controller_fsm.v
│   ├── tb_interrupt_controller_top.v
│   ├── tb_interrupt_mask_register.v
│   ├── tb_interrupt_priority_encoder.v
│   └── tb_interrupt_request_register.v
│
├── synth/
│   ├── netlists/
│   ├── schematics/
│   └── scripts/
│
├── waveforms/
│   └── screenshots/
│
├── waves/
│
├── README.md
└── command.md
```

## Learning Outcomes

During this project I learned:

- Programmable Interrupt Controller architecture
- Interrupt request handling
- Interrupt masking techniques
- Fixed-priority interrupt encoding
- FSM-based interrupt control
- Modular RTL design
- Hierarchical hardware integration
- Processor interrupt interface concepts
- Functional RTL verification
- GTKWave waveform debugging
- RTL synthesis using Yosys
- Synthesized netlist generation
- RTL schematic analysis