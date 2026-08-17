# Project 33 — Direct-Mapped Write-Back Data Cache

## Overview

This project implements a small 32-bit direct-mapped data cache in Verilog as part of the processor memory hierarchy.

The main purpose of the project was to move beyond instruction-only caching and understand how a processor handles cached data when both read and write operations are involved.

Unlike the instruction cache from Project 32, this cache supports CPU reads, CPU writes, cache hits, cache misses, write allocation, dirty cache lines, memory write-back, and cache-line replacement.

The cache contains 8 entries, with each entry storing one 32-bit data word together with a tag, valid bit, and dirty bit.

The design also includes a small cache controller implemented as a finite-state machine. This controller manages normal cache accesses as well as the additional steps required when a dirty cache line must be written back to memory before a new line can be loaded.

The project was verified using a dedicated Verilog testbench, a behavioral backing-memory model, Icarus Verilog, and GTKWave.


## Architecture

    CPU
     |
     | Read / Write Request
     v
    +---------------------------+
    |        Data Cache         |
    |                           |
    |  +---------------------+  |
    |  | Valid Bit Storage   |  |
    |  +---------------------+  |
    |                           |
    |  +---------------------+  |
    |  | Dirty Bit Storage   |  |
    |  +---------------------+  |
    |                           |
    |  +---------------------+  |
    |  | Tag Storage         |  |
    |  +---------------------+  |
    |                           |
    |  +---------------------+  |
    |  | Data Storage        |  |
    |  +---------------------+  |
    +-------------+-------------+
                  |
          +-------+-------+
          |               |
         HIT             MISS
          |               |
          v               v
      CPU Response     Check Line
                            |
                     +------+------+
                     |             |
                   Clean         Dirty
                     |             |
                     |             v
                     |        Write Back
                     |             |
                     +------+------+
                            |
                            v
                          Refill
                            |
                            v
                       Cache Update
                            |
                            v
                       CPU Response


## Project Objectives

The project was developed to gain practical experience with:

- Data cache architecture
- Direct-mapped cache organization
- Cache indexing
- Address tag extraction
- Valid-bit management
- Dirty-bit management
- Read hits
- Read misses
- Write hits
- Write misses
- Write-back caching
- Write allocation
- Dirty cache-line eviction
- Memory write-back
- Cache refill
- Cache replacement
- Cache controller FSM design
- CPU-to-cache interfaces
- Cache-to-memory interfaces
- Behavioral memory modeling
- RTL arrays
- Sequential and combinational RTL
- Testbench development
- GTKWave waveform analysis


## Cache Configuration

The cache uses the following configuration:

- Address width: 32 bits
- Data width: 32 bits
- Number of cache lines: 8
- Cache organization: Direct-mapped
- Line size: 1 × 32-bit word
- Replacement policy: Direct-mapped replacement
- Write policy: Write-back
- Write miss policy: Write-allocate

The cache therefore provides a small but realistic model of a processor data-cache structure.


## Address Breakdown

With 8 cache lines and one 32-bit word per cache entry, the address is divided into:

    31                         5 4      2 1      0
    +---------------------------+--------+--------+
    |            TAG            | INDEX  | OFFSET |
    +---------------------------+--------+--------+
              27 bits             3 bits    2 bits

The address fields are:

    Tag    = address[31:5]
    Index  = address[4:2]
    Offset = address[1:0]

The 3-bit index selects one of the 8 cache entries.

The offset identifies the byte position inside the 32-bit word, although the current cache stores one complete word per line and therefore does not use the offset to select between multiple words.


## Cache Entry Structure

Each cache entry contains:

    +-------+-------+-------------+----------------+
    | Valid | Dirty |     Tag     |      Data      |
    +-------+-------+-------------+----------------+
    |  1bit |  1bit |   27 bits   |     32 bits    |
    +-------+-------+-------------+----------------+


## CPU Interface

The CPU-side interface contains:

| Signal | Width | Description |
|---|---:|---|
| `clk` | 1 | Cache clock |
| `rst` | 1 | Resets and invalidates the cache |
| `cpu_read` | 1 | Requests a CPU read |
| `cpu_write` | 1 | Requests a CPU write |
| `cpu_address` | 32 | Address requested by the CPU |
| `cpu_write_data` | 32 | Data supplied during a CPU write |
| `cpu_read_data` | 32 | Data returned to the CPU |
| `cpu_ready` | 1 | Indicates completion of the CPU transaction |


## Memory Interface

The cache communicates with the backing memory through:

