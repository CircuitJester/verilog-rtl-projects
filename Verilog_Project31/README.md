# Project 31 — Return Address Stack (RAS)

## Overview

This project implements a small Return Address Stack (RAS) in Verilog as a processor microarchitecture component for predicting function return addresses.

A Return Address Stack is commonly used in modern processors to improve the prediction of return instructions. When a function call occurs, the return address can be pushed into the stack. When the corresponding return instruction is encountered, the most recently stored return address is popped and used as the predicted return target.

The design implemented in this project contains an 8-entry stack with 32-bit return addresses and supports push, pop, reset, empty detection, and full detection.

The project was designed to understand how a relatively small hardware structure can improve instruction-flow prediction inside a processor.

## Architecture

```text
                    Function Call
                         |
                         | return_address
                         v
                  +--------------+
                  |              |
                  |     RAS      |
                  |              |
                  |  8 Entries   |
                  |  32-bit each |
                  |              |
                  +------+-------+
                         |
                         | Top Entry
                         v
              predicted_return_address
                         |
                         v
                  Processor Fetch
```

## Main Features
- 8-entry return address stack
- 32-bit return addresses
- Push operation
- Pop operation
- Synchronous reset
- Empty detection
- Full detection
- LIFO operation
- Protection against stack overflow
- Protection against stack underflow
- Combinational top-of-stack prediction
- Parameterized stack depth
- RTL-level verification
- GTKWave waveform analysis


## Project Structure
```
Verilog_Project31/
├── build/
├── tb/
│   └── tb_return_address_stack.v
├── verification/
├── verilogcode/
│   └── return_address_stack.v
├── waves/
│   └── return_address_stack.vcd
└── README.md
```

## Tools Used

- Verilog HDL
- Icarus Verilog
- GTKWave
- VS Code
- WSL / Linux
- Git
- GitHub