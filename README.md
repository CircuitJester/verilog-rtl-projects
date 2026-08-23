# 🚀 Verilog RTL Design

A continuously growing collection of **Verilog HDL projects** focused on **RTL Design, Digital System Design, Processor Microarchitecture, FPGA Development, and ASIC Design Fundamentals**.

This repository documents a progressive journey from basic digital logic to communication protocols, memory controllers, bus architectures, DMA engines, interrupt controllers, processor datapaths, pipeline control, branch prediction, cache architecture, and RTL synthesis using **Yosys**.

The portfolio is built around a practical engineering workflow:

> **Define the architecture → Write the RTL → Verify the behavior → Analyze waveforms → Synthesize the design → Inspect the hardware structure → Document the result**

The objective is not only to learn Verilog syntax, but to understand how RTL represents real digital hardware and how that RTL progresses toward synthesized hardware.

---

# 📊 Repository Progress

The repository currently contains **37 completed Verilog RTL projects**.

The projects cover:

- Digital logic design
- Sequential logic
- FSM design
- Timers and PWM
- FIFO architecture
- SPI
- I²C
- UART
- CAN
- AXI4-Lite
- SDRAM
- DMA
- Interrupt controllers
- Processor datapaths
- Pipeline architecture
- Hazard detection
- Data forwarding
- Branch control
- Branch prediction
- Branch target prediction
- Return address prediction
- Instruction caches
- Data caches
- Advanced cache architecture
- Multi-MSHR non-blocking cache
- RTL synthesis using Yosys

The current Yosys synthesis workflow has been extended through **Project 31**.

Projects beyond Project 31 continue the processor memory-hierarchy development path, moving from conventional cache architecture toward more advanced memory-system designs.

---

# 🛠 Engineering Workflow

The projects follow a progressively more complete hardware-development methodology.

For RTL projects:

    Problem Definition

            │

            ▼

    Architecture

            │

            ▼

    RTL Implementation

            │

            ▼

    Testbench Development

            │

            ▼

    Functional Simulation

            │

            ▼

    GTKWave Analysis

            │

            ▼

    Documentation

            │

            ▼

    Git Version Control

For projects that have entered the Yosys workflow:

    Problem Definition

            │

            ▼

    RTL Architecture

            │

            ▼

    RTL Implementation

            │

            ▼

    Module Verification

            │

            ▼

    System Integration

            │

            ▼

    Yosys RTL Synthesis

            │

            ▼

    Netlist Generation

            │

            ▼

    RTL Schematic Analysis

            │

            ▼

    Documentation

            │

            ▼

    Git Version Control

This workflow keeps verification and synthesis connected directly to the RTL rather than treating them as separate activities.

---

# 💻 Technology Stack

## RTL Language

- Verilog HDL
- SystemVerilog where applicable

## Simulation & Verification

- Icarus Verilog
- GTKWave
- Verilog testbenches
- Behavioral models
- VCD waveform analysis

## RTL Synthesis

- Yosys
- Synthesized Verilog netlists
- RTL schematic generation
- Design statistics
- Logic optimization
- RTL hierarchy analysis

## Development Environment

- Visual Studio Code
- Ubuntu / WSL
- Git
- GitHub

---

# 📚 Project Roadmap

| Project | Topic | Status |
| ------: | ------------------------------------------ | :----: |
| 01 | Combinational Logic | ✅ |
| 02 | Sequential Logic | ✅ |
| 03 | FSM Fundamentals | ✅ |
| 04 | Utility RTL IPs | ✅ |
| 05 | SPI Master | ✅ |
| 06 | SPI Slave | ✅ |
| 07 | I²C Master Controller | ✅ |
| 08 | I²C Slave Controller | ✅ |
| 09 | CAN Bus Controller | ✅ |
| 10 | AXI4-Lite Master IP | ✅ |
| 11 | AXI4-Lite Slave IP | ✅ |
| 12 | RTL Integration Fundamentals | ✅ |
| 13 | I²C Master Controller | ✅ |
| 14 | UART Controller | ✅ |
| 15 | SDRAM Controller | ✅ |
| 16 | Multi-Port SDRAM Arbiter | ✅ |
| 17 | SPI Master IP Core | ✅ |
| 18 | Programmable Interrupt Controller | ✅ |
| 19 | AXI4-Lite Slave Peripheral | ✅ |
| 20 | DMA Controller | ✅ |
| 21 | Pipelined ALU | ✅ |
| 22 | Hazard Detection Unit | ✅ |
| 23 | Forwarding Unit | ✅ |
| 24 | 5-Stage Pipelined ALU | ✅ |
| 25 | Load-Use Hazard Detection | ✅ |
| 26 | Branch Control Unit | ✅ |
| 27 | RISC-V Pipeline Forwarding Unit | ✅ |
| 28 | Processor / RISC-V-Oriented RTL | ✅ |
| 29 | Two-Bit Branch Predictor | ✅ |
| 30 | Branch Target Buffer | ✅ |
| 31 | Return Address Stack | ✅ |
| 32 | Instruction Cache | ✅ |
| 33 | Write-Back Data Cache | ✅ |
| 34 | Advanced Cache / Memory-Hierarchy Development | ✅ |
| 35 | Advanced Cache / Memory-Hierarchy Development | ✅ |
| 36 | Advanced Cache / Memory-Hierarchy Development | ✅ |
| 37 | Multi-MSHR Non-Blocking Cache | ✅ |

