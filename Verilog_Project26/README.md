# Project 26 — Branch Control Unit

## Overview

This project implements a modular **Branch Control Unit** for a pipelined processor using Verilog HDL.

The design handles the control-flow changes produced by branch instructions. When a branch is taken, instructions following the branch may already have entered the pipeline through the sequential instruction path. These instructions can no longer be executed and must be discarded.

The Branch Control Unit determines whether the branch should redirect execution and generates the corresponding **pipeline flush control** and **target program counter**.

This project follows the load-use hazard detection work developed in **Project 25** and introduces the second major category of pipeline hazard: the **control hazard**.

The RTL design is also synthesized using **Yosys**, with a synthesized netlist and RTL schematic generated for the complete Branch Control Unit.

---


# Objective

The primary objective is to provide the control logic required to handle a taken branch in a pipelined processor.

The unit processes branch-control information and determines:

- Whether a branch should be taken
- Whether the current pipeline contents must be flushed
- The target program counter for the redirected instruction stream

The design therefore combines **branch decision logic** with **pipeline control** and **program counter redirection**.

---


# Control Hazard

A control hazard occurs when the processor cannot immediately determine which instruction should be fetched next.

For normal sequential execution:

```text
        PC
         │
         ▼
       PC + 4
         │
         ▼
   Next Instruction
```

For a taken branch:

```text
     Current PC
         │
         ▼
   Branch Instruction
         │
         │ Branch Taken
         ▼
    Branch Target
         │
         ▼
 New Instruction Stream
```

Instructions fetched from the sequential path may already be present in the pipeline when the branch decision becomes available.

Those instructions must therefore be discarded when the branch is taken.

---


# Architecture

```text
        ┌──────────────────────┐
        │   Branch Enable      │
        └──────────┬───────────┘
                   │
                   ▼
        ┌──────────────────────┐
        │    Branch Taken      │
        └──────────┬───────────┘
                   │
                   ▼
          ┌────────────────┐
          │ Branch Control │
          │      Unit      │
          └───────┬────────┘
                  │
           ┌──────┴──────┐
           │             │
           ▼             ▼
      Flush Control   Target PC
           │             │
           ▼             ▼
      Pipeline Flush  PC + Offset
```

---


# Branch Control Flow

The branch-control operation can be represented as:

```text
Branch Instruction
        │
        ▼
Branch Enabled?
        │
        ├─────────────── No ──────────────► Sequential Execution
        │
        ▼ Yes
Branch Condition
        │
        ├─────────────── Not Taken ───────► Sequential Execution
        │
        ▼ Taken
Branch Target Calculation
        │
        ├──────────────► Target PC
        │
        └──────────────► Pipeline Flush
```

When the branch is taken, the processor redirects instruction fetching toward the calculated branch target and removes instructions belonging to the incorrect sequential path.

---


# Branch Target Calculation

The target program counter is calculated using the current program counter and the branch offset.

Conceptually:

```text
target_pc = current_pc + branch_offset
```

The design supports both positive and negative branch offsets.

Therefore, branch targets can be located:

- Ahead of the current instruction address
- Behind the current instruction address

Signed offset handling allows the same control logic to support both forward and backward branches.

---


# Pipeline Flush

When a branch is taken, the sequential instructions that have entered the pipeline may belong to the wrong execution path.

The Branch Control Unit therefore generates the pipeline flush control.

```text
Taken Branch
     │
     ▼
Branch Control Unit
     │
     ├───────────────► Flush Pipeline
     │
     └───────────────► Generate Target PC
                              │
                              ▼
                       Redirect Fetch
```

This prevents incorrect instructions from continuing through the processor pipeline.

---


# Project Structure

```text
Verilog_Project26/
│
├── build/
│
├── RTL/
│   └── branch_control_unit.v
│
├── tb/
│   └── tb_branch_control_unit.v
│
├── verification/
│
├── synth/
│   ├── netlists/
│   ├── schematics/
│   └── scripts/
│
├── verilogcode/
│   └── branch_control_unit.v
│
├── waves/
│
├── README.md
└── command.md
```


# Features

- Branch Decision Logic
- Branch Enable Handling
- Taken Branch Detection
- Pipeline Flush Generation
- Target Program Counter Generation
- Program Counter Redirection
- Signed Branch Offset Handling
- Forward Branch Support
- Backward Branch Support
- Sequential Execution Handling
- Combinational Control Logic
- Modular RTL Design
- Dedicated Functional Verification
- Top-Level Verification
- Yosys RTL Synthesis
- Synthesized Netlist Generation
- RTL Schematic Generation

