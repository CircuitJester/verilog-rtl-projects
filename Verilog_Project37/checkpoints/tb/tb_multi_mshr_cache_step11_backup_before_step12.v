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

    wire [3:0]  mshr_valid_debug;
    wire [31:0] mshr_addr_debug [0:3];

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

        .mshr_valid_debug(mshr_valid_debug),
        .mshr_addr_debug(mshr_addr_debug),

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

        pass_count = 0;
        fail_count = 0;
        memory_request_count = 0;

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
        $display("STEP 11 - DUPLICATE OUTSTANDING REQUEST");
        $display("================================================");


        /*
         * ========================================================
         * TEST 1
         * ========================================================
         */

        $display("");
        $display("TEST 1: Allocate initial miss 0x100");
        $display("Expected: MSHR allocated");

        submit_request(
            32'h00000100,
            1'b0,
            32'h00000000
        );

        #1;

        if (mshr_valid_debug != 4'b0001 &&
            mshr_valid_debug[0]) begin

            $display(
                "PASS: 0x100 allocated to MSHR 0"
            );

            pass_count = pass_count + 1;

        end
        else if (mshr_valid_debug[0] &&
                 mshr_addr_debug[0] == 32'h00000100) begin

            $display(
                "PASS: 0x100 allocated to MSHR 0"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: initial 0x100 allocation failed"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 2
         * ========================================================
         */

        $display("");
        $display("TEST 2: Verify initial MSHR ownership");
        $display("Expected: MSHR 0 = 0x100");

        if (mshr_valid_debug[0] &&
            mshr_addr_debug[0] == 32'h00000100) begin

            $display(
                "PASS: MSHR 0 correctly owns 0x100"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR ownership incorrect"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 3
         * ========================================================
         */

        $display("");
        $display("TEST 3: Submit duplicate outstanding 0x100");
        $display("Expected: request BLOCKED");

        @(negedge clk);

        req_valid = 1'b1;
        req_addr  = 32'h00000100;
        req_write = 1'b0;
        req_wdata = 32'b0;

        #1;

        if (!req_ready) begin

            $display(
                "PASS: duplicate 0x100 request blocked"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: duplicate 0x100 request was accepted"
            );

            fail_count = fail_count + 1;

        end

        @(posedge clk);

        @(negedge clk);

        req_valid = 1'b0;
        req_addr  = 32'b0;
        req_write = 1'b0;
        req_wdata = 32'b0;


        /*
         * ========================================================
         * TEST 4
         * ========================================================
         */

        $display("");
        $display("TEST 4: Verify duplicate did not allocate MSHR");
        $display("Expected: only MSHR 0 remains active");

        #1;

        if (mshr_valid_debug == 4'b0001 &&
            mshr_addr_debug[0] == 32'h00000100) begin

            $display(
                "PASS: duplicate did not create another MSHR"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: duplicate corrupted MSHR table"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 5
         * ========================================================
         */

        $display("");
        $display("TEST 5: Verify no duplicate memory transaction");
        $display("Expected: exactly one memory request so far");

        if (memory_request_count == 1) begin

            $display(
                "PASS: duplicate did not generate second memory request"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: memory request count=%0d",
                memory_request_count
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 6
         * ========================================================
         */

        $display("");
        $display("TEST 6: Complete original 0x100 request");
        $display("Expected: cache refill");

        complete_mshr(
            2'd0,
            32'hAAAA0100
        );

        #1;

        if (mshr_valid_debug == 4'b0000) begin

            $display(
                "PASS: original MSHR completed"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: MSHR remained allocated"
            );

            fail_count = fail_count + 1;

        end


        /*
         * ========================================================
         * TEST 7
         * ========================================================
         */

        $display("");
        $display("TEST 7: Access 0x100 after refill");
        $display("Expected: HIT + AAAA0100");

        submit_request(
            32'h00000100,
            1'b0,
            32'h00000000
        );

        #1;

        if (resp_valid &&
            resp_hit &&
            resp_rdata == 32'hAAAA0100) begin

            $display(
                "PASS: 0x100 cache hit correct"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: 0x100 cache hit incorrect data=%h hit=%b",
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
        $display("TEST 8: Verify MSHR table after refill");
        $display("Expected: empty");

        if (mshr_valid_debug == 4'b0000) begin

            $display(
                "PASS: MSHR table empty"
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
         * TEST 9
         * ========================================================
         */

        $display("");
        $display("TEST 9: Verify duplicate prevention did not block future access");
        $display("Expected: cache still accepts traffic");

        @(negedge clk);

        req_valid = 1'b1;
        req_addr  = 32'h00000100;
        req_write = 1'b0;
        req_wdata = 32'b0;

        #1;

        if (req_ready) begin

            $display(
                "PASS: cache accepts address after completion"
            );

            pass_count = pass_count + 1;

        end
        else begin

            $display(
                "FAIL: cache remained blocked after completion"
            );

            fail_count = fail_count + 1;

        end

        @(posedge clk);

        @(negedge clk);

        req_valid = 1'b0;
        req_addr  = 32'b0;
        req_write = 1'b0;
        req_wdata = 32'b0;


        /*
         * ========================================================
         * SUMMARY
         * ========================================================
         */

        #10;

        $display("");
        $display("================================================");
        $display("PROJECT 37 STEP 11 VERIFICATION SUMMARY");
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
                "PROJECT 37 STEP 11 VERIFICATION: PASS"
            );

        end
        else begin

            $display(
                "PROJECT 37 STEP 11 VERIFICATION: FAIL"
            );

        end

        $display(
            "================================================"
        );

        $finish;

    end

endmodule
