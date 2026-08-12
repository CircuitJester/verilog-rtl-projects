# Project 28 — Static Branch Prediction Unit

## Overview

This project implements a simple static branch prediction unit in Verilog HDL for a pipelined processor datapath.

The purpose of the design is to determine the next program counter value before the actual branch outcome is resolved. This allows instruction fetch to continue using a predicted path instead of waiting for the branch decision.

The predictor used in this project follows a simple static policy:

* Non-branch instruction → predict not taken
* Branch instruction → predict taken

When a branch is detected, the predicted program counter is calculated using the current PC and the supplied branch offset. For a normal instruction, execution continues sequentially using `PC + 4`.

The project is intentionally kept simple so that the fundamental relationship between branch prediction, program-counter selection, and control hazards can be understood before moving toward more advanced dynamic prediction techniques.



## Architecture

```text
                 Current PC
                     |
                     v
              +--------------+
              |    Branch    |
              |  Prediction  |
              |     Unit     |
              +------+-------+
                     |
          +----------+----------+
          |                     |
          v                     v
    Sequential Path        Branch Target
       PC + 4             PC + Offset
          |                     |
          +----------+----------+
                     |
                     v
              Predicted PC
```



## Verification

The design was verified using a dedicated Verilog testbench and GTKWave waveform analysis.

The testbench checks:

* Normal sequential instruction flow
* Taken branch prediction
* Positive branch offsets
* Negative branch offsets
* Forward branch targets
* Backward branch targets
* Predicted program counter generation

The simulation generates:

```text
waves/branch_prediction_unit.vcd
```



## Testbench

### `tb_branch_prediction_unit.v`

The testbench drives different PC values, branch offsets, and branch-valid conditions into the predictor.

It generates a VCD file for waveform inspection:

```text
waves/branch_prediction_unit.vcd
```

The verification is directed toward functional behavior rather than performance measurement because this project implements a standalone static predictor.



## Simulation

Compile the RTL and testbench using Icarus Verilog:

```bash
iverilog -g2012 \
-o build/branch_prediction_unit_tb.vvp \
verilogcode/branch_prediction_unit.v \
tb/tb_branch_prediction_unit.v
```

Run the simulation:

```bash
vvp build/branch_prediction_unit_tb.vvp
```

Open the waveform:

```bash
gtkwave waves/branch_prediction_unit.vcd
```


## Project Structure

```text
Verilog_Project28/
│
├── README.md
│
├── verilogcode/
│   └── branch_prediction_unit.v
│
├── tb/
│   └── tb_branch_prediction_unit.v
│
├── verification/
│
├── waves/
│   └── branch_prediction_unit.vcd
│
└── build/
    └── branch_prediction_unit_tb.vvp
```



## Tools Used

* Verilog HDL
* Icarus Verilog
* GTKWave
* VS Code
* Ubuntu / WSL
* Git
* GitHub



## Learning Outcomes

This project provided practical experience with:

* Static branch prediction
* Control hazards
* Program counter selection
* Branch target calculation
* Sequential instruction flow
* Branch offset arithmetic
* Two's complement branch offsets
* Forward branch handling
* Backward branch handling
* Combinational RTL design
* Processor fetch control
* Verilog testbench development
* VCD waveform generation
* GTKWave waveform analysis
* RTL debugging

The project also establishes the basic foundation required to understand more advanced branch prediction mechanisms.



## Project Significance

This project extends the processor pipeline work developed in the previous projects.

The progression is:

```text
Project 24
5-Stage Pipelined ALU
        |
        v
Project 25
Hazard Detection
        |
        v
Project 26
Branch Control
        |
        v
Project 27
Data Forwarding
        |
        v
Project 28
Static Branch Prediction
```

The earlier projects focused on detecting and resolving pipeline hazards. Project 28 adds the predicting control flow before the branch outcome is known.

This moves the processor architecture toward more realistic instruction-fetch and pipeline-control behavior.



