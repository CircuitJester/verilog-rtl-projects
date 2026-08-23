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

    wire       mem_req_valid;
    wire [1:0] mem_req_mshr;
    wire [31:0] mem_req_addr;
    wire       mem_req_write;
    wire [31:0] mem_req_wdata;

    reg        mem_resp_valid;
    reg [1:0]  mem_resp_mshr;
    reg [31:0] mem_resp_rdata;

    reg        mshr_release_valid;
    reg [1:0]  mshr_release_index;

    wire [3:0] mshr_valid_debug;
    wire [3:0] mshr_write_debug;
    wire [31:0] mshr_addr_debug [0:3];

    wire       req_mshr_match_debug;
    wire [1:0] req_mshr_index_debug;

    wire [1:0] req_class_debug;

    wire       resp_valid;
    wire       resp_hit;
    wire [31:0] resp_rdata;

    integer pass_count;
    integer fail_count;
    integer memory_request_count;


    /*
     * ============================================================
     * DUT
     * ============================================================
     */

    multi_mshr_cache #(
        .MSHR_COUNT(4),
        .CACHE_LINES(4)
    ) dut (
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
        .mshr_write_debug(mshr_write_debug),
        .mshr_addr_debug(mshr_addr_debug),

        .req_mshr_match_debug(req_mshr_match_debug),
        .req_mshr_index_debug(req_mshr_index_debug),

        .req_class_debug(req_class_debug),

        .resp_valid(resp_valid),
        .resp_hit(resp_hit),
        .resp_rdata(resp_rdata)
    );


    /*
     * ============================================================
     * CLOCK
     * ============================================================
     */

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end


    /*
     * ============================================================
     * VCD
     * ============================================================
     */

    initial begin
        $dumpfile("waves/multi_mshr_cache.vcd");
        $dumpvars(0, tb_multi_mshr_cache);
    end


    /*
     * ============================================================
     * HELPER: SUBMIT REQUEST
     * ============================================================
     */

    task submit_request;
        input [31:0] addr;
        input        write;
        input [31:0] wdata;

        begin

            @(negedge clk);

            req_valid = 1'b1;
            req_addr  = addr;
            req_write = write;
            req_wdata = wdata;

            #1;

            if (req_ready) begin

                $display(
                    "REQUEST ACCEPTED: address=%h write=%b data=%h",
                    req_addr,
                    req_write,
                    req_wdata
                );

            end
            else begin

                $display(
                    "REQUEST BLOCKED: address=%h",
                    req_addr
                );

            end

            @(posedge clk);

            
              #1;

              req_valid = 1'b0;

        end
    endtask


    /*
     * ============================================================
     * HELPER: MEMORY RESPONSE
     * ============================================================
     */

    task complete_mshr;
        input [1:0]  mshr_index;
        input [31:0] data;

        begin

            @(negedge clk);

            mem_resp_valid = 1'b1;
            mem_resp_mshr  = mshr_index;
            mem_resp_rdata = data;

            @(posedge clk);

            #1;

            mem_resp_valid = 1'b0;

            $display(
                "MEMORY RESPONSE: MSHR=%0d data=%h",
                mshr_index,
                data
            );

        end
    endtask


    /*
     * ============================================================
     * MAIN TEST
     * ============================================================
     */

    initial begin

        req_valid = 1'b0;
        req_addr  = 32'b0;
        req_write = 1'b0;
        req_wdata = 32'b0;

        mem_resp_valid = 1'b0;
        mem_resp_mshr  = 2'b0;
        mem_resp_rdata = 32'b0;

        mshr_release_valid = 1'b0;
        mshr_release_index = 2'b0;

        pass_count = 0;
        fail_count = 0;
        memory_request_count = 0;


        /*
         * ========================================================
         * RESET
         * ========================================================
         */

        rst = 1'b1;

        repeat (3)
            @(posedge clk);

        rst = 1'b0;

        @(posedge clk);


        $display("");
        $display("================================================");
        $display("PROJECT 37 - MULTI-MSHR NON-BLOCKING CACHE");
        $display("STEP 13 - REQUEST CLASSIFICATION");
        $display("================================================");


        /*
         * ========================================================
         * TEST 1
         * ========================================================
         *
         * Empty cache + no outstanding MSHR.
         *
         * Expected:
         *
         *      req_class_debug = 01
         *      NEW MISS
         */

        $display("");
        $display("TEST 1: Classify new request");
        $display("Expected: NEW MISS");

        @(negedge clk);

        req_addr  = 32'h00000100;
        req_write = 1'b0;
        req_wdata = 32'b0;
        req_valid = 1'b0;

        #1;

        if (req_class_debug == 2'b01) begin

            $display(
                "PASS: 0x100 classified as NEW MISS"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x100 classification=%b",
                req_class_debug
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 2
         * ========================================================
         *
         * Submit 0x100 and allocate an MSHR.
         */

        $display("");
        $display("TEST 2: Allocate 0x100");
        $display("Expected: MSHR 0 allocated");

        submit_request(
            32'h00000100,
            1'b0,
            32'h00000000
        );

        #1;

        if (mshr_valid_debug == 4'b0001 &&
            mshr_addr_debug[0] == 32'h00000100) begin

            $display(
                "PASS: MSHR 0 owns 0x100"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR ownership incorrect valid=%b addr=%h",
                mshr_valid_debug,
                mshr_addr_debug[0]
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 3
         * ========================================================
         *
         * The same address is now outstanding.
         *
         * Expected:
         *
         *      req_mshr_match_debug = 1
         *      req_mshr_index_debug = 0
         *      req_class_debug      = 10
         */

        $display("");
        $display("TEST 3: Classify duplicate outstanding request");
        $display("Expected: DUPLICATE / OWNER MSHR 0");

        @(negedge clk);

        req_addr  = 32'h00000100;
        req_write = 1'b0;
        req_wdata = 32'b0;
        req_valid = 1'b0;

        #1;

        if (req_mshr_match_debug &&
            req_mshr_index_debug == 2'd0 &&
            req_class_debug == 2'b10) begin

            $display(
                "PASS: 0x100 classified as DUPLICATE, owner=MSHR 0"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: match=%b owner=%d class=%b",
                req_mshr_match_debug,
                req_mshr_index_debug,
                req_class_debug
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 4
         * ========================================================
         *
         * Different address with an active MSHR.
         *
         * Expected:
         *
         *      no owner
         *      NEW MISS
         */

        $display("");
        $display("TEST 4: Classify unrelated request");
        $display("Expected: NEW MISS");

        @(negedge clk);

        req_addr  = 32'h00000140;
        req_write = 1'b0;
        req_wdata = 32'b0;
        req_valid = 1'b0;

        #1;

        if (!req_mshr_match_debug &&
            req_class_debug == 2'b01) begin

            $display(
                "PASS: 0x140 classified as NEW MISS"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: match=%b class=%b",
                req_mshr_match_debug,
                req_class_debug
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 5
         * ========================================================
         *
         * Complete MSHR 0.
         *
         * This installs 0x100 into the cache.
         */

        $display("");
        $display("TEST 5: Complete 0x100");
        $display("Expected: cache refill");

        complete_mshr(
            2'd0,
            32'hAAAA0100
        );

        #1;

        if (mshr_valid_debug == 4'b0000 &&
            dut.cache_valid[0] &&
            dut.cache_tag[0] == 26'h0000004 &&
            dut.cache_data[0] == 32'hAAAA0100) begin

            $display(
                "PASS: 0x100 installed in cache and MSHR released"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: cache valid=%b tag=%h data=%h MSHR=%b",
                dut.cache_valid[0],
                dut.cache_tag[0],
                dut.cache_data[0],
                mshr_valid_debug
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 6
         * ========================================================
         *
         * 0x100 is now a cache hit.
         *
         * Expected:
         *
         *      req_class_debug = 00
         */

        $display("");
        $display("TEST 6: Classify cached request");
        $display("Expected: CACHE HIT");

        @(negedge clk);

        req_addr  = 32'h00000100;
        req_write = 1'b0;
        req_wdata = 32'b0;
        req_valid = 1'b0;

        #1;

        if (req_class_debug == 2'b00 &&
            req_mshr_match_debug == 1'b0) begin

            $display(
                "PASS: 0x100 classified as CACHE HIT"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: class=%b match=%b",
                req_class_debug,
                req_mshr_match_debug
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 7
         * ========================================================
         *
         * A different address is not cached and has no owner.
         *
         * Expected:
         *
         *      NEW MISS
         */

        $display("");
        $display("TEST 7: Classify uncached address after refill");
        $display("Expected: NEW MISS");

        @(negedge clk);

        req_addr  = 32'h00000180;
        req_write = 1'b0;
        req_wdata = 32'b0;
        req_valid = 1'b0;

        #1;

        if (req_class_debug == 2'b01 &&
            !req_mshr_match_debug) begin

            $display(
                "PASS: 0x180 classified as NEW MISS"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: class=%b match=%b",
                req_class_debug,
                req_mshr_match_debug
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 8
         * ========================================================
         *
         * Allocate 0x180 and verify it becomes a duplicate.
         */

        $display("");
        $display("TEST 8: Allocate 0x180 and reclassify");
        $display("Expected: NEW MISS -> DUPLICATE");

        submit_request(
            32'h00000180,
            1'b0,
            32'h00000000
        );

        @(negedge clk);

        req_addr  = 32'h00000180;
        req_write = 1'b0;
        req_wdata = 32'b0;
        req_valid = 1'b0;

        #1;

        if (req_mshr_match_debug &&
            req_class_debug == 2'b10) begin

            $display(
                "PASS: 0x180 became DUPLICATE after allocation"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x180 class=%b match=%b owner=%d",
                req_class_debug,
                req_mshr_match_debug,
                req_mshr_index_debug
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 9
         * ========================================================
         *
         * Complete MSHR 0 or the actual owner of 0x180.
         */

        $display("");
        $display("TEST 9: Complete 0x180");
        $display("Expected: MSHR released");

        complete_mshr(
            2'd0,
            32'hAAAA0180
        );

        #1;

        if (mshr_valid_debug == 4'b0000) begin

            $display(
                "PASS: final MSHR released"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR table=%b",
                mshr_valid_debug
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 10
         * ========================================================
         *
         * Final classification sanity check.
         *
         * 0x180 should now be a cache hit.
         */

        $display("");
        $display("TEST 10: Final classification check");
        $display("Expected: CACHE HIT");

        @(negedge clk);

        req_addr  = 32'h00000180;
        req_write = 1'b0;
        req_wdata = 32'b0;
        req_valid = 1'b0;

        #1;

        if (req_class_debug == 2'b00 &&
            req_mshr_match_debug == 1'b0) begin

            $display(
                "PASS: 0x180 classified as CACHE HIT"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: final class=%b match=%b",
                req_class_debug,
                req_mshr_match_debug
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * SUMMARY
         * ========================================================
         */

        $display("");
        $display("================================================");
        $display("PROJECT 37 STEP 13 VERIFICATION SUMMARY");
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

        $display("");

        if (fail_count == 0) begin

            $display(
                "PROJECT 37 STEP 13 VERIFICATION: PASS"
            );

        end
        else begin

            $display(
                "PROJECT 37 STEP 13 VERIFICATION: FAIL"
            );

        end

        $display("================================================");

        $finish;

    end


    /*
     * ============================================================
     * MEMORY REQUEST MONITOR
     * ============================================================
     */

    always @(posedge clk) begin

        if (mem_req_valid) begin

            memory_request_count = memory_request_count + 1;

            $display(
                "MEMORY REQUEST: MSHR=%0d address=%h write=%b data=%h",
                mem_req_mshr,
                mem_req_addr,
                mem_req_write,
                mem_req_wdata
            );

        end

    end

endmodule