---


# Verification

A dedicated Verilog testbench is provided for the Branch Control Unit.

Verification covers:

- Normal sequential execution
- Branch condition asserted while branch is disabled
- Branch instruction that is not taken
- Taken forward branch
- Taken backward branch
- Return to normal sequential execution

The verification focuses on both primary outputs:

```text
flush_pipeline
target_pc
```

This ensures that the unit not only identifies a taken branch but also calculates the correct destination address.

---


# Synthesis

The RTL design was synthesized using **Yosys**.

The synthesis flow includes:

- RTL elaboration
- Hierarchy analysis
- Process conversion
- Logic optimization
- Design statistics
- Synthesized netlist generation
- RTL schematic generation

Since Project 26 contains a single RTL module, the `branch_control_unit` is synthesized directly as the top-level design.


---


# Synthesis Flow

```text
branch_control_unit.v
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
      ┌───┴────┐
      ▼        ▼
  Netlist    Schematic
      │        │
      ▼        ▼
     .v       .svg
```

---


# Concepts Covered

- Verilog HDL
- RTL Design
- Processor Microarchitecture
- Five-Stage Pipeline
- Control Hazards
- Branch Decision Logic
- Branch Target Calculation
- Pipeline Flushing
- Program Counter Redirection
- Sequential PC Generation
- Signed Branch Offsets
- Two's-Complement Arithmetic
- Forward Branch Handling
- Backward Branch Handling
- Control Path Design
- Combinational RTL Logic
- Functional Verification
- RTL Synthesis
- Yosys
- Synthesized Netlist Generation
- RTL Schematic Analysis

---


# Applications

The Branch Control Unit can be integrated into:

- RISC-V Processors
- MIPS Processors
- Five-Stage Pipeline CPUs
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
- Ubuntu (WSL)
- Git
- GitHub

---


# Learning Outcomes

After completing this project, the following concepts were practiced:

- Control Hazard Handling
- Branch Decision Logic
- Branch Target Generation
- Pipeline Flush Control
- Program Counter Redirection
- Signed Offset Arithmetic
- Forward Branch Handling
- Backward Branch Handling
- Sequential Instruction Flow
- Processor Control-Path Design
- Combinational RTL Logic
- Functional Verification
- RTL Synthesis
- Synthesized Netlist Generation
- RTL Schematic Analysis

---


# Relation to Previous Projects

Project 25 introduced **data hazard detection** for a pipelined processor.

```text
Project 25
Data Hazard
     │
     ▼
Load-Use Detection
     │
     ▼
Stall / Bubble
```

Project 26 introduces **control hazard handling**.

```text
Project 26
Control Hazard
     │
     ▼
Branch Decision
     │
     ▼
Flush / PC Redirect
```

Together, the two projects demonstrate two fundamental pipeline-control mechanisms.

```text
             5-Stage Pipeline
                    │
             ┌──────┴──────┐
             │             │
             ▼             ▼
       Data Hazards   Control Hazards
             │             │
             ▼             ▼
        Project 25     Project 26
             │             │
             ▼             ▼
       Stall / Bubble     Flush
                         +
                       Redirect
```

---


# Processor Control Progression

The recent processor projects now build toward a progressively more complete pipeline-control architecture:

```text
Project 23
Forwarding Unit
      │
      ▼
Data Dependency Resolution
      │
      ▼
Project 24
5-Stage Pipeline
      │
      ▼
Pipeline Datapath
      │
      ▼
Project 25
Hazard Detection
      │
      ▼
Stall / Bubble Control
      │
      ▼
Project 26
Branch Control
      │
      ▼
Pipeline Flush
+
PC Redirection
```

This progression establishes the major building blocks required for a more complete pipelined processor control system.

---



# Key Takeaway

A pipelined processor must handle more than register dependencies.

When a branch changes the instruction flow, instructions that have already entered the pipeline may belong to the wrong execution path.

The Branch Control Unit addresses this problem by:

```text
Detect Taken Branch
        +
Calculate Target PC
        +
Flush Incorrect Pipeline Instructions
        =
Correct Control-Flow Redirection
```

This provides the fundamental control mechanism required for safe branch execution in a pipelined processor.