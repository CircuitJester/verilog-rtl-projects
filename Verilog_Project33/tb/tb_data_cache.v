`timescale 1ns/1ps

module tb_data_cache;

    reg clk;
    reg rst;

    reg cpu_read;
    reg cpu_write;
    reg [31:0] cpu_address;
    reg [31:0] cpu_write_data;

    wire [31:0] cpu_read_data;
    wire cpu_ready;

    wire memory_read;
    wire memory_write;
    wire [31:0] memory_address;
    wire [31:0] memory_write_data;

    reg [31:0] memory_read_data;
    reg memory_ready;

    reg [31:0] main_memory [0:63];

    integer i;

    data_cache dut (
        .clk(clk),
        .rst(rst),

        .cpu_read(cpu_read),
        .cpu_write(cpu_write),
        .cpu_address(cpu_address),
        .cpu_write_data(cpu_write_data),

        .cpu_read_data(cpu_read_data),
        .cpu_ready(cpu_ready),

        .memory_read(memory_read),
        .memory_write(memory_write),
        .memory_address(memory_address),
        .memory_write_data(memory_write_data),

        .memory_read_data(memory_read_data),
        .memory_ready(memory_ready)
    );


    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    always @(*) begin
        memory_read_data = main_memory[memory_address[7:2]];
    end


    always @(negedge clk) begin

        memory_ready <= 1'b0;

        if (memory_write) begin

            main_memory[memory_address[7:2]] <= memory_write_data;

            memory_ready <= 1'b1;

            $display(
                "MEMORY WRITE-BACK: address=%h data=%h",
                memory_address,
                memory_write_data
            );

        end

        else if (memory_read) begin

            memory_ready <= 1'b1;

            $display(
                "MEMORY READ: address=%h data=%h",
                memory_address,
                main_memory[memory_address[7:2]]
            );

        end
    end

    task automatic perform_read;
        input [31:0] address;

        begin

            @(negedge clk);

            cpu_address = address;
            cpu_read = 1'b1;
            cpu_write = 1'b0;

            $display(
                "CPU READ REQUEST: address=%h",
                address
            );

            @(negedge clk);

            cpu_read = 1'b0;

            while (!cpu_ready) begin
                @(negedge clk);
            end

            $display(
                "CPU READ COMPLETE: address=%h data=%h",
                address,
                cpu_read_data
            );

            @(negedge clk);
        end
    endtask

    task automatic perform_write;
        input [31:0] address;
        input [31:0] data_value;

        begin

            @(negedge clk);

            cpu_address = address;
            cpu_write_data = data_value;

            cpu_read = 1'b0;
            cpu_write = 1'b1;

            $display(
                "CPU WRITE REQUEST: address=%h data=%h",
                address,
                data_value
            );

            @(negedge clk);

            cpu_write = 1'b0;


            while (!cpu_ready) begin
                @(negedge clk);
            end

            $display(
                "CPU WRITE COMPLETE: address=%h data=%h",
                address,
                data_value
            );

            @(negedge clk);
        end
    endtask

    initial begin

        $dumpfile("waves/data_cache.vcd");
        $dumpvars(0, tb_data_cache);


        for (i = 0; i < 64; i = i + 1) begin
            main_memory[i] = 32'h10000000 + i;
        end

        rst = 1'b1;

        cpu_read = 1'b0;
        cpu_write = 1'b0;

        cpu_address = 32'b0;
        cpu_write_data = 32'b0;

        memory_ready = 1'b0;

        #12;
        rst = 1'b0;


        perform_read(32'h00000000);

        perform_read(32'h00000000);

        perform_write(
            32'h00000000,
            32'hDEADBEEF
        );

        perform_read(32'h00000000);

        perform_read(32'h00000020);

        perform_read(32'h00000020);

        perform_read(32'h00000000);

        #20;

        $finish;

    end

endmodule