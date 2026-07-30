# Project 14 – UART Controller (Universal Asynchronous Receiver Transmitter)

## Overview

This project implements a modular UART Controller in Verilog HDL. The design supports asynchronous serial communication by integrating separate transmitter, receiver, baud rate generator, and finite state machines (FSMs) into a reusable UART IP core.
The project follows a modular RTL design methodology, making each block independently verifiable before system-level integration.


## Features

- Parameterizable Data Width
- Configurable Baud Rate Divider
- UART Transmitter
- UART Receiver
- UART TX FSM
- UART RX FSM
- Modular Architecture
- Loopback Verification
- Fully Synthesizable RTL


## Modules

### 1. UART Baud Generator

Generates baud tick pulses from the system clock.

Files:-

- uart_baud_generator.v
- tb_uart_baud_generator.v



### 2. UART Transmitter

Converts parallel data into serial UART frames.

Files

- uart_transmitter.v
- tb_uart_transmitter.v


### 3. UART Receiver

Converts serial UART frames into parallel data.

Files

- uart_receiver.v
- tb_uart_receiver.v


### 4. UART TX FSM

Controls the transmission sequence.

State Flow

```
IDLE
 ↓
LOAD
 ↓
START
 ↓
SHIFT
 ↓
STOP
 ↓
DONE
```

Files

- uart_tx_fsm.v
- tb_uart_tx_fsm.v


### 5. UART RX FSM

Controls the receive sequence.

State Flow

```
IDLE
 ↓
START
 ↓
RECEIVE
 ↓
STOP
 ↓
DONE
```

Files

- uart_rx_fsm.v
- tb_uart_rx_fsm.v


### 6. UART Top Module

Integrates all UART components into a complete controller.

Files

- uart_top.v
- tb_uart_top.v


## Simulation Results

Verified modules:-

- Baud Generator
- UART Transmitter
- UART Receiver
- UART TX FSM
- UART RX FSM
- UART Top Module


## Verification

Loopback Test

```
TX -----> RX
```

Test Data

```
0xA5
0x5A
```

Results

```
TX Data = RX Data
```

Transmission Status

```
PASS
```




## Concepts Learned

- UART Communication
- Asynchronous Serial Protocol
- Baud Rate Generation
- Parallel-to-Serial Conversion
- Serial-to-Parallel Conversion
- Finite State Machines
- Modular RTL Design
- Loopback Verification
- System-Level Verification


