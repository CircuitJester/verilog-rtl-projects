# Project 19 – AXI4-Lite Slave Peripheral

## Overview

This project implements a modular AXI4-Lite Slave Peripheral in Verilog HDL. The design provides a memory-mapped peripheral interface capable of receiving AXI4-Lite read and write transactions and accessing an internal register file through address decoding logic.

The architecture is divided into independent RTL modules for address decoding, AXI read handling, AXI write handling, and register storage before being integrated into the complete AXI4-Lite slave peripheral.

The project follows a structured RTL development methodology including modular RTL design, dedicated verification, hierarchical integration, Yosys synthesis, synthesized netlist generation, and RTL schematic analysis.

## Features

- AXI4-Lite Read Channel
- AXI4-Lite Write Channel
- Address Decoder
- Memory-Mapped Register File
- AXI4-Lite Slave Top-Level Integration
- Modular RTL Architecture
- Dedicated Verification Environment
- System-Level Verification
- Yosys RTL Synthesis
- Synthesized Netlist Generation
- RTL Schematic Generation




## Peripheral Architecture

```text
                  AXI4-Lite Interface
                         |
              +----------+----------+
              |                     |
              v                     v
       AXI Write Channel     AXI Read Channel
              |                     |
              +----------+----------+
                         |
                         v
                  Address Decoder
                         |
                         v
                    Register File
```



## Verification

The RTL modules are accompanied by dedicated Verilog testbenches.

The verification environment covers:

- Address Decoder Operation
- Register File Access
- AXI Write Transactions
- AXI Read Transactions
- AXI Slave Integration
- Memory-Mapped Register Access
- System-Level Peripheral Behavior


## Synthesis

The RTL design was synthesized using Yosys.

The synthesis workflow includes:

- RTL elaboration
- Hierarchy analysis
- Process conversion
- Logic optimization
- Design statistics
- Synthesized netlist generation
- RTL schematic generation

Each major RTL module was synthesized independently, followed by synthesis of the complete `axi_slave_top` design.

The synthesis flow explicitly selects the intended top-level module before schematic generation to ensure that the generated schematic represents the correct design hierarchy.

## Project Structure

```text
Verilog_Project19/
│
├── build/
│
├── RTL/
│   ├── address_decoder.v
│   ├── axi_read_channel.v
│   ├── axi_slave_top.v
│   ├── axi_write_channel.v
│   └── register_file.v
│
├── tb/
│   ├── tb_address_decoder.v
│   ├── tb_axi_read_channel.v
│   ├── tb_axi_slave_top.v
│   ├── tb_axi_write_channel.v
│   └── tb_register_file.v
│
├── Verification/
│
├── synth/
│   ├── netlists/
│   ├── schematics/
│   └── scripts/
│
├── waves/
│
├── README.md
└── command.md
```

## Learning Outcomes

During this project I learned:

- AXI4-Lite slave architecture
- Memory-mapped peripheral design
- AXI read and write channel handling
- Address decoding
- Register file architecture
- Ready/Valid handshake concepts
- Modular RTL design
- Hierarchical hardware integration
- Dedicated RTL verification
- Yosys synthesis
- Synthesized netlist generation
- RTL schematic analysis