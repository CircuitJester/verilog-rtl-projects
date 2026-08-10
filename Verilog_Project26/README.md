# Project 26 — Branch Control Unit

## Overview

This project implements a branch control unit for a pipelined processor using Verilog HDL.

The purpose of the design is to handle the control-flow change produced by a taken branch instruction.

In a pipelined processor, instructions following a branch may already have entered the pipeline before the branch condition is resolved. If the branch is taken, those instructions may belong to the wrong execution path and must be discarded.

The branch control unit determines whether a branch should redirect execution and generates the corresponding pipeline flush signal and target program counter.

This project follows the hazard detection work from Project 25 and introduces the second major type of pipeline hazard: the control hazard.

---

## Control Hazard

A control hazard occurs when the processor cannot immediately determine which instruction should be fetched next.

For a sequential instruction stream:

    PC
     │
     ▼
    PC + 4
     │
     ▼
    Next instruction

For a taken branch:

    Current PC
        │
        ▼
    Branch instruction
        │
        │ Branch condition true
        ▼
    Branch Target
        │
        ▼
    New instruction stream

Instructions that were fetched from the sequential path may need to be removed from the pipeline.

---


## Architecture

    ┌──────────────────────┐
    │ Branch Enable        │
    └──────────┬───────────┘
               │
               │
    ┌──────────▼───────────┐
    │ Branch Taken         │
    └──────────┬───────────┘
               │
               ▼
       ┌────────────────┐
       │ Branch Control │
       │     Unit       │
       └───────┬────────┘
               │
        ┌──────┴──────┐
        │             │
        ▼             ▼
    Flush Control   Target PC
        │             │
        ▼             ▼
    Pipeline       PC + Offset
     Flush

---


## Verification

The testbench checks several different control-flow conditions:

- Normal sequential execution
- Branch condition asserted while branch is disabled
- Branch instruction that is not taken
- Taken forward branch
- Taken backward branch
- Return to normal sequential execution

The verification focuses on both outputs:

    flush_pipeline
    target_pc

This ensures that the unit not only identifies a taken branch but also calculates the correct destination address.

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
    Branch and Flush Verification

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

- Control hazards in pipelined processors
- Branch decision logic
- Branch target calculation
- Pipeline flushing
- Program counter redirection
- Sequential PC generation
- Signed branch offsets
- Two's-complement arithmetic
- Forward branch handling
- Backward branch handling
- Control-path RTL design
- Combinational decision logic
- Module-level verification
- GTKWave waveform analysis
- Processor control-flow behavior

---

## Relation to Project 25

Project 25 focused on data hazards.

    Project 25
    Data Hazard
         │
         ▼
    Load-Use Detection
         │
         ▼
    Stall / Bubble

Project 26 focuses on control hazards.

    Project 26
    Control Hazard
         │
         ▼
    Branch Decision
         │
         ▼
    Flush / PC Redirect

Together, the two projects demonstrate two important pipeline-control mechanisms.

    5-Stage Pipeline
           │
           ├───────────────┐
           │               │
           ▼               ▼
      Data Hazards    Control Hazards
           │               │
           ▼               ▼
       Project 25      Project 26
           │               │
           ▼               ▼
       Stall/Bubble       Flush
                         + Redirect

---

## Key Takeaway

A pipelined processor cannot assume that every instruction can continue normally.

Data dependencies can require the pipeline to stall, while branch decisions can invalidate instructions that have already entered the pipeline.

This project implements the control side of that problem by detecting a taken branch, generating a pipeline flush request, and calculating the new program counter.

The combination of Project 25 and Project 26 provides a foundation for more advanced processor features such as forwarding networks, branch prediction, pipeline control logic, and eventually a complete pipelined CPU.