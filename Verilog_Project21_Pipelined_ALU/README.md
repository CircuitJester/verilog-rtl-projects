# Project 21 – Pipelined ALU

## Overview

This project implements a modular **32-bit Pipelined Arithmetic Logic Unit (ALU)** in Verilog HDL. Unlike a conventional combinational ALU, this design introduces a pipeline register to synchronize computation results and processor status flags, closely resembling the execution stage of a pipelined processor.

The design follows a hierarchical RTL architecture where each functional block is implemented, verified, and integrated independently before performing complete system-level verification.

---

# Architecture

```
                 Opcode
                    │
                    ▼
          +------------------+
          |   ALU Control    |
          +------------------+
                    │
                    ▼
Operand A ─────────►│
                    │
Operand B ─────────►│
          +------------------+
          |   ALU Execute    |
          +------------------+
                    │
                    ▼
          +------------------+
          |  Flag Generator  |
          +------------------+
                    │
                    ▼
          +----------------------+
          | Pipeline Register    |
          +----------------------+
                    │
                    ▼
        Registered Result & Flags
```

---


# Features

- 32-bit Parameterized ALU
- Modular RTL Architecture
- Opcode-Based ALU Control
- Arithmetic Operations
- Logical Operations
- Shift Operations
- Compare Operations
- Processor Status Flag Generation
- Pipeline Register
- Hierarchical Top-Level Integration
- Complete Functional Verification

---

# Supported Operations

| Opcode | Operation |
|---------|-----------|
|000|Addition|
|001|Subtraction|
|010|AND|
|011|OR|
|100|XOR|
|101|Logical Left Shift|
|110|Logical Right Shift|
|111|Compare|

---

# Status Flags

The ALU generates the following processor status flags:

- Zero Flag
- Carry Flag
- Negative Flag
- Overflow Flag

---

# Modules

## 1. ALU Control

Converts instruction opcode into internal ALU control signals.

---

## 2. ALU Execute

Performs arithmetic and logical operations.

---

## 3. ALU Flag Generator

Generates processor status flags from the ALU result.

---

## 4. Pipeline Register

Registers the ALU output and status flags using synchronous logic.

---

## 5. Top-Level Integration

Integrates all submodules into a complete pipelined execution stage.

---

# Verification

Each module was verified independently before complete top-level integration.

Verification includes:

- Individual Module Simulation
- Top-Level Simulation
- Analysis
- Functional Verification
- Pipeline Register Timing Verification

---

# Concepts Covered

- Verilog HDL
- RTL Design
- Processor Datapath Design
- ALU Architecture
- Pipeline Registers
- Control Path & Datapath Separation
- Processor Status Flags
- Hierarchical RTL Design
- Functional Verification

---

# Learning Outcomes

Through this project, the following concepts were implemented and verified:

- Modular RTL Development
- Processor Execution Stage Design
- Synchronous Sequential Logic
- Combinational Logic Design
- Pipeline Stage Implementation
- System-Level Integration
- Hardware Verification Methodology

---

# Future Improvements

- Barrel Shifter
- Arithmetic Shift Operations
- Signed Overflow Detection
- Multiply/Divide Unit
- Forwarding Logic
- Hazard Detection Unit
- Multi-stage Pipeline Integration

---

# Skills Demonstrated

- RTL Design
- Processor Architecture Fundamentals
- ALU Design
- Pipeline Design
- FSM Understanding
- Digital Logic Design
- Hardware Verification
- Hierarchical Design
- Git & GitHub Workflow