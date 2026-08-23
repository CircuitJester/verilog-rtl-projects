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
     * ============================================================
     * CLOCK
     * ============================================================
     */

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
     * DUT
     * ============================================================
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

            end
            else begin

                $display(
                    "REQUEST BLOCKED: address=%h",
                    address
                );

            end

            @(posedge clk);

            /*
             * Leave request asserted through the active clock edge.
             */

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

            /*
             * Response is consumed on this rising edge.
             */

            @(posedge clk);

            /*
             * Wait one full cycle after the sequential
             * cache update before removing the response.
             */

            @(negedge clk);

            mem_resp_valid = 1'b0;
            mem_resp_mshr  = 2'd0;
            mem_resp_rdata = 32'b0;

            /*
             * Allow cache state and response outputs to settle.
             */

            @(posedge clk);
            #1;

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

        repeat (3)
            @(posedge clk);

        rst = 1'b0;

        @(posedge clk);


        $display("================================================");
        $display("PROJECT 37 - MULTI-MSHR NON-BLOCKING CACHE");
        $display("STEP 10 - SAME-INDEX MSHR COLLISION");
        $display("================================================");


        /*
         * ========================================================
         * TEST 1
         * ========================================================
         */

        $display("");
        $display("TEST 1: Allocate four misses to SAME cache index");
        $display("Expected: 0x00, 0x40, 0x80, 0xC0 all map to index 0");

        submit_request(32'h00000000, 1'b0, 32'h00000000);
        submit_request(32'h00000040, 1'b0, 32'h00000000);
        submit_request(32'h00000080, 1'b0, 32'h00000000);
        submit_request(32'h000000C0, 1'b0, 32'h00000000);

        #1;

        if (mshr_valid_debug == 4'b1111 &&
            mshr_addr_debug[0] == 32'h00000000 &&
            mshr_addr_debug[1] == 32'h00000040 &&
            mshr_addr_debug[2] == 32'h00000080 &&
            mshr_addr_debug[3] == 32'h000000C0) begin

            $display(
                "PASS: all four same-index MSHRs preserved"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: same-index MSHR allocation incorrect"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 2
         * ========================================================
         */

        $display("");
        $display("TEST 2: Complete 0x80 first");

        complete_mshr(
            2'd2,
            32'h88880000
        );

        if (!mshr_valid_debug[2] &&
            mshr_valid_debug[0] &&
            mshr_valid_debug[1] &&
            mshr_valid_debug[3]) begin

            $display(
                "PASS: MSHR 2 completed independently"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR 2 completion corrupted other MSHRs"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 3
         * ========================================================
         */

        $display("");
        $display("TEST 3: Complete 0x40 second");

        complete_mshr(
            2'd1,
            32'h44440000
        );

        if (!mshr_valid_debug[1] &&
            mshr_valid_debug[0] &&
            mshr_valid_debug[3]) begin

            $display(
                "PASS: MSHR 1 completed independently"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR 1 completion corrupted state"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 4
         * ========================================================
         */

        $display("");
        $display("TEST 4: Complete 0xC0 third");

        complete_mshr(
            2'd3,
            32'hCCCC0000
        );

        if (!mshr_valid_debug[3] &&
            mshr_valid_debug[0]) begin

            $display(
                "PASS: MSHR 3 completed independently"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR 3 completion corrupted state"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 5
         * ========================================================
         */

        $display("");
        $display("TEST 5: Complete 0x00 LAST");

        complete_mshr(
            2'd0,
            32'h00000000
        );

        if (mshr_valid_debug == 4'b0000) begin

            $display(
                "PASS: all colliding MSHRs released"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: colliding MSHRs remain allocated"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 6
         * ========================================================
         *
         * Directly inspect cache state rather than depending on
         * the one-cycle response pulse from the previous refill.
         */

        $display("");
        $display("TEST 6: Inspect final cache index 0");
        $display("Expected: VALID=1 TAG=3 DATA=CCCC0000");

        #1;

        if (dut.cache_valid[0] &&
            dut.cache_tag[0] == 26'h0000003 &&
            dut.cache_data[0] == 32'hCCCC0000) begin

            $display(
                "PASS: newest collision winner is 0xC0"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: cache[0] valid=%b tag=%h data=%h",
                dut.cache_valid[0],
                dut.cache_tag[0],
                dut.cache_data[0]
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 7
         * ========================================================
         */

        $display("");
        $display("TEST 7: Verify 0x40 is no longer cached");
        $display("Expected: MISS");

        submit_request(
            32'h00000040,
            1'b0,
            32'h00000000
        );

        #1;

        if (mshr_valid_debug[0] &&
            mshr_addr_debug[0] == 32'h00000040) begin

            $display(
                "PASS: 0x40 correctly generated replacement miss"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x40 replacement miss not generated"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 8
         * ========================================================
         */

        $display("");
        $display("TEST 8: Complete replacement 0x40");

        complete_mshr(
            2'd0,
            32'h44440000
        );

        if (mshr_valid_debug == 4'b0000 &&
            dut.cache_valid[0] &&
            dut.cache_tag[0] == 26'h0000001 &&
            dut.cache_data[0] == 32'h44440000) begin

            $display(
                "PASS: replacement line installed correctly"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: replacement line not installed correctly"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 9
         * ========================================================
         */

        $display("");
        $display("TEST 9: Verify 0x40 is now a HIT");

        submit_request(
            32'h00000040,
            1'b0,
            32'h00000000
        );

        /*
         * Allow the CPU response pulse to settle.
         */

        #1;

        if (resp_valid &&
            resp_hit &&
            resp_rdata == 32'h44440000) begin

            $display(
                "PASS: replacement 0x40 cache line is a HIT"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x40 replacement hit incorrect data=%h hit=%b valid=%b",
                resp_rdata,
                resp_hit,
                resp_valid
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
        $display("PROJECT 37 STEP 10 VERIFICATION SUMMARY");
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

            $display("================================================");
            $display("PROJECT 37 STEP 10 VERIFICATION: PASS");
            $display("================================================");

        end
        else begin

            $display("================================================");
            $display("PROJECT 37 STEP 10 VERIFICATION: FAIL");
            $display("================================================");

        end

        $finish;

    end

endmodule
