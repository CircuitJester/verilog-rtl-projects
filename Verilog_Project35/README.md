# Project 35 — Cache Miss / Stall Controller

## Overview

Project 35 implements a cache miss and stall controller that manages communication between a CPU-style request interface, a cache, and backing memory.

The project focuses on the control and timing required when a cache access cannot be completed immediately.

The controller supports:

- CPU request/ready handshaking
- CPU response/valid signaling
- Read hits
- Read misses
- CPU stall during cache misses
- Memory refill
- Write hits
- Write misses
- Dirty-bit tracking
- Dirty write-back
- Clean replacement
- Cache-line restoration
- Single-cycle memory transactions
- Backing-memory verification
- Transaction counting
- Full behavioral verification

Final verification result:

    PASS COUNT = 60
    FAIL COUNT = 0

    PROJECT 35 FULL VERIFICATION: PASS

---


## Architecture

The controller operates between a CPU request interface and backing memory:

    +----------------------+
    |         CPU          |
    +----------+-----------+
               |
         CPU Request
               |
               v
    +----------------------+
    | Cache Miss / Stall   |
    |      Controller      |
    +----------+-----------+
               |
         Memory Interface
               |
               v
    +----------------------+
    |    Backing Memory    |
    +----------------------+

The general miss-handling flow is:

    CPU Request
         |
         v
    Cache Lookup
         |
         +-------- HIT --------> CPU Response
         |
         +-------- MISS
                      |
                      v
                  Stall CPU
                      |
                      v
              Check Cache Victim
                      |
                 +----+----+
                 |         |
               Clean     Dirty
                 |         |
                 |      Write-Back
                 |         |
                 +----+----+
                      |
                      v
                 Memory Refill
                      |
                      v
                 Cache Update
                      |
                      v
                 CPU Response

---


## Main Learning Objectives

This project focuses on the control logic required around cache misses.

The major concepts are:

1. CPU request/ready handshaking
2. CPU response/valid signaling
3. Cache hit detection
4. Cache miss detection
5. CPU stall control
6. Memory request generation
7. Memory response handling
8. Cache refill
9. Dirty-bit management
10. Dirty write-back
11. Clean replacement
12. Write-miss handling
13. Transaction sequencing
14. Memory transaction counting
15. Backing-memory verification
16. Waveform-based debugging

---


## Interface

### CPU Request Interface

| Signal | Direction | Width | Description |
|---|---|---:|---|
| `req_valid` | Input | 1 | Indicates that a CPU request is valid |
| `req_ready` | Output | 1 | Indicates that the controller can accept a request |
| `req_write` | Input | 1 | Selects read or write operation |
| `req_addr` | Input | 32 | CPU request address |
| `req_wdata` | Input | 32 | CPU write data |

A CPU request is accepted when:

    req_valid = 1
    req_ready = 1

---

### CPU Response Interface

| Signal | Direction | Width | Description |
|---|---|---:|---|
| `resp_valid` | Output | 1 | Indicates a completed CPU transaction |
| `resp_hit` | Output | 1 | Indicates whether the original access was a cache hit |
| `resp_rdata` | Output | 32 | Returned data |

---

### Memory Read Interface

| Signal | Direction | Width | Description |
|---|---|---:|---|
| `mem_read` | Output | 1 | Requests a backing-memory read |
| `mem_addr` | Output | 32 | Address sent to memory |
| `mem_rdata` | Input | 32 | Data returned from memory |
| `mem_ready` | Input | 1 | Indicates that the memory response is available |

---

### Memory Write Interface

| Signal | Direction | Width | Description |
|---|---|---:|---|
| `mem_write` | Output | 1 | Requests a backing-memory write |
| `mem_write_addr` | Output | 32 | Address of data being written back |
| `mem_write_data` | Output | 32 | Data being written back |
| `mem_write_ready` | Input | 1 | Indicates that memory accepted the write |

---


# Repository Structure

    Verilog_Project35/
    │
    ├── README.md
    │
    ├── RTL/
    │   └── cache_miss_stall_controller.v
    │
    ├── tb/
    │   └── tb_cache_miss_stall_controller.v
    │
    ├── verification/
    │   └── cache_miss_stall_controller.png
    │
    ├── build/
    │   └── cache_miss_stall_controller_tb.vvp
    │
    └── waves/
        └── cache_miss_stall_controller.vcd

Generated simulation artifacts such as `build/`, `waves/`, `.vvp`, and `.vcd` are excluded from Git tracking using the repository `.gitignore`.

---


# Tools Used

## Icarus Verilog

Used for RTL compilation and simulation.

    iverilog -g2012 \
    -o build/cache_miss_stall_controller_tb.vvp \
    RTL/cache_miss_stall_controller.v \
    tb/tb_cache_miss_stall_controller.v

## VVP

Used to execute the compiled simulation.

    vvp build/cache_miss_stall_controller_tb.vvp

## GTKWave

Used for waveform inspection.

    gtkwave waves/cache_miss_stall_controller.vcd

---




# Conclusion

Project 35 implements and verifies a cache miss/stall controller with CPU-side handshaking and backing-memory transaction control.

The final design successfully handles:

    Read Hits
    Read Misses
    CPU Stalls
    Memory Refills
    Write Hits
    Write Misses
    Dirty Lines
    Dirty Write-Back
    Clean Replacement
    Dirty Eviction
    Cache Restoration

Final verification:

    PASS COUNT = 60
    FAIL COUNT = 0

The most important transaction demonstrated by this project is:

                 +-------------+
                 | CPU Request |
                 +------+------+
                        |
                        v
                 +-------------+
                 | Cache Lookup|
                 +------+------+
                        |
                 +------+------+
                 |             |
                HIT           MISS
                 |             |
                 v             v
           Return Data      Stall CPU
                               |
                        +------+------+
                        |             |
                      Clean         Dirty
                        |             |
                        |         Write-Back
                        |             |
                        +------+------+
                               |
                               v
                         Memory Read
                               |
                               v
                          Cache Refill
                               |
                               v
                         CPU Response
                               |
                               v
                             IDLE

Project 35 demonstrates that cache design is not only about storing data. The critical engineering challenge is coordinating control, timing, handshaking, memory transactions, dirty-state management, cache refill, and verification so that every cache transaction completes correctly.