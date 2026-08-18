`timescale 1ns/1ps

module tb_set_associative_data_cache;

    reg clk;
    reg rst;

    reg req_valid;
    reg req_write;
    reg [31:0] req_addr;
    reg [31:0] req_wdata;

    wire resp_valid;
    wire resp_hit;
    wire [31:0] resp_rdata;

    wire mem_read;
    wire [31:0] mem_addr;

    wire [31:0] mem_rdata;
    wire mem_ready;


    wire mem_write;
    wire [31:0] mem_write_addr;
    wire [31:0] mem_write_data;

    wire mem_write_ready;


    reg [31:0] backing_memory [0:255];

    integer i;

    set_associative_data_cache dut (

        .clk(clk),
        .rst(rst),

        .req_valid(req_valid),
        .req_write(req_write),
        .req_addr(req_addr),
        .req_wdata(req_wdata),

        .resp_valid(resp_valid),
        .resp_hit(resp_hit),
        .resp_rdata(resp_rdata),

        .mem_read(mem_read),
        .mem_addr(mem_addr),
        .mem_rdata(mem_rdata),
        .mem_ready(mem_ready),

        .mem_write(mem_write),
        .mem_write_addr(mem_write_addr),
        .mem_write_data(mem_write_data),
        .mem_write_ready(mem_write_ready)

    );

    always #5 clk = ~clk;

    assign mem_ready = mem_read;

    assign mem_rdata =
        (mem_addr == 32'h0000_0000) ? backing_memory[0] :
        (mem_addr == 32'h0000_0010) ? backing_memory[4] :
        (mem_addr == 32'h0000_0020) ? backing_memory[8] :
        (mem_addr == 32'h0000_0030) ? backing_memory[12]:
        32'hDEAD_BEEF;

    assign mem_write_ready = mem_write;

    always @(posedge clk) begin

        if (mem_write) begin

            case (mem_write_addr)

                32'h0000_0000: begin

                    backing_memory[0] <=
                        mem_write_data;

                end

                32'h0000_0010: begin

                    backing_memory[4] <=
                        mem_write_data;

                end

                32'h0000_0020: begin

                    backing_memory[8] <=
                        mem_write_data;

                end

                32'h0000_0030: begin

                    backing_memory[12] <=
                        mem_write_data;

                end

                default: begin

                end

            endcase

            $display(
                "MEMORY WRITE-BACK: address=%h data=%h",
                mem_write_addr,
                mem_write_data
            );

        end

    end

    task cache_read;

        input [31:0] addr;

        begin

            @(negedge clk);

            req_valid = 1'b1;

            req_write = 1'b0;

            req_addr = addr;

            req_wdata = 32'h0000_0000;

            @(negedge clk);

            req_valid = 1'b0;

            wait (resp_valid == 1'b1);

            #1;

            $display(
                "CPU READ RESPONSE: address=%h hit=%b data=%h",
                addr,
                resp_hit,
                resp_rdata
            );

            @(negedge clk);

        end

    endtask

    task cache_write;

        input [31:0] addr;
        input [31:0] data;

        begin

            @(negedge clk);

            req_valid = 1'b1;

            req_write = 1'b1;

            req_addr = addr;

            req_wdata = data;

            @(negedge clk);

            req_valid = 1'b0;

            wait (resp_valid == 1'b1);

            #1;

            $display(
                "CPU WRITE RESPONSE: address=%h hit=%b data=%h",
                addr,
                resp_hit,
                resp_rdata
            );

            @(negedge clk);

        end

    endtask

    initial 
    begin

        clk = 1'b0;

        rst = 1'b1;

        req_valid = 1'b0;

        req_write = 1'b0;

        req_addr = 32'h0000_0000;

        req_wdata = 32'h0000_0000;

        for (i = 0; i < 256; i = i + 1) begin

            backing_memory[i] = 32'h0000_0000;

        end

        backing_memory[0]  = 32'h1111_0000;
        backing_memory[4]  = 32'h2222_0000;
        backing_memory[8]  = 32'h3333_0000;
        backing_memory[12] = 32'h4444_0000;

        #20;

        rst = 1'b0;

        $display("");
        $display("TEST 1: First read");
        $display("Expected: MISS + 11110000");

        cache_read(32'h0000_0000);

        $display("");
        $display("TEST 2: Repeated read");
        $display("Expected: HIT + 11110000");

        cache_read(32'h0000_0000);

        $display("");
        $display("TEST 3: Second address");
        $display("Expected: MISS + 22220000");

        cache_read(32'h0000_0010);


        $display("");
        $display("TEST 4: Repeated second address");
        $display("Expected: HIT + 22220000");

        cache_read(32'h0000_0010);

        $display("");
        $display("TEST 5: Write hit");
        $display("Expected: HIT + BBBBBBBB");

        cache_write(
            32'h0000_0000,
            32'hBBBB_BBBB
        );


        $display("");
        $display("TEST 6: Read modified address");
        $display("Expected: HIT + BBBBBBBB");

        cache_read(32'h0000_0000);

        $display("");
        $display("TEST 7: Update LRU ordering");
        $display("Expected: HIT + 22220000");

        cache_read(32'h0000_0010);


        $display("");
        $display("TEST 8: Dirty eviction");
        $display("Expected: WRITE-BACK + MISS + 33330000");

        cache_read(32'h0000_0020);


        $display("");
        $display("TEST 9: Read evicted dirty line");
        $display("Expected: MISS + BBBBBBBB");

        cache_read(32'h0000_0000);

        $display("");
        $display("TEST 10: Repeated restored line");
        $display("Expected: HIT + BBBBBBBB");

        cache_read(32'h0000_0000);

        

        $display(
            "MEMORY[0x00000000] = %h",
            backing_memory[0]
        );

        $display(
            "MEMORY[0x00000010] = %h",
            backing_memory[4]
        );

        $display(
            "MEMORY[0x00000020] = %h",
            backing_memory[8]
        );

    end

    initial 
    begin

        $dumpfile("waves/data_cache_2way.vcd");

        $dumpvars(
            0,
            tb_set_associative_data_cache
        );

    end

endmodule