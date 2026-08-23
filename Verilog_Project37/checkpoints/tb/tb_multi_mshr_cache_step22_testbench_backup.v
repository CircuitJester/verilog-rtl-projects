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
        $display("STEP 21 - MULTIPLE COLLIDING MISS GENERATIONS");
        $display("================================================");


        /*
         * ========================================================
         * TEST 1
         * ========================================================
         *
         * Three requests target the same direct-mapped cache index:
         *
         *     0x100 -> index 0
         *     0x140 -> index 0
         *     0x180 -> index 0
         *
         * They have different tags and therefore represent different
         * generations of the same cache line.
         */

        $display("");
        $display("TEST 1: Allocate three colliding misses");
        $display("Expected: MSHR 0/1/2 allocated");

        submit_request(32'h00000100, 1'b0, 32'h00000000);
        submit_request(32'h00000140, 1'b0, 32'h00000000);
        submit_request(32'h00000180, 1'b0, 32'h00000000);

        #1;

        if (mshr_valid_debug[0] &&
            mshr_valid_debug[1] &&
            mshr_valid_debug[2] &&
            mshr_addr_debug[0] == 32'h00000100 &&
            mshr_addr_debug[1] == 32'h00000140 &&
            mshr_addr_debug[2] == 32'h00000180) begin

            $display("PASS: three colliding requests occupy MSHR 0/1/2");
            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: valid=%b addr0=%h addr1=%h addr2=%h",
                mshr_valid_debug,
                mshr_addr_debug[0],
                mshr_addr_debug[1],
                mshr_addr_debug[2]
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 2
         * ========================================================
         */

        $display("");
        $display("TEST 2: Verify memory requests");
        $display("Expected: three memory transactions");

        repeat (5)
            @(posedge clk);

        #1;

        if (memory_request_count == 3) begin

            $display("PASS: exactly three memory requests observed");
            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: expected 3 memory requests, observed %0d",
                memory_request_count
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 3
         * ========================================================
         *
         * Complete the oldest generation first.
         *
         * 0x100 is stale because 0x140 and 0x180 have already
         * advanced the generation of cache index 0.
         */

        $display("");
        $display("TEST 3: Complete oldest colliding request");
        $display("Expected: MSHR 0 released, cache remains unchanged");

        complete_mshr(0, 32'hAAAA0100);

        #1;

        if (!mshr_valid_debug[0] &&
            mshr_valid_debug[1] &&
            mshr_valid_debug[2]) begin

            $display("PASS: oldest MSHR released while newer MSHRs remain");

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: unexpected MSHR state valid=%b",
                mshr_valid_debug
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 4
         * ========================================================
         *
         * 0x100 must NOT become a cache hit.
         */

        $display("");
        $display("TEST 4: Verify oldest response was stale");
        $display("Expected: 0x100 is NOT a CACHE HIT");

        @(negedge clk);

        req_addr  = 32'h00000100;
        req_write = 1'b0;
        req_wdata = 32'b0;
        req_valid = 1'b0;

        #1;

        if (req_class_debug != 2'b00) begin

            $display("PASS: 0x100 was not installed by stale response");
            pass_count = pass_count + 1;

        end
        else begin

            $display("FAIL: 0x100 incorrectly became a CACHE HIT");
            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 5
         * ========================================================
         *
         * Complete the middle generation.
         *
         * 0x140 is also stale because 0x180 is newer.
         */

        $display("");
        $display("TEST 5: Complete middle colliding request");
        $display("Expected: MSHR 1 released, 0x180 remains outstanding");

        complete_mshr(1, 32'hAAAA0140);

        #1;

        if (!mshr_valid_debug[1] &&
            mshr_valid_debug[2]) begin

            $display("PASS: middle generation released correctly");
            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: unexpected MSHR state valid=%b",
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
        $display("TEST 6: Verify middle generation was stale");
        $display("Expected: 0x140 is NOT a CACHE HIT");

        @(negedge clk);

        req_addr = 32'h00000140;

        #1;

        if (req_class_debug != 2'b00) begin

            $display("PASS: 0x140 was not installed by stale response");
            pass_count = pass_count + 1;

        end
        else begin

            $display("FAIL: 0x140 incorrectly became a CACHE HIT");
            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 7
         * ========================================================
         *
         * Complete newest generation.
         *
         * Only this response is allowed to refill cache index 0.
         */

        $display("");
        $display("TEST 7: Complete newest colliding request");
        $display("Expected: 0x180 becomes CACHE HIT");

        complete_mshr(2, 32'hAAAA0180);

        #1;

        @(negedge clk);

        req_addr = 32'h00000180;

        #1;

        if (req_class_debug == 2'b00) begin

            $display("PASS: newest generation 0x180 is a CACHE HIT");
            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x180 class=%b",
                req_class_debug
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 8
         * ========================================================
         *
         * Older generations must remain absent.
         */

        $display("");
        $display("TEST 8: Verify older generations remain replaced");
        $display("Expected: 0x100 and 0x140 are NEW MISS");

        @(negedge clk);

        req_addr = 32'h00000100;

        #1;

        if (req_class_debug == 2'b01) begin

            $display("PASS: 0x100 is NEW MISS");

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x100 class=%b",
                req_class_debug
            );

            fail_count = fail_count + 1;

        end


        @(negedge clk);

        req_addr = 32'h00000140;

        #1;

        if (req_class_debug == 2'b01) begin

            $display("PASS: 0x140 is NEW MISS");

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x140 class=%b",
                req_class_debug
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 9
         * ========================================================
         */

        $display("");
        $display("TEST 9: Verify all MSHRs are released");
        $display("Expected: valid=0000");

        #1;

        if (mshr_valid_debug == 4'b0000) begin

            $display("PASS: all MSHRs released");
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
         * TEST 10
         * ========================================================
         */

        $display("");
        $display("TEST 10: Final generation integrity check");
        $display("Expected: only newest 0x180 is cached");

        @(negedge clk);

        req_addr = 32'h00000180;

        #1;

        if (req_class_debug == 2'b00) begin

            $display("PASS: final cache state belongs to newest generation");
            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: final 0x180 class=%b",
                req_class_debug
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
        $display("PROJECT 37 STEP 21 VERIFICATION SUMMARY");
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
            $display(
                "PROJECT 37 STEP 21 VERIFICATION: PASS"
            );

        end
        else begin

            $display("");
            $display(
                "PROJECT 37 STEP 21 VERIFICATION: FAIL"
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