| Signal | Width | Description |
|---|---:|---|
| `memory_read` | 1 | Requests a memory read |
| `memory_write` | 1 | Requests a memory write |
| `memory_address` | 32 | Address used for the memory transaction |
| `memory_write_data` | 32 | Data written back to memory |
| `memory_read_data` | 32 | Data returned from memory |
| `memory_ready` | 1 | Indicates that the memory transaction is complete |

This interface allows the cache to handle both memory refills and dirty-line write-backs.


## Cache Controller

The cache controller uses the following states:

    STATE_IDLE
        |
        v
    STATE_LOOKUP
        |
        +--------------------+
        |                    |
       HIT                  MISS
        |                    |
        v                    v
    COMPLETE          Dirty cache line?
                           |
                    +------+------+
                    |             |
                   YES            NO
                    |             |
                    v             |
               WRITEBACK          |
                    |             |
                    +------+------+
                           |
                           v
                        REFILL
                           |
                           v
                       COMPLETE
                           |
                           v
                         IDLE

The controller keeps the CPU request information in internal registers while a memory transaction is in progress.

This prevents the cache from losing the original address or write data during a miss.


## Verification Strategy

The testbench uses a simple behavioral backing memory to provide deterministic data during cache misses and to record write-back operations.

The verification sequence includes:

1. Reset the cache
2. Perform an initial read
3. Verify the initial cache miss
4. Refill the cache from memory
5. Read the same address again
6. Verify a cache hit
7. Perform a write hit
8. Modify cached data
9. Set the dirty bit
10. Read the modified value
11. Access a conflicting address
12. Trigger dirty-line replacement
13. Write the dirty data back to memory
14. Refill the new cache line
15. Access the new address again
16. Verify cache-hit behavior
17. Return to the original conflicting address


## Testbench
The testbench contains:

- Clock generation
- Reset sequence
- CPU read transactions
- CPU write transactions
- Behavioral backing memory
- Memory read responses
- Memory write-back handling
- Cache miss testing
- Cache hit testing
- Dirty-line replacement testing
- Conflict-address testing
- VCD waveform generation

The behavioral memory is initialized with recognizable values so that cache and memory transactions can be distinguished easily during waveform analysis.



## GTKWave Verification

The simulation waveform was generated as:

    waves/data_cache.vcd

The waveform was inspected using GTKWave.

The main CPU-side signals include:

    clk
    rst
    cpu_address
    cpu_read
    cpu_write
    cpu_write_data
    cpu_read_data
    cpu_ready

The memory-side signals include:

    memory_address
    memory_read
    memory_read_data
    memory_ready
    memory_write
    memory_write_data

The waveform makes it possible to observe the relationship between CPU requests, cache responses, memory transactions, and cache replacement activity.


## Important Waveform Events

The waveform was used to inspect the following sequence:

    CPU request
        |
        v
    Cache lookup
        |
        v
    Hit or miss
        |
        v
    Memory transaction when required
        |
        v
    Cache update
        |
        v
    CPU ready

The write-back path is particularly important because it demonstrates the interaction between:

    cpu_write
    dirty cache state
    memory_write
    memory_write_data
    memory_address
    memory_ready


## Project Structure

    Verilog_Project33/
    ├── build/
    │
    ├── tb/
    │   └── tb_data_cache.v
    │
    ├── verification/
    │
    ├── verilogcode/
    │   └── data_cache.v
    │
    ├── waves/
    │   └── data_cache.vcd
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

This project provided practical experience with a processor data-cache architecture and introduced several concepts that were not required by the previous instruction-cache project.

The main concepts learned were:

- Direct-mapped data caches
- Cache metadata
- Valid bits
- Dirty bits
- Tag storage
- Data storage
- Cache indexing
- Tag comparison
- Read hits
- Read misses
- Write hits
- Write misses
- Write-back caching
- Write allocation
- Dirty-line eviction
- Memory write-back
- Cache refill
- Cache replacement
- Conflict misses
- Cache controller FSMs
- CPU/cache interfaces
- Cache/memory interfaces
- Request tracking
- Behavioral memory modeling
- RTL array modeling
- Sequential RTL
- Testbench development
- VCD generation
- GTKWave waveform debugging


## Connection With Previous Projects

The processor-oriented portfolio has now progressed from control-flow prediction into the memory hierarchy:

    Project 29
    2-Bit Branch Predictor
          |
          v
    Predict branch direction

    Project 30
    Branch Target Buffer
          |
          v
    Predict branch target

    Project 31
    Return Address Stack
          |
          v
    Predict return addresses

    Project 32
    Instruction Cache
          |
          v
    Cache instruction fetches

    Project 33
    Data Cache
          |
          v
    Cache processor data accesses

Project 32 introduced the basic cache concepts using an instruction cache.

Project 33 extends those concepts into a writable data-cache system with dirty state, write-back, and replacement handling.

