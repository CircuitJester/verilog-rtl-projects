# Verilog RTL Design

This repository is where I have been building my Verilog RTL skills through a growing set of digital design and hardware projects.

I started with basic combinational and sequential logic and gradually moved into FSMs, communication interfaces, memory systems, AXI4-Lite, DMA, interrupt control and processor-oriented RTL. As the projects became more involved, I also added simulation, waveform analysis and Yosys synthesis to the workflow.

The goal is simple: **write the RTL, verify it, inspect what the synthesis tool produces, and understand why the hardware looks the way it does.**

---

## What is in the repository

The repository currently contains **27 project directories** with:

* **411 Verilog/SystemVerilog source files**
* **143 testbench-related files**
* **122 Yosys synthesis scripts**
* **121 synthesized netlists**
* **120 RTL schematics**
* **143 waveform images**

These counts are based on the current repository contents and include supporting RTL, verification and synthesis artifacts.

The Yosys flow currently covers **Projects 01–21**. Projects 22–27 are focused on processor and pipeline concepts and have not yet been added to the repository's Yosys flow.

---

## Design Progression

The projects follow a gradual progression rather than being treated as isolated Verilog exercises.

```text
Digital Logic
      ↓
Sequential RTL
      ↓
FSMs, Timers, PWM and FIFO
      ↓
SPI / I²C / CAN
      ↓
AXI4-Lite
      ↓
Communication IP
      ↓
SDRAM and Arbitration
      ↓
Interrupts / DMA / System IP
      ↓
Pipeline and Processor RTL
      ↓
RISC-V-oriented concepts
```

---

## Project Areas

### Digital Design Foundations

The early projects cover the building blocks used throughout the later designs:

* Combinational logic
* Sequential logic
* Registers
* Counters
* Adders
* ALU logic
* Priority encoders

### FSM and Control Logic

The next stage moves into state-based hardware and timing-related blocks:

* Finite State Machines
* UART control
* Timers
* PWM
* FIFO
* Sequence detection
* Control-oriented RTL

### Communication Interfaces

I implemented several common digital communication interfaces at the RTL level:

* SPI Master
* SPI Slave
* I²C Master
* I²C Slave
* UART
* CAN

The projects include both protocol-level control logic and smaller supporting blocks such as counters, shift registers, clock generation and FSMs.

### Bus and System Interfaces

The repository then moves toward system-level interfaces:

* AXI4-Lite Master
* AXI4-Lite Slave
* AXI4-Lite peripheral logic
* Address decoding
* Bus multiplexing

### Memory and Data Movement

The later system-oriented projects include:

* SDRAM Controller
* Multi-Port SDRAM Arbiter
* DMA Controller
* Request FIFO
* Arbitration logic

### Processor-Oriented RTL

The most recent part of the repository focuses on pipeline and processor datapath concepts:

* Pipelined ALU
* Hazard Detection Unit
* Forwarding Unit
* 5-stage pipeline concepts
* Branch Control
* RISC-V-oriented forwarding logic

These projects are helping me understand how individual RTL blocks fit together inside a pipelined processor.

---

## Verification Workflow

For most projects, I follow a simple RTL development loop:

```text
RTL Design
    ↓
Testbench
    ↓
Simulation
    ↓
Waveform Analysis
    ↓
Synthesis
    ↓
Netlist / Schematic Inspection
```

Simulation is mainly used to check functional behavior and understand timing and state transitions.

The waveform artifacts are kept with the projects so that the verification process is visible instead of only showing the final RTL source.

---

## Yosys Synthesis

I use Yosys to synthesize the RTL in Projects 01–21 and inspect the resulting netlists and RTL schematics.

The current synthesis work includes commands and flows around:

* RTL elaboration
* Hierarchy checking
* Process conversion
* Optimization
* Technology mapping
* Module selection
* Statistics
* Netlist generation
* RTL schematic generation

The repository currently contains Yosys scripts throughout Projects 01–21.

For example, the synthesis directories contain generated Verilog netlists and schematic outputs alongside the scripts used to produce them.

This has been useful for connecting the RTL I write with the hardware structure produced by synthesis.

---

## Selected Project Progression

| Project | Focus |
|---|---|
| [01](Verilog_Project01/) | Combinational Logic |
| [02](Verilog_Project02/) | Sequential Logic |
| [03](Verilog_Project03/) | FSMs and UART Controllers |
| [04](Verilog_Project04/) | Timers, PWM and FIFO |
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
| [25](Verilog_Project25/) | Hazard Detection Unit |
| [26](Verilog_Project26/) | Branch Control Unit |
| [27](Verilog_Project27/) | RISC-V Pipeline Forwarding Unit |

Some later projects revisit related concepts from an architectural or processor-oriented perspective. The individual project READMEs contain the implementation details for each design.

---

## Repository Structure

Each project is kept separate so that the RTL, verification and synthesis work can be inspected independently.

A typical project follows a structure similar to:

```text
Verilog_ProjectXX/
├── README.md
├── RTL/
├── tb/
├── synth/
│   ├── scripts/
│   ├── netlists/
│   └── schematics/
└── waveforms/
```

The exact structure varies between projects depending on what the design needs.

---

## Tools

The main tools used across the repository are:

* Verilog HDL
* SystemVerilog where applicable
* Icarus Verilog
* GTKWave
* Yosys
* Linux / WSL
* Git and GitHub

The toolchain is intentionally kept lightweight so that the designs can be written, simulated and synthesized locally.

---

## What I am learning through these projects

The main thing I am trying to build is not just familiarity with Verilog syntax.

I am working toward understanding the complete path from a hardware idea to an implementation that can be verified and synthesized.

That means getting more comfortable with:

* RTL architecture
* Synchronous design
* FSM design
* Pipeline control
* Protocol implementation
* Memory interfaces
* Bus protocols
* Verification
* Synthesis
* Hardware structure after synthesis

---

## Current Direction

The next step is to move further from individual RTL blocks toward larger hardware systems.

My current learning path is moving toward:

```text
RTL Design
    ↓
FPGA Design
    ↓
Yosys
    ↓
OpenROAD
    ↓
Open-Source ASIC Flow
    ↓
RISC-V Hardware
```

This repository is the RTL foundation for that progression.

---

## Explore the Projects

If you are mainly interested in digital design, start with Projects 01–04.

For communication RTL, look at Projects 05–09 and 12–14.

For system-level interfaces and memory, look at Projects 10–20.

For processor and pipeline concepts, start with Projects 21–27.

Each project contains its own README and implementation files so the design can be explored in more detail.

---

## Notes

This repository is an active learning and engineering portfolio. Some designs are more mature than others, and I am continuing to improve the verification and synthesis flow as I learn more.

The later projects are also becoming a bridge toward my broader FPGA, ASIC and processor-design work.
