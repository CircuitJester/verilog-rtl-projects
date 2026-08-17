# Project 29 — 2-Bit Dynamic Branch Predictor

## Overview

This project implements a **2-bit dynamic branch predictor** in Verilog HDL.

The design models a small but practical branch-prediction mechanism used in processor pipelines. Instead of determining the prediction from only the most recent branch outcome, the predictor maintains a two-bit state representing how strongly the branch is expected to be taken or not taken.

The predictor uses four saturating states:

```text
00 → Strongly Not Taken
01 → Weakly Not Taken
10 → Weakly Taken
11 → Strongly Taken
```

The most significant state bit is used to generate the branch prediction.

A taken branch moves the predictor toward the taken states, while a not-taken branch moves it toward the not-taken states.

The state saturates at both extremes:

```text
00 ← 01 ← 10 ← 11
```

A further not-taken outcome while in `00` keeps the predictor at `00`, while a further taken outcome while in `11` keeps it at `11`.

This project introduces the basic hardware mechanism behind **dynamic branch prediction** and demonstrates how a small amount of branch-history information can influence processor control-flow decisions.

---


# Objective

The main objective is to implement a compact dynamic branch predictor using a **2-bit saturating state machine**.

The design demonstrates:

- Prediction based on stored state
- State updates based on branch outcomes
- Strong and weak prediction states
- Saturating state transitions
- Reset behavior
- Sequential state storage
- Combinational prediction generation

The project provides a foundation for understanding more advanced branch-prediction structures used in modern processors.

---


# Predictor States

The predictor contains a two-bit state register.

The four possible states are:

```text
+-------+-----------------------+------------+
| State | Prediction Strength   | Prediction |
+-------+-----------------------+------------+
|  00   | Strongly Not Taken    | Not Taken |
|  01   | Weakly Not Taken      | Not Taken |
|  10   | Weakly Taken          | Taken     |
|  11   | Strongly Taken        | Taken     |
+-------+-----------------------+------------+
```

The most significant bit determines the current prediction:

```text
state[1] = 0 → Not Taken
state[1] = 1 → Taken
```

This provides hysteresis so that a single unusual branch outcome does not immediately reverse a strong prediction.

---


# Architecture

```text
                     Branch Outcome
                           │
                           ▼
                 ┌───────────────────┐
                 │  State Update     │
                 │      Logic        │
                 └─────────┬─────────┘
                           │
                           ▼
                  ┌────────────────┐
                  │ 2-Bit State    │
                  │    Register    │
                  └───────┬────────┘
                          │
                          │ state[1]
                          ▼
                  ┌────────────────┐
                  │  Prediction    │
                  │     Logic      │
                  └───────┬────────┘
                          │
                          ▼
                  Branch Prediction
```

The predictor therefore contains two primary functions:

```text
Branch Outcome
      │
      ▼
State Update
      │
      ▼
2-Bit Saturating State
      │
      ▼
Prediction
```

---


# Features

- 2-Bit Dynamic Branch Prediction
- Four Prediction States
- Strongly Taken State
- Weakly Taken State
- Weakly Not-Taken State
- Strongly Not-Taken State
- Saturating Counter Behavior
- Prediction from Most Significant State Bit
- Sequential State Updates
- Reset Handling
- Conditional State Transitions
- Directed Functional Verification
- VCD Waveform Generation
- Yosys RTL Synthesis
- Synthesized Netlist Generation
- RTL Schematic Generation

---


# Verification

The predictor is verified using a dedicated Verilog testbench.

The verification focuses on the behavior of the predictor state and its response to different branch outcomes.

The testbench exercises:

- Reset behavior
- Initial prediction state
- Taken branch updates
- Not-taken branch updates
- Transition between weak and strong states
- Saturation at `00`
- Saturation at `11`
- Prediction generation from the stored state

The verification artifacts provide a way to inspect both the stored predictor state and the resulting prediction behavior.

---


# Verification Flow

```text
RTL Design
    │
    ▼
Testbench Development
    │
    ▼
Icarus Verilog Simulation
    │
    ▼
Functional Verification
    │
    ▼
VCD Waveform
    │
    ▼
Waveform Analysis
```

---


# Yosys Synthesis

