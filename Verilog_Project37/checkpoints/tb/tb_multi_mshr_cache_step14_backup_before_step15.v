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
        $display("STEP 14 - MSHR FULL BACKPRESSURE");
        $display("================================================");


        /*
         * ========================================================
         * TEST 1
         * ========================================================
         */

        $display("");
        $display("TEST 1: Allocate 0x100");
        $display("Expected: MSHR 0");

        submit_request(
            32'h00000100,
            1'b0,
            32'h00000000
        );

        #1;

        if (mshr_valid_debug[0] &&
            mshr_addr_debug[0] == 32'h00000100) begin

            $display("PASS: MSHR 0 owns 0x100");
            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR 0 allocation valid=%b addr=%h",
                mshr_valid_debug,
                mshr_addr_debug[0]
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 2
         * ========================================================
         */

        $display("");
        $display("TEST 2: Allocate 0x140");
        $display("Expected: MSHR 1");

        submit_request(
            32'h00000140,
            1'b0,
            32'h00000000
        );

        #1;

        if (mshr_valid_debug[1] &&
            mshr_addr_debug[1] == 32'h00000140) begin

            $display("PASS: MSHR 1 owns 0x140");
            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR 1 allocation valid=%b addr=%h",
                mshr_valid_debug,
                mshr_addr_debug[1]
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 3
         * ========================================================
         */

        $display("");
        $display("TEST 3: Allocate 0x180");
        $display("Expected: MSHR 2");

        submit_request(
            32'h00000180,
            1'b0,
            32'h00000000
        );

        #1;

        if (mshr_valid_debug[2] &&
            mshr_addr_debug[2] == 32'h00000180) begin

            $display("PASS: MSHR 2 owns 0x180");
            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR 2 allocation valid=%b addr=%h",
                mshr_valid_debug,
                mshr_addr_debug[2]
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 4
         * ========================================================
         */

        $display("");
        $display("TEST 4: Allocate 0x1C0");
        $display("Expected: MSHR 3");

        submit_request(
            32'h000001C0,
            1'b0,
            32'h00000000
        );

        #1;

        if (mshr_valid_debug[3] &&
            mshr_addr_debug[3] == 32'h000001C0) begin

            $display("PASS: MSHR 3 owns 0x1C0");
            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR 3 allocation valid=%b addr=%h",
                mshr_valid_debug,
                mshr_addr_debug[3]
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 5
         * ========================================================
         */

        $display("");
        $display("TEST 5: Verify MSHR table is full");
        $display("Expected: valid=1111");

        #1;

        if (mshr_valid_debug == 4'b1111) begin

            $display("PASS: all four MSHRs are active");
            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR table valid=%b",
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
        $display("TEST 6: Submit fifth outstanding miss 0x200");
        $display("Expected: REQUEST BLOCKED");

        @(negedge clk);

        req_addr  = 32'h00000200;
        req_write = 1'b0;
        req_wdata = 32'b0;
        req_valid = 1'b1;

        #1;

        if (!req_ready) begin

            $display("PASS: 0x200 blocked because all MSHRs are full");
            pass_count = pass_count + 1;

        end
        else begin

            $display("FAIL: 0x200 incorrectly accepted");
            fail_count = fail_count + 1;

        end

        @(posedge clk);

        #1;

        req_valid = 1'b0;


        /*
         * ========================================================
         * TEST 7
         * ========================================================
         */

        $display("");
        $display("TEST 7: Verify blocked request did not allocate");
        $display("Expected: valid=1111");

        #1;

        if (mshr_valid_debug == 4'b1111) begin

            $display("PASS: blocked request created no fifth MSHR");
            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR state changed unexpectedly valid=%b",
                mshr_valid_debug
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 8
         * ========================================================
         */

        $display("");
        $display("TEST 8: Release MSHR 0");
        $display("Expected: MSHR 0 becomes free");

        @(negedge clk);

        mshr_release_valid = 1'b1;
        mshr_release_index = 2'd0;

        @(posedge clk);

        #1;

        mshr_release_valid = 1'b0;

        if (!mshr_valid_debug[0] &&
            mshr_valid_debug[3:1] == 3'b111) begin

            $display("PASS: MSHR 0 released");
            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: release state valid=%b",
                mshr_valid_debug
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 9
         * ========================================================
         */

        $display("");
        $display("TEST 9: Retry 0x200");
        $display("Expected: request accepted into MSHR 0");

        submit_request(
            32'h00000200,
            1'b0,
            32'h00000000
        );

        #1;

        if (mshr_valid_debug[0] &&
            mshr_addr_debug[0] == 32'h00000200) begin

            $display("PASS: 0x200 allocated after MSHR became free");
            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x200 allocation valid=%b addr=%h",
                mshr_valid_debug,
                mshr_addr_debug[0]
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 10
         * ========================================================
         */

        $display("");
        $display("TEST 10: Complete all outstanding MSHRs");
        $display("Expected: all MSHRs released");

        complete_mshr(2'd1, 32'hAAAA0140);
        complete_mshr(2'd2, 32'hAAAA0180);
        complete_mshr(2'd3, 32'hAAAA01C0);
        complete_mshr(2'd0, 32'hAAAA0200);

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
         * SUMMARY
         * ========================================================
         */

        $display("");
        $display("================================================");
        $display("PROJECT 37 STEP 14 VERIFICATION SUMMARY");
        $display("================================================");

        $display("PASS COUNT = %0d", pass_count);
        $display("FAIL COUNT = %0d", fail_count);
        $display("MEMORY REQUESTS = %0d", memory_request_count);

        $display("");

        if (fail_count == 0) begin
            $display("PROJECT 37 STEP 14 VERIFICATION: PASS");
        end
        else begin
            $display("PROJECT 37 STEP 14 VERIFICATION: FAIL");
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
