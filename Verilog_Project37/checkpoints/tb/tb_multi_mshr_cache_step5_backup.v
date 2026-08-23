`timescale 1ns/1ps

module tb_multi_mshr_cache;

    reg clk;
    reg rst;

    reg        req_valid;
    wire       req_ready;
    reg [31:0] req_addr;
    reg        req_write;
    reg [31:0] req_wdata;

    wire       mshr_alloc_valid;
    wire [1:0] mshr_alloc_index;

    wire        mem_req_valid;
    wire [1:0]  mem_req_mshr;
    wire [31:0] mem_req_addr;
    wire        mem_req_write;
    wire [31:0] mem_req_wdata;

    reg        mem_resp_valid;
    reg [1:0]  mem_resp_mshr;
    reg [31:0] mem_resp_rdata;

    reg        mshr_release_valid;
    reg [1:0]  mshr_release_index;

    wire [3:0]  mshr_valid_debug;
    wire [31:0] mshr_addr_debug [0:3];
    wire [3:0]  mshr_write_debug;

    wire        resp_valid;
    wire        resp_hit;
    wire [31:0] resp_rdata;

    integer pass_count;
    integer fail_count;
    integer memory_request_count;

    reg [3:0] memory_request_seen;


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


    always #5 clk = ~clk;


    /*
     * ============================================================
     * MEMORY REQUEST MONITOR
     * ============================================================
     */

    always @(posedge clk) begin

        if (mem_req_valid) begin

            memory_request_count =
                memory_request_count + 1;

            memory_request_seen[mem_req_mshr] =
                1'b1;

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
     * ============================================================
     * CPU REQUEST TASK
     * ============================================================
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

                @(posedge clk);

            end
            else begin

                $display(
                    "REQUEST BLOCKED: address=%h",
                    address
                );

                @(posedge clk);

            end

            @(negedge clk);

            req_valid = 1'b0;
            req_addr  = 32'b0;
            req_write = 1'b0;
            req_wdata = 32'b0;

        end

    endtask


    /*
     * ============================================================
     * MEMORY RESPONSE TASK
     * ============================================================
     */

    task complete_mshr;

        input [1:0] index;
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
     * ============================================================
     * INITIALIZATION
     * ============================================================
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
        memory_request_seen = 4'b0000;


        $dumpfile("waves/multi_mshr_cache.vcd");
        $dumpvars(0, tb_multi_mshr_cache);


        $display("================================================");
        $display("PROJECT 37 - MULTI-MSHR NON-BLOCKING CACHE");
        $display("STEP 5 - OUT-OF-ORDER CACHE REFILLS");
        $display("================================================");


        /*
         * RESET
         */

        #20;
        rst = 1'b0;


        /*
         * ========================================================
         * TEST 1
         * ========================================================
         */

        $display("");
        $display("TEST 1: Allocate MSHR 0");
        $display("Expected: address 00000000");

        submit_request(
            32'h00000000,
            1'b0,
            32'h00000000
        );

        #1;

        if (mshr_valid_debug[0] &&
            mshr_addr_debug[0] == 32'h00000000) begin

            $display("PASS: MSHR 0 allocated");
            pass_count = pass_count + 1;

        end
        else begin

            $display("FAIL: MSHR 0 allocation");
            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 2
         * ========================================================
         */

        $display("");
        $display("TEST 2: Allocate MSHR 1");
        $display("Expected: address 00000010");

        submit_request(
            32'h00000010,
            1'b0,
            32'h00000000
        );

        #1;

        if (mshr_valid_debug[1] &&
            mshr_addr_debug[1] == 32'h00000010) begin

            $display("PASS: MSHR 1 allocated");
            pass_count = pass_count + 1;

        end
        else begin

            $display("FAIL: MSHR 1 allocation");
            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 3
         * ========================================================
         */

        $display("");
        $display("TEST 3: Allocate MSHR 2");
        $display("Expected: address 00000020");

        submit_request(
            32'h00000020,
            1'b0,
            32'h00000000
        );

        #1;

        if (mshr_valid_debug[2] &&
            mshr_addr_debug[2] == 32'h00000020) begin

            $display("PASS: MSHR 2 allocated");
            pass_count = pass_count + 1;

        end
        else begin

            $display("FAIL: MSHR 2 allocation");
            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 4
         * ========================================================
         */

        $display("");
        $display("TEST 4: Allocate MSHR 3");
        $display("Expected: address 00000030 + WRITE");

        submit_request(
            32'h00000030,
            1'b1,
            32'hAAAAAAAA
        );

        #1;

        if (mshr_valid_debug[3] &&
            mshr_addr_debug[3] == 32'h00000030 &&
            mshr_write_debug[3]) begin

            $display("PASS: MSHR 3 allocated with write");
            pass_count = pass_count + 1;

        end
        else begin

            $display("FAIL: MSHR 3 allocation");
            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 5
         * ========================================================
         */

        $display("");
        $display("TEST 5: Verify all four misses remain outstanding");

        if (mshr_valid_debug == 4'b1111) begin

            $display("PASS: all four MSHRs remain active");
            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR state = %b",
                mshr_valid_debug
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 6
         * ========================================================
         */

        $display("");
        $display("TEST 6: Verify four memory requests");

        repeat (4)
            @(posedge clk);

        #1;

        if (memory_request_count == 4 &&
            memory_request_seen == 4'b1111) begin

            $display("PASS: four memory requests generated");
            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: memory requests=%0d seen=%b",
                memory_request_count,
                memory_request_seen
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 7
         * ========================================================
         */

        $display("");
        $display("TEST 7: Complete MSHR 2 first");
        $display("Expected: 33330000");

        complete_mshr(
            2'd2,
            32'h33330000
        );

        #1;

        if (!mshr_valid_debug[2] &&
            mshr_valid_debug[0] &&
            mshr_valid_debug[1] &&
            mshr_valid_debug[3]) begin

            $display(
                "PASS: MSHR 2 released; other MSHRs preserved"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR 2 completion corrupted table"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 8
         * ========================================================
         */

        $display("");
        $display("TEST 8: Complete MSHR 0");
        $display("Expected: 11110000");

        complete_mshr(
            2'd0,
            32'h11110000
        );

        #1;

        if (!mshr_valid_debug[0] &&
            mshr_valid_debug[1] &&
            mshr_valid_debug[3]) begin

            $display("PASS: MSHR 0 released");
            pass_count = pass_count + 1;

        end
        else begin

            $display("FAIL: MSHR 0 completion");
            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 9
         * ========================================================
         */

        $display("");
        $display("TEST 9: Complete MSHR 3");
        $display("Expected: 44440000 from memory");

        complete_mshr(
            2'd3,
            32'h44440000
        );

        #1;

        if (!mshr_valid_debug[3] &&
            mshr_valid_debug[1]) begin

            $display("PASS: MSHR 3 released");
            pass_count = pass_count + 1;

        end
        else begin

            $display("FAIL: MSHR 3 completion");
            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 10
         * ========================================================
         */

        $display("");
        $display("TEST 10: Complete MSHR 1 last");
        $display("Expected: 22220000");

        complete_mshr(
            2'd1,
            32'h22220000
        );

        #1;

        if (!mshr_valid_debug[1]) begin

            $display("PASS: MSHR 1 released");
            pass_count = pass_count + 1;

        end
        else begin

            $display("FAIL: MSHR 1 completion");
            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 11
         * ========================================================
         */

        $display("");
        $display("TEST 11: Verify all MSHRs released");

        if (mshr_valid_debug == 4'b0000) begin

            $display("PASS: all MSHRs released");
            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: final MSHR state=%b",
                mshr_valid_debug
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 12
         * ========================================================
         */

        $display("");
        $display("TEST 12: Verify cache line 0");
        $display("Expected: HIT + 11110000");

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
                "PASS: cache line 0 contains 11110000"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: cache line 0 data=%h hit=%b",
                resp_rdata,
                resp_hit
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 13
         * ========================================================
         */

        $display("");
        $display("TEST 13: Verify cache line 1");
        $display("Expected: HIT + 22220000");

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
                "PASS: cache line 1 contains 22220000"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: cache line 1 data=%h hit=%b",
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
        $display("TEST 14: Verify cache line 2");
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
                "PASS: cache line 2 contains 33330000"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: cache line 2 data=%h hit=%b",
                resp_rdata,
                resp_hit
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 15
         * ========================================================
         *
         * MSHR 3 was a WRITE MISS.
         *
         * Memory returned 44440000, but the CPU write data
         * AAAAAAAA must be installed in the cache.
         */

        $display("");
        $display("TEST 15: Verify write-miss cache line");
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
                "PASS: write-miss line contains AAAAAAAA"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: write-miss line data=%h hit=%b",
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
        $display("TEST 16: Verify no extra memory transactions");

        if (memory_request_count == 4) begin

            $display(
                "PASS: cache hits generated no new memory requests"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: memory request count=%0d",
                memory_request_count
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
        $display("PROJECT 37 STEP 5 VERIFICATION SUMMARY");
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
            $display("PROJECT 37 STEP 5 VERIFICATION: PASS");
            $display("================================================");

        end
        else begin

            $display("");
            $display("================================================");
            $display("PROJECT 37 STEP 5 VERIFICATION: FAIL");
            $display("================================================");

        end


        #20;

        $finish;

    end

endmodule