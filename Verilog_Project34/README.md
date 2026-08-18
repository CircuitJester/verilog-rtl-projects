# Project 34 — 2-Way Set-Associative Write-Back Data Cache

## Overview

Project 34 is a 2-way set-associative data cache implemented in synthesizable Verilog RTL.

This project builds on the cache concepts developed in the previous projects and introduces a more realistic cache organization with:

- 2 cache ways
- 4 cache sets
- Tag comparison
- Valid bits
- Dirty bits
- LRU-based replacement
- Read hits and misses
- Write hits
- Write-allocate behavior
- Dirty-line eviction
- Write-back to backing memory
- Cache-line refill
- Behavioral backing-memory verification

The main goal of this project was to understand how a processor cache behaves when multiple addresses map to the same set, and especially what happens when a modified dirty cache line must be evicted.

---

## What I Built

The cache contains:

```text
2 Ways
4 Sets
1 × 32-bit word per cache line
32-bit address
Write-back policy
Write-allocate policy
LRU replacement
```

The address is divided as:

```text
31                         4 3      2 1      0
+---------------------------+--------+--------+
|            TAG            |  SET   | OFFSET |
|          28 bits          | 2 bits | 2 bits |
+---------------------------+--------+--------+
```

Since the cache contains four sets:

```text
SET 0
SET 1
SET 2
SET 3
```

Each set contains two ways:

```text
              CACHE SET
        +-------------------+
        |                   |
        |      WAY 0        |
        |                   |
        +-------------------+
        |                   |
        |      WAY 1        |
        |                   |
        +-------------------+
                 |
                 v
             LRU STATE
```

---


## Cache Organization

Each cache line contains:

```text
Valid
Dirty
Tag
Data
```

The internal organization is:

```text
                 +----------------------+
                 |      Cache Set       |
                 +----------------------+
                 | Way 0                |
                 |  Valid               |
                 |  Dirty               |
                 |  Tag                 |
                 |  Data                |
                 +----------------------+
                 | Way 1                |
                 |  Valid               |
                 |  Dirty               |
                 |  Tag                 |
                 |  Data                |
                 +----------------------+
                           |
                           v
                     LRU information
```

The LRU state identifies which way should be selected when both ways are occupied and a new cache line needs to be installed.

---


## Read Operation

A CPU read follows this sequence:

```text
CPU Read Request
       |
       v
Extract Set + Tag
       |
       v
Compare Way 0
       |
       +---- HIT ----> Return cached data
       |
       v
Compare Way 1
       |
       +---- HIT ----> Return cached data
       |
       v
     MISS
       |
       v
Select replacement way
       |
       v
Check dirty bit
       |
       +---- CLEAN ----> Refill
       |
       +---- DIRTY ----> Write Back
                              |
                              v
                            Refill
                              |
                              v
                       Return new data
```

---


## Project Structure

```text
Verilog_Project34/
│
├── README.md
│
├── RTL/
│   └── set_associative_data_cache.v
│
├── tb/
│   └── tb_set_associative_data_cache.v
│
├── verification/
│   └── data_cache_2way_writeback.png
│
└── waves/
    └── data_cache_2way.vcd
```
---



## Tools Used

- Verilog/SystemVerilog
- Icarus Verilog
- GTKWave
- Linux/WSL
- VS Code
- Git
- GitHub

---



## Design 

The final architecture can be summarized as:

```text
                    CPU
                     |
                     v
             +---------------+
             | Cache Lookup  |
             +-------+-------+
                     |
             +-------+-------+
             |               |
            HIT             MISS
             |               |
             v               v
        Return Data     Select Victim
                             |
                       +-----+-----+
                       |           |
                     CLEAN       DIRTY
                       |           |
                       |           v
                       |      Write Back
                       |           |
                       +-----+-----+
                             |
                             v
                           Refill
                             |
                             v
                       Update Cache
                             |
                             v
                       CPU Response
```

This project is an important step toward understanding processor memory hierarchies and the RTL implementation of cache controllers.

---