Each project contains its own implementation and verification documentation. Projects that have entered the Yosys workflow additionally contain synthesis-related documentation and artifacts.

---

# 🧭 Design Progression

The overall learning progression is:

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

    Reusable RTL IP

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

    Return Address Prediction

          ↓

    Instruction Cache

          ↓

    Data Cache

          ↓

    Advanced Cache Architecture

          ↓

    Multi-MSHR Non-Blocking Cache

          ↓

    Yosys Synthesis

          ↓

    Open-Source ASIC Flow

---

# 🔬 Yosys RTL Synthesis

Yosys is now integrated into the portfolio through **Project 31**.

The current synthesis milestone is:

    Projects 01–31

            │

            ▼

          Yosys

            │

            ├── RTL Parsing

            ├── Hierarchy Analysis

            ├── Process Conversion

            ├── Logic Optimization

            ├── Design Statistics

            ├── Synthesized Netlist

            └── RTL Schematic

The synthesis workflow demonstrates the transition from behavioral RTL toward a synthesized hardware representation.

The general flow is:

    Verilog RTL

         ↓

    RTL Parsing

         ↓

    Hierarchy Analysis

         ↓

    Process Conversion

         ↓

    Logic Optimization

         ↓

    Technology-Independent Synthesis

         ↓

    Synthesized Netlist

         ↓

    RTL / Logic Schematic

---

# 🧪 Yosys-Enabled Projects

The current Yosys milestone covers:

| Project | Design | Yosys |
| ------: | ------------------------------------------ | :---: |
| 01 | Combinational Logic | ✅ |
| 02 | Sequential Logic | ✅ |
| 03 | FSM Fundamentals | ✅ |
| 04 | Utility RTL IPs | ✅ |
| 05 | SPI Master | ✅ |
| 06 | SPI Slave | ✅ |
| 07 | I²C Master | ✅ |
| 08 | I²C Slave | ✅ |
| 09 | CAN Bus Controller | ✅ |
| 10 | AXI4-Lite Master IP | ✅ |
| 11 | AXI4-Lite Slave IP | ✅ |
| 12 | RTL Integration Fundamentals | ✅ |
| 13 | I²C Master Controller | ✅ |
| 14 | UART Controller | ✅ |
| 15 | SDRAM Controller | ✅ |
| 16 | Multi-Port SDRAM Arbiter | ✅ |
| 17 | SPI Master IP Core | ✅ |
| 18 | Programmable Interrupt Controller | ✅ |
| 19 | AXI4-Lite Slave Peripheral | ✅ |
| 20 | DMA Controller | ✅ |
| 21 | Pipelined ALU | ✅ |
| 22 | Hazard Detection Unit | ✅ |
| 23 | Forwarding Unit | ✅ |
| 24 | 5-Stage Pipelined ALU | ✅ |
| 25 | Load-Use Hazard Detection | ✅ |
| 26 | Branch Control Unit | ✅ |
| 27 | RISC-V Pipeline Forwarding Unit | ✅ |
| 28 | Processor / RISC-V-Oriented RTL | ✅ |
| 29 | Two-Bit Branch Predictor | ✅ |
| 30 | Branch Target Buffer | ✅ |
| 31 | Return Address Stack | ✅ |

Each Yosys-enabled project focuses on connecting the original RTL with the resulting synthesized hardware structure.

Typical synthesis artifacts include:

    synth/

    ├── scripts/

    ├── netlists/

    └── schematics/

The exact directory structure varies between projects as the repository is progressively standardized.

