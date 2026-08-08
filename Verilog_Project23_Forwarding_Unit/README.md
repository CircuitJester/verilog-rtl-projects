# Project 23 — Processor Forwarding Unit

A modular **Verilog RTL implementation of a processor forwarding unit** designed to resolve data hazards in a pipelined processor datapath.

The project detects register dependencies between the current instruction and results available in the **EX/MEM** and **MEM/WB** pipeline stages, generates forwarding decisions, and selects the correct operand values for the ALU.

The design is implemented using a hierarchical RTL architecture and completely verified using dedicated Verilog testbenches and GTKWave waveform analysis.

---

# Objective

In a pipelined processor, consecutive instructions may depend on results that have not yet been written back to the register file.

For example:

```text
ADD x10, x5, x6
SUB x12, x10, x7
```


# Architecture
```

                    Forwarding Unit
                           │
             ┌─────────────┴─────────────┐
             │                           │
             ▼                           ▼
     Register Comparator          Register Comparator
           (RS1)                       (RS2)
             │                           │
             └─────────────┬─────────────┘
                           ▼
                Forwarding Control Logic
                           │
                    ┌──────┴──────┐
                    ▼             ▼
                forward_a     forward_b
                    │             │
                    ▼             ▼
                Forwarding     Forwarding
                  MUX A           MUX B
                    │             │
                    ▼             ▼
                ALU Operand A  ALU Operand B

```
                