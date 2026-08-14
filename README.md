# Verilog RTL Design

This repository is a growing collection of **Verilog RTL, digital hardware and processor-oriented design projects** developed as part of my progression toward FPGA, ASIC and processor design.

The projects started with basic combinational and sequential logic and gradually moved into FSMs, communication protocols, memory systems, AXI4-Lite, DMA, interrupt control, processor datapaths and pipeline control.

As the designs became more complex, the development workflow also evolved from basic RTL simulation toward a more complete hardware-design flow involving **functional verification, waveform analysis and Yosys synthesis**.

The goal is simple:

> **Write the RTL, verify the behavior, synthesize the design, inspect the resulting hardware structure, and understand the relationship between RTL and implementation.**

---


## Repository Progress

The repository currently contains **30 Verilog RTL projects** covering digital design, communication interfaces, system-level RTL and processor-oriented hardware.

The projects are developed incrementally, with later designs building on concepts introduced in earlier projects.

The current synthesis milestone is:

```text
Projects 01–26
      │
      ▼
Yosys RTL Synthesis
      │
      ├── Synthesis Scripts
      ├── Synthesized Netlists
      └── RTL Schematics
```

Projects beyond the current Yosys milestone continue the processor and RISC-V-oriented development path and will be brought into the synthesis flow as the portfolio progresses.

---


# Design Progression

The repository follows a gradual progression from fundamental digital logic toward processor and ASIC-oriented RTL.

```text
Digital Logic
      ↓
Sequential RTL
      ↓
FSMs and Control Logic
      ↓
Timers / PWM / FIFO
      ↓
SPI / I²C / UART / CAN
      ↓
AXI4-Lite
      ↓
Memory Systems
      ↓
Interrupts / DMA
      ↓
RTL IP Development
      ↓
Processor Datapath
      ↓
Pipeline Architecture
      ↓
Hazard Detection
      ↓
Forwarding
      ↓
Branch Control
      ↓
Branch Prediction
      ↓
RISC-V-Oriented Hardware
      ↓
Yosys Synthesis
      ↓
Open-Source ASIC Flow
```

---


# Project Areas

## Digital Design Foundations

The early projects establish the fundamental RTL building blocks used throughout the repository.

Topics include:

- Combinational Logic
- Sequential Logic
- Registers
- Counters
- Adders
- ALU Logic
- Priority Encoders
- Basic RTL structures

These projects establish the foundation for understanding synchronous digital hardware before moving into larger systems.

---


## FSM and Control Logic

The next group of projects introduces state-based hardware and timing-oriented control.

Topics include:

- Finite State Machines
- UART Control
- Timers
- PWM
- FIFO
- Sequence Detection
- Control-Oriented RTL

These designs focus on understanding how state, timing and control signals interact inside synchronous hardware.

---


## Communication Interfaces

The repository then moves into communication-oriented RTL.

Implemented interfaces include:

- SPI Master
- SPI Slave
- I²C Master
- I²C Slave
- UART
- CAN

The communication projects include both protocol-level control logic and supporting RTL such as:

- Shift Registers
- Clock Dividers
- Counters
- FSMs
- Control Logic
- Data Transfer Logic

---


## Bus and System Interfaces

The next stage moves toward system-level hardware interfaces.

Projects cover:

- AXI4-Lite Master
- AXI4-Lite Slave
- AXI4-Lite Slave Peripheral
- Register Files
- Address Decoding
- Bus Multiplexing
- Memory-Mapped Interfaces

These projects introduce the concepts required for connecting reusable RTL blocks into larger digital systems.

---


## Memory and Data Movement

The repository also contains RTL focused on memory access and hardware data movement.

Topics include:

- SDRAM Controller
- Multi-Port SDRAM Arbiter
- DMA Controller
- Request FIFOs
- Arbitration
- Address Generation
- Transfer Control

These projects move the portfolio from isolated RTL blocks toward system-level hardware architecture.

---


# Processor-Oriented RTL

The later projects focus increasingly on processor microarchitecture.

This part of the portfolio currently includes:

- Pipelined ALU
- Hazard Detection
- Forwarding
- 5-Stage Pipeline Architecture
- Pipeline Control
- Branch Control
- Branch Prediction
- RISC-V-oriented concepts
- Pipeline Datapath Design

The goal is to understand how individual RTL blocks combine to form the control and datapath portions of a pipelined processor.

---


# Processor Development Progression