---

# 🧠 Processor-Oriented RTL

The later projects increasingly focus on processor microarchitecture.

The processor development path currently covers:

- ALU execution
- Pipeline registers
- Processor datapaths
- Pipeline control
- RAW dependency detection
- Load-use hazards
- Data forwarding
- Branch decisions
- Pipeline flushing
- Branch prediction
- Branch target prediction
- Return address prediction
- Instruction caching
- Data caching
- Advanced cache architecture
- Multiple outstanding cache transactions

The goal is to understand how individual RTL blocks interact inside a pipelined processor and its memory hierarchy.

---

# 🏗 Processor Development Progression

The processor-oriented progression is:

    Pipelined ALU

          │

          ▼

    Hazard Detection

          │

          ▼

    Forwarding Unit

          │

          ▼

    5-Stage Pipeline

          │

          ▼

    Load-Use Hazard Handling

          │

          ▼

    Branch Control

          │

          ▼

    RISC-V-Oriented RTL

          │

          ▼

    Two-Bit Branch Predictor

          │

          ▼

    Branch Target Buffer

          │

          ▼

    Return Address Stack

          │

          ▼

    Instruction Cache

          │

          ▼

    Data Cache

          │

          ▼

    Advanced Cache Architecture

          │

          ▼

    Multi-MSHR Non-Blocking Cache

---

# 🧩 Processor Microarchitecture Concepts

## Datapath

- ALU Design
- Processor Datapath
- Pipeline Registers
- Operand Routing
- Execution Stages
- Pipeline Data Flow
- Cache Data Paths

## Hazard Handling

- RAW Dependencies
- Load-Use Hazards
- Pipeline Stalls
- Pipeline Bubbles
- Forwarding
- Operand Selection

## Control Flow

- Branch Decisions
- Pipeline Flushing
- Program Counter Redirection
- Branch Target Calculation
- Branch Prediction
- Branch Target Prediction
- Return Address Prediction

## Pipeline Control

- IF/ID Control
- ID/EX Control
- EX/MEM Control
- MEM/WB Control
- Stall Control
- Flush Control

---

# 🧠 Processor Prediction

Projects 29–31 introduce hardware structures that improve processor control-flow prediction.

## Project 29 — Two-Bit Branch Predictor

The project implements a two-bit saturating prediction mechanism.

Concepts include:

- Prediction states
- Strongly Taken
- Weakly Taken
- Weakly Not Taken
- Strongly Not Taken
- Prediction updates
- Saturating transitions
- Branch outcome tracking

The project demonstrates how recent branch behavior can be used to improve future predictions.

## Project 30 — Branch Target Buffer

The branch target buffer extends branch prediction by storing predicted branch targets.

Concepts include:

- Branch PC lookup
- Target storage
- Hit detection
- Target prediction
- Table updates
- PC-to-target association

This demonstrates how a processor can predict both branch direction and the destination address of a predicted branch.

## Project 31 — Return Address Stack

The return address stack provides hardware support for predicting function return addresses.

Concepts include:

- Push operations
- Pop operations
- Stack management
- Empty detection
- Full detection
- Return-address tracking
- Call / return behavior
- Sequential stack control

Project 31 is also the current endpoint of the Yosys synthesis workflow.

---

# 💾 Processor Memory Hierarchy

Projects 32 onward extend the processor work into increasingly advanced cache and memory-hierarchy designs.

    Project 32

    Instruction Cache

          │

          ▼

    Project 33

    Write-Back Data Cache

          │

          ▼

    Projects 34–36

    Advanced Cache Development

          │

          ▼

    Project 37

    Multi-MSHR Non-Blocking Cache

These projects introduce:

- Cache indexing
- Tags
- Valid bits
- Dirty bits
- Cache hits
- Cache misses
- Memory refill
- Cache replacement
- Write allocation
- Write-back behavior
- Multiple outstanding requests
- MSHR-based tracking

---

# Project 32 — Instruction Cache

Project 32 introduces an instruction cache into the processor instruction-fetch path.

The design focuses on:

- Direct-mapped cache organization
- Cache lines
- Address indexing
- Tag comparison
- Valid bits
- Cache hits
- Cache misses
- Instruction refill
- Memory interface behavior
- Cache lookup logic

The project establishes the basic cache architecture required before introducing writable data caching.

---

# Project 33 — Write-Back Data Cache

Project 33 extends caching into the processor data path.

The project implements a small direct-mapped data cache with:

