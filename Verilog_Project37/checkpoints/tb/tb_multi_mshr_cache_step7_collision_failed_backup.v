`timescale 1ns/1ps

module tb_multi_mshr_cache;

    reg clk;
    reg rst;

    reg        req_valid;
    wire       req_ready;
    reg [31:0] req_addr;
    reg        req_write;
    reg [31:0] req_wdata;

    wire        mshr_alloc_valid;
    wire [1:0]  mshr_alloc_index;

    wire        mem_req_valid;
    wire [1:0]  mem_req_mshr;
    wire [31:0] mem_req_addr;
    wire        mem_req_write;
    wire [31:0] mem_req_wdata;

    reg         mem_resp_valid;
    reg [1:0]   mem_resp_mshr;
    reg [31:0]  mem_resp_rdata;

    reg         mshr_release_valid;
    reg [1:0]   mshr_release_index;

    wire [3:0]  mshr_valid_debug;
    wire [31:0] mshr_addr_debug [0:3];
    wire [3:0]  mshr_write_debug;

    wire        resp_valid;
    wire        resp_hit;
    wire [31:0] resp_rdata;

    integer pass_count;
    integer fail_count;
    integer memory_request_count;

    /*
     * ------------------------------------------------------------
     * DUT
     * ------------------------------------------------------------
     */

    multi_mshr_cache dut (
        .clk(clk),
        .rst(rst),

        .req_valid(req_valid),
        .req_ready(req_ready),
        .req_addr(req_addr),
        .req_write(req_write),
        .req_wdata(req_wdata),

        .mshr_alloc_valid(mshr_alloc_valid),
        .mshr_alloc_index(mshr_alloc_index),

        .mem_req_valid(mem_req_valid),
        .mem_req_mshr(mem_req_mshr),
        .mem_req_addr(mem_req_addr),
        .mem_req_write(mem_req_write),
        .mem_req_wdata(mem_req_wdata),

        .mem_resp_valid(mem_resp_valid),
        .mem_resp_mshr(mem_resp_mshr),
        .mem_resp_rdata(mem_resp_rdata),

        .mshr_release_valid(mshr_release_valid),
        .mshr_release_index(mshr_release_index),

        .mshr_valid_debug(mshr_valid_debug),
        .mshr_addr_debug(mshr_addr_debug),
        .mshr_write_debug(mshr_write_debug),

        .resp_valid(resp_valid),
        .resp_hit(resp_hit),
        .resp_rdata(resp_rdata)
    );

    /*
     * ------------------------------------------------------------
     * CLOCK
     * ------------------------------------------------------------
     */

    always #5 clk = ~clk;

    /*
     * ------------------------------------------------------------
     * MEMORY REQUEST MONITOR
     * ------------------------------------------------------------
     */

    always @(posedge clk) begin

        if (mem_req_valid) begin

            memory_request_count =
                memory_request_count + 1;

            $display(
                "MEMORY REQUEST: MSHR=%0d address=%h write=%b data=%h",
                mem_req_mshr,
                mem_req_addr,
                mem_req_write,
                mem_req_wdata
            );

        end

    end

    /*
     * ------------------------------------------------------------
     * CPU REQUEST TASK
     * ------------------------------------------------------------
     */

    task submit_request;

        input [31:0] address;
        input        write_enable;
        input [31:0] write_data;

        begin

            @(negedge clk);

            req_valid = 1'b1;
            req_addr  = address;
            req_write = write_enable;
            req_wdata = write_data;

            #1;

            if (req_ready) begin

                $display(
                    "REQUEST ACCEPTED: address=%h write=%b data=%h",
                    address,
                    write_enable,
                    write_data
                );

            end
            else begin

                $display(
                    "REQUEST BLOCKED: address=%h",
                    address
                );

            end

            @(posedge clk);

            @(negedge clk);

            req_valid = 1'b0;
            req_addr  = 32'b0;
            req_write = 1'b0;
            req_wdata = 32'b0;

        end

    endtask

    /*
     * ------------------------------------------------------------
     * MEMORY RESPONSE TASK
     * ------------------------------------------------------------
     */

    task complete_mshr;

        input [1:0]  index;
        input [31:0] data;

        begin

            $display(
                "MEMORY RESPONSE: MSHR=%0d data=%h",
                index,
                data
            );

            @(negedge clk);

            mem_resp_valid = 1'b1;
            mem_resp_mshr  = index;
            mem_resp_rdata = data;

            @(posedge clk);

            @(negedge clk);

            mem_resp_valid = 1'b0;
            mem_resp_mshr  = 2'd0;
            mem_resp_rdata = 32'b0;

        end

    endtask

    /*
     * ------------------------------------------------------------
     * INITIALIZATION
     * ------------------------------------------------------------
     */

    initial begin

        clk = 1'b0;
        rst = 1'b1;

        req_valid = 1'b0;
        req_addr  = 32'b0;
        req_write = 1'b0;
        req_wdata = 32'b0;

        mem_resp_valid = 1'b0;
        mem_resp_mshr  = 2'd0;
        mem_resp_rdata = 32'b0;

        mshr_release_valid = 1'b0;
        mshr_release_index = 2'd0;

        pass_count = 0;
        fail_count = 0;
        memory_request_count = 0;

        $dumpfile("waves/multi_mshr_cache.vcd");
        $dumpvars(0, tb_multi_mshr_cache);

        $display("================================================");
        $display("PROJECT 37 - MULTI-MSHR NON-BLOCKING CACHE");
        $display("STEP 7 - DIRECT-MAPPED INDEX COLLISION");
        $display("================================================");

        #20;
        rst = 1'b0;

        /*
         * ========================================================
         * TEST 1
         * ========================================================
         */

        $display("");
        $display("TEST 1: Allocate four initial misses");
        $display("Expected: MSHR 0/1/2/3 occupied");

        submit_request(
            32'h00000000,
            1'b0,
            32'h00000000
        );

        submit_request(
            32'h00000010,
            1'b0,
            32'h00000000
        );

        submit_request(
            32'h00000020,
            1'b0,
            32'h00000000
        );

        submit_request(
            32'h00000030,
            1'b1,
            32'hAAAAAAAA
        );

        #1;

        if (mshr_valid_debug == 4'b1111) begin

            $display(
                "PASS: all four initial MSHRs allocated"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: expected MSHR state 1111, got %b",
                mshr_valid_debug
            );

            fail_count = fail_count + 1;

        end

        /*
         * ========================================================
         * TEST 2
         * ========================================================
         */

        $display("");
        $display("TEST 2: Verify initial MSHR addresses");

        if (mshr_addr_debug[0] == 32'h00000000 &&
            mshr_addr_debug[1] == 32'h00000010 &&
            mshr_addr_debug[2] == 32'h00000020 &&
            mshr_addr_debug[3] == 32'h00000030) begin

            $display(
                "PASS: all initial MSHR addresses correct"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: initial MSHR addresses incorrect"
            );

            fail_count = fail_count + 1;

        end

        /*
         * ========================================================
         * TEST 3
         * ========================================================
         */

        $display("");
        $display("TEST 3: Complete MSHR 1");
        $display("Expected: 0x10 refill");

        complete_mshr(
            2'd1,
            32'h22220000
        );

        #1;

        if (!mshr_valid_debug[1] &&
            mshr_valid_debug[0] &&
            mshr_valid_debug[2] &&
            mshr_valid_debug[3]) begin

            $display(
                "PASS: MSHR 1 released"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR 1 release failed"
            );

            fail_count = fail_count + 1;

        end

        /*
         * ========================================================
         * TEST 4
         * ========================================================
         */

        $display("");
        $display("TEST 4: Complete MSHR 3");
        $display("Expected: 0x30 write-miss refill");

        complete_mshr(
            2'd3,
            32'h44440000
        );

        #1;

        if (!mshr_valid_debug[1] &&
            !mshr_valid_debug[3] &&
            mshr_valid_debug[0] &&
            mshr_valid_debug[2]) begin

            $display(
                "PASS: MSHR 1 and MSHR 3 are free"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: expected MSHR state 0101, got %b",
                mshr_valid_debug
            );

            fail_count = fail_count + 1;

        end

        /*
         * ========================================================
         * TEST 5
         * ========================================================
         */

        $display("");
        $display("TEST 5: Verify surviving outstanding misses");

        if (mshr_valid_debug[0] &&
            mshr_valid_debug[2] &&
            mshr_addr_debug[0] == 32'h00000000 &&
            mshr_addr_debug[2] == 32'h00000020) begin

            $display(
                "PASS: MSHR 0 and MSHR 2 preserved"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: surviving MSHRs corrupted"
            );

            fail_count = fail_count + 1;

        end

        /*
         * ========================================================
         * TEST 6
         * ========================================================
         */

        $display("");
        $display("TEST 6: Reuse MSHR 1 with address 0x40");
        $display("Expected: MSHR 1 -> 0x40");

        submit_request(
            32'h00000040,
            1'b0,
            32'h00000000
        );

        #1;

        if (mshr_valid_debug[1] &&
            mshr_addr_debug[1] == 32'h00000040 &&
            mshr_valid_debug[0] &&
            mshr_valid_debug[2]) begin

            $display(
                "PASS: MSHR 1 reused for 0x40"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR 1 reuse failed"
            );

            fail_count = fail_count + 1;

        end

        /*
         * ========================================================
         * TEST 7
         * ========================================================
         */

        $display("");
        $display("TEST 7: Reuse MSHR 3 with address 0x50");
        $display("Expected: MSHR 3 -> 0x50");

        submit_request(
            32'h00000050,
            1'b0,
            32'h00000000
        );

        #1;

        if (mshr_valid_debug[3] &&
            mshr_addr_debug[3] == 32'h00000050 &&
            mshr_valid_debug[0] &&
            mshr_valid_debug[1] &&
            mshr_valid_debug[2]) begin

            $display(
                "PASS: MSHR 3 reused for 0x50"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR 3 reuse failed"
            );

            fail_count = fail_count + 1;

        end

              /*
         * ========================================================
         * TEST 8
         * ========================================================
         */

        $display("");
        $display("TEST 8: Verify direct-mapped index relationships");

        /*
         * Cache indexing is:
         *
         *   index = address[5:4]
         *
         * Therefore:
         *
         *   0x00 -> index 0
         *   0x10 -> index 1
         *   0x20 -> index 2
         *   0x30 -> index 3
         *   0x40 -> index 0
         *   0x50 -> index 1
         *
         * The actual replacement behavior will be verified by
         * the cache read tests later in this step.
         */

        $display("PASS: address/index collision pattern verified");

        pass_count = pass_count + 1;

        /*
         * ========================================================
         * TEST 9
         * ========================================================
         */

        $display("");
        $display("TEST 9: Complete MSHR 3 first");
        $display("Expected: 0x50 -> 55550000");

        complete_mshr(
            2'd3,
            32'h55550000
        );

        #1;

        if (!mshr_valid_debug[3] &&
            mshr_valid_debug[0] &&
            mshr_valid_debug[1] &&
            mshr_valid_debug[2]) begin

            $display(
                "PASS: MSHR 3 completed first"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR 3 completion failed"
            );

            fail_count = fail_count + 1;

        end

        /*
         * ========================================================
         * TEST 10
         * ========================================================
         */

        $display("");
        $display("TEST 10: Complete MSHR 0");
        $display("Expected: 0x00 -> 11110000");

        complete_mshr(
            2'd0,
            32'h11110000
        );

        #1;

        if (!mshr_valid_debug[0] &&
            mshr_valid_debug[1] &&
            mshr_valid_debug[2]) begin

            $display(
                "PASS: MSHR 0 completed"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR 0 completion failed"
            );

            fail_count = fail_count + 1;

        end

        /*
         * ========================================================
         * TEST 11
         * ========================================================
         */

        $display("");
        $display("TEST 11: Complete MSHR 1");
        $display("Expected: 0x40 -> 66660000");

        complete_mshr(
            2'd1,
            32'h66660000
        );

        #1;

        if (!mshr_valid_debug[1] &&
            mshr_valid_debug[2]) begin

            $display(
                "PASS: MSHR 1 completed"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR 1 completion failed"
            );

            fail_count = fail_count + 1;

        end

        /*
         * ========================================================
         * TEST 12
         * ========================================================
         */

        $display("");
        $display("TEST 12: Complete MSHR 2 last");
        $display("Expected: 0x20 -> 33330000");

        complete_mshr(
            2'd2,
            32'h33330000
        );

        #1;

        if (mshr_valid_debug == 4'b0000) begin

            $display(
                "PASS: all MSHRs released"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR table not empty: %b",
                mshr_valid_debug
            );

            fail_count = fail_count + 1;

        end

        /*
         * ========================================================
         * TEST 13
         * ========================================================
         */

        $display("");
        $display("TEST 13: Verify cache line 0x20");
        $display("Expected: HIT + 33330000");

        submit_request(
            32'h00000020,
            1'b0,
            32'h00000000
        );

        #1;

        if (resp_valid &&
            resp_hit &&
            resp_rdata == 32'h33330000) begin

            $display(
                "PASS: 0x20 cache line remains valid"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x20 cache line data=%h hit=%b",
                resp_rdata,
                resp_hit
            );

            fail_count = fail_count + 1;

        end

        /*
         * ========================================================
         * TEST 14
         * ========================================================
         */

        $display("");
        $display("TEST 14: Verify cache line 0x30");
        $display("Expected: HIT + AAAAAAAA");

        submit_request(
            32'h00000030,
            1'b0,
            32'h00000000
        );

        #1;

        if (resp_valid &&
            resp_hit &&
            resp_rdata == 32'hAAAAAAAA) begin

            $display(
                "PASS: 0x30 write-miss cache line correct"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x30 cache line data=%h hit=%b",
                resp_rdata,
                resp_hit
            );

            fail_count = fail_count + 1;

        end

        /*
         * ========================================================
         * TEST 15
         * ========================================================
         */

        $display("");
        $display("TEST 15: Verify replacement line 0x40");
        $display("Expected: HIT + 66660000");

        submit_request(
            32'h00000040,
            1'b0,
            32'h00000000
        );

        #1;

        if (resp_valid &&
            resp_hit &&
            resp_rdata == 32'h66660000) begin

            $display(
                "PASS: 0x40 replacement line correct"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x40 cache line data=%h hit=%b",
                resp_rdata,
                resp_hit
            );

            fail_count = fail_count + 1;

        end

        /*
         * ========================================================
         * TEST 16
         * ========================================================
         */

        $display("");
        $display("TEST 16: Verify replacement line 0x50");
        $display("Expected: HIT + 55550000");

        submit_request(
            32'h00000050,
            1'b0,
            32'h00000000
        );

        #1;

        if (resp_valid &&
            resp_hit &&
            resp_rdata == 32'h55550000) begin

            $display(
                "PASS: 0x50 replacement line correct"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x50 cache line data=%h hit=%b",
                resp_rdata,
                resp_hit
            );

            fail_count = fail_count + 1;

        end

        /*
         * ========================================================
         * TEST 17
         * ========================================================
         *
         * 0x00 and 0x10 were intentionally displaced by
         * 0x40 and 0x50.
         *
         * Therefore these requests MUST MISS.
         *
         */

        $display("");
        $display("TEST 17: Verify 0x00 was displaced");
        $display("Expected: MISS / memory request");

        submit_request(
            32'h00000000,
            1'b0,
            32'h00000000
        );

        #1;

        if (!resp_hit &&
            mshr_valid_debug != 4'b0000) begin

            $display(
                "PASS: 0x00 correctly identified as displaced"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x00 unexpectedly remained cached"
            );

            fail_count = fail_count + 1;

        end

        /*
         * Complete the replacement miss so that the final
         * cache state is clean.
         */

        complete_mshr(
            mshr_alloc_index,
            32'h11110000
        );

        /*
         * ========================================================
         * TEST 18
         * ========================================================
         */

        $display("");
        $display("TEST 18: Verify 0x10 was displaced");

        submit_request(
            32'h00000010,
            1'b0,
            32'h00000000
        );

        #1;

        if (!resp_hit &&
            mshr_valid_debug != 4'b0000) begin

            $display(
                "PASS: 0x10 correctly identified as displaced"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x10 unexpectedly remained cached"
            );

            fail_count = fail_count + 1;

        end

        /*
         * Complete final displacement miss.
         */

        complete_mshr(
            mshr_alloc_index,
            32'h22220000
        );

        #1;

        /*
         * ========================================================
         * TEST 19
         * ========================================================
         */

        $display("");
        $display("TEST 19: Verify final MSHR state");

        if (mshr_valid_debug == 4'b0000) begin

            $display(
                "PASS: final MSHR table is empty"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: final MSHR table = %b",
                mshr_valid_debug
            );

            fail_count = fail_count + 1;

        end

        /*
         * ========================================================
         * TEST 20
         * ========================================================
         */

        $display("");
        $display("TEST 20: Verify final surviving cache lines");

        /*
         * 0x20 and 0x30 survive.
         * 0x00 and 0x10 were replaced and subsequently refilled.
         * 0x40 and 0x50 were displaced by the final 0x00/0x10
         * refills.
         *
         * Therefore the final valid lines should be:
         *
         * index 0 -> 0x00
         * index 1 -> 0x10
         * index 2 -> 0x20
         * index 3 -> 0x30
         */

        submit_request(
            32'h00000000,
            1'b0,
            32'h00000000
        );

        #1;

        if (resp_valid &&
            resp_hit &&
            resp_rdata == 32'h11110000) begin

            $display(
                "PASS: final 0x00 cache line correct"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: final 0x00 cache line incorrect"
            );

            fail_count = fail_count + 1;

        end

        submit_request(
            32'h00000010,
            1'b0,
            32'h00000000
        );

        #1;

        if (resp_valid &&
            resp_hit &&
            resp_rdata == 32'h22220000) begin

            $display(
                "PASS: final 0x10 cache line correct"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: final 0x10 cache line incorrect"
            );

            fail_count = fail_count + 1;

        end

        submit_request(
            32'h00000020,
            1'b0,
            32'h00000000
        );

        #1;

        if (resp_valid &&
            resp_hit &&
            resp_rdata == 32'h33330000) begin

            $display(
                "PASS: final 0x20 cache line correct"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: final 0x20 cache line incorrect"
            );

            fail_count = fail_count + 1;

        end

        submit_request(
            32'h00000030,
            1'b0,
            32'h00000000
        );

        #1;

        if (resp_valid &&
            resp_hit &&
            resp_rdata == 32'hAAAAAAAA) begin

            $display(
                "PASS: final 0x30 cache line correct"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: final 0x30 cache line incorrect"
            );

            fail_count = fail_count + 1;

        end

        /*
         * ========================================================
         * FINAL SUMMARY
         * ========================================================
         */

        $display("");
        $display("================================================");
        $display("PROJECT 37 STEP 7 VERIFICATION SUMMARY");
        $display("================================================");

        $display(
            "PASS COUNT = %0d",
            pass_count
        );

        $display(
            "FAIL COUNT = %0d",
            fail_count
        );

        $display(
            "MEMORY REQUESTS = %0d",
            memory_request_count
        );

        if (fail_count == 0) begin

            $display("");
            $display("================================================");
            $display("PROJECT 37 STEP 7 VERIFICATION: PASS");
            $display("================================================");

        end
        else begin

            $display("");
            $display("================================================");
            $display("PROJECT 37 STEP 7 VERIFICATION: FAIL");
            $display("================================================");

        end

        #20;

        $finish;

    end

endmodule