The processor-oriented projects are being developed as a connected learning path rather than isolated exercises.

```text
Pipelined ALU
      │
      ▼
Forwarding Unit
      │
      ▼
5-Stage Pipeline
      │
      ▼
Hazard Detection
      │
      ▼
Branch Control
      │
      ▼
Branch Prediction
      │
      ▼
RISC-V-Oriented Pipeline Logic
      │
      ▼
More Complete Processor Architecture
```

---


# Selected Project Roadmap

| Project | Focus |
|---:|---|
| [01](Verilog_Project01/) | Combinational Logic |
| [02](Verilog_Project02/) | Sequential Logic |
| [03](Verilog_Project03/) | FSM Fundamentals |
| [04](Verilog_Project04/) | Utility RTL / Timers / PWM / FIFO |
| [05](Verilog_Project05/) | SPI Master |
| [06](Verilog_Project06/) | SPI Slave |
| [07](Verilog_Project07/) | I²C Master |
| [08](Verilog_Project08/) | I²C Slave |
| [09](Verilog_Project09/) | CAN Controller |
| [10](Verilog_Project10/) | AXI4-Lite Master |
| [11](Verilog_Project11/) | AXI4-Lite Slave |
| [12](Verilog_Project12/) | SPI Master |
| [13](Verilog_Project13/) | I²C Master |
| [14](Verilog_Project14/) | UART Controller |
| [15](Verilog_Project15/) | SDRAM Controller |
| [16](Verilog_Project16/) | Multi-Port SDRAM Arbiter |
| [17](Verilog_Project17/) | SPI Master IP |
| [18](Verilog_Project18/) | Programmable Interrupt Controller |
| [19](Verilog_Project19/) | AXI4-Lite Slave Peripheral |
| [20](Verilog_Project20/) | DMA Controller |
| [21](Verilog_Project21_Pipelined_ALU/) | Pipelined ALU |
| [22](Verilog_Project22_Hazard_Detection_Unit/) | Hazard Detection Unit |
| [23](Verilog_Project23_Forwarding_Unit/) | Processor Forwarding Unit |
| [24](Verilog_Project24/) | 5-Stage Pipelined ALU |
| [25](Verilog_Project25/) | Load-Use Hazard Detection |
| [26](Verilog_Project26/) | Branch Control Unit |
| [27](Verilog_Project27/) | RISC-V Pipeline Forwarding Unit |
| [28](Verilog_Project28/) | Processor / RISC-V-Oriented RTL |
| [29](Verilog_Project29/) | Two-Bit Branch Predictor |
| [30](Verilog_Project30/) | Processor / RISC-V-Oriented RTL |

Projects may revisit related concepts at a deeper architectural level. Each individual project README contains the implementation-specific details.

---


# Verification Workflow

The projects follow a progressively more complete RTL development workflow.

```text
Problem Definition
        ↓
RTL Architecture
        ↓
RTL Implementation
        ↓
Testbench Development
        ↓
Simulation
        ↓
Waveform Analysis
        ↓
Yosys Synthesis
        ↓
Netlist Generation
        ↓
RTL Schematic Inspection
        ↓
Documentation
        ↓
Git Version Control
```

Simulation is used to verify functional behavior, state transitions and control logic.

Waveforms are used where timing and sequential behavior need to be inspected.

For projects that have entered the Yosys workflow, synthesis artifacts are also retained so the generated hardware structure can be examined rather than treating synthesis as a black box.

---


# Yosys Synthesis

Yosys is currently integrated into the workflow through **Project 26**.

```text
Projects 01–26
      │
      ▼
    Yosys
      │
      ├── RTL Elaboration
      ├── Hierarchy Analysis
      ├── Process Conversion
      ├── Optimization
      ├── Design Statistics
      ├── Netlist Generation
      └── RTL Schematic Generation
```

The synthesis workflow is organized around individual Yosys scripts for the RTL modules and top-level designs.

Generated artifacts include:

```text
synth/
├── scripts/
├── netlists/
└── schematics/
```

The generated netlists provide a synthesized representation of the RTL, while the schematic outputs make the resulting hardware structure easier to inspect.

The synthesis workflow is intentionally kept close to the RTL so that the relationship between:

```text
RTL
 ↓
Logic
 ↓
Synthesized Hardware
```

can be studied directly.

---


# Yosys Project Standard

Projects that have been migrated into the Yosys workflow generally follow a structure similar to:

