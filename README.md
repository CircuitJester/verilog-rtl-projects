# 🚀 Verilog RTL Design

A continuously growing collection of **industry-oriented Verilog HDL projects** focused on **RTL Design, Digital System Design, FPGA Development, and ASIC Design Fundamentals**.

This repository documents my journey from basic digital logic to advanced communication protocols, memory controllers, bus architectures, DMA engines, interrupt controllers, processor datapath components, pipeline control, and reusable RTL IP cores.

Every project follows a structured engineering workflow including RTL implementation, verification, documentation, synthesis, and version control.

Projects **01–21** additionally follow a structured **Yosys RTL synthesis workflow**, including synthesis scripts, synthesized netlists, and RTL schematic generation.

---

# 📊 Repository Statistics

| Category                |    Count |
| ----------------------- | -------: |
| Projects Completed      |   **26** |
| Verilog Modules         | **130+** |
| Testbenches             | **130+** |
| GTKWave Simulations     | **110+** |
| Yosys Synthesis Projects|   **21** |
| Communication Protocols |   **6+** |
| Processor Subsystems    |   **6+** |
| Memory Systems          |    **4+** |
| Bus Architectures       |    **3+** |
| RTL IP Cores            |   **26** |

---

# 🛠 Engineering Workflow

Projects follow a structured RTL development methodology.

For projects using simulation-based verification:

```text
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
GTKWave Analysis
        │
        ▼
System Integration
        │
        ▼
Documentation
        │
        ▼
Git Version Control
```

For projects integrated with the Yosys synthesis workflow:

```text
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
```

---

# 💻 Technology Stack

## Languages

- Verilog HDL

## Simulation & Verification

- Icarus Verilog
- GTKWave

## RTL Synthesis

- Yosys

## Development Environment

- Visual Studio Code
- Ubuntu (WSL)
- Git
- GitHub

---

# 📚 Project Roadmap

| Project | Topic                              | Status |
| ------: | ---------------------------------- | :----: |
|       1 | Combinational Logic                |   ✅   |
|       2 | Sequential Logic                   |   ✅   |
|       3 | FSM Fundamentals                   |   ✅   |
|       4 | Utility RTL IPs                    |   ✅   |
|       5 | SPI Master                         |   ✅   |
|       6 | SPI Slave                          |   ✅   |
|       7 | I²C Master Controller              |   ✅   |
|       8 | I²C Slave Controller               |   ✅   |
|       9 | CAN Bus Controller                 |   ✅   |
|      10 | AXI4-Lite Master IP                |   ✅   |
|      11 | AXI4-Lite Slave IP                 |   ✅   |
|      12 | RTL Integration Fundamentals       |   ✅   |
|      13 | I²C Master Controller              |   ✅   |
|      14 | UART Controller                    |   ✅   |
|      15 | SDRAM Controller                   |   ✅   |
|      16 | Multi-Port SDRAM Arbiter           |   ✅   |
|      17 | SPI Master IP Core                 |   ✅   |
|      18 | Programmable Interrupt Controller  |   ✅   |
|      19 | AXI4-Lite Slave Peripheral         |   ✅   |
|      20 | DMA Controller                     |   ✅   |
|      21 | Pipelined ALU                      |   ✅   |
|      22 | Hazard Detection Unit              |   ✅   |
|      23 | Forwarding Unit                    |   ✅   |
|      24 | 5-Stage Pipelined ALU              |   ✅   |
|      25 | Hazard Detection Unit              |   ✅   |
|      26 | Data Forwarding Unit               |   ✅   |

---

# 🔬 Yosys RTL Synthesis

Projects **01–21** have been integrated into the repository's RTL synthesis workflow using **Yosys**.

The synthesis workflow demonstrates the transition from Verilog RTL toward a synthesized hardware representation.

## Yosys Workflow

```text
Verilog RTL
     │
     ▼
Yosys RTL Parsing
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
Technology-Independent Synthesis
     │
     ├──────────────► Synthesized Netlist
     │
     └──────────────► RTL Schematic
```

## Yosys-Enabled Projects

| Project | Design                         | Yosys |
| ------: | ------------------------------ | :---: |
| 01      | Combinational Logic            |  ✅   |
| 02      | Sequential Logic               |  ✅   |
| 03      | FSM Fundamentals               |  ✅   |
| 04      | Utility RTL IPs                |  ✅   |
| 05      | SPI Master                     |  ✅   |
| 06      | SPI Slave                      |  ✅   |
| 07      | I²C Master                     |  ✅   |
| 08      | I²C Slave                      |  ✅   |
| 09      | CAN Bus Controller             |  ✅   |
| 10      | AXI4-Lite Master IP            |  ✅   |
| 11      | AXI4-Lite Slave IP             |  ✅   |
| 12      | RTL Integration Fundamentals   |  ✅   |
| 13      | I²C Master Controller          |  ✅   |
| 14      | UART Controller                |  ✅   |
| 15      | SDRAM Controller               |  ✅   |
| 16      | Multi-Port SDRAM Arbiter       |  ✅   |
| 17      | SPI Master IP Core             |  ✅   |
| 18      | Programmable Interrupt Control |  ✅   |
| 19      | AXI4-Lite Slave Peripheral     |  ✅   |
| 20      | DMA Controller                 |  ✅   |
| 21      | Pipelined ALU                  |  ✅   |

