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
        $display("STEP 20 - STALE RESPONSE GENERATION PROTECTION");
        $display("================================================");


        /*
         * ========================================================
         * TEST 1
         * ========================================================
         *
         * Allocate old request 0x100.
         *
         * 0x100 -> cache index 0
         */

        $display("");
        $display("TEST 1: Allocate old request 0x100");
        $display("Expected: MSHR 0");

        submit_request(
            32'h00000100,
            1'b0,
            32'h00000000
        );

        #1;

        if (mshr_valid_debug == 4'b0001 &&
            mshr_addr_debug[0] == 32'h00000100) begin

            $display("PASS: MSHR 0 owns old request 0x100");
            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: valid=%b addr0=%h",
                mshr_valid_debug,
                mshr_addr_debug[0]
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 2
         * ========================================================
         *
         * Allocate newer request 0x140.
         *
         * 0x140 -> same cache index 0.
         *
         * This creates the generation conflict.
         */

        $display("");
        $display("TEST 2: Allocate newer colliding request 0x140");
        $display("Expected: MSHR 1 owns 0x140");

        submit_request(
            32'h00000140,
            1'b0,
            32'h00000000
        );

        #1;

        if (mshr_valid_debug[0] &&
            mshr_valid_debug[1] &&
            mshr_addr_debug[0] == 32'h00000100 &&
            mshr_addr_debug[1] == 32'h00000140) begin

            $display(
                "PASS: MSHR 0=0x100 and MSHR 1=0x140"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: valid=%b addr0=%h addr1=%h",
                mshr_valid_debug,
                mshr_addr_debug[0],
                mshr_addr_debug[1]
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 3
         * ========================================================
         *
         * Complete OLD MSHR 0.
         *
         * Its generation is now stale because MSHR 1
         * represents the newer request for the same cache index.
         *
         * Expected:
         *
         *   MSHR 0 released
         *   0x100 must NOT overwrite cache line 0
         *   MSHR 1 remains active
         */

        $display("");
        $display("TEST 3: Complete stale MSHR 0");
        $display("Expected: stale response ignored for cache refill");

        complete_mshr(
            2'd0,
            32'hAAAA0100
        );

        #1;

        if (!mshr_valid_debug[0] &&
            mshr_valid_debug[1] &&
            mshr_addr_debug[1] == 32'h00000140) begin

            $display(
                "PASS: stale MSHR 0 released, newer MSHR 1 remains"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: valid=%b addr1=%h",
                mshr_valid_debug,
                mshr_addr_debug[1]
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 4
         * ========================================================
         *
         * Verify the newer 0x140 request still owns the cache index.
         */

        $display("");
        $display("TEST 4: Verify newer request ownership");
        $display("Expected: 0x140 is DUPLICATE / MSHR 1");

        @(negedge clk);

        req_addr  = 32'h00000140;
        req_write = 1'b0;
        req_wdata = 32'b0;
        req_valid = 1'b0;

        #1;

        if (req_class_debug == 2'b10 &&
            req_mshr_match_debug == 1'b1 &&
            req_mshr_index_debug == 2'd1) begin

            $display(
                "PASS: 0x140 remains DUPLICATE owned by MSHR 1"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: class=%b match=%b owner=%0d",
                req_class_debug,
                req_mshr_match_debug,
                req_mshr_index_debug
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 5
         * ========================================================
         *
         * Verify old 0x100 was NOT installed by the stale response.
         *
         * Because 0x140 is still outstanding and owns the same
         * cache index, 0x100 must not appear as a cache hit.
         */

        $display("");
        $display("TEST 5: Verify stale 0x100 was not installed");
        $display("Expected: 0x100 is NOT a CACHE HIT");

        @(negedge clk);

        req_addr = 32'h00000100;

        #1;

        if (req_class_debug != 2'b00) begin

            $display(
                "PASS: 0x100 is not a CACHE HIT after stale response"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: stale 0x100 incorrectly became CACHE HIT"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 6
         * ========================================================
         *
         * Complete the NEWER request.
         */

        $display("");
        $display("TEST 6: Complete current MSHR 1");
        $display("Expected: 0x140 refill succeeds");

        complete_mshr(
            2'd1,
            32'hAAAA0140
        );

        #1;

        if (mshr_valid_debug == 4'b0000) begin

            $display(
                "PASS: current MSHR 1 completed"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: stale MSHR remains valid=%b",
                mshr_valid_debug
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 7
         * ========================================================
         *
         * The newer request must now be a cache hit.
         */

        $display("");
        $display("TEST 7: Verify 0x140 became CACHE HIT");
        $display("Expected: CACHE HIT");

        @(negedge clk);

        req_addr = 32'h00000140;

        #1;

        if (req_class_debug == 2'b00 &&
            req_mshr_match_debug == 1'b0) begin

            $display(
                "PASS: 0x140 is a CACHE HIT"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x140 class=%b match=%b",
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
         * The old 0x100 must not be a cache hit.
         *
         * 0x140 is the newer line occupying cache index 0.
         */

        $display("");
        $display("TEST 8: Verify old 0x100 remains replaced");
        $display("Expected: NEW MISS");

        @(negedge clk);

        req_addr = 32'h00000100;

        #1;

        if (req_class_debug == 2'b01 &&
            req_mshr_match_debug == 1'b0) begin

            $display(
                "PASS: 0x100 is NEW MISS after 0x140 refill"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x100 class=%b match=%b",
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
        $display("PROJECT 37 STEP 20 VERIFICATION SUMMARY");
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
                "PROJECT 37 STEP 20 VERIFICATION: PASS"
            );

        end
        else begin

            $display(
                "PROJECT 37 STEP 20 VERIFICATION: FAIL"
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
