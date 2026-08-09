# Project 24 — 5-Stage Pipelined ALU

## Overview

This project implements a 32-bit pipelined ALU datapath in Verilog, with separate pipeline registers between the major processing stages.

The main goal was to understand how a processor breaks instruction execution into multiple clock cycles and how the datapath is controlled when a pipeline needs to stall or flush.

Instead of keeping the ALU as a single combinational block, the design separates the processing flow into pipeline stages and uses dedicated registers to transfer both data and control information from one stage to the next.

The project also includes a pipeline control unit and verification testbenches for the individual pipeline registers as well as the complete pipelined datapath.

---


## Architecture

        ┌──────────────┐
        │ Instruction  │
        │    Fetch     │
        └──────┬───────┘
               │
               ▼
        ┌──────────────┐
        │    IF/ID     │
        │   Register   │
        └──────┬───────┘
               │
               ▼
        ┌──────────────┐
        │   Decode /   │
        │ Register Read│
        └──────┬───────┘
               │
               ▼
        ┌──────────────┐
        │    ID/EX     │
        │   Register   │
        └──────┬───────┘
               │
               ▼
        ┌──────────────┐
        │   Execute /  │
        │      ALU     │
        └──────┬───────┘
               │
               ▼
        ┌──────────────┐
        │    EX/MEM    │
        │   Register   │
        └──────┬───────┘
               │
               ▼
        ┌──────────────┐
        │    Memory    │
        │    Stage     │
        └──────┬───────┘
               │
               ▼
        ┌──────────────┐
        │    MEM/WB    │
        │   Register   │
        └──────┬───────┘
               │
               ▼
        ┌──────────────┐
        │ Write Back   │
        └──────────────┘



## Project Objectives

The project was developed to gain practical experience with:

-> Multi-stage processor datapaths
-> Pipeline registers
-> ALU execution stages
-> Control signal propagation
-> Pipeline stalls
-> Pipeline flushing
-> Clocked RTL design
-> Datapath/control separation
-> Hierarchical Verilog design
-> Module-level verification
-> Top-level integration verification
-> GTKWave waveform analysis


