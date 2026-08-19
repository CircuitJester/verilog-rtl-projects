`timescale 1ns/1ps

module tb_cache_miss_stall_controller;

    // ============================================================
    // CLOCK / RESET
    // ============================================================

    reg clk;
    reg rst;

    // ============================================================
    // CPU INTERFACE
    // ============================================================

    reg         req_valid;
    wire        req_ready;

    reg         req_write;
    reg  [31:0] req_addr;
    reg  [31:0] req_wdata;

    wire        resp_valid;
    wire        resp_hit;
    wire [31:0] resp_rdata;

    // ============================================================
    // MEMORY READ INTERFACE
    // ============================================================

    wire        mem_read;
    wire [31:0] mem_addr;

    reg  [31:0] mem_rdata;
    reg         mem_ready;

    // ============================================================
    // MEMORY WRITE INTERFACE
    // ============================================================

    wire        mem_write;
    wire [31:0] mem_write_addr;
    wire [31:0] mem_write_data;

    reg         mem_write_ready;

    // ============================================================
    // BACKING MEMORY
    //
    // Address mapping:
    //
    // memory[mem_addr[9:2]]
    //
    // Therefore:
    //
    // 0x00 -> memory[0]
    // 0x10 -> memory[4]
    // 0x20 -> memory[8]
    // 0x30 -> memory[12]
    // 0x70 -> memory[28]
    // ============================================================

    reg [31:0] memory [0:255];

    // ============================================================
    // MEMORY TRANSACTION TRACKING
    // ============================================================

    reg        read_pending;
    reg [31:0] read_pending_addr;
    reg [31:0] read_pending_data;

    reg        write_pending;
    reg [31:0] write_pending_addr;
    reg [31:0] write_pending_data;

    integer read_response_count;
    integer write_response_count;

    // ============================================================
    // TEST STATUS
    // ============================================================

    integer pass_count;
    integer fail_count;

    // ============================================================
    // DUT
    // ============================================================

    cache_miss_stall_controller dut (

        .clk        (clk),
        .rst        (rst),

        .req_valid  (req_valid),
        .req_ready  (req_ready),

        .req_write  (req_write),
        .req_addr   (req_addr),
        .req_wdata  (req_wdata),

        .resp_valid (resp_valid),
        .resp_hit   (resp_hit),
        .resp_rdata (resp_rdata),

        .mem_read   (mem_read),
        .mem_addr   (mem_addr),

        .mem_rdata  (mem_rdata),
        .mem_ready  (mem_ready),

        .mem_write       (mem_write),
        .mem_write_addr  (mem_write_addr),
        .mem_write_data  (mem_write_data),

        .mem_write_ready (mem_write_ready)

    );

    // ============================================================
    // CLOCK
    // ============================================================

    always #5 clk = ~clk;

    // ============================================================
    // BACKING MEMORY MODEL
    //
    // One memory read request produces exactly one response.
    //
    // One memory write request produces exactly one completion.
    // ============================================================

    always @(posedge clk) begin

        // --------------------------------------------------------
        // Default response pulses
        // --------------------------------------------------------

        mem_ready       <= 1'b0;
        mem_write_ready <= 1'b0;

        // --------------------------------------------------------
        // READ REQUEST
        // --------------------------------------------------------

        if (mem_read && !read_pending) begin

            read_pending <= 1'b1;

            read_pending_addr <=
                mem_addr;

            read_pending_data <=
                memory[mem_addr[9:2]];

        end

        // --------------------------------------------------------
        // READ RESPONSE
        // --------------------------------------------------------

        else if (read_pending) begin

            mem_rdata <=
                read_pending_data;

            mem_ready <=
                1'b1;

            read_response_count <=
                read_response_count + 1;

            $display(
                "MEMORY READ : address=%h data=%h",
                read_pending_addr,
                read_pending_data
            );

            read_pending <=
                1'b0;

        end

        // --------------------------------------------------------
        // WRITE REQUEST
        // --------------------------------------------------------

        if (mem_write && !write_pending) begin

            write_pending <=
                1'b1;

            write_pending_addr <=
                mem_write_addr;

            write_pending_data <=
                mem_write_data;

        end

        // --------------------------------------------------------
        // WRITE RESPONSE
        // --------------------------------------------------------

        else if (write_pending) begin

            memory[write_pending_addr[9:2]] <=
                write_pending_data;

            mem_write_ready <=
                1'b1;

            write_response_count <=
                write_response_count + 1;

            $display(
                "MEMORY WRITE: address=%h data=%h",
                write_pending_addr,
                write_pending_data
            );

            write_pending <=
                1'b0;

        end

    end

    // ============================================================
    // CHECK HELPER
    // ============================================================

    task check_value;

        input [31:0] expected;
        input [31:0] actual;
        input [255:0] description;

        begin

            if (actual === expected) begin

                $display(
                    "PASS: %s",
                    description
                );

                pass_count = pass_count + 1;

            end

            else begin

                $display(
                    "FAIL: %s expected=%h actual=%h",
                    description,
                    expected,
                    actual
                );

                fail_count = fail_count + 1;

            end

        end

    endtask

    // ============================================================
    // CPU READ TASK
    // ============================================================

    task cache_read;

        input [31:0] addr;
        input         expected_hit;
        input [31:0] expected_data;

        begin

            while (!req_ready)
                @(negedge clk);

            @(negedge clk);

            req_valid = 1'b1;
            req_write = 1'b0;
            req_addr  = addr;
            req_wdata = 32'h0000_0000;

            #1;

            if (!req_ready) begin

                $display(
                    "FAIL: request was not accepted"
                );

                fail_count = fail_count + 1;

            end

            else begin

                $display(
                    "CPU READ REQUEST: address=%h",
                    addr
                );

                pass_count = pass_count + 1;

            end

            @(negedge clk);

            req_valid = 1'b0;

            wait (resp_valid);

            #1;

            $display(
                "CPU RESPONSE: hit=%b data=%h",
                resp_hit,
                resp_rdata
            );

            check_value(
                expected_hit,
                resp_hit,
                "response hit status"
            );

            check_value(
                expected_data,
                resp_rdata,
                "response data"
            );

            @(negedge clk);

        end

    endtask

    // ============================================================
    // CPU WRITE TASK
    // ============================================================

    task cache_write;

        input [31:0] addr;
        input [31:0] data;
        input         expected_hit;

        begin

            while (!req_ready)
                @(negedge clk);

            @(negedge clk);

            req_valid = 1'b1;
            req_write = 1'b1;
            req_addr  = addr;
            req_wdata = data;

            #1;

            if (!req_ready) begin

                $display(
                    "FAIL: write request was not accepted"
                );

                fail_count = fail_count + 1;

            end

            else begin

                $display(
                    "CPU WRITE REQUEST: address=%h data=%h",
                    addr,
                    data
                );

                pass_count = pass_count + 1;

            end

            @(negedge clk);

            req_valid = 1'b0;

            wait (resp_valid);

            #1;

            $display(
                "CPU WRITE RESPONSE: hit=%b data=%h",
                resp_hit,
                resp_rdata
            );

            check_value(
                expected_hit,
                resp_hit,
                "write hit status"
            );

            check_value(
                data,
                resp_rdata,
                "write response data"
            );

            @(negedge clk);

        end

    endtask

    // ============================================================
    // MAIN TEST
    // ============================================================

    initial begin

        // --------------------------------------------------------
        // INITIAL VALUES
        // --------------------------------------------------------

        clk = 1'b0;
        rst = 1'b1;

        req_valid = 1'b0;
        req_write = 1'b0;

        req_addr  = 32'h0000_0000;
        req_wdata = 32'h0000_0000;

        mem_rdata = 32'h0000_0000;
        mem_ready = 1'b0;

        mem_write_ready = 1'b0;

        read_pending = 1'b0;
        read_pending_addr = 32'h0000_0000;
        read_pending_data = 32'h0000_0000;

        write_pending = 1'b0;
        write_pending_addr = 32'h0000_0000;
        write_pending_data = 32'h0000_0000;

        read_response_count = 0;
        write_response_count = 0;

        pass_count = 0;
        fail_count = 0;

        // --------------------------------------------------------
        // INITIALIZE BACKING MEMORY
        // --------------------------------------------------------

        memory[0]  = 32'h1111_0000;
        memory[4]  = 32'h2222_0000;
        memory[8]  = 32'h3333_0000;
        memory[12] = 32'h4444_0000;

        // --------------------------------------------------------
        // IMPORTANT:
        //
        // Address 0x70 maps to memory[28].
        //
        // Initialize it explicitly so the clean replacement
        // test does not produce X values.
        // --------------------------------------------------------

        memory[28] = 32'h0000_0000;

        // --------------------------------------------------------
        // RESET
        // --------------------------------------------------------

        #20;

        rst = 1'b0;

        $display("");
        $display("================================================");
        $display("PROJECT 35 - CACHE MISS / STALL CONTROLLER");
        $display("STEP 5 - FULL VERIFICATION");
        $display("================================================");

        // ========================================================
        // TEST 1
        // ========================================================

        $display("");
        $display("TEST 1: Reset / controller ready");

        check_value(
            1'b1,
            req_ready,
            "controller ready after reset"
        );

        // ========================================================
        // TEST 2
        // ========================================================

        $display("");
        $display("TEST 2: First read miss");
        $display("Expected: MISS + 11110000");

        read_response_count = 0;

        cache_read(
            32'h0000_0000,
            1'b0,
            32'h1111_0000
        );

        check_value(
            1,
            read_response_count,
            "exactly one memory read response"
        );

        // ========================================================
        // TEST 3
        // ========================================================

        $display("");
        $display("TEST 3: Repeated read hit");
        $display("Expected: HIT + no memory access");

        read_response_count = 0;

        cache_read(
            32'h0000_0000,
            1'b1,
            32'h1111_0000
        );

        check_value(
            0,
            read_response_count,
            "no memory read on cache hit"
        );

        // ========================================================
        // TEST 4
        // ========================================================

        $display("");
        $display("TEST 4: Write hit");
        $display("Expected: HIT + AAAAAAAA");

        cache_write(
            32'h0000_0000,
            32'hAAAA_AAAA,
            1'b1
        );

        // ========================================================
        // TEST 5
        // ========================================================

        $display("");
        $display("TEST 5: Read after write");
        $display("Expected: HIT + AAAAAAAA");

        read_response_count = 0;

        cache_read(
            32'h0000_0000,
            1'b1,
            32'hAAAA_AAAA
        );

        check_value(
            0,
            read_response_count,
            "modified line served from cache"
        );

        // ========================================================
        // TEST 6
        //
        // Access 0x10.
        //
        // 0x00 and 0x10 map to the same direct-mapped set.
        //
        // 0x00 is dirty, so it must be written back before 0x10
        // is refilled.
        // ========================================================

        $display("");
        $display("TEST 6: Dirty eviction");
        $display("Expected: WRITE-BACK AAAAAAAA + refill 22220000");

        write_response_count = 0;

        cache_read(
            32'h0000_0010,
            1'b0,
            32'h2222_0000
        );

        check_value(
            1,
            write_response_count,
            "dirty victim written back"
        );

        check_value(
            32'hAAAA_AAAA,
            memory[0],
            "memory updated after write-back"
        );

        // ========================================================
        // TEST 7
        //
        // 0x00 was already evicted by Test 6.
        //
        // Therefore this is a CLEAN MISS.
        // ========================================================

        $display("");
        $display("TEST 7: Restore original address");
        $display("Expected: CLEAN MISS + AAAAAAAA");

        read_response_count = 0;
        write_response_count = 0;

        cache_read(
            32'h0000_0000,
            1'b0,
            32'hAAAA_AAAA
        );

        check_value(
            1,
            read_response_count,
            "restored address caused memory read"
        );

        check_value(
            0,
            write_response_count,
            "clean victim caused no write-back"
        );

        // ========================================================
        // TEST 8
        // ========================================================

        $display("");
        $display("TEST 8: Repeated restored address");
        $display("Expected: HIT + AAAAAAAA");

        read_response_count = 0;
        write_response_count = 0;

        cache_read(
            32'h0000_0000,
            1'b1,
            32'hAAAA_AAAA
        );

        check_value(
            0,
            read_response_count,
            "restored line served from cache"
        );

        check_value(
            0,
            write_response_count,
            "cache hit generated no write-back"
        );

        // ========================================================
        // TEST 9
        //
        // 0x20 conflicts with 0x00.
        //
        // Current 0x00 line is clean, therefore replacement must
        // NOT produce a write-back.
        // ========================================================

        $display("");
        $display("TEST 9: Clean replacement");
        $display("Expected: MISS + 33330000 + NO WRITE-BACK");

        read_response_count = 0;
        write_response_count = 0;

        cache_read(
            32'h0000_0020,
            1'b0,
            32'h3333_0000
        );

        check_value(
            1,
            read_response_count,
            "clean replacement caused one memory read"
        );

        check_value(
            0,
            write_response_count,
            "clean victim caused no write-back"
        );

        // ========================================================
        // TEST 10
        // ========================================================

        $display("");
        $display("TEST 10: Repeated clean-line hit");

        read_response_count = 0;
        write_response_count = 0;

        cache_read(
            32'h0000_0020,
            1'b1,
            32'h3333_0000
        );

        check_value(
            0,
            read_response_count,
            "clean hit generated no memory read"
        );

        check_value(
            0,
            write_response_count,
            "clean hit generated no memory write"
        );

        // ========================================================
        // TEST 11
        //
        // 0x30 is a write miss.
        //
        // The backing memory at 0x30 contains 44440000.
        // The cache then updates the line to 55555555 and marks
        // it dirty.
        // ========================================================

        $display("");
        $display("TEST 11: Write miss");

        read_response_count = 0;
        write_response_count = 0;

        cache_write(
            32'h0000_0030,
            32'h5555_5555,
            1'b0
        );

        check_value(
            1,
            read_response_count,
            "write miss caused one memory refill"
        );

        check_value(
            0,
            write_response_count,
            "clean victim caused no write-back"
        );

        // ========================================================
        // TEST 12
        // ========================================================

        $display("");
        $display("TEST 12: Read after write miss");
        $display("Expected: HIT + 55555555");

        read_response_count = 0;
        write_response_count = 0;

        cache_read(
            32'h0000_0030,
            1'b1,
            32'h5555_5555
        );

        check_value(
            0,
            read_response_count,
            "write-miss line served from cache"
        );

        check_value(
            0,
            write_response_count,
            "no write-back while line remains cached"
        );

        // ========================================================
        // TEST 13
        //
        // 0x70 conflicts with 0x30 in this direct-mapped cache.
        //
        // The 0x30 line is dirty.
        //
        // Therefore:
        //
        // 1. 0x30 must be written back.
        // 2. 0x70 must be refilled.
        // ========================================================

        $display("");
        $display("TEST 13: Dirty eviction of write-miss line");
        $display("Expected: WRITE-BACK 55555555");

        write_response_count = 0;

        cache_read(
            32'h0000_0070,
            1'b0,
            32'h0000_0000
        );

        check_value(
            1,
            write_response_count,
            "dirty 0x30 line written back"
        );

        check_value(
            32'h5555_5555,
            memory[12],
            "memory[0x30] contains written data"
        );

        // ========================================================
        // TEST 14
        // ========================================================

        $display("");
        $display("TEST 14: Restore 0x30 after dirty eviction");

        read_response_count = 0;

        cache_read(
            32'h0000_0030,
            1'b0,
            32'h5555_5555
        );

        check_value(
            1,
            read_response_count,
            "restored 0x30 required memory read"
        );

        // ========================================================
        // FINAL BACKING MEMORY
        // ========================================================

        $display("");
        $display("================================================");
        $display("FINAL BACKING MEMORY");
        $display("================================================");

        $display(
            "MEMORY[0x00000000] = %h",
            memory[0]
        );

        $display(
            "MEMORY[0x00000010] = %h",
            memory[4]
        );

        $display(
            "MEMORY[0x00000020] = %h",
            memory[8]
        );

        $display(
            "MEMORY[0x00000030] = %h",
            memory[12]
        );

        $display(
            "MEMORY[0x00000070] = %h",
            memory[28]
        );

        // ========================================================
        // FINAL STATUS
        // ========================================================

        $display("");
        $display("================================================");
        $display("PROJECT 35 STEP 5 VERIFICATION SUMMARY");
        $display("================================================");

        $display(
            "PASS COUNT = %0d",
            pass_count
        );

        $display(
            "FAIL COUNT = %0d",
            fail_count
        );

        if (fail_count == 0) begin

            $display("");
            $display(
                "=============================================="
            );

            $display(
                "PROJECT 35 FULL VERIFICATION: PASS"
            );

            $display(
                "=============================================="
            );

        end

        else begin

            $display("");
            $display(
                "=============================================="
            );

            $display(
                "PROJECT 35 FULL VERIFICATION: FAIL"
            );

            $display(
                "=============================================="
            );

        end

        $display("");

        $finish;

    end

    // ============================================================
    // WAVEFORM
    // ============================================================

    initial begin

        $dumpfile(
            "waves/cache_miss_stall_controller.vcd"
        );

        $dumpvars(
            0,
            tb_cache_miss_stall_controller
        );

    end

endmodule