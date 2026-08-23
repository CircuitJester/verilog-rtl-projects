# Project 37 — Multi-MSHR Non-Blocking Cache

A synthesizable Verilog RTL implementation of a multi-MSHR non-blocking cache capable of handling multiple outstanding cache misses, out-of-order memory responses, MSHR reuse, duplicate request detection, stale response protection, generation tracking, and write-miss data retention.

This project was developed incrementally through 23 verification steps, with each major architectural feature tested before progressing to the next stage.

---

## Project Overview

A conventional blocking cache normally waits for a miss to complete before processing another miss.

A non-blocking cache removes this restriction by allowing multiple cache misses to remain outstanding simultaneously.

Project 37 implements this behavior using four Miss Status Holding Registers (MSHRs).

The architecture can be summarized as:

    CPU Request
         |
         v
    +-------------------+
    |   Cache Lookup    |
    +-------------------+
         |
         +---- HIT --------------------> CPU Response
         |
         +---- MISS
               |
               v
        +---------------+
        |  MSHR Table   |
        |               |
        | MSHR 0        |
        | MSHR 1        |
        | MSHR 2        |
        | MSHR 3        |
        +---------------+
               |
               v
             Memory

The design allows up to four outstanding cache misses at the same time.

---


## Main Objectives

The project was designed to demonstrate the following RTL concepts:

- Multiple outstanding cache misses
- MSHR allocation
- MSHR release
- MSHR reuse
- Request ownership tracking
- Duplicate miss detection
- Memory request generation
- Out-of-order memory response handling
- Cache refill
- Generation tracking
- Stale response protection
- Multiple colliding miss generations
- Write-miss data retention
- CPU response generation
- Directed RTL verification
- Waveform-based debugging

---


## Cache Organization

The cache is a small direct-mapped cache containing four cache lines.

Address organization:

    31                         6 5    4 3          0
    +----------------------------+------+------------+
    |            TAG             |INDEX |  OFFSET    |
    +----------------------------+------+------------+

    TAG    = 26 bits
    INDEX  = 2 bits
    OFFSET = 4 bits

The current design therefore contains:

    Cache lines : 4
    Data width  : 32 bits
    Tag width   : 26 bits
    Index width : 2 bits
    MSHRs       : 4

The direct-mapped organization is intentional because it provides useful collision scenarios for testing stale memory responses and generation tracking.

---


## MSHR Architecture

Each MSHR represents one outstanding cache transaction.

The MSHR table tracks:

    MSHR
     |
     +-- Valid
     +-- Address
     +-- Read / Write
     +-- Write Data
     +-- Memory Request Sent
     +-- Generation

The four MSHRs are:

    MSHR 0
    MSHR 1
    MSHR 2
    MSHR 3

This allows four cache misses to remain outstanding simultaneously.

---



## CPU Response Interface

The cache provides:

    resp_valid
    resp_hit
    resp_rdata

These signals communicate the completed transaction back to the CPU.

For a read miss:

    resp_rdata = memory response data

For a write miss:

    resp_rdata = original CPU write data

This distinction is important because the memory response may contain unrelated or stale data for a write transaction.

---


## Response Completion Flow

A typical read miss follows:

    CPU Request
         |
         v
    Cache Lookup
         |
         v
       MISS
         |
         v
    Allocate MSHR
         |
         v
    Memory Request
         |
         v
    Wait for Response
         |
         v
    Generation Check
         |
         +---- Current ----> Cache Refill
         |
         +---- Stale ------> No Cache Refill
         |
         v
    CPU Response
         |
         v
    Release MSHR

This flow allows multiple independent misses to progress concurrently.

---


## Simulation Tools

The project was verified using:

- Icarus Verilog
- GTKWave
- Linux / WSL

Compilation command:

    iverilog -g2012 \
    -o build/multi_mshr_cache_tb.vvp \
    RTL/multi_mshr_cache.v \
    tb/tb_multi_mshr_cache.v

Run command:

    vvp build/multi_mshr_cache_tb.vvp

The simulation generates:

    waves/multi_mshr_cache.vcd

The waveform can be opened using:

    gtkwave waves/multi_mshr_cache.vcd

---


## Typical Duplicate Flow

    CPU Request
         |
         v
    MSHR Ownership Lookup
         |
         v
    Address already owned
         |
         v
      DUPLICATE

No second memory request is generated.

---


## Design Lessons

### Multiple outstanding requests require independent state

A single miss register is not sufficient for a non-blocking cache.

Each outstanding transaction needs its own MSHR entry.

### Memory responses cannot be assumed to return in order

The MSHR identifier allows each response to be matched to the correct transaction.

### Direct-mapped collisions create stale response hazards

An older transaction can return after a newer transaction has already claimed the same cache index.

### Generation tracking solves stale refill problems

Comparing the MSHR generation with the current cache-index generation identifies whether a response is current or stale.

### Write misses require persistent write data

The CPU write data must remain stored in the MSHR until the transaction completes.

### Verification must cover corner cases

The most important behaviors are often found in scenarios involving:

    Multiple outstanding misses
    Out-of-order responses
    MSHR reuse
    Duplicate requests
    Cache index collisions
    Multiple generations
    Stale responses
    Write misses
    Delayed responses

---


## Current Project Status

    Project                 : 37
    Design                  : Multi-MSHR Non-Blocking Cache

    Cache Type              : Direct-Mapped
    Cache Lines             : 4
    Data Width              : 32 bits
    Tag Width               : 26 bits
    Index Width             : 2 bits
    MSHR Count              : 4

    MSHR Reuse              : Implemented
    Owner Tracking          : Implemented
    Duplicate Detection     : Implemented
    Generation Tracking     : Implemented
    Stale Response Protect  : Implemented
    Out-of-Order Response   : Implemented
    Write Miss Retention    : Implemented
    CPU Response Interface  : Implemented

    Verified Through        : Step 23
    Latest Verification     : PASS

    Step 23 Pass Count      : 9
    Step 23 Fail Count      : 0
    Step 23 Memory Requests : 2

---


## Project Structure

    Verilog_Project37/
    |
    +-- RTL/
    |   +-- multi_mshr_cache.v
    |
    +-- tb/
    |   +-- tb_multi_mshr_cache.v
    |
    +-- checkpoints/
    |   +-- RTL/
    |   +-- tb/
    |
    +-- build/
    |
    +-- waves/
    |
    +-- README.md

The build and waveform directories contain generated simulation artifacts.

---


## Skills Demonstrated

This project demonstrates practical RTL experience in:

- Verilog RTL design
- Cache controller design
- Non-blocking cache architecture
- MSHR implementation
- Transaction ownership tracking
- Direct-mapped cache behavior
- Cache index collision handling
- Generation counters
- Stale transaction protection
- Out-of-order response handling
- Write-miss handling
- CPU response generation
- RTL debugging
- Directed testbench development
- Simulation-based verification
- Waveform debugging
- Icarus Verilog
- GTKWave
- Git-based incremental development

---


## Conclusion

Project 37 moves beyond basic cache RTL and focuses on the control problems that occur when several memory transactions are allowed to remain outstanding simultaneously.

The final design demonstrates:

    Multiple outstanding misses
            |
            v
    MSHR allocation
            |
            v
    Ownership tracking
            |
            v
    Out-of-order responses
            |
            v
    Generation checking
            |
            v
    Stale response protection
            |
            v
    Correct cache refill
            |
            v
    CPU response
            |
            v
    MSHR release and reuse

The project provides a strong RTL foundation for more advanced processor memory-system work and future ASIC-oriented development.

---

