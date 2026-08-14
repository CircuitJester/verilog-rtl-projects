# Project 30 — Branch Target Buffer (BTB)

## Overview

This project implements a small Branch Target Buffer (BTB) in Verilog.

The purpose of the BTB is to remember the target address of previously encountered branch instructions. During instruction fetch, the processor can look up the current PC in the BTB and, when a matching entry is found, obtain the previously stored branch target without waiting for the branch instruction to reach the later pipeline stages.

This project builds on the branch prediction concepts introduced in Project 29. The branch predictor determines whether a branch is expected to be taken, while the BTB provides the target address that can be used when the branch is predicted taken.

The design uses a small direct-mapped table with four entries. Each entry stores a valid bit, a PC tag, and the corresponding branch target address.


## Architecture

                    Lookup PC
                        |
                        v
                +---------------+
                | Extract Index |
                |    and Tag    |
                +-------+-------+
                        |
                 +------+------+
                 |             |
                 v             v
              Index           Tag
                 |             |
                 v             v
          Select BTB Entry   Compare Tag
                 |             |
                 +------+------+
                        |
                 Valid + Tag Match
                        |
                +-------+-------+
                |               |
              HIT             MISS
                |               |
                v               v
          Target Address      No Target


Each BTB entry contains:

    +-------+-------------+----------------+
    | Valid | PC Tag      | Target Address |
    +-------+-------------+----------------+

The design uses the PC bits as follows:

    31                         4 3    2 1    0
    +---------------------------+------+------+
    |           PC Tag          |Index |Offset|
    +---------------------------+------+------+
              28 bits             2      2


The two index bits select one of the four entries. The upper PC bits are stored as the tag and compared during a lookup. The lowest two bits are ignored because instruction addresses are assumed to be word aligned.



## Project Structure

    Verilog_Project30/
    ├── build/
    │
    ├── tb/
    │   └── tb_branch_target_buffer.v
    │
    ├── verification/
    │
    ├── verilogcode/
    │   └── branch_target_buffer.v
    │
    ├── waves/
    │   └── branch_target_buffer.vcd
    │
    └── README.md


## Tools Used

- Verilog HDL
- Icarus Verilog
- GTKWave
- Linux / WSL
- VS Code
- Git
- GitHub


## Learning Outcomes

This project provided practical experience with the hardware structure used to remember branch target addresses.

The main concepts covered were:

- Branch target prediction
- Branch Target Buffers
- Direct-mapped lookup structures
- Valid bits
- PC indexing
- PC tag extraction
- Tag comparison
- Target address storage
- BTB hit detection
- BTB miss detection
- Synchronous state updates
- Entry replacement
- Reset-based invalidation
- Tagged lookup structures
- Combinational lookup logic
- Sequential update logic
- RTL array modeling
- Directed Verilog testbench development
- VCD waveform generation
- GTKWave waveform analysis



## Connection With Project 29

Project 29 implemented a 2-bit dynamic branch predictor using a saturating state machine.

Project 30 adds the target-address storage required to make branch prediction more useful.

The combined concept is:

                     Current PC
                         |
              +----------+----------+
              |                     |
              v                     v
        2-Bit Predictor             BTB
         Project 29             Project 30
              |                     |
              v                     v
       Taken / Not Taken       Target Address
              |                     |
              +----------+----------+
                         |
                         v
                      Next PC

The predictor provides the direction decision, while the BTB provides the destination address.

This separation also keeps the RTL modular and makes both blocks easier to verify independently.


## What I Learned

The main lesson from this project was that branch prediction involves more than simply predicting whether a branch will be taken.

A processor also needs to know where execution should continue if the prediction is taken. A BTB provides that information by remembering branch target addresses from previous executions.

Another important concept was the use of tags and valid bits. The index alone is not enough to determine whether a branch is present in the table because different PCs can map to the same entry. The tag comparison provides the additional check needed to identify the correct branch.

The project also reinforced the connection between BTBs and other tagged hardware structures such as caches, where an index selects an entry and a tag determines whether that entry corresponds to the requested address.