- 32-bit addresses
- 32-bit data
- 8 cache lines
- Valid bits
- Dirty bits
- Tag storage
- Data storage
- Read hits
- Read misses
- Write hits
- Write misses
- Write allocation
- Write-back behavior
- Dirty-line eviction
- Cache refill
- Cache replacement
- Cache controller FSM

The project demonstrates the difference between cached data and main-memory data and introduces dirty-line handling for write-back caching.

---

# Project 37 — Multi-MSHR Non-Blocking Cache

Project 37 extends the cache architecture toward a **multi-MSHR non-blocking cache**.

The project focuses on:

- Multiple outstanding cache misses
- MSHR allocation
- MSHR ownership
- MSHR reuse
- Duplicate request detection
- Memory request tracking
- Out-of-order memory responses
- Cache-index generation tracking
- Stale response protection
- Write-miss data retention
- CPU-side response handling

The project was developed incrementally through multiple verification steps, with the latest verified milestone covering **Step 23 — Out-of-Order CPU Response Data**.

The final Step 23 verification completed successfully with:

    PASS COUNT = 9
    FAIL COUNT = 0
    MEMORY REQUESTS = 2

    PROJECT 37 STEP 23 VERIFICATION: PASS

Project 37 represents the next stage of cache development beyond a conventional write-back cache, introducing the ability to track multiple outstanding memory transactions.

---

# ⭐ Featured Projects

## Pipelined ALU

A modular 32-bit pipelined execution stage implementing arithmetic and logic operations together with pipeline registers and processor-oriented control.

Highlights:

- ALU Control
- ALU Execution
- Processor Flags
- Pipeline Register
- Hierarchical RTL
- Functional Verification

## Hazard Detection Unit

A processor pipeline control subsystem designed to detect RAW dependencies and generate pipeline stall behavior.

Highlights:

- Register Comparison
- Hazard Detection Logic
- Stall Generation
- Controller FSM
- Pipeline Control
- Functional Verification

## Forwarding Unit

A processor datapath subsystem designed to reduce RAW hazards by forwarding results from later pipeline stages to dependent operands.

Highlights:

- Register Dependency Comparison
- EX/MEM Hazard Detection
- MEM/WB Hazard Detection
- Forward-A Control
- Forward-B Control
- Operand Selection
- Functional Verification

## DMA Controller

A modular memory-to-memory DMA engine demonstrating autonomous hardware data movement.

Highlights:

- DMA Control
- Address Generation
- Transfer Counter
- DMA Controller FSM
- Top-Level Integration
- Functional Verification

## AXI4-Lite Slave Peripheral

A memory-mapped RTL peripheral demonstrating bus transactions and register-based control.

Highlights:

- Register File
- Address Decoder
- AXI Read Channel
- AXI Write Channel
- Top-Level Integration
- Functional Verification

## Programmable Interrupt Controller

A hardware interrupt-management block demonstrating interrupt prioritization and masking.

Highlights:

- Interrupt Sources
- Interrupt Masking
- Priority Encoder
- Interrupt Controller FSM
- CPU Interface

## SDRAM Controller

A memory controller implementing the basic control structure required for SDRAM operation.

Highlights:

- Initialization FSM
- Refresh Control
- Read Controller
- Write Controller
- Timing Generation

## Multi-Port SDRAM Arbiter

A shared-memory arbitration system designed to coordinate multiple memory request sources.

Highlights:

- Round-Robin Arbitration
- FIFO Scheduling
- Shared Memory Access
- Bus Multiplexing
- Arbitration FSM

## Instruction Cache

A direct-mapped instruction cache demonstrating basic cache lookup and refill behavior.

Highlights:

- Cache Indexing
- Tag Storage
- Valid Bits
- Hit Detection
- Miss Detection
- Instruction Refill
- Memory Interface

## Write-Back Data Cache

A direct-mapped writable data cache demonstrating cache hits, misses, dirty-line tracking, write allocation, write-back, and cache replacement.

Highlights:

- Direct-Mapped Cache
- Valid Bits
- Dirty Bits
- Tag Comparison
- Read Hits
- Read Misses
- Write Hits
- Write Misses
- Write Allocation
- Write-Back
- Dirty-Line Eviction
- Cache Refill
- Cache Controller FSM

## Multi-MSHR Non-Blocking Cache

An advanced cache architecture designed to track multiple outstanding memory transactions using multiple Miss Status Holding Registers.

Highlights:

