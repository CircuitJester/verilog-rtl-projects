# Programmable Interrupt Controller (PIC)

A parameterized 8-channel Programmable Interrupt Controller (PIC) written in Verilog. This project demonstrates how modern processors receive, prioritize, mask, and service multiple interrupt requests using a modular RTL architecture.



## Overview

This project implements a complete interrupt controller capable of:

- Capturing interrupt requests
- Storing pending interrupts
- Masking software-disabled interrupt sources
- Selecting the highest-priority interrupt
- Managing interrupt servicing using an FSM
- Clearing serviced interrupts

The design follows a modular architecture similar to those used in commercial microcontrollers and SoCs.



## Features

- Parameterized interrupt width (default: 8 IRQs)
- Interrupt Request Register
- Interrupt Mask Register
- Fixed Priority Encoder
- Interrupt Controller FSM
- CPU Acknowledge Interface
- One-Hot Interrupt Clear Logic
- Fully verified


## Modules

### 1. Interrupt Request Register

Stores all active interrupt requests until acknowledged by the CPU.

---

### 2. Interrupt Mask Register

Allows software to enable or disable individual interrupt sources.



### 3. Interrupt Priority Encoder

Selects the highest-priority interrupt among all pending enabled interrupts.

Priority Order:

```
IRQ7
IRQ6
IRQ5
IRQ4
IRQ3
IRQ2
IRQ1
IRQ0
```



### 4. Interrupt Controller FSM

Controls the complete interrupt servicing sequence.

```
IDLE

↓

ASSERT_INTERRUPT

↓

WAIT_ACK

↓

CLEAR_INTERRUPT

↓

IDLE
```



### 5. Interrupt Controller Top

Integrates every module into one reusable interrupt controller IP.


## Verification

Verified scenarios include:

- Reset operation
- Interrupt request capture
- Interrupt masking
- Priority resolution
- CPU interrupt generation
- CPU acknowledge
- Interrupt clearing
- Multiple interrupt handling
- Masked interrupt rejection


## Learning Outcomes

This project demonstrates:

- Register design
- Combinational logic
- Priority encoders
- Finite State Machines (FSMs)
- Parameterized RTL
- Modular hardware architecture
- Interrupt controller design
- RTL verification


## Future Improvements

- Nested Interrupt Support
- Programmable Priority Levels
- Interrupt Vector Table
- Interrupt Preemption
- Edge/Level Trigger Configuration
- AXI/APB Register Interface

