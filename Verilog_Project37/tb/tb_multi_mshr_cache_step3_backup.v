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
        .mshr_write_debug(mshr_write_debug)
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
     * CPU request task.
     *
     * The task waits only for request acceptance.
     * Memory transactions are handled independently.
     */
    task submit_request;

        input [31:0] address;
        input        write_enable;
        input [31:0] write_data;

        reg [1:0] selected_index;

        begin

            @(negedge clk);

            req_valid = 1'b1;
            req_addr  = address;
            req_write = write_enable;
            req_wdata = write_data;

            #1;

            if (req_ready) begin

                selected_index = mshr_alloc_index;

                $display(
                    "REQUEST ACCEPTED: MSHR=%0d address=%h write=%b data=%h",
                    selected_index,
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
     * Complete a selected outstanding MSHR.
     *
     * The MSHR index is explicitly supplied so that
     * responses can arrive out of order.
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
     * Check whether a particular MSHR is free.
     */
    task check_mshr_free;

        input [1:0] index;

        begin

            if (!mshr_valid_debug[index]) begin

                $display(
                    "PASS: MSHR %0d released",
                    index
                );

                pass_count = pass_count + 1;

            end
            else begin

                $display(
                    "FAIL: MSHR %0d still active",
                    index
                );

                fail_count = fail_count + 1;

            end

        end

    endtask


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
        $display("STEP 3 - OUT-OF-ORDER MISS COMPLETION");
        $display("================================================");


        /*
         * RESET
         */
        #20;

        rst = 1'b0;


        /*
         * TEST 1
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
         * TEST 2
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
         * TEST 3
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
         * TEST 4
         */
        $display("");
        $display("TEST 4: Allocate MSHR 3");
        $display("Expected: address 00000030");

        submit_request(
            32'h00000030,
            1'b1,
            32'hAAAAAAAA
        );

        #1;

        if (mshr_valid_debug[3] &&
            mshr_addr_debug[3] == 32'h00000030 &&
            mshr_write_debug[3]) begin

            $display("PASS: MSHR 3 allocated");

            pass_count = pass_count + 1;

        end
        else begin

            $display("FAIL: MSHR 3 allocation");

            fail_count = fail_count + 1;

        end


        /*
         * Allow memory requests to be issued.
         */
        repeat (5) @(posedge clk);


        /*
         * TEST 5
         */
        $display("");
        $display("TEST 5: Verify four outstanding misses");

        if (mshr_valid_debug == 4'b1111) begin

            $display(
                "PASS: all four MSHRs remain active"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR status = %b",
                mshr_valid_debug
            );

            fail_count = fail_count + 1;

        end


        /*
         * TEST 6
         */
        $display("");
        $display("TEST 6: Verify four memory requests");

        if (memory_request_count == 4) begin

            $display(
                "PASS: four memory transactions generated"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: expected 4 memory requests, got %0d",
                memory_request_count
            );

            fail_count = fail_count + 1;

        end


        /*
         * TEST 7
         *
         * Complete MSHR 2 FIRST.
         */
        $display("");
        $display("TEST 7: Complete MSHR 2 first");
        $display("Expected: MSHR 2 released");

        complete_mshr(
            2'd2,
            32'h33330000
        );

        check_mshr_free(2'd2);


        /*
         * Verify other MSHRs remain active.
         */
        if (mshr_valid_debug[0] &&
            mshr_valid_debug[1] &&
            mshr_valid_debug[3]) begin

            $display(
                "PASS: other outstanding MSHRs preserved"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: unrelated MSHR state changed"
            );

            fail_count = fail_count + 1;

        end


        /*
         * TEST 8
         *
         * Complete MSHR 0 second.
         */
        $display("");
        $display("TEST 8: Complete MSHR 0");
        $display("Expected: MSHR 0 released");

        complete_mshr(
            2'd0,
            32'h11110000
        );

        check_mshr_free(2'd0);


        /*
         * TEST 9
         *
         * Complete MSHR 3.
         */
        $display("");
        $display("TEST 9: Complete MSHR 3");
        $display("Expected: MSHR 3 released");

        complete_mshr(
            2'd3,
            32'h44440000
        );

        check_mshr_free(2'd3);


        /*
         * TEST 10
         *
         * Complete MSHR 1 LAST.
         */
        $display("");
        $display("TEST 10: Complete MSHR 1 last");
        $display("Expected: MSHR 1 released");

        complete_mshr(
            2'd1,
            32'h22220000
        );

        check_mshr_free(2'd1);


        /*
         * TEST 11
         */
        $display("");
        $display("TEST 11: Verify all MSHRs released");

        if (mshr_valid_debug == 4'b0000) begin

            $display(
                "PASS: all four MSHRs released"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR status = %b",
                mshr_valid_debug
            );

            fail_count = fail_count + 1;

        end


        /*
         * TEST 12
         *
         * Verify allocator recovered after
         * out-of-order completion.
         */
        $display("");
        $display("TEST 12: Reuse released MSHR");
        $display("Expected: MSHR 0");

        submit_request(
            32'h00000040,
            1'b0,
            32'h00000000
        );

        #1;

        if (mshr_valid_debug[0] &&
            mshr_addr_debug[0] == 32'h00000040) begin

            $display(
                "PASS: MSHR 0 reused correctly"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR reuse failed"
            );

            fail_count = fail_count + 1;

        end


        /*
         * TEST 13
         */
        $display("");
        $display("TEST 13: Verify new memory request");

        repeat (2) @(posedge clk);

        if (memory_request_count == 5) begin

            $display(
                "PASS: new transaction generated after releases"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: expected 5 total memory requests, got %0d",
                memory_request_count
            );

            fail_count = fail_count + 1;

        end


        /*
         * TEST 14
         */
        $display("");
        $display("TEST 14: Complete reused MSHR");

        complete_mshr(
            2'd0,
            32'h55550000
        );

        if (!mshr_valid_debug[0]) begin

            $display(
                "PASS: reused MSHR completed correctly"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: reused MSHR still active"
            );

            fail_count = fail_count + 1;

        end


        /*
         * TEST 15
         */
        $display("");
        $display("TEST 15: Final MSHR state");

        if (mshr_valid_debug == 4'b0000) begin

            $display(
                "PASS: final MSHR table is empty"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: final MSHR status = %b",
                mshr_valid_debug
            );

            fail_count = fail_count + 1;

        end


        /*
         * FINAL SUMMARY
         */
        $display("");
        $display("================================================");
        $display("PROJECT 37 STEP 3 VERIFICATION SUMMARY");
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
            $display("PROJECT 37 STEP 3 VERIFICATION: PASS");
            $display("================================================");

        end
        else begin

            $display("");
            $display("================================================");
            $display("PROJECT 37 STEP 3 VERIFICATION: FAIL");
            $display("================================================");

        end


        #20;

        $finish;

    end

endmodule