- Multiple Outstanding Misses
- MSHR Allocation
- MSHR Ownership
- MSHR Reuse
- Duplicate Detection
- Out-of-Order Responses
- Cache Generation Tracking
- Stale Response Protection
- Write-Miss Data Retention
- Functional Verification

---

# 📖 Major Concepts Covered

## RTL Design

- Combinational Logic
- Sequential Logic
- Parameterized RTL
- Modular Design
- Hierarchical Design
- Reusable RTL IP
- RTL Integration
- Synchronous Design
- Control-Oriented RTL

## Processor Architecture

- ALU Design
- Processor Datapath
- Pipeline Registers
- Execution Stage Design
- Pipeline Control
- Hazard Detection
- Data Forwarding
- Branch Control
- Branch Prediction
- Branch Target Prediction
- Return Address Prediction
- Instruction Cache
- Data Cache
- Non-Blocking Cache Architecture

## Control Logic

- Finite State Machines
- Arbitration
- Scheduling
- Interrupt Handling
- DMA Control
- Hazard Detection
- Pipeline Stall Control
- Forwarding Control
- Cache Control
- Memory Transaction Control

## Memory Systems

- Register Files
- FIFO Buffers
- SDRAM Controllers
- DMA Address Generation
- Memory-Mapped Registers
- Memory Arbitration
- Instruction Caches
- Data Caches
- Cache Tags
- Valid Bits
- Dirty Bits
- Cache Refill
- Write-Back
- MSHR Tracking

## Communication Protocols

- UART
- SPI
- I²C
- CAN
- AXI4-Lite

## Bus & System Architecture

- AXI4-Lite Master
- AXI4-Lite Slave
- Address Decoding
- Multi-Port Arbitration
- DMA Architecture
- Memory-Mapped Peripheral Design

## Verification

- Verilog Testbenches
- Functional Verification
- Behavioral Models
- GTKWave Analysis
- VCD Generation
- Top-Level Integration
- System-Level Verification
- Waveform Debugging

## Synthesis

- Yosys RTL Synthesis
- RTL Hierarchy Analysis
- Process Conversion
- Logic Optimization
- Cell Statistics
- Synthesized Netlist Generation
- RTL Schematic Generation
- Technology-Independent Synthesis
- Hardware Structure Analysis

---

# 🎯 Skills Developed

- Verilog HDL
- RTL Design
- Digital Logic Design
- Processor Datapath Design
- ALU Design
- Pipeline Architecture
- Forwarding Logic
- Hazard Detection
- Branch Prediction
- Branch Target Prediction
- Return Address Prediction
- Cache Architecture
- Data Cache Design
- Instruction Cache Design
- Non-Blocking Cache Design
- MSHR Architecture
- Finite State Machine Design
- Memory Controller Design
- DMA Controller Design
- Interrupt Controller Design
- Communication Protocol Design
- Bus Interface Design
- RTL Verification
- Hierarchical Hardware Design
- Modular IP Development
- Processor Microarchitecture
- Hardware Debugging
- RTL Synthesis
- Yosys
- Netlist Analysis
- Git & GitHub Workflow

---

# 🔍 Verification Philosophy

Verification is treated as part of the design process rather than something added after RTL development.

The general approach is:

    Design

      ↓

    Identify Expected Behavior

      ↓

    Build Testbench

      ↓

    Run Simulation

      ↓

    Inspect Waveform

      ↓

    Debug

      ↓

    Re-verify

For more complex projects, verification focuses on both individual blocks and top-level behavior.

Important verification targets include:

- Reset behavior
- State transitions
- Control signals
- Data movement
- Boundary conditions
- Protocol timing
- Pipeline dependencies
- Cache hit/miss behavior
- Memory transactions
- Integration behavior

---


# 📁 Repository Structure

Each project is maintained independently so that its RTL, verification environment, and synthesis results can be inspected without unnecessarily depending on other projects.

A typical project may contain:

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

The exact directory structure varies depending on the project and the stage at which it entered the standardized workflow.

Generated simulation artifacts such as VCD files and compiled simulation binaries are kept outside version control where appropriate.

---


# 🧪 Simulation and Waveform Analysis

Simulation is primarily performed using:

    Icarus Verilog

          ↓

    VCD Generation

          ↓

    GTKWave

          ↓

    Waveform Analysis

GTKWave is used to inspect:

- Clock behavior
- Reset behavior
- FSM transitions
- Data paths
- Control signals
- Pipeline timing
- Memory transactions
- Cache hits
- Cache misses
- Write-back operations
- Refill behavior

