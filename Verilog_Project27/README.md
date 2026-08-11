# Project 27 — RISC-V Pipeline Forwarding Unit

## Overview

This project implements a forwarding unit for a 5-stage pipelined processor datapath using Verilog HDL.

The forwarding unit is responsible for resolving data hazards that occur when an instruction in the Execute stage requires a register value that is still being produced by an earlier instruction in the pipeline.

Instead of stopping the pipeline every time a dependency occurs, the forwarding unit detects when a newer value is already available in the EX/MEM or MEM/WB pipeline stages and generates control signals that allow the datapath to select the correct forwarded value.

The design focuses specifically on RAW (Read After Write) hazards and demonstrates how forwarding reduces unnecessary pipeline stalls while maintaining correct instruction execution.

The project was designed as a standalone RTL block so that the forwarding logic can later be integrated into a larger RISC-V pipelined processor.



## Forwarding Concept

Consider the following instruction sequence:

    ADD  x5, x1, x2
    SUB  x6, x5, x3

The `SUB` instruction needs the newly calculated value of `x5`, but the value may not have reached the register file yet.

Without forwarding, the processor may need to stall the pipeline.

With forwarding, the ALU can receive the recently calculated value directly from a later pipeline stage.

    EX/MEM result
          |
          v
    +-------------+
    |  Forwarding |
    |    Unit     |
    +-------------+
          |
          +-----------> ALU Operand A
          |
          +-----------> ALU Operand B

This allows dependent instructions to continue through the pipeline without waiting for normal register write-back.



## Forwarding Sources

The forwarding unit considers two possible sources:

    1. EX/MEM pipeline register
    2. MEM/WB pipeline register

The EX/MEM stage has higher priority because it contains a more recent result than MEM/WB.

The forwarding encoding used by the design is:

    2'b00 -> Use normal register-file value
    2'b01 -> Forward value from MEM/WB
    2'b10 -> Forward value from EX/MEM

The same encoding is used independently for both ALU operands.



## Forwarding Decisions

For the first ALU operand:

    if EX/MEM writes the register required by ID/EX.rs1
        forward_a = 2'b10

    else if MEM/WB writes the register required by ID/EX.rs1
        forward_a = 2'b01

    else
        forward_a = 2'b00

For the second ALU operand:

    if EX/MEM writes the register required by ID/EX.rs2
        forward_b = 2'b10

    else if MEM/WB writes the register required by ID/EX.rs2
        forward_b = 2'b01

    else
        forward_b = 2'b00

Register x0 is excluded from forwarding because it is hardwired to zero in a RISC-V register file.



## Priority Handling

One of the important parts of the design is handling the situation where both EX/MEM and MEM/WB appear to contain a value for the same source register.

For example:

    EX/MEM:
        rd = x10
        reg_write = 1

    MEM/WB:
        rd = x10
        reg_write = 1

    ID/EX:
        rs1 = x10

The EX/MEM value must be selected because it represents the newer result.

Therefore:

    forward_a = 2'b10

rather than:

    forward_a = 2'b01

This priority is implemented directly through the conditional structure of the forwarding logic.



## Module

### forwarding_unit.v

The main RTL module receives:

    ex_mem_rd
    ex_mem_reg_write
    mem_wb_rd
    mem_wb_reg_write
    id_ex_rs1
    id_ex_rs2

and produces:

    forward_a
    forward_b

The outputs are combinational control signals used by the processor datapath to select the appropriate ALU input source.



## Verification

The design was verified using a dedicated Verilog testbench and GTKWave waveform analysis.

The testbench exercises the major forwarding scenarios:

    - EX/MEM forwarding to operand A
    - EX/MEM forwarding to operand B
    - MEM/WB forwarding to operand A
    - MEM/WB forwarding to operand B
    - Simultaneous forwarding for both operands
    - No dependency between pipeline stages
    - Register-write disabled conditions
    - Register x0 dependency
    - EX/MEM versus MEM/WB priority

The waveform was inspected using GTKWave to verify that the forwarding control signals respond correctly to changes in register dependencies and write-enable signals.




## Project Structure

    Verilog_Project27/
    |
    +-- verilogcode/
    |   +-- forwarding_unit.v
    |
    +-- tb/
    |   +-- tb_forwarding_unit.v
    |
    +-- verification/
    |
    +-- waves/
    |   +-- forwarding_unit.vcd
    |
    +-- build/
    |
    +-- README.md



## Simulation

Compile the RTL and testbench with Icarus Verilog:

    iverilog -g2012 \
    -o build/forwarding_unit_tb.vvp \
    verilogcode/forwarding_unit.v \
    tb/tb_forwarding_unit.v

Run the simulation:

    vvp build/forwarding_unit_tb.vvp

Open the generated waveform:

    gtkwave waves/forwarding_unit.vcd



## Tools Used

    Verilog HDL
    Icarus Verilog
    GTKWave
    VS Code
    WSL / Linux



## Learning Outcomes

This project provided practical experience with:

    - Data hazards in pipelined processors
    - RAW (Read After Write) hazards
    - Register dependency detection
    - Operand forwarding
    - EX/MEM and MEM/WB pipeline stages
    - Combinational control logic
    - Forwarding priority
    - Register-write qualification
    - RISC-V register x0 handling
    - ALU operand selection
    - RTL module design
    - Verilog testbench development
    - VCD waveform generation
    - GTKWave-based verification
    - Debugging pipeline control behavior

More importantly, the project demonstrates how a processor can maintain pipeline throughput by resolving data dependencies through hardware forwarding rather than relying entirely on pipeline stalls.



## Project Significance

This project extends the earlier pipelined processor work by adding an important performance-oriented mechanism.

The previous pipeline projects established the basic 5-stage datapath, pipeline registers, hazard detection, and branch control. This project adds the forwarding mechanism required to reduce unnecessary stalls caused by data dependencies.

Together, these components move the design closer to a practical pipelined RISC-V processor architecture.