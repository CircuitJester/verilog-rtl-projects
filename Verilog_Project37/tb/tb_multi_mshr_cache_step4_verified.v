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

    wire [3:0] mshr_valid_debug;
    wire [31:0] mshr_addr_debug [0:3];
    wire [3:0] mshr_write_debug;

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
     * Memory request monitor.
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
     * Submit CPU request.
     */

    task submit_request;

        input [31:0] address;
        input        write_enable;
        input [31:0] write_data;

        begin

            @(negedge clk);

            req_valid = 1'b1;

            req_addr = address;

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

            req_addr = 32'b0;

            req_write = 1'b0;

            req_wdata = 32'b0;

        end

    endtask


    /*
     * Complete an outstanding memory transaction.
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

            mem_resp_mshr = index;

            mem_resp_rdata = data;

            @(posedge clk);

            @(negedge clk);

            mem_resp_valid = 1'b0;

            mem_resp_mshr = 2'd0;

            mem_resp_rdata = 32'b0;

        end

    endtask


    /*
     * Wait for a response.
     */

    task wait_response;

        begin

            @(posedge clk);

            #1;

        end

    endtask


    initial begin

        clk = 1'b0;

        rst = 1'b1;

        req_valid = 1'b0;

        req_addr = 32'b0;

        req_write = 1'b0;

        req_wdata = 32'b0;

        mem_resp_valid = 1'b0;

        mem_resp_mshr = 2'd0;

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

        $display("STEP 4 - CACHE REFILL + MSHR COMPLETION");

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

        $display("TEST 1: First read miss");

        $display("Expected: MISS + MSHR allocation");


        submit_request(
            32'h00000000,
            1'b0,
            32'h00000000
        );


        #1;


        if (mshr_valid_debug[0] &&
            mshr_addr_debug[0] == 32'h00000000) begin

            $display(
                "PASS: first miss allocated to MSHR 0"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: first miss was not allocated"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 2
         * ========================================================
         */

        $display("");

        $display("TEST 2: Memory request");

        $display("Expected: address 00000000");


        repeat (2) @(posedge clk);


        if (memory_request_count == 1 &&
            memory_request_seen[0]) begin

            $display(
                "PASS: memory request generated"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: memory request not generated"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 3
         * ========================================================
         */

        $display("");

        $display("TEST 3: Memory refill");

        $display("Expected: 11110000");


        complete_mshr(
            2'd0,
            32'h11110000
        );


        if (!mshr_valid_debug[0]) begin

            $display(
                "PASS: MSHR 0 released after refill"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR 0 was not released"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 4
         * ========================================================
         */

        $display("");

        $display("TEST 4: Refill response");

        $display("Expected: MISS response + 11110000");


        #1;


        if (resp_valid &&
            !resp_hit &&
            resp_rdata == 32'h11110000) begin

            $display(
                "PASS: refill returned correct CPU data"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: refill response incorrect"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 5
         * ========================================================
         */

        $display("");

        $display("TEST 5: Read refilled address");

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
                "PASS: refilled line produces cache hit"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: refilled line did not hit"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 6
         * ========================================================
         */

        $display("");

        $display("TEST 6: Second address miss");

        $display("Expected: MISS + MSHR allocation");


        submit_request(
            32'h00000010,
            1'b0,
            32'h00000000
        );


        #1;


        if (mshr_valid_debug[0] &&
            mshr_addr_debug[0] == 32'h00000010) begin

            $display(
                "PASS: second miss allocated"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: second miss allocation"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 7
         * ========================================================
         */

        $display("");

        $display("TEST 7: Second memory refill");

        $display("Expected: 22220000");


        repeat (2) @(posedge clk);


        complete_mshr(
            2'd0,
            32'h22220000
        );


        #1;


        if (resp_valid &&
            !resp_hit &&
            resp_rdata == 32'h22220000) begin

            $display(
                "PASS: second refill completed correctly"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: second refill incorrect"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 8
         * ========================================================
         */

        $display("");

        $display("TEST 8: Repeated second address");

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
                "PASS: second refilled line hits"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: second refilled line did not hit"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 9
         * ========================================================
         */

        $display("");

        $display("TEST 9: Verify first cache line remains valid");

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
                "PASS: first refilled line remains cached"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: first cache line corrupted"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 10
         * ========================================================
         */

        $display("");

        $display("TEST 10: Write hit");

        $display("Expected: HIT + AAAAAAAA");


        submit_request(
            32'h00000000,
            1'b1,
            32'hAAAAAAAA
        );


        #1;


        if (resp_valid &&
            resp_hit &&
            resp_rdata == 32'hAAAAAAAA) begin

            $display(
                "PASS: write hit updated cache"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: write hit failed"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 11
         * ========================================================
         */

        $display("");

        $display("TEST 11: Read after write");

        $display("Expected: HIT + AAAAAAAA");


        submit_request(
            32'h00000000,
            1'b0,
            32'h00000000
        );


        #1;


        if (resp_valid &&
            resp_hit &&
            resp_rdata == 32'hAAAAAAAA) begin

            $display(
                "PASS: modified cache data returned"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: modified cache data incorrect"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 12
         * ========================================================
         */

        $display("");

        $display("TEST 12: Cache hit generates no new memory request");


        if (memory_request_count == 2) begin

            $display(
                "PASS: cache hits generated no memory transactions"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: unexpected memory transaction count = %0d",
                memory_request_count
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 13
         * ========================================================
         */

        $display("");

        $display("TEST 13: Final MSHR state");


        if (mshr_valid_debug == 4'b0000) begin

            $display(
                "PASS: all MSHRs free"
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
         * FINAL SUMMARY
         * ========================================================
         */

        $display("");

        $display("================================================");

        $display(
            "PROJECT 37 STEP 4 VERIFICATION SUMMARY"
        );

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

            $display(
                "PROJECT 37 STEP 4 VERIFICATION: PASS"
            );

            $display("================================================");

        end
        else begin

            $display("");

            $display("================================================");

            $display(
                "PROJECT 37 STEP 4 VERIFICATION: FAIL"
            );

            $display("================================================");

        end


        #20;

        $finish;

    end

endmodule