Waveform analysis is particularly important for sequential RTL because many hardware problems are related to timing and state transitions rather than simple combinational correctness.

---

# 🧱 RTL Design Practices

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
- Readable and maintainable hardware descriptions

The RTL is written with the intention of making the hardware behavior understandable to another engineer.

---

# 📈 Current Learning Journey

The current learning progression can be summarized as:

    Digital Logic

          │

          ▼

    RTL Design

          │

          ▼

    Communication Protocols

          │

          ▼

    Memory Systems

          │

          ▼

    Bus Architectures

          │

          ▼

    RTL IP Development

          │

          ▼

    Processor Datapath Design

          │

          ▼

    Pipeline Architecture

          │

          ▼

    Hazard Detection

          │

          ▼

    Data Forwarding

          │

          ▼

    Branch Control

          │

          ▼

    Branch Prediction

          │

          ▼

    Return Address Prediction

          │

          ▼

    Instruction Cache

          │

          ▼

    Data Cache

          │

          ▼

    Advanced Cache Architecture

          │

          ▼

    Multi-MSHR Non-Blocking Cache

          │

          ▼

    RTL Synthesis

          │

          ▼

    ASIC Design

---

# 🧠 What I Am Learning

The objective of this repository is not simply to learn Verilog syntax.

The larger goal is to understand the complete digital hardware-development path:

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

Through these projects, I am developing practical understanding of:

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
- Forwarding
- Branch control
- Branch prediction
- Return address prediction
- Cache architecture
- Memory hierarchy
- Non-blocking cache concepts
- RTL verification
- Waveform debugging
- RTL synthesis
- Hardware structure after synthesis

---

# 🗺️ Explore the Projects

For digital-design fundamentals:

    Projects 01–04

For communication RTL:

    Projects 05–09

    Projects 12–14

For system-level interfaces, memory, interrupts, and data movement:

    Projects 10–20

For processor and pipeline architecture:

    Projects 21–28

For processor prediction:

    Projects 29–31

For processor memory hierarchy:

    Projects 32–37

For Yosys synthesis:

    Projects 01–31

Each project contains its own documentation, RTL, verification environment, and relevant implementation artifacts.

---

# 🏁 Current Milestone

The repository has now progressed from basic RTL exercises into a processor-oriented hardware portfolio.

    37 RTL Projects

          │

          ▼

    Digital Logic

          │

          ▼

    Communication + System IP

          │

          ▼

    Memory + DMA

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

    Return Address Prediction

          │

          ▼

    Instruction Cache

          │

          ▼

    Write-Back Data Cache

          │

          ▼

    Advanced Cache Architecture

          │

          ▼

    Multi-MSHR Non-Blocking Cache

At the same time, the synthesis workflow has progressed through **Project 31 using Yosys**, creating a bridge between RTL design and synthesized hardware.

The portfolio is therefore developing along two connected tracks:

    RTL / Processor Architecture

                │

                ├───────────────┐

                │               │

                ▼               ▼

        Processor Design      Yosys

                │               │

                ▼               ▼

        Memory Hierarchy    Synthesis

                │               │

                └───────┬───────┘

                        ▼

              Open-Source ASIC Flow

---


# 👨‍💻 Author

**Omm Prakash Sahoo**

**B.Tech | Electronics & Communication Engineering**

## Core Engineering Domains

- RTL Design & Verification
- FPGA Design
- Processor Microarchitecture
- Digital Hardware Architecture
- Memory Controller Design
- Cache Architecture
- Bus Interface Design
- DMA & Interrupt Controller Design
- Pipeline & Hazard Control
- ASIC Design Fundamentals
- Embedded Systems
- Edge AI Hardware

---

# 🌟 Repository Vision

This repository is being developed as a long-term collection of reusable RTL IP cores, processor subsystems, and digital hardware projects.

The emphasis is on:

- Modularity
- Verification
- Documentation
- Synthesis
- Hardware understanding
- Continuous improvement
- Practical engineering workflows

Each completed project strengthens the foundation for more advanced topics including FPGA systems, SoC architecture, RISC-V processor design, ASIC implementation, and hardware acceleration.

The portfolio is progressively moving from:

**Digital RTL → System RTL → Processor RTL → Memory Hierarchy → Non-Blocking Cache Architecture → Yosys Synthesis → ASIC-Oriented Hardware Design**

---

⭐ **If you find this repository useful, consider giving it a star!**