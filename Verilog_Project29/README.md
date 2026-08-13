# Project 29 — 2-Bit Dynamic Branch Predictor

## Overview

This project implements a 2-bit dynamic branch predictor in Verilog.

The purpose of the design is to model a small but practical branch prediction mechanism used in processor pipelines. Instead of making a branch decision from only the most recent branch result, the predictor keeps a two-bit state that represents how strongly the branch is expected to be taken or not taken.

The predictor uses four states:

- `00` — Strongly Not Taken
- `01` — Weakly Not Taken
- `10` — Weakly Taken
- `11` — Strongly Taken

The most significant state bit is used to generate the branch prediction.

A taken branch moves the predictor toward the taken states, while a not-taken branch moves it toward the not-taken states. The counter saturates at `00` and `11`, so repeated outcomes do not cause the state to wrap around.

This project focuses on understanding the basic hardware mechanism behind dynamic branch prediction and how a small amount of historical information can be used to improve processor control-flow decisions.


## Design

The predictor contains a two-bit state register.

The prediction is generated directly from the most significant bit of the state:

```text
State    Prediction
-------------------
00       Not Taken
01       Not Taken
10       Taken
11       Taken
```

## Learning Outcomes

This project helped me understand how a simple dynamic branch predictor can be implemented directly in RTL.

The main concepts covered were:

- Two-bit saturating counters
- Dynamic branch prediction
- Weak and strong prediction states
- State-machine style RTL design
- Sequential state updates
- Reset handling
- Conditional state updates
- Saturation behavior
- Prediction generation from stored state
- Hardware verification using a directed testbench
- VCD waveform generation
- GTKWave-based debugging and signal analysis

More importantly, the project connected a small RTL block to an actual processor design problem. Branch prediction is part of the control-flow machinery of pipelined processors, so this design builds on the earlier pipeline, hazard detection, branch control.