Each Yosys-enabled project contains:

- Yosys synthesis scripts
- RTL hierarchy analysis
- Logic optimization
- Cell statistics
- Synthesized Verilog netlists
- RTL schematic generation
- Synthesis command documentation

---

# ⭐ Featured Projects

## Pipelined ALU

A modular **32-bit pipelined execution stage** implementing instruction decoding, arithmetic and logic execution, processor flag generation, and synchronous pipeline registers.

**Highlights**

- ALU Control Unit
- ALU Execution Unit
- Processor Flag Generator
- Pipeline Register
- Hierarchical RTL Design
- Complete System-Level Verification

---

## Hazard Detection Unit

A processor pipeline control subsystem capable of detecting RAW data hazards, generating stall signals, and controlling pipeline execution using an FSM-based controller.

**Highlights**

- Register Comparator
- Pipeline Stall Generator
- Hazard Detection Logic
- Hazard Controller FSM
- Top-Level Hazard Detection Unit
- Complete Functional Verification

---

## Forwarding Unit

A processor pipeline datapath subsystem designed to reduce RAW data hazards by forwarding results from later pipeline stages directly back to dependent execution-stage operands.

**Highlights**

- Register Dependency Comparison
- EX/MEM Hazard Detection
- MEM/WB Hazard Detection
- Forward-A Control Logic
- Forward-B Control Logic
- Pipeline Dependency Analysis
- Modular RTL Architecture
- Complete Functional Verification

---

## DMA Controller

A modular memory-to-memory DMA engine demonstrating autonomous hardware operation using dedicated control logic, address generation, transfer counting, and an FSM-based controller.

**Highlights**

- DMA Control Register
- Address Generator
- Transfer Counter
- DMA Controller FSM
- Top-Level Integration
- Functional Verification

---

## AXI4-Lite Slave Peripheral

**Highlights**

- Register File
- Address Decoder
- AXI Read Channel
- AXI Write Channel
- Top-Level Integration
- Functional Verification

---

## Programmable Interrupt Controller

**Highlights**

- 8 Interrupt Sources
- Interrupt Mask Register
- Fixed Priority Encoder
- Interrupt Controller FSM
- CPU Interface

---

## Multi-Port SDRAM Arbiter

**Highlights**

- Round Robin Arbitration
- FIFO Scheduling
- Shared Memory Access
- Bus Multiplexer
- Arbitration FSM

---

## SDRAM Controller

**Highlights**

- Initialization FSM
- Refresh Controller
- Read Controller
- Write Controller
- Timing Generator

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

## Processor Architecture

- ALU Design
- Processor Datapath
- Pipeline Registers
- Status Flag Generation
- Execution Stage Design
- Hazard Detection
- Data Forwarding
- Pipeline Control
- RAW Dependency Resolution

## Control Logic

- Finite State Machines (FSM)
- Arbitration
- Scheduling
- Interrupt Handling
- DMA Control
- Hazard Detection
- Pipeline Stall Control
- Forwarding Control

## Memory Systems

- Register Files
- FIFO Buffers
- SDRAM Controllers
- DMA Address Generation
- Memory-Mapped Registers
- Memory Arbitration

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
- GTKWave Analysis
- Top-Level Integration
- System-Level Verification
- Waveform Debugging

## Synthesis

- Yosys RTL Synthesis
- RTL Hierarchy Analysis
- Logic Optimization
- Cell Statistics
- Synthesized Netlist Generation
- RTL Schematic Generation
- Technology-Independent Synthesis

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
- Finite State Machine (FSM) Design
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

# 📈 Current Learning Journey

```text
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
FPGA System Design
      │
      ▼
RTL Synthesis
      │
      ▼
ASIC Design
```

---


# 👨‍💻 Author

**Omm Prakash Sahoo**

**B.Tech | Electronics & Communication Engineering**

## ⚡ Core Engineering Domains

- 🔹 RTL Design & Verification
- 🔹 FPGA Design
- 🔹 Processor Microarchitecture
- 🔹 Digital Hardware Architecture
- 🔹 Memory Controller Design
- 🔹 Bus Interface Design
- 🔹 DMA & Interrupt Controller Design
- 🔹 Pipeline & Hazard Control
- 🔹 ASIC Design Fundamentals
- 🔹 Embedded Systems
- 🔹 Edge AI Hardware

---

## 🌟 Repository Vision

This repository is being developed as a long-term collection of reusable RTL IP cores and digital hardware projects. It follows industry-style design practices with an emphasis on modularity, verification, documentation, synthesis, and continuous improvement.

Each completed project strengthens the foundation for more advanced topics including FPGA systems, SoC architecture, processor design, and ASIC implementation.

---

⭐ **If you find this repository helpful, consider giving it a star!**