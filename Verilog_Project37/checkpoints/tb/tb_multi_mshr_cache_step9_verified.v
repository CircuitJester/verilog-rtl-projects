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

        /*
         * Hold reset.
         */

        repeat (3)
            @(posedge clk);

        rst = 1'b0;

        /*
         * Allow reset state to settle.
         */

        @(posedge clk);


        $display("================================================");
        $display("PROJECT 37 - MULTI-MSHR NON-BLOCKING CACHE");
        $display("STEP 9 - OUT-OF-ORDER MSHR COMPLETION");
        $display("================================================");


        /*
         * ========================================================
         * TEST 1
         * ========================================================
         */

        $display("");
        $display("TEST 1: Allocate four outstanding misses");
        $display("Expected: MSHR 0=0x100, 1=0x110, 2=0x120, 3=0x130");

        submit_request(
            32'h00000100,
            1'b0,
            32'h00000000
        );

        submit_request(
            32'h00000110,
            1'b0,
            32'h00000000
        );

        submit_request(
            32'h00000120,
            1'b0,
            32'h00000000
        );

        submit_request(
            32'h00000130,
            1'b0,
            32'h00000000
        );

        #1;

        if (mshr_valid_debug == 4'b1111 &&
            mshr_addr_debug[0] == 32'h00000100 &&
            mshr_addr_debug[1] == 32'h00000110 &&
            mshr_addr_debug[2] == 32'h00000120 &&
            mshr_addr_debug[3] == 32'h00000130) begin

            $display(
                "PASS: four outstanding MSHRs allocated correctly"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: initial MSHR allocation incorrect"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 2
         * ========================================================
         */

        $display("");
        $display("TEST 2: Complete MSHR 2 first");
        $display("Expected: 0x120 -> AAAA1200");

        complete_mshr(
            2'd2,
            32'hAAAA1200
        );

        #1;

        if (!mshr_valid_debug[2] &&
            mshr_valid_debug[0] &&
            mshr_valid_debug[1] &&
            mshr_valid_debug[3] &&
            mshr_addr_debug[0] == 32'h00000100 &&
            mshr_addr_debug[1] == 32'h00000110 &&
            mshr_addr_debug[3] == 32'h00000130) begin

            $display(
                "PASS: MSHR 2 completed without disturbing others"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR 2 completion corrupted outstanding state"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 3
         * ========================================================
         */

        $display("");
        $display("TEST 3: Complete MSHR 0 second");
        $display("Expected: 0x100 -> AAAA0000");

        complete_mshr(
            2'd0,
            32'hAAAA0000
        );

        #1;

        if (!mshr_valid_debug[0] &&
            !mshr_valid_debug[2] &&
            mshr_valid_debug[1] &&
            mshr_valid_debug[3] &&
            mshr_addr_debug[1] == 32'h00000110 &&
            mshr_addr_debug[3] == 32'h00000130) begin

            $display(
                "PASS: MSHR 0 completed out of order"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR 0 out-of-order completion failed"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 4
         * ========================================================
         */

        $display("");
        $display("TEST 4: Complete MSHR 3 third");
        $display("Expected: 0x130 -> AAAA0300");

        complete_mshr(
            2'd3,
            32'hAAAA0300
        );

        #1;

        if (!mshr_valid_debug[0] &&
            !mshr_valid_debug[2] &&
            !mshr_valid_debug[3] &&
            mshr_valid_debug[1] &&
            mshr_addr_debug[1] == 32'h00000110) begin

            $display(
                "PASS: MSHR 3 completed independently"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR 3 completion failed"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 5
         * ========================================================
         */

        $display("");
        $display("TEST 5: Complete final MSHR 1");
        $display("Expected: 0x110 -> AAAA0100");

        complete_mshr(
            2'd1,
            32'hAAAA0100
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
                "FAIL: final MSHR was not released"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 6
         * ========================================================
         */

        $display("");
        $display("TEST 6: Verify cache line 0x100");
        $display("Expected: HIT + AAAA0000");

        submit_request(
            32'h00000100,
            1'b0,
            32'h00000000
        );

        #1;

        if (resp_valid &&
            resp_hit &&
            resp_rdata == 32'hAAAA0000) begin

            $display(
                "PASS: 0x100 cache line correct"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x100 cache line incorrect data=%h hit=%b",
                resp_rdata,
                resp_hit
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 7
         * ========================================================
         */

        $display("");
        $display("TEST 7: Verify cache line 0x110");
        $display("Expected: HIT + AAAA0100");

        submit_request(
            32'h00000110,
            1'b0,
            32'h00000000
        );

        #1;

        if (resp_valid &&
            resp_hit &&
            resp_rdata == 32'hAAAA0100) begin

            $display(
                "PASS: 0x110 cache line correct"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x110 cache line incorrect data=%h hit=%b",
                resp_rdata,
                resp_hit
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 8
         * ========================================================
         */

        $display("");
        $display("TEST 8: Verify cache line 0x120");
        $display("Expected: HIT + AAAA1200");

        submit_request(
            32'h00000120,
            1'b0,
            32'h00000000
        );

        #1;

        if (resp_valid &&
            resp_hit &&
            resp_rdata == 32'hAAAA1200) begin

            $display(
                "PASS: 0x120 cache line correct"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x120 cache line incorrect data=%h hit=%b",
                resp_rdata,
                resp_hit
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 9
         * ========================================================
         */

        $display("");
        $display("TEST 9: Verify cache line 0x130");
        $display("Expected: HIT + AAAA0300");

        submit_request(
            32'h00000130,
            1'b0,
            32'h00000000
        );

        #1;

        if (resp_valid &&
            resp_hit &&
            resp_rdata == 32'hAAAA0300) begin

            $display(
                "PASS: 0x130 cache line correct"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x130 cache line incorrect data=%h hit=%b",
                resp_rdata,
                resp_hit
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 10
         * ========================================================
         */

        $display("");
        $display("TEST 10: Verify cache accepts new miss after drain");

        submit_request(
            32'h00000140,
            1'b0,
            32'h00000000
        );

        #1;

        if (mshr_valid_debug != 4'b0000) begin

            /*
             * New miss should occupy exactly one MSHR.
             */

            if (mshr_valid_debug[0] ||
                mshr_valid_debug[1] ||
                mshr_valid_debug[2] ||
                mshr_valid_debug[3]) begin

                $display(
                    "PASS: new post-drain miss allocated"
                );

                pass_count = pass_count + 1;

            end
            else begin

                $display(
                    "FAIL: post-drain miss not allocated"
                );

                fail_count = fail_count + 1;

            end

        end
        else begin

            $display(
                "FAIL: post-drain request did not allocate an MSHR"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 11
         * ========================================================
         */

        $display("");
        $display("TEST 11: Complete post-drain MSHR");

        if (mshr_valid_debug[0])
            complete_mshr(2'd0, 32'hAAAA0400);

        else if (mshr_valid_debug[1])
            complete_mshr(2'd1, 32'hAAAA0400);

        else if (mshr_valid_debug[2])
            complete_mshr(2'd2, 32'hAAAA0400);

        else if (mshr_valid_debug[3])
            complete_mshr(2'd3, 32'hAAAA0400);

        #1;

        if (mshr_valid_debug == 4'b0000) begin

            $display(
                "PASS: post-drain MSHR completed"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: post-drain MSHR remained allocated"
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
        $display("PROJECT 37 STEP 9 VERIFICATION SUMMARY");
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
                "================================================"
            );

            $display(
                "PROJECT 37 STEP 9 VERIFICATION: PASS"
            );

            $display(
                "================================================"
            );

        end
        else begin

            $display(
                "================================================"
            );

            $display(
                "PROJECT 37 STEP 9 VERIFICATION: FAIL"
            );

            $display(
                "================================================"
            );

        end

        $finish;

    end

endmodule