```text
Verilog_ProjectXX/
│
├── README.md
├── command.md
├── RTL/
│
├── tb/
│
├── verification/
│
├── synth/
│   ├── scripts/
│   ├── netlists/
│   └── schematics/
│
└── waves/
```

The exact structure varies depending on the project.

---


# RTL Design Practices

The projects are developed with an emphasis on:

- Modular RTL
- Clear module boundaries
- Hierarchical integration
- Synchronous design
- Reusable hardware blocks
- Explicit control logic
- Parameterized designs where appropriate
- Independent module verification
- Top-level integration verification
- Synthesis-aware RTL development

The objective is not simply to make the simulation pass, but to understand how the RTL translates into hardware.

---


# Processor Microarchitecture

The recent projects increasingly focus on the interaction between processor datapath and control logic.

Important concepts covered include:

### Datapath

- ALU Design
- Pipeline Registers
- Operand Routing
- Execution Stages
- Pipeline Data Flow

### Hazard Handling

- RAW Dependencies
- Load-Use Hazards
- Pipeline Stalls
- Pipeline Bubbles
- Forwarding
- Operand Selection

### Control Flow

- Branch Decisions
- Pipeline Flushing
- Program Counter Redirection
- Branch Target Calculation
- Branch Prediction

### Pipeline Control

- IF/ID Control
- ID/EX Control
- EX/MEM Control
- MEM/WB Control
- Stall Control
- Flush Control

These concepts form the foundation for building a more complete pipelined processor.

---



# Tools

The primary tools used across the repository are:

- Verilog HDL
- SystemVerilog where applicable
- Icarus Verilog
- GTKWave
- Yosys
- Visual Studio Code
- Ubuntu / WSL
- Git
- GitHub

The toolchain is intentionally lightweight and locally reproducible.

---



# What I am Learning

The objective of this repository is not simply to learn Verilog syntax.

The larger goal is to understand the complete hardware-development path:

```text
Hardware Requirement
        ↓
Architecture
        ↓
RTL
        ↓
Verification
        ↓
Synthesis
        ↓
Hardware Structure
        ↓
Implementation
```

Through the projects, I am developing practical understanding of:

- Digital logic
- RTL architecture
- Synchronous design
- FSM design
- Protocol implementation
- Memory interfaces
- Bus protocols
- Processor datapaths
- Pipeline architecture
- Hazard handling
- Branch control
- Verification
- Synthesis
- Hardware structure after synthesis

---



# Repository Structure

Each project is maintained independently so that its RTL, verification environment and synthesis results can be inspected without depending on other projects.

A typical project contains:

```text
Verilog_ProjectXX/
├── README.md
├── command.md
├── RTL/
├── tb/
├── verification/
├── synth/
│   ├── scripts/
│   ├── netlists/
│   └── schematics/
└── waves/
```

Earlier projects may use slightly different directory names because the repository is being progressively migrated toward the standardized RTL and Yosys workflow.

---


# Explore the Projects

For digital-design fundamentals, start with:

```text
Projects 01–04
```

For communication RTL:

```text
Projects 05–09
Projects 12–14
```

For system-level interfaces, memory and data movement:

```text
Projects 10–20
```

For processor and pipeline architecture:

```text
Projects 21–30
```

For Yosys synthesis and hardware-structure inspection:

```text
Projects 01–26
```

Each project contains its own documentation and implementation files.

---


# Current Milestone

The repository has now progressed from basic RTL exercises into a broader processor-oriented RTL portfolio.

```text
30 RTL Projects
      │
      ▼
Communication + Memory + System IP
      │
      ▼
Processor Datapath
      │
      ▼
Pipeline Architecture
      │
      ▼
Hazard Detection
      │
      ▼
Forwarding
      │
      ▼
Branch Control
      │
      ▼
Branch Prediction
      │
      ▼
RISC-V-Oriented Hardware
```

At the same time, the Yosys workflow has been extended through **Project 26**, creating a bridge between RTL design and synthesis.

---


# Notes

This repository is an active engineering and learning portfolio.

Some projects are intentionally small because they establish concepts used by later designs, while the newer projects increasingly combine multiple RTL concepts into larger hardware subsystems.

The verification and synthesis workflow is also continuously evolving as new tools and processor-design concepts are introduced.

The later projects form a bridge toward broader work in **FPGA design, ASIC implementation, RISC-V architecture and hardware acceleration**.