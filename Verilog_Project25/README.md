# Project 25 — Hazard Detection Unit

## Overview

This project implements a hazard detection unit for a 5-stage pipelined processor using Verilog HDL.

The purpose of the design is to detect a load-use data hazard between an instruction currently in the EX stage and the instruction waiting in the ID stage.

In a pipelined processor, a load instruction does not produce its memory data immediately. If the following instruction tries to use the destination register of that load, allowing it to continue into the execution stage can result in incorrect data being used.

The hazard detection unit identifies this dependency and generates control signals that temporarily stop part of the pipeline and insert a bubble into the execution path.

This project builds on the pipelined datapath developed in Project 24 and introduces one of the basic mechanisms used in real processor pipeline control.

---


## Architecture

    ┌───────────────────────────┐
    │ Instruction in EX Stage   │
    │                           │
    │ id_ex_mem_read            │
    │ id_ex_rd                  │
    └─────────────┬─────────────┘
                  │
                  │ Compare destination
                  │ with ID source regs
                  ▼
    ┌───────────────────────────┐
    │   Hazard Detection Unit   │
    │                           │
    │ Compare rd with rs1/rs2   │
    └─────────────┬─────────────┘
                  │
          ┌───────┼────────┐
          │       │        │
          ▼       ▼        ▼
      PC Write  IF/ID    ID/EX
        Control  Write    Flush
          │       │        │
          ▼       ▼        ▼
        Hold    Hold     Bubble

---


## Hazard Detection Logic

The basic condition is:

    id_ex_mem_read &&
    id_ex_rd != 0 &&
    (
        id_ex_rd == if_id_rs1 ||
        id_ex_rd == if_id_rs2
    )

If this condition is true, the unit generates:

    pc_write    = 0
    if_id_write = 0
    id_ex_flush = 1

Otherwise:

    pc_write    = 1
    if_id_write = 1
    id_ex_flush = 0

Register zero is excluded from the comparison so that dependencies involving the architectural zero register do not generate a false hazard.

---


## Verification

A dedicated testbench was created to verify several hazard scenarios.

The verification covers:

- No memory-read instruction
- Load-use hazard through `rs1`
- Load-use hazard through `rs2`
- No dependency between source and destination registers
- Destination register equal to zero
- Both source registers depending on the pending load
- Dependency-free instruction after a load

The testbench uses a reusable transaction task to apply different register dependency combinations without duplicating large sections of stimulus code.

---


## Verification Flow

    RTL Design
        │
        ▼
    Testbench Development
        │
        ▼
    Icarus Verilog Compilation
        │
        ▼
    Functional Simulation
        │
        ▼
    VCD Waveform Generation
        │
        ▼
    GTKWave Analysis
        │
        ▼
    Hazard Behavior Verification

---

## Tools Used

- Verilog HDL
- Icarus Verilog
- GTKWave
- Visual Studio Code
- Ubuntu / WSL
- Git

---

## Learning Outcomes

This project provided practical experience with:

- Data hazards in pipelined processors
- Load-use hazard detection
- Register dependency checking
- Pipeline stalls
- Pipeline bubbles
- Pipeline control signals
- PC hold logic
- IF/ID pipeline register control
- ID/EX pipeline flushing
- Special handling of register zero
- Datapath and control interaction
- RTL combinational control logic
- Module-level verification
- Waveform-based debugging

---

## Relation to Project 24

Project 24 introduced the 5-stage pipelined ALU datapath and the pipeline registers connecting the stages.

Project 25 extends that design by adding hazard detection.

    Project 24
    5-Stage Pipeline
          │
          ▼
    Pipeline Registers
          │
          ▼
    Project 25
    Hazard Detection
          │
          ▼
    Stall / Bubble Control

This creates a more realistic processor pipeline instead of treating each pipeline stage independently.

---

## Key Takeaway

The main idea of this project is that a pipeline cannot always keep moving every cycle.

When an instruction depends on data that is not yet available, the processor must temporarily control the pipeline rather than allowing incorrect data to propagate.

The hazard detection unit provides that control by holding the PC, holding the IF/ID stage, and flushing the ID/EX stage when a load-use dependency is detected.

This forms the foundation for more advanced pipeline techniques such as data forwarding, branch hazard handling, and complete processor control logic.