# Project 32 — Direct-Mapped Instruction Cache

## Overview

This project implements a small direct-mapped instruction cache in Verilog as part of the processor memory hierarchy.

The goal was to understand how a processor can keep recently accessed instructions close to the CPU instead of requesting every instruction directly from a slower memory system.

The cache accepts an instruction-fetch address from the CPU, checks whether the requested instruction is already stored in the cache, and either returns the cached instruction on a hit or requests the instruction from memory on a miss.

The implementation uses 8 cache lines, with each line storing one 32-bit instruction. Each entry also contains a valid bit and a tag used to determine whether the stored instruction belongs to the requested address.

This project extends the processor-oriented RTL work from the earlier branch prediction projects and introduces practical cache organization, tag comparison, cache misses, refills, and replacement behavior.


## Architecture

    CPU / Fetch Stage
            |
            | CPU Address
            v
    +---------------------------+
    |     Instruction Cache     |
    |                           |
    |  +---------------------+  |
    |  | Valid Bit Storage   |  |
    |  +---------------------+  |
    |                           |
    |  +---------------------+  |
    |  | Tag Storage         |  |
    |  +---------------------+  |
    |                           |
    |  +---------------------+  |
    |  | Instruction Storage |  |
    |  +---------------------+  |
    +------------+--------------+
                 |
          +------+------+
          |             |
         HIT           MISS
          |             |
          v             v
    Return Instruction  Memory Request
                            |
                            v
                       Memory Response
                            |
                            v
                       Cache Refill
                            |
                            v
                     Return Instruction


## Main RTL Module

The main module is:

    instruction_cache

The RTL is located at:

    verilogcode/instruction_cache.v


## Interface

### CPU-Side Inputs

| Signal | Width | Description |
|---|---:|---|
| `clk` | 1 | Cache clock |
| `rst` | 1 | Resets and invalidates the cache |
| `cpu_request` | 1 | Indicates an instruction fetch request |
| `cpu_address` | 32 | Address of the requested instruction |


### CPU-Side Outputs

| Signal | Width | Description |
|---|---:|---|
| `cpu_hit` | 1 | Indicates a cache hit |
| `cpu_instruction` | 32 | Instruction returned from the cache |


### Memory-Side Signals

| Signal | Width | Description |
|---|---:|---|
| `memory_request` | 1 | Requests instruction data from memory |
| `memory_address` | 32 | Address requested from memory |
| `memory_data` | 32 | Instruction returned by memory |
| `memory_ready` | 1 | Indicates that memory data is available |



## Cache Hit Flow

The normal hit path is:

    CPU Address
         |
         v
    Extract Index + Tag
         |
         v
    Select Cache Line
         |
         v
    Check Valid Bit
         |
         v
    Compare Tag
         |
         v
        HIT
         |
         v
    Return Cached Instruction


## Verification Strategy

The testbench uses a small behavioral memory model to provide deterministic instruction data during cache misses.

The verification sequence covers:

1. Resetting the cache
2. Accessing an empty cache
3. Verifying the initial miss
4. Fetching instruction data from memory
5. Refilling a cache entry
6. Accessing the same address again
7. Verifying a cache hit
8. Accessing another cache line
9. Testing multiple cache entries
10. Accessing addresses that map to the same cache index
11. Verifying tag mismatch behavior
12. Verifying cache replacement


## Project Structure

    Verilog_Project32/
    ├── build/
    │
    ├── tb/
    │   └── tb_instruction_cache.v
    │
    ├── verification/
    │
    ├── verilogcode/
    │   └── instruction_cache.v
    │
    ├── waves/
    │   └── instruction_cache.vcd
    │
    └── README.md


## Tools Used

- Verilog HDL
- Icarus Verilog
- GTKWave
- VS Code
- Linux / WSL
- Git
- GitHub


## Learning Outcomes

This project provided practical experience with the basic architecture of an instruction cache.

The main concepts covered were:

- CPU instruction-fetch caching
- Direct-mapped cache organization
- Cache lines
- Valid-bit management
- Address tag extraction
- Cache indexing
- Tag comparison
- Cache hit detection
- Cache miss detection
- Memory request generation
- Memory response handling
- Cache refill
- Cache entry replacement
- Conflict misses
- Sequential RTL design
- Combinational lookup logic
- RTL array modeling
- Behavioral memory modeling
- Testbench development
- VCD waveform generation
- GTKWave debugging

The project also provided a practical connection between computer architecture theory and synthesizable RTL.


## Connection With Previous Projects

The earlier projects focused heavily on processor control-flow prediction:

    Project 29
    2-Bit Branch Predictor
            |
            v
    Predict whether branch is taken

    Project 30
    Branch Target Buffer
            |
            v
    Predict where the branch goes

    Project 31
    Return Address Stack
            |
            v
    Predict function return address

    Project 32
    Instruction Cache
            |
            v
    Provide instructions efficiently

This moves the portfolio from branch prediction into the processor memory hierarchy.

Together, these structures represent important parts of a modern processor front end.


