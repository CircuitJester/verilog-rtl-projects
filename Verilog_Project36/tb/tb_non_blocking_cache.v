`timescale 1ns/1ps

module tb_non_blocking_cache;

    reg clk;
    reg rst;

    reg req_valid;
    wire req_ready;
    reg req_write;
    reg [31:0] req_addr;
    reg [31:0] req_wdata;

    wire resp_valid;
    wire resp_hit;
    wire [31:0] resp_rdata;

    wire mem_read;
    wire [31:0] mem_addr;
    reg [31:0] mem_rdata;
    reg mem_ready;

    wire miss_pending;
    wire [31:0]  miss_addr_debug;
    wire miss_write_debug;

    integer pass_count;
    integer fail_count;
    integer memory_read_count;

    non_blocking_cache dut (
        .clk              (clk),
        .rst              (rst),

        .req_valid (req_valid),
        .req_ready (req_ready),
        .req_write (req_write),
        .req_addr (req_addr),
        .req_wdata (req_wdata),

        .resp_valid (resp_valid),
        .resp_hit (resp_hit),
        .resp_rdata (resp_rdata),

        .mem_read (mem_read),
        .mem_addr (mem_addr),
        .mem_rdata (mem_rdata),
        .mem_ready (mem_ready),

        .miss_pending (miss_pending),
        .miss_addr_debug (miss_addr_debug),
        .miss_write_debug (miss_write_debug)
    );

    always #5 clk = ~clk;

    task pass;
        input [255:0] message;

        begin
            pass_count = pass_count + 1;
            $display("PASS: %s", message);
        end
    endtask

    task fail;
        input [255:0] message;

        begin
            fail_count = fail_count + 1;
            $display("FAIL: %s", message);
        end
    endtask

    task cpu_request;
        input [31:0] address;
        input write_enable;
        input [31:0] write_data;

        begin

            @(negedge clk);

            req_valid = 1'b1;
            req_write = write_enable;
            req_addr = address;
            req_wdata = write_data;

            @(posedge clk);

            #1;

            req_valid = 1'b0;

        end
    endtask

    task memory_respond;
        input [31:0] data;

        begin

            @(negedge clk);

            mem_rdata = data;
            mem_ready = 1'b1;

            @(posedge clk);

            #1;

            mem_ready = 1'b0;

        end
    endtask

    initial 
    begin

        $dumpfile("waves/non_blocking_cache.vcd");
        $dumpvars(0, tb_non_blocking_cache);

        clk = 1'b0;
        rst = 1'b1;

        req_valid = 1'b0;
        req_write = 1'b0;
        req_addr  = 32'h00000000;
        req_wdata = 32'h00000000;

        mem_rdata = 32'h00000000;
        mem_ready = 1'b0;

        pass_count = 0;
        fail_count = 0;
        memory_read_count = 0;

        $display("");
        $display("PROJECT 36 - NON-BLOCKING CACHE");
        $display("STEP 8 - FULL VERIFICATION");

        repeat (2) @(posedge clk);

        rst = 1'b0;

        $display("");
        $display("TEST 1: Reset / controller ready");

        @(posedge clk);
        #1;

        if (req_ready)
            pass("controller ready after reset");
        else
            fail("controller not ready after reset");

        $display("");
        $display("TEST 2: First read miss");
        $display("Expected: MISS + 11110000");

        cpu_request(
            32'h00000000,
            1'b0,
            32'h00000000
        );

        if (miss_pending &&
            miss_addr_debug == 32'h00000000)
            pass("first miss allocated to MSHR");
        else
            fail("first miss allocation");

        if (mem_read &&
            mem_addr == 32'h00000000)
            pass("correct memory request generated");
        else
            fail("incorrect memory request");

        memory_read_count = memory_read_count + 1;

        memory_respond(32'h11110000);

        if (resp_valid &&
            !resp_hit &&
            resp_rdata == 32'h11110000)
            pass("first miss returned correct data");
        else
            fail("first miss response");

        $display("");
        $display("TEST 3: Repeated read hit");
        $display("Expected: HIT + 11110000");

        cpu_request(
            32'h00000000,
            1'b0,
            32'h00000000
        );

        if (resp_valid &&
            resp_hit &&
            resp_rdata == 32'h11110000)
            pass("cache hit returned correct data");
        else
            fail("cache hit response");

        if (!mem_read)
            pass("cache hit generated no memory request");
        else
            fail("cache hit generated unexpected memory request");

        $display("");
        $display("TEST 4: Fill second cache line");

        cpu_request(
            32'h00000010,
            1'b0,
            32'h00000000
        );

        if (miss_pending &&
            miss_addr_debug == 32'h00000010)
            pass("second miss allocated");
        else
            fail("second miss allocation");

        if (mem_read &&
            mem_addr == 32'h00000010)
            pass("second memory request correct");
        else
            fail("second memory request incorrect");

        memory_read_count = memory_read_count + 1;

        memory_respond(32'h22220000);

        if (resp_valid &&
            !resp_hit &&
            resp_rdata == 32'h22220000)
            pass("second refill correct");
        else
            fail("second refill response");


        $display("");
        $display("TEST 5: Independent HIT during outstanding MISS");

        cpu_request(
            32'h00000020,
            1'b0,
            32'h00000000
        );

        if (miss_pending &&
            miss_addr_debug == 32'h00000020)
            pass("outstanding miss captured");
        else
            fail("outstanding miss capture");

        // Hit existing line while miss is outstanding.

        cpu_request(
            32'h00000010,
            1'b0,
            32'h00000000
        );

        if (resp_valid &&
            resp_hit &&
            resp_rdata == 32'h22220000)
            pass("independent hit completed");
        else
            fail("independent hit response");

        if (miss_pending &&
            miss_addr_debug == 32'h00000020)
            pass("outstanding miss preserved");
        else
            fail("outstanding miss corrupted");


        $display("");
        $display("TEST 6: Complete outstanding miss");

        memory_respond(32'h33330000);

        if (resp_valid &&
            !resp_hit &&
            resp_rdata == 32'h33330000)
            pass("outstanding miss completed");
        else
            fail("outstanding miss completion");


        $display("");
        $display("TEST 7: Second MISS while MSHR busy");

        cpu_request(
            32'h00000030,
            1'b0,
            32'h00000000
        );

        if (miss_pending &&
            miss_addr_debug == 32'h00000030)
            pass("new miss captured");
        else
            fail("new miss capture");

        @(negedge clk);

        req_valid = 1'b1;
        req_write = 1'b0;
        req_addr = 32'h00000040;
        req_wdata = 32'h00000000;

        #1;

        if (!req_ready)
            pass("second miss blocked while MSHR busy");
        else
            fail("second miss was incorrectly accepted");

        @(posedge clk);

        #1;

        req_valid = 1'b0;

        if (miss_pending &&
            miss_addr_debug == 32'h00000030)
            pass("original MSHR preserved");
        else
            fail("original MSHR corrupted");

        // Complete 0x30.

        memory_respond(32'h44440000);

        if (resp_valid &&
            !resp_hit &&
            resp_rdata == 32'h44440000)
            pass("blocked-miss sequence recovered correctly");
        else
            fail("blocked-miss recovery");


        $display("");
        $display("TEST 8: Repeated hit after refill");

        cpu_request(
            32'h00000030,
            1'b0,
            32'h00000000
        );

        if (resp_valid &&
            resp_hit &&
            resp_rdata == 32'h44440000)
            pass("refilled line produces HIT");
        else
            fail("refilled line hit");


        $display("");
        $display("TEST 9: Write hit");
        $display("Expected: HIT + AAAAAAAA");

        cpu_request(
            32'h00000030,
            1'b1,
            32'hAAAAAAAA
        );

        if (resp_valid &&
            resp_hit &&
            resp_rdata == 32'hAAAAAAAA)
            pass("write hit updated cache");
        else
            fail("write hit");


        $display("");
        $display("TEST 10: Read after write");

        cpu_request(
            32'h00000030,
            1'b0,
            32'h00000000
        );

        if (resp_valid &&
            resp_hit &&
            resp_rdata == 32'hAAAAAAAA)
            pass("modified cache data returned");
        else
            fail("read-after-write");


        $display("");
        $display("TEST 11: Response pulse integrity");

        @(posedge clk);
        #1;

        if (!resp_valid)
            pass("resp_valid returned LOW after response");
        else
            fail("resp_valid remained HIGH");


        $display("");
        $display("TEST 12: New miss after previous transaction");

        cpu_request(
            32'h00000050,
            1'b0,
            32'h00000000
        );

        if (miss_pending &&
            miss_addr_debug == 32'h00000050)
            pass("new MSHR allocation successful");
        else
            fail("new MSHR allocation");

        if (mem_read &&
            mem_addr == 32'h00000050)
            pass("new memory request correct");
        else
            fail("new memory request");

        memory_read_count = memory_read_count + 1;

        memory_respond(32'h55550000);

        if (resp_valid &&
            !resp_hit &&
            resp_rdata == 32'h55550000)
            pass("new miss response correct");
        else
            fail("new miss response");


        $display("");
        $display("TEST 13: Final cache hit");

        cpu_request(
            32'h00000050,
            1'b0,
            32'h00000000
        );

        if (resp_valid &&
            resp_hit &&
            resp_rdata == 32'h55550000)
            pass("final cache hit correct");
        else
            fail("final cache hit");


        $display("");
        $display("TEST 14: Final controller state");

        if (!miss_pending)
            pass("MSHR is free");
        else
            fail("MSHR still occupied");

        if (req_ready)
            pass("CPU interface ready");
        else
            fail("CPU interface not ready");

      
        $display("");
        $display("PROJECT 36 FULL VERIFICATION SUMMARY");

        $display("PASS COUNT = %0d", pass_count);
        $display("FAIL COUNT = %0d", fail_count);
        $display("MEMORY READ TRANSACTIONS = %0d", memory_read_count);

        $display("");

        if (fail_count == 0) begin

            $display("PROJECT 36 FULL VERIFICATION: PASS");

        end
        else 
        begin

            $display("PROJECT 36 FULL VERIFICATION: FAIL");

        end

        #20;

        $finish;

    end

endmodule
