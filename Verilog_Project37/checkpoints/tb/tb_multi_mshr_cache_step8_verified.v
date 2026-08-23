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
     * COMPLETE MSHR TASK
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

        /*
         * Allow reset to initialize the DUT.
         */

        #20;

        rst = 1'b0;

        #10;


        /*
         * ========================================================
         * HEADER
         * ========================================================
         */

        $display("");
        $display("================================================");
        $display("PROJECT 37 - MULTI-MSHR NON-BLOCKING CACHE");
        $display("STEP 8 - MSHR FULL BACKPRESSURE");
        $display("================================================");


        /*
         * ========================================================
         * TEST 1
         * ========================================================
         */

        $display("");
        $display("TEST 1: Allocate four outstanding misses");
        $display("Expected: all four MSHRs occupied");

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

        if (mshr_valid_debug == 4'b1111) begin

            $display(
                "PASS: all four MSHRs occupied"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR state=%b",
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
        $display("TEST 2: Verify req_ready when MSHRs are full");
        $display("Expected: req_ready = 0");

        @(negedge clk);

        req_valid = 1'b0;
        req_addr  = 32'h00000140;
        req_write = 1'b0;
        req_wdata = 32'b0;

        #1;

        if (!req_ready) begin

            $display(
                "PASS: req_ready correctly deasserted"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: req_ready remained asserted"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 3
         * ========================================================
         */

        $display("");
        $display("TEST 3: Attempt fifth outstanding miss");
        $display("Expected: request must be blocked");

        @(negedge clk);

        req_valid = 1'b1;
        req_addr  = 32'h00000140;
        req_write = 1'b0;
        req_wdata = 32'b0;

        #1;

        if (!req_ready) begin

            $display(
                "PASS: fifth request blocked by full MSHR table"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: fifth request incorrectly accepted"
            );

            fail_count = fail_count + 1;

        end

        @(posedge clk);

        @(negedge clk);

        req_valid = 1'b0;
        req_addr  = 32'b0;
        req_write = 1'b0;
        req_wdata = 32'b0;

        #1;


        /*
         * ========================================================
         * TEST 4
         * ========================================================
         */

        $display("");
        $display("TEST 4: Verify blocked request did not corrupt MSHRs");

        if (mshr_valid_debug == 4'b1111 &&
            mshr_addr_debug[0] == 32'h00000100 &&
            mshr_addr_debug[1] == 32'h00000110 &&
            mshr_addr_debug[2] == 32'h00000120 &&
            mshr_addr_debug[3] == 32'h00000130) begin

            $display(
                "PASS: original MSHR contents preserved"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR table was corrupted"
            );

            $display(
                "MSHR state=%b",
                mshr_valid_debug
            );

            $display(
                "MSHR0=%h MSHR1=%h MSHR2=%h MSHR3=%h",
                mshr_addr_debug[0],
                mshr_addr_debug[1],
                mshr_addr_debug[2],
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
        $display("TEST 5: Complete MSHR 2");
        $display("Expected: one MSHR becomes free");

        complete_mshr(
            2'd2,
            32'hAAAA1200
        );

        #1;

        if (mshr_valid_debug == 4'b1011) begin

            $display(
                "PASS: MSHR 2 released"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR state after completion=%b",
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
        $display("TEST 6: Verify req_ready recovers");
        $display("Expected: req_ready = 1");

        @(negedge clk);

        req_addr  = 32'h00000140;
        req_write = 1'b0;
        req_wdata = 32'b0;
        req_valid = 1'b0;

        #1;

        if (req_ready) begin

            $display(
                "PASS: req_ready recovered after MSHR release"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: req_ready remained low"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 7
         * ========================================================
         */

        $display("");
        $display("TEST 7: Allocate previously blocked request");
        $display("Expected: 0x140 uses released MSHR 2");

        submit_request(
            32'h00000140,
            1'b0,
            32'h00000000
        );

        #1;

        if (mshr_valid_debug[2] &&
            mshr_addr_debug[2] == 32'h00000140 &&
            mshr_valid_debug[0] &&
            mshr_valid_debug[1] &&
            mshr_valid_debug[3]) begin

            $display(
                "PASS: blocked request allocated into MSHR 2"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x140 allocation incorrect"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 8
         * ========================================================
         */

        $display("");
        $display("TEST 8: Verify all four MSHRs occupied again");

        #1;

        if (mshr_valid_debug == 4'b1111) begin

            $display(
                "PASS: MSHR table returned to full state"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR state=%b",
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
        $display("TEST 9: Complete MSHR 0");

        complete_mshr(
            2'd0,
            32'hAAAA0000
        );

        #1;

        if (!mshr_valid_debug[0] &&
            mshr_valid_debug[1] &&
            mshr_valid_debug[2] &&
            mshr_valid_debug[3]) begin

            $display(
                "PASS: MSHR 0 released cleanly"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR 0 release corrupted table"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 10
         * ========================================================
         */

        $display("");
        $display("TEST 10: Complete MSHR 1");

        complete_mshr(
            2'd1,
            32'hAAAA0100
        );

        #1;

        if (!mshr_valid_debug[1] &&
            mshr_valid_debug[2] &&
            mshr_valid_debug[3]) begin

            $display(
                "PASS: MSHR 1 released cleanly"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR 1 release corrupted table"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 11
         * ========================================================
         */

        $display("");
        $display("TEST 11: Complete MSHR 2");

        complete_mshr(
            2'd2,
            32'hAAAA0200
        );

        #1;

        if (!mshr_valid_debug[2] &&
            mshr_valid_debug[3]) begin

            $display(
                "PASS: MSHR 2 released cleanly"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR 2 release corrupted table"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 12
         * ========================================================
         */

        $display("");
        $display("TEST 12: Complete MSHR 3");

        complete_mshr(
            2'd3,
            32'hAAAA0300
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
        $display("TEST 13: Verify req_ready after complete drain");
        $display("Expected: req_ready = 1");

        @(negedge clk);

        req_valid = 1'b0;
        req_addr  = 32'h00000200;
        req_write = 1'b0;
        req_wdata = 32'b0;

        #1;

        if (req_ready) begin

            $display(
                "PASS: cache accepts new traffic after drain"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: req_ready remained low after drain"
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
        $display("PROJECT 37 STEP 8 VERIFICATION SUMMARY");
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
            $display("PROJECT 37 STEP 8 VERIFICATION: PASS");
            $display("================================================");

        end
        else begin

            $display("");
            $display("================================================");
            $display("PROJECT 37 STEP 8 VERIFICATION: FAIL");
            $display("================================================");

        end

        #20;

        $finish;

    end

endmodule
