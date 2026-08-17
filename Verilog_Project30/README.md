# Project 30 — Branch Target Buffer (BTB)

## Overview

This project implements a small **Branch Target Buffer (BTB)** in Verilog HDL.

A BTB stores the target addresses of previously encountered branch instructions so that the processor can obtain a predicted branch destination during instruction fetch without waiting for the branch instruction to reach a later pipeline stage.

The project builds on the branch-prediction concepts introduced in **Project 29**.

While the branch predictor determines **whether a branch is expected to be taken**, the BTB provides the **target address** that can be used when the branch is predicted taken.

The design implements a small **4-entry direct-mapped BTB**.

Each entry stores:

```text
Valid Bit
PC Tag
Target Address
```

During a lookup, the current PC is divided into an index and tag. The index selects one BTB entry, while the tag and valid bit determine whether the selected entry contains a matching branch target.

---


# Objective

The main objective is to understand how a processor can store and retrieve previously observed branch target addresses using a small tagged lookup structure.

The BTB demonstrates:

- PC indexing
- PC tag extraction
- Tagged lookup
- Valid-bit checking
- Target-address storage
- Hit detection
- Miss detection
- Entry replacement
- Reset-based invalidation
- Combinational lookup
- Sequential BTB updates

The design is intentionally small so that the underlying hardware structure can be understood before moving toward larger branch-prediction and instruction-fetch architectures.

---


# Branch Target Buffer Concept

A processor that predicts a branch as taken needs two pieces of information:

```text
1. Is the branch taken?
2. Where is the branch target?
```

The branch predictor and BTB provide these pieces separately.

```text
        Current PC
            │
      ┌─────┴─────┐
      │           │
      ▼           ▼
Branch Predictor  BTB
      │           │
      ▼           ▼
 Taken/Not Taken Target Address
      │           │
      └─────┬─────┘
            │
            ▼
         Next PC
```

Project 29 provides the branch-direction prediction.

Project 30 provides the target-address lookup.

---


# Architecture

```text
                     Lookup PC
                         │
                         ▼
                ┌─────────────────┐
                │ Extract Index    │
                │      + Tag       │
                └────────┬────────┘
                         │
                  ┌──────┴──────┐
                  │             │
                  ▼             ▼
                Index           Tag
                  │             │
                  ▼             ▼
           Select BTB Entry   Compare Tag
                  │             │
                  └──────┬──────┘
                         │
                    Valid + Match
                         │
                  ┌──────┴──────┐
                  │             │
                 HIT           MISS
                  │             │
                  ▼             ▼
           Target Address    No Target
```

The lookup therefore follows:

```text
Lookup PC
   │
   ▼
Extract Index + Tag
   │
   ▼
Select Entry
   │
   ▼
Check Valid Bit
   │
   ▼
Compare Tag
   │
   ├── Match → BTB Hit → Target Address
   │
   └── No Match → BTB Miss
```

---


# BTB Entry Structure

Each entry contains:

```text
+-------+-------------+----------------+
| Valid | PC Tag      | Target Address |
+-------+-------------+----------------+
```

The valid bit indicates whether the entry contains meaningful information.

The PC tag identifies which instruction address is associated with the entry.

The target address stores the destination of the previously observed branch.

---


# Address Mapping

The design uses the PC bits as follows:

```text
31                         4 3    2 1    0
+---------------------------+------+------+
|           PC Tag          |Index |Offset|
+---------------------------+------+------+
            28 bits            2      2
```

The two index bits select one of the four BTB entries:

```text
00 → Entry 0
01 → Entry 1
10 → Entry 2
11 → Entry 3
```

The upper PC bits are stored as the tag and compared during lookup.

The lowest two bits are ignored because instruction addresses are assumed to be word aligned.

---


# Module

## `branch_target_buffer.v`

The main RTL module implements the BTB storage and lookup logic.

Its responsibilities include:

1. Extracting the PC index
2. Extracting the PC tag
3. Selecting the corresponding BTB entry
4. Checking the valid bit
5. Comparing the stored tag
6. Detecting BTB hits
7. Returning the stored target address
8. Updating BTB entries
9. Invalidating entries during reset

The design uses RTL arrays to model the small table of BTB entries.

---


# Features

- 4-Entry Branch Target Buffer
- Direct-Mapped Organization
- PC Index Extraction
- PC Tag Extraction
- Valid-Bit Checking
- Tag Comparison
- BTB Hit Detection
- BTB Miss Detection
- Target Address Storage
- Entry Replacement
- Reset-Based Invalidation
- Combinational Lookup Logic
- Sequential Update Logic
- RTL Array Modeling
- Directed Functional Verification
- VCD Waveform Generation
- Yosys RTL Synthesis
- Synthesized Netlist Generation
- RTL Schematic Generation

