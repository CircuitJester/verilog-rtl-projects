**# Project 36 — Non-Blocking Cache**

**## Overview**

Project 36 implements a non-blocking cache controller that allows the cache to continue servicing independent cache hits while a previous cache miss is still being processed.

The project extends the cache miss/stall controller developed in Project 35 by introducing a **Miss Status Holding Register (MSHR)** for tracking an outstanding cache miss.

The project focuses on the control and transaction handling required when a cache miss is waiting for a memory response.

The controller supports:

\- CPU request/ready handshaking

\- CPU response/valid signaling

\- Read hits

\- Read misses

\- Outstanding miss tracking

\- MSHR allocation

\- MSHR address tracking

\- MSHR operation tracking

\- Memory request generation

\- Memory refill

\- CPU response after miss completion

\- Independent cache hits during an outstanding miss

\- Blocking of a second miss while the MSHR is busy

\- MSHR release

\- Write hits

\- Read-after-write verification

\- Response ordering

\- Response pulse verification

\- Multiple miss/hit transaction sequences

\- Full behavioral verification

Final verification result:

    PASS COUNT = 27

    FAIL COUNT = 0

    MEMORY READ TRANSACTIONS = 3

    PROJECT 36 FULL VERIFICATION: PASS

\---



**## Architecture**

The controller operates between a CPU request interface, the cache, an MSHR, and backing memory:

    +----------------------+
    |         CPU          |
    +----------+-----------+
               |
         CPU Request
               |
               v
    +----------------------+
    |  Non-Blocking Cache  |
    |     Controller       |
    +----------+-----------+
               |
        +------+------+
        |             |
       HIT           MISS
        |             |
        v             v
    CPU Response     MSHR
                      |
                      v
               Memory Request
                      |
                      v
               Memory Response
                      |
                      v
                 Cache Refill
                      |
                      v
                 CPU Response

The general transaction flow is:

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
                 Check MSHR
                       |
                 +-----+-----+
                 |           |
               FREE         BUSY
                 |           |
                 v           v
            Allocate       Block
              MSHR         Request
                 |
                 v
          Memory Request
                 |
                 v
          Memory Response
                 |
                 v
            Cache Refill
                 |
                 v
            CPU Response
                 |
                 v
            MSHR Release

The key non-blocking behavior occurs when an independent cache hit arrives while a miss is outstanding:

    MISS A
      |
      v
     MSHR
      |
      +--------------------> Memory Request
      |
      |
    HIT B
      |
      v
    CPU Response
      |
      |
    Memory Response A
      |
      v
    CPU Response A

The original miss remains stored in the MSHR while the independent cache hit is serviced.

\---



**## Main Learning Objectives**

This project focuses on the control logic required to build a basic non-blocking cache.

The major concepts are:

1\. CPU request/ready handshaking

2\. CPU response/valid signaling

3\. Cache hit detection

4\. Cache miss detection

5\. Outstanding cache miss tracking

6\. Miss Status Holding Register operation

7\. MSHR allocation

8\. MSHR address storage

9\. MSHR operation storage

10\. Memory request generation

11\. Memory response handling

12\. Cache refill

13\. Independent cache hit during a miss

14\. Second-miss blocking

15\. MSHR release

16\. Write-hit handling

17\. Read-after-write behavior

18\. Response ordering

19\. Response pulse integrity

20\. Transaction sequencing

21\. Waveform-based debugging

22\. Full behavioral verification

\---



**## Interface**

**### CPU Request Interface**

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

When a cache miss is already outstanding and the incoming request is another miss, the controller prevents the second miss from overwriting the active MSHR.

\---


**### CPU Response Interface**

| Signal | Direction | Width | Description |
|---|---|---:|---|
| `resp_valid` | Output | 1 | Indicates a completed CPU transaction |
| `resp_hit` | Output | 1 | Indicates whether the original access was a cache hit |
| `resp_rdata` | Output | 32 | Returned data |

The response is generated when:

- A cache hit is completed
- A cache miss has received its memory response
- A cache refill has completed

\---


**### Memory Interface**

| Signal | Direction | Width | Description |
|---|---|---:|---|
| `mem_read` | Output | 1 | Requests a backing-memory read |
| `mem_addr` | Output | 32 | Address sent to memory |
| `mem_rdata` | Input | 32 | Data returned from memory |
| `mem_ready` | Input | 1 | Indicates that the memory response is available |

The memory interface is used to complete outstanding cache misses.

\---


**### MSHR Interface / Debug Signals**

| Signal | Direction | Width | Description |
|---|---|---:|---|
| `miss_pending` | Output | 1 | Indicates that an outstanding miss is active |
| `miss_addr_debug` | Output | 32 | Address stored in the MSHR |
| `miss_write_debug` | Output | 1 | Operation stored in the MSHR |

The MSHR stores the information required to complete the outstanding cache transaction.

\---



**# Repository Structure**

    Verilog_Project36/
    │
    ├── README.md
    │
    ├── RTL/
    │   └── non_blocking_cache.v
    │
    ├── tb/
    │   └── tb_non_blocking_cache.v
    │
    ├── verification/
    │   └── non_blocking_cache.png
    │
    ├── build/
    │   └── non_blocking_cache_tb.vvp
    │
    └── waves/
        └── non_blocking_cache.vcd

Generated simulation artifacts such as `build/`, `waves/`, `.vvp`, and `.vcd` are excluded from Git tracking using the repository `.gitignore`.

\---



**# Tools Used**

**## Icarus Verilog**

Used for RTL compilation and simulation.

    iverilog -g2012 \
    -o build/non_blocking_cache_tb.vvp \
    RTL/non_blocking_cache.v \
    tb/tb_non_blocking_cache.v

**## VVP**

Used to execute the compiled simulation.

    vvp build/non_blocking_cache_tb.vvp

**## GTKWave**

Used for waveform inspection.

    gtkwave waves/non_blocking_cache.vcd



**# Conclusion**

Project 36 implements and verifies a non-blocking cache controller with a single-entry Miss Status Holding Register.

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
                   CPU Response     Check MSHR
                                       |
                                 +-----+-----+
                                 |           |
                               FREE         BUSY
                                 |           |
                                 v           v
                           Allocate MSHR   Block
                                 |         Request
                                 v
                          Memory Request
                                 |
                                 v
                          Memory Response
                                 |
                                 v
                           Cache Refill
                                 |
                                 v
                           CPU Response
                                 |
                                 v
                           MSHR Release

During the outstanding miss:

                         +-------------+
                         | Outstanding |
                         |    MISS     |
                         +------+------+
                                |
                                |
                         +------+------+
                         |             |
                     Memory       Independent
                     Request          HIT
                         |             |
                         |             v
                         |        CPU Response
                         |
                         v
                  Memory Response
                         |
                         v
                  Complete MISS
                         |
                         v
                    MSHR Release

Project 36 demonstrates that a non-blocking cache requires more than basic cache storage. The critical engineering challenge is coordinating cache lookup, outstanding miss tracking, MSHR state, memory transactions, independent cache hits, request arbitration, response ordering, and transaction completion without corrupting the active miss.

This project establishes the foundation for progressing toward more advanced cache architectures involving multiple MSHRs, multiple outstanding memory requests, out-of-order memory responses, store buffers, multi-level caches, and cache coherence.