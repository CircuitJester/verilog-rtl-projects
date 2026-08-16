`timescale 1ns/1ps

module tb_instruction_cache;

    reg clk;
    reg rst;

    reg cpu_request;
    reg [31:0] cpu_address;

    wire cpu_hit;
    wire [31:0] cpu_instruction;

    wire memory_request;
    wire [31:0] memory_address;
    reg [31:0] memory_data;
    reg memory_ready;

    reg [31:0] memory [0:31];

    instruction_cache dut (
        .clk(clk),
        .rst(rst),
        .cpu_request(cpu_request),
        .cpu_address(cpu_address),
        .cpu_hit(cpu_hit),
        .cpu_instruction(cpu_instruction),
        .memory_request(memory_request),
        .memory_address(memory_address),
        .memory_data(memory_data),
        .memory_ready(memory_ready)
        
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    always @(*) begin
        memory_data = memory[memory_address[6:2]];
    end

    task fetch_instruction;
        input [31:0] address;

        begin

            cpu_address = address;
            cpu_request = 1'b1;
            #10;
            cpu_request = 1'b0;

            if (memory_request) 
            begin

                #10;
                memory_ready = 1'b1;
                #10;
                memory_ready = 1'b0;

            end

            #10;

        end
    endtask

    initial 
    begin

        $dumpfile("waves/instruction_cache.vcd");
        $dumpvars(0, tb_instruction_cache);

        memory[0]  = 32'h11111111;
        memory[1]  = 32'h22222222;
        memory[2]  = 32'h33333333;
        memory[3]  = 32'h44444444;
        memory[4]  = 32'h55555555;
        memory[5]  = 32'h66666666;
        memory[6]  = 32'h77777777;
        memory[7]  = 32'h88888888;

        memory[8]  = 32'hAAAA0001;
        memory[9]  = 32'hAAAA0002;
        memory[10] = 32'hAAAA0003;
        memory[11] = 32'hAAAA0004;
        memory[12] = 32'hBBBB0001;
        memory[13] = 32'hBBBB0002;
        memory[14] = 32'hBBBB0003;
        memory[15] = 32'hBBBB0004;

        memory[16] = 32'hCCCC0001;
        memory[17] = 32'hCCCC0002;
        memory[18] = 32'hCCCC0003;
        memory[19] = 32'hCCCC0004;
        memory[20] = 32'hDDDD0001;
        memory[21] = 32'hDDDD0002;
        memory[22] = 32'hDDDD0003;
        memory[23] = 32'hDDDD0004;

        memory[24] = 32'hEEEE0001;
        memory[25] = 32'hEEEE0002;
        memory[26] = 32'hEEEE0003;
        memory[27] = 32'hEEEE0004;
        memory[28] = 32'hFFFF0001;
        memory[29] = 32'hFFFF0002;
        memory[30] = 32'hFFFF0003;
        memory[31] = 32'hFFFF0004;

        rst = 1'b1;
        cpu_request = 1'b0;
        cpu_address = 32'h00000000;
        memory_ready = 1'b0;

        #12;
        rst = 1'b0;

        fetch_instruction(32'h00000000);
        fetch_instruction(32'h00000000);

        fetch_instruction(32'h00000004);
        fetch_instruction(32'h00000004);

        fetch_instruction(32'h00000020);
        fetch_instruction(32'h00000020);

        fetch_instruction(32'h00000040);
        fetch_instruction(32'h00000040);

        fetch_instruction(32'h00000000);
        #20;

        $finish;

    end

endmodule