---


# Verification

The BTB is verified using a dedicated Verilog testbench.

The verification focuses on the basic behavior of the lookup and update mechanism.

Important scenarios include:

- Reset invalidation
- Lookup of an invalid entry
- BTB miss
- Writing a branch target
- Lookup of a previously stored branch
- Matching PC tag
- Matching index
- BTB hit
- Target address retrieval
- Different PCs mapping to different entries
- Entry replacement when indexes collide

The generated waveform is maintained under:

```text
waves/branch_target_buffer.vcd
```

The waveform can be inspected to observe the relationship between the lookup PC, valid state, tag comparison, hit detection, and target address.

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
VCD Waveform Generation
    │
    ▼
Waveform Analysis
```

---


# Yosys Synthesis

The RTL is synthesized using **Yosys** to inspect how the BTB RTL is transformed into a synthesized hardware representation.

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


# Project Structure

```text
Verilog_Project30/
│
├── README.md
│
├── RTL/
│   └── branch_target_buffer.v
│
├── tb/
│   └── tb_branch_target_buffer.v
│
├── verification/
│   └── ...
│
├── waves/
│   └── branch_target_buffer.vcd
│
├── build/
│   └── ...
│
└── synth/
    ├── netlists/
    │   └── branch_target_buffer_netlist.v
    │
    ├── schematics/
    │   └── branch_target_buffer.svg
    │
    └── scripts/
        └── synth_branch_target_buffer.ys
```

---


# Concepts Covered

- Verilog HDL
- RTL Design
- Branch Target Buffers
- Branch Target Prediction
- Direct-Mapped Tables
- Tagged Lookup Structures
- PC Indexing
- PC Tag Extraction
- Valid Bits
- Tag Comparison
- BTB Hit Detection
- BTB Miss Detection
- Target Address Storage
- Entry Replacement
- Reset Invalidation
- RTL Array Modeling
- Combinational Lookup Logic
- Sequential Update Logic
- Functional Verification
- VCD Waveform Analysis
- RTL Synthesis
- Yosys
- Netlist Inspection
- RTL Schematic Analysis

---


# Applications

A BTB can be used as a building block for:

- RISC-V Processors
- Pipelined CPU Designs
- Instruction Fetch Units
- Branch Prediction Systems
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

- Branch target storage
- Branch target lookup
- Direct-mapped hardware structures
- PC indexing
- PC tag extraction
- Tagged comparisons
- Valid-bit management
- Hit and miss detection
- Target address storage
- Entry replacement
- Reset-based invalidation
- RTL array modeling
- Combinational lookup logic
- Sequential update logic
- Functional verification
- VCD waveform analysis
- Yosys synthesis
- Netlist inspection
- RTL schematic analysis

An important architectural lesson from this project is that branch prediction requires more than determining whether a branch is likely to be taken.

The processor also needs the **destination address** of the predicted branch. The BTB provides this information by remembering target addresses from previously encountered branches.

---


# Connection With Project 29

Project 29 introduced a **2-bit dynamic branch predictor**.

Its responsibility is to predict:

```text
Taken
   or
Not Taken
```

Project 30 introduces the BTB, whose responsibility is to provide:

```text
Branch Target Address
```

The two structures can therefore operate together:

```text
                     Current PC
                         │
              ┌──────────┴──────────┐
              │                     │
              ▼                     ▼
      2-Bit Branch Predictor       BTB
           Project 29           Project 30
              │                     │
              ▼                     ▼
       Taken / Not Taken       Target Address
              │                     │
              └──────────┬──────────┘
                         │
                         ▼
                      Next PC
```

The predictor provides the **direction**, while the BTB provides the **destination**.

Keeping these functions separate also makes the processor architecture more modular and easier to verify.

---


# Processor Branch-Control Progression

The processor projects now demonstrate an increasingly complete branch-control path:

```text
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
2-Bit Dynamic Prediction
      │
      ▼
Project 30
Branch Target Buffer
```

The progression moves from reacting to branch decisions toward predicting both:

```text
Branch Direction
        +
Branch Target
```

before the branch reaches the later stages of the pipeline.

---


# BTB and Cache-Like Structures

One of the important hardware concepts reinforced by this project is the similarity between a BTB and other tagged lookup structures.

The lookup process is:

```text
Address
   │
   ▼
Extract Index
   │
   ▼
Select Entry
   │
   ▼
Compare Tag
   │
   ▼
Check Valid
   │
   ▼
Hit / Miss
```

This same general structure appears in several hardware systems, including cache-like lookup mechanisms.

The BTB therefore provides useful experience with:

- Indexed tables
- Tags
- Valid bits
- Hit detection
- Replacement
- Stored metadata

---

