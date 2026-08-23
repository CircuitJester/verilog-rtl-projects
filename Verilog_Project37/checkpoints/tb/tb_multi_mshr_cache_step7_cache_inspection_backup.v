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

    reg [1:0] mshr_40;
    reg [1:0] mshr_50;
    reg [1:0] mshr_00;
    reg [1:0] mshr_10;

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

            @(posedge clk);

            @(negedge clk);

            mem_resp_valid = 1'b0;
            mem_resp_mshr  = 2'd0;
            mem_resp_rdata = 32'b0;

        end

    endtask

    /*
     * ============================================================
     * FIND MSHR BY ADDRESS
     * ============================================================
     */

    task find_mshr;

        input  [31:0] address;
        output [1:0]  found_index;

        begin

            found_index = 2'd0;

            if (mshr_valid_debug[0] &&
                mshr_addr_debug[0] == address)

                found_index = 2'd0;

            else if (mshr_valid_debug[1] &&
                     mshr_addr_debug[1] == address)

                found_index = 2'd1;

            else if (mshr_valid_debug[2] &&
                     mshr_addr_debug[2] == address)

                found_index = 2'd2;

            else if (mshr_valid_debug[3] &&
                     mshr_addr_debug[3] == address)

                found_index = 2'd3;

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

        mshr_40 = 2'd0;
        mshr_50 = 2'd0;
        mshr_00 = 2'd0;
        mshr_10 = 2'd0;

        $dumpfile("waves/multi_mshr_cache.vcd");
        $dumpvars(0, tb_multi_mshr_cache);

        $display("================================================");
        $display("PROJECT 37 - MULTI-MSHR NON-BLOCKING CACHE");
        $display("STEP 7 - MIXED MSHR REUSE + INDEX COLLISION");
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
                "FAIL: initial MSHR state=%b",
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
                "PASS: initial MSHR mapping correct"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: initial MSHR mapping incorrect"
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
        $display("Expected: 0x10 -> 22220000");

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
        $display("Expected: write miss 0x30");

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
                "PASS: MSHR 1 and MSHR 3 released"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: released MSHR state incorrect"
            );

            fail_count = fail_count + 1;

        end

        /*
         * ========================================================
         * TEST 5
         * ========================================================
         */

        $display("");
        $display("TEST 5: Verify older outstanding MSHRs preserved");

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
        $display("TEST 6: Allocate 0x40 into released MSHR");

        submit_request(
            32'h00000040,
            1'b0,
            32'h00000000
        );

        #1;

        find_mshr(
            32'h00000040,
            mshr_40
        );

        if (mshr_valid_debug[mshr_40] &&
            mshr_addr_debug[mshr_40] == 32'h00000040) begin

            $display(
                "PASS: 0x40 allocated to MSHR %0d",
                mshr_40
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x40 allocation failed"
            );

            fail_count = fail_count + 1;

        end

        /*
         * ========================================================
         * TEST 7
         * ========================================================
         */

        $display("");
        $display("TEST 7: Verify mixed outstanding traffic");

        if (mshr_valid_debug[0] &&
            mshr_valid_debug[2] &&
            mshr_valid_debug[mshr_40] &&
            mshr_addr_debug[0] == 32'h00000000 &&
            mshr_addr_debug[2] == 32'h00000020 &&
            mshr_addr_debug[mshr_40] == 32'h00000040) begin

            $display(
                "PASS: mixed MSHR table preserved"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: mixed MSHR table incorrect"
            );

            fail_count = fail_count + 1;

        end

        /*
         * ========================================================
         * TEST 8
         * ========================================================
         */

        $display("");
        $display("TEST 8: Complete 0x40");

        complete_mshr(
            mshr_40,
            32'h66660000
        );

        #1;

        if (!mshr_valid_debug[mshr_40] &&
            mshr_valid_debug[0] &&
            mshr_valid_debug[2]) begin

            $display(
                "PASS: 0x40 completed"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x40 completion failed"
            );

            fail_count = fail_count + 1;

        end

        /*
         * ========================================================
         * TEST 9
         * ========================================================
         */

        $display("");
        $display("TEST 9: Allocate 0x50");

        submit_request(
            32'h00000050,
            1'b0,
            32'h00000000
        );

        #1;

        find_mshr(
            32'h00000050,
            mshr_50
        );

        if (mshr_valid_debug[mshr_50] &&
            mshr_addr_debug[mshr_50] == 32'h00000050) begin

            $display(
                "PASS: 0x50 allocated to MSHR %0d",
                mshr_50
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x50 allocation failed"
            );

            fail_count = fail_count + 1;

        end

        /*
         * ========================================================
         * TEST 10
         * ========================================================
         */

        $display("");
        $display("TEST 10: Complete 0x50");

        complete_mshr(
            mshr_50,
            32'h55550000
        );

        #1;

        if (!mshr_valid_debug[mshr_50] &&
            mshr_valid_debug[0] &&
            mshr_valid_debug[2]) begin

            $display(
                "PASS: 0x50 completed"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x50 completion failed"
            );

            fail_count = fail_count + 1;

        end

        /*
         * ========================================================
         * TEST 11
         * ========================================================
         */

        $display("");
        $display("TEST 11: Complete original MSHR 0");

        complete_mshr(
            2'd0,
            32'h11110000
        );

        #1;

        if (!mshr_valid_debug[0] &&
            mshr_valid_debug[2]) begin

            $display(
                "PASS: original MSHR 0 completed"
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
         * TEST 12
         * ========================================================
         */

        $display("");
        $display("TEST 12: Complete original MSHR 2");

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
                "FAIL: final MSHR state=%b",
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
        $display("TEST 13: Verify 0x20 cache line");
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
                "PASS: 0x20 cache line correct"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x20 cache line incorrect"
            );

            fail_count = fail_count + 1;

        end

        /*
         * ========================================================
         * TEST 14
         * ========================================================
         */

        $display("");
        $display("TEST 14: Verify 0x30 write-miss cache line");
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
                "PASS: 0x30 cache line correct"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x30 cache line incorrect"
            );

            fail_count = fail_count + 1;

        end

        /*
         * ========================================================
         * TEST 15
         * ========================================================
         *
         * IMPORTANT:
         * 0x00 has NOT been accessed again yet.
         * Therefore 0x40 must still be present.
         */

        $display("");
        $display("TEST 15: Verify 0x40 before collision replacement");
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
                "PASS: 0x40 cache line correct"
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
         *
         * 0x50 has index 1 and 0x10 also has index 1.
         * Since 0x10 was already replaced by 0x50, 0x50
         * must remain cached here.
         */

        $display("");
        $display("TEST 16: Verify 0x50 before collision replacement");
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
                "PASS: 0x50 cache line correct"
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
         * 0x00 and 0x40 share index 0.
         * Requesting 0x00 must therefore MISS.
         */

        $display("");
        $display("TEST 17: Verify 0x00 was displaced by 0x40");
        $display("Expected: MISS");

        submit_request(
            32'h00000000,
            1'b0,
            32'h00000000
        );

        #1;

        find_mshr(
            32'h00000000,
            mshr_00
        );

        if (mshr_valid_debug[mshr_00] &&
            mshr_addr_debug[mshr_00] == 32'h00000000) begin

            $display(
                "PASS: 0x00 correctly generated replacement miss"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x00 replacement miss not generated"
            );

            fail_count = fail_count + 1;

        end

        /*
         * Complete the replacement.
         */

        complete_mshr(
            mshr_00,
            32'h11110000
        );

        /*
         * ========================================================
         * TEST 18
         * ========================================================
         *
         * 0x10 and 0x50 share index 1.
         * 0x50 displaced 0x10, so requesting 0x10 must MISS.
         */

        $display("");
        $display("TEST 18: Verify 0x10 was displaced by 0x50");
        $display("Expected: MISS");

        submit_request(
            32'h00000010,
            1'b0,
            32'h00000000
        );

        #1;

        find_mshr(
            32'h00000010,
            mshr_10
        );

        if (mshr_valid_debug[mshr_10] &&
            mshr_addr_debug[mshr_10] == 32'h00000010) begin

            $display(
                "PASS: 0x10 correctly generated replacement miss"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x10 replacement miss not generated"
            );

            fail_count = fail_count + 1;

        end

        complete_mshr(
            mshr_10,
            32'h22220000
        );

        /*
         * ========================================================
         * TEST 19
         * ========================================================
         */

        $display("");
        $display("TEST 19: Verify final MSHR state");

        #1;

        if (mshr_valid_debug == 4'b0000) begin

            $display(
                "PASS: final MSHR table is empty"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: final MSHR table=%b",
                mshr_valid_debug
            );

            fail_count = fail_count + 1;

        end

        /*
         * ========================================================
         * TEST 20
         * ========================================================
         *
         * After the intentional collision replacements:
         *
         * index 0 -> 0x00
         * index 1 -> 0x10
         * index 2 -> 0x20
         * index 3 -> 0x30
         */

        $display("");
        $display("TEST 20: Verify final cache contents");

        /*
         * 0x00
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

        /*
         * 0x10
         */

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

        /*
         * 0x20
         */

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

        /*
         * 0x30
         */

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