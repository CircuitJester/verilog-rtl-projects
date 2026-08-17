# Project 28 — Static Branch Prediction Unit

## Overview

This project implements a simple **static branch prediction unit** for a pipelined processor datapath using Verilog HDL.

The predictor determines the next program counter value before the actual branch outcome is resolved. This allows the instruction-fetch stage to continue using a predicted execution path instead of waiting for the branch decision.

The project introduces the basic relationship between **branch prediction, program-counter selection, branch target calculation, and control hazards**.

It provides a foundation for later processor designs involving more advanced dynamic branch prediction techniques.

---


# Objective

The main objective is to implement a lightweight branch prediction block that can provide a predicted program counter before the actual branch result is available.

The unit receives:

- Current program counter
- Branch-valid indication
- Branch offset

and generates:

- Predicted program counter

The predictor follows a static prediction policy rather than maintaining prediction history.

---


# Architecture

```text
                     Current PC
                         │
                         ▼
                ┌──────────────────┐
                │ Static Branch    │
                │ Prediction Unit  │
                └────────┬─────────┘
                         │
              ┌──────────┴──────────┐
              │                     │
              ▼                     ▼
       Non-Branch Path         Branch Path
              │                     │
              ▼                     ▼
           PC + 4             PC + Offset
              │                     │
              └──────────┬──────────┘
                         │
                         ▼
                  Predicted PC
```

---


# Control Hazard Context

Branch instructions introduce a control hazard because the processor may fetch subsequent instructions before knowing whether the branch should redirect execution.

The prediction does not determine whether the branch is actually taken. It provides an early estimate of the next instruction address.

If the prediction is later determined to be incorrect, additional pipeline-control logic would be required to recover from the misprediction.

---


# Module

## branch_prediction_unit.v

The `branch_prediction_unit` is the primary RTL module.

It performs:

1. Branch detection
2. Sequential PC generation
3. Branch target calculation
4. Predicted PC selection

The module is designed as a standalone processor-control block so that it can later be integrated with a larger instruction-fetch and pipeline-control architecture.

---


# Features

- Static Branch Prediction
- Predict-Taken Branch Policy
- Sequential PC Generation
- Branch Target Calculation
- Positive Branch Offset Support
- Negative Branch Offset Support
- Forward Branch Handling
- Backward Branch Handling
- Program Counter Selection
- Combinational RTL Logic
- Processor Fetch Control
- Dedicated Functional Verification
- VCD Waveform Generation
- Yosys RTL Synthesis
- Synthesized Netlist Generation
- RTL Schematic Generation

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

The RTL is also synthesized using **Yosys** to connect the behavioral RTL implementation with the resulting hardware structure.

The synthesis flow includes:

- RTL elaboration
- Hierarchy analysis
- Process conversion
- Logic optimization
- Design statistics
- Netlist generation
- RTL schematic generation

The top-level module is explicitly selected during schematic generation.

---


# Synthesis Flow

```text
branch_prediction_unit.v
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

# Project Structure

```text
Verilog_Project28/
│
├── README.md
│
├── RTL/
│   └── branch_prediction_unit.v
│
├── tb/
│   └── tb_branch_prediction_unit.v
│
├── verification/
│
├── waves/
│   └── branch_prediction_unit.vcd
│
├── build/
│
└── synth/
    ├── netlists/
    │   └── branch_prediction_unit_netlist.v
    │
    ├── schematics/
    │   └── branch_prediction_unit.svg
    │
    └── scripts/
        └── synth_branch_prediction_unit.ys
```

---


# Concepts Covered

- Verilog HDL
- RTL Design
- Static Branch Prediction
- Control Hazards
- Program Counter Selection
- Branch Target Calculation
- Sequential Instruction Flow
- Signed Branch Offsets
- Two's-Complement Arithmetic
- Forward Branch Handling
- Backward Branch Handling
- Processor Fetch Control
- Combinational RTL
- Functional Verification
- VCD Waveforms
- RTL Synthesis
- Yosys
- Synthesized Netlists
- RTL Schematic Analysis

---


# Applications

The branch prediction unit can be used as a building block for:

- RISC-V Processors
- Pipelined CPU Designs
- Instruction Fetch Units
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

- Static branch prediction
- Control-flow prediction
- Program counter selection
- Branch target calculation
- Signed offset arithmetic
- Forward and backward branch handling
- Control hazard concepts
- Processor fetch control
- Combinational RTL design
- Verilog testbench development
- Functional verification
- RTL synthesis
- Yosys synthesis scripting
- Netlist inspection
- RTL schematic analysis

More importantly, the project demonstrates how a processor can determine a likely next instruction address before the actual branch result is available.

---


# Relation to Previous Projects

Project 24 established the basic **5-stage pipelined datapath**.

Project 25 introduced **load-use hazard detection** and pipeline stall/bubble control.

Project 26 introduced **branch control**, including branch target handling and pipeline flushing.

Project 27 introduced **data forwarding** to reduce unnecessary stalls caused by RAW dependencies.

Project 28 adds **static branch prediction** to the processor control path.

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
```

The progression moves from basic pipeline structure toward increasingly realistic processor-control mechanisms.

---


# Processor Control Progression

The processor-oriented projects can now be viewed as a connected architecture:

```text
                5-Stage Pipeline
                       │
          ┌────────────┼────────────┐
          │            │            │
          ▼            ▼            ▼
     Data Hazards  Control Hazards  Data Forwarding
          │            │            │
          ▼            ▼            ▼
       Project 25   Project 26    Project 27
                       │
                       ▼
                Branch Prediction
                       │
                       ▼
                   Project 28
```

These mechanisms form important pieces of a practical pipelined processor.

---

