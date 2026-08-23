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

    multi_mshr_cache dut (
        .clk                (clk),
        .rst                (rst),

        .req_valid          (req_valid),
        .req_ready          (req_ready),
        .req_addr           (req_addr),
        .req_write          (req_write),
        .req_wdata          (req_wdata),

        .mshr_alloc_valid   (mshr_alloc_valid),
        .mshr_alloc_index   (mshr_alloc_index),

        .mem_req_valid      (mem_req_valid),
        .mem_req_mshr       (mem_req_mshr),
        .mem_req_addr       (mem_req_addr),
        .mem_req_write      (mem_req_write),
        .mem_req_wdata      (mem_req_wdata),

        .mem_resp_valid     (mem_resp_valid),
        .mem_resp_mshr      (mem_resp_mshr),
        .mem_resp_rdata     (mem_resp_rdata),

        .mshr_release_valid (mshr_release_valid),
        .mshr_release_index (mshr_release_index),

        .mshr_valid_debug   (mshr_valid_debug),
        .mshr_write_debug   (mshr_write_debug),
        .mshr_addr_debug    (mshr_addr_debug),

        .req_mshr_match_debug
                            (req_mshr_match_debug),
        .req_mshr_index_debug
                            (req_mshr_index_debug),

        .resp_valid         (resp_valid),
        .resp_hit           (resp_hit),
        .resp_rdata         (resp_rdata)
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


    /*
     * ============================================================
     * REQUEST HELPER
     * ============================================================
     */

    task submit_request;

        input [31:0] addr;
        input        write_en;
        input [31:0] data;

        begin

            @(negedge clk);

            req_valid = 1'b1;
            req_addr  = addr;
            req_write = write_en;
            req_wdata = data;

            #1;

            if (req_ready) begin

                $display(
                    "REQUEST ACCEPTED: address=%h write=%b data=%h",
                    addr,
                    write_en,
                    data
                );

            end
            else begin

                $display(
                    "REQUEST BLOCKED: address=%h",
                    addr
                );

            end

            @(posedge clk);

            #1;

            req_valid = 1'b0;

        end

    endtask


    /*
     * ============================================================
     * MEMORY RESPONSE HELPER
     * ============================================================
     */

    task complete_mshr;

        input [1:0]  mshr_index;
        input [31:0] response_data;

        begin

            @(negedge clk);

            mem_resp_valid = 1'b1;
            mem_resp_mshr  = mshr_index;
            mem_resp_rdata = response_data;

            $display(
                "MEMORY RESPONSE: MSHR=%0d data=%h",
                mshr_index,
                response_data
            );

            @(posedge clk);

            #1;

            mem_resp_valid = 1'b0;

        end

    endtask


    /*
     * ============================================================
     * INITIALIZATION
     * ============================================================
     */

    initial begin

        rst = 1'b1;

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

        repeat (2)
            @(posedge clk);

        rst = 1'b0;

        @(posedge clk);

        $display("");
        $display("================================================");
        $display("PROJECT 37 - MULTI-MSHR NON-BLOCKING CACHE");
        $display("STEP 12 - MSHR OWNER LOOKUP");
        $display("================================================");


        /*
         * ========================================================
         * TEST 1
         * ========================================================
         */

        $display("");
        $display("TEST 1: Allocate 0x100");
        $display("Expected: MSHR 0 owns 0x100");

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
                "FAIL: MSHR state=%b addr0=%h",
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
        $display("TEST 2: Lookup outstanding 0x100");
        $display("Expected: MATCH=1 OWNER=MSHR 0");

        @(negedge clk);

        req_valid = 1'b0;
        req_addr  = 32'h00000100;
        req_write = 1'b0;
        req_wdata = 32'b0;

        #1;

        if (req_mshr_match_debug &&
            req_mshr_index_debug == 2'd0) begin

            $display(
                "PASS: 0x100 correctly maps to MSHR 0"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: match=%b owner=%0d",
                req_mshr_match_debug,
                req_mshr_index_debug
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 3
         * ========================================================
         */

        $display("");
        $display("TEST 3: Lookup unrelated 0x140");
        $display("Expected: MATCH=0");

        @(negedge clk);

        req_addr = 32'h00000140;

        #1;

        if (!req_mshr_match_debug) begin

            $display(
                "PASS: 0x140 has no outstanding MSHR owner"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: unexpected owner=%0d",
                req_mshr_index_debug
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 4
         * ========================================================
         */

        $display("");
        $display("TEST 4: Allocate additional outstanding misses");
        $display("Expected: MSHR 1=0x140, MSHR 2=0x180");

        submit_request(
            32'h00000140,
            1'b0,
            32'h00000000
        );

        submit_request(
            32'h00000180,
            1'b0,
            32'h00000000
        );

        #1;

        if (mshr_valid_debug == 4'b0111 &&
            mshr_addr_debug[0] == 32'h00000100 &&
            mshr_addr_debug[1] == 32'h00000140 &&
            mshr_addr_debug[2] == 32'h00000180) begin

            $display(
                "PASS: three MSHRs contain expected addresses"
            );

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
         * TEST 5
         * ========================================================
         */

        $display("");
        $display("TEST 5: Lookup 0x140");
        $display("Expected: MATCH=1 OWNER=MSHR 1");

        @(negedge clk);

        req_addr = 32'h00000140;

        #1;

        if (req_mshr_match_debug &&
            req_mshr_index_debug == 2'd1) begin

            $display(
                "PASS: 0x140 correctly maps to MSHR 1"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: match=%b owner=%0d",
                req_mshr_match_debug,
                req_mshr_index_debug
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 6
         * ========================================================
         */

        $display("");
        $display("TEST 6: Lookup 0x180");
        $display("Expected: MATCH=1 OWNER=MSHR 2");

        req_addr = 32'h00000180;

        #1;

        if (req_mshr_match_debug &&
            req_mshr_index_debug == 2'd2) begin

            $display(
                "PASS: 0x180 correctly maps to MSHR 2"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: match=%b owner=%0d",
                req_mshr_match_debug,
                req_mshr_index_debug
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 7
         * ========================================================
         */

        $display("");
        $display("TEST 7: Complete MSHR 1");
        $display("Expected: owner lookup for 0x140 disappears");

        complete_mshr(
            2'd1,
            32'hAAAA0140
        );

        req_addr = 32'h00000140;

        #1;

        if (!req_mshr_match_debug &&
            mshr_valid_debug == 4'b0101) begin

            $display(
                "PASS: MSHR owner removed after completion"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: match=%b valid=%b",
                req_mshr_match_debug,
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
        $display("TEST 8: Verify duplicate blocking remains intact");
        $display("Expected: 0x100 request remains blocked");

        @(negedge clk);

        req_valid = 1'b1;
        req_addr  = 32'h00000100;
        req_write = 1'b0;
        req_wdata = 32'b0;

        #1;

        if (!req_ready &&
            req_mshr_match_debug &&
            req_mshr_index_debug == 2'd0) begin

            $display(
                "PASS: duplicate 0x100 remains blocked and owner is MSHR 0"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: ready=%b match=%b owner=%0d",
                req_ready,
                req_mshr_match_debug,
                req_mshr_index_debug
            );

            fail_count = fail_count + 1;

        end

        @(posedge clk);

        #1;

        req_valid = 1'b0;


        /*
         * ========================================================
         * TEST 9
         * ========================================================
         */

        $display("");
        $display("TEST 9: Complete remaining MSHRs");
        $display("Expected: all MSHRs released");

        complete_mshr(
            2'd0,
            32'hAAAA0100
        );

        complete_mshr(
            2'd2,
            32'hAAAA0180
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
                "FAIL: MSHR table=%b",
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
        $display("TEST 10: Lookup after complete drain");
        $display("Expected: no outstanding MSHR match");

        req_addr = 32'h00000100;

        #1;

        if (!req_mshr_match_debug) begin

            $display(
                "PASS: no stale MSHR owner remains"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: stale owner=%0d",
                req_mshr_index_debug
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
        $display("PROJECT 37 STEP 12 VERIFICATION SUMMARY");
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
                "PROJECT 37 STEP 12 VERIFICATION: PASS"
            );

        end
        else begin

            $display(
                "PROJECT 37 STEP 12 VERIFICATION: FAIL"
            );

        end

        $display("================================================");

        $finish;

    end


    /*
     * ============================================================
     * WAVEFORM DUMP
     * ============================================================
     */

    initial begin

        $dumpfile("waves/multi_mshr_cache.vcd");

        $dumpvars(
            0,
            tb_multi_mshr_cache
        );

    end

endmodule