The RTL is synthesized using **Yosys** to inspect the hardware structure generated from the behavioral predictor description.

The synthesis flow includes:

- RTL elaboration
- Hierarchy analysis
- Process conversion
- Logic optimization
- Design statistics
- Netlist generation
- RTL schematic generation

The top-level predictor module is explicitly selected during schematic generation.

Generated synthesis artifacts are maintained under:

---


# Synthesis Flow

```text
two_bit_branch_predictor.v
            │
            ▼
          Yosys
            │
            ▼
     Hierarchy Analysis
            │
            ▼
     Process Conversion
            │
            ▼
      Logic Optimization
            │
            ▼
       Design Statistics
            │
       ┌────┴────┐
       ▼         ▼
    Netlist   Schematic
       │         │
       ▼         ▼
      .v        .svg
```

The synthesis script is:

```text
synth/scripts/synth_two_bit_branch_predictor.ys
```

---


# Project Structure

```text
Verilog_Project29/
│
├── README.md
│
├── RTL/
│   └── two_bit_branch_predictor.v
│
├── tb/
│   └── tb_two_bit_branch_predictor.v
│
├── verification/
│   └── ...
│
├── waves/
│   └── two_bit_branch_predictor.vcd
│
├── build/
│   └── ...
│
└── synth/
    ├── netlists/
    │   └── two_bit_branch_predictor_netlist.v
    │
    ├── schematics/
    │   └── two_bit_branch_predictor.svg
    │
    └── scripts/
        └── synth_two_bit_branch_predictor.ys
```

---


# Concepts Covered

- Verilog HDL
- RTL Design
- Dynamic Branch Prediction
- Two-Bit Saturating Counters
- Prediction Hysteresis
- Strong and Weak Prediction States
- Sequential State Machines
- State Transition Logic
- Reset Handling
- Conditional State Updates
- Saturation Behavior
- Branch Outcome Tracking
- Processor Control Flow
- Functional Verification
- VCD Waveform Generation
- RTL Synthesis
- Yosys
- Synthesized Netlist Analysis
- RTL Schematic Analysis

---


# Applications

The predictor can be used as a building block for:

- RISC-V Processors
- Pipelined CPU Designs
- Instruction Fetch Units
- Branch Prediction Units
- FPGA Processor Designs
- Educational CPU Architectures
- Custom Processor Datapaths
- ASIC Processor Designs

---


# Tools Used

- Verilog HDL
- Icarus Verilog
- Yosys
- Visual Studio Code
- Ubuntu / WSL
- Git
- GitHub

---


# Learning Outcomes

This project provided practical experience with:

- Dynamic branch prediction
- Two-bit saturating counters
- Prediction hysteresis
- Strong and weak prediction states
- Sequential state updates
- Reset handling
- Conditional state transitions
- Saturation behavior
- Prediction generation
- Branch outcome tracking
- RTL state-machine design
- Functional verification
- VCD waveform analysis
- Yosys synthesis
- Netlist inspection
- RTL schematic analysis

More importantly, the project connects a small sequential RTL block to a real processor microarchitecture problem: **predicting control flow using recent branch behavior**.

---


# Relation to Previous Projects

The processor-control projects now form a progressive sequence.

### Project 24 — 5-Stage Pipeline

Established the basic pipelined datapath and pipeline registers.

### Project 25 — Hazard Detection

Introduced load-use hazard detection and pipeline stall/bubble control.

### Project 26 — Branch Control

Introduced branch target generation and pipeline control for branch redirection.

### Project 27 — Forwarding Unit

Introduced data forwarding to reduce unnecessary stalls caused by RAW dependencies.

### Project 28 — Static Branch Prediction

Introduced prediction of branch direction before the actual branch result is available.

### Project 29 — Dynamic Branch Prediction

Introduces stored branch-history information through a two-bit saturating predictor.

```text
Project 24
5-Stage Pipeline
       │
       ▼
Project 25
Hazard Detection
       │
       ▼
Project 26
Branch Control
       │
       ▼
Project 27
Data Forwarding
       │
       ▼
Project 28
Static Branch Prediction
       │
       ▼
Project 29
2-Bit Dynamic Branch Prediction
```

---


