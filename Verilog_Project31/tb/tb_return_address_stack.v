`timescale 1ns/1ps

module tb_return_address_stack;

    reg clk;
    reg rst;
    reg push;
    reg pop;
    reg [31:0] return_address;

    wire [31:0] predicted_return_address;
    wire empty;
    wire full;

    return_address_stack #(
        .STACK_DEPTH(8)
    ) dut (
        .clk(clk),
        .rst(rst),
        .push(push),
        .pop(pop),
        .return_address(return_address),
        .predicted_return_address(predicted_return_address),
        .empty(empty),
        .full(full)
        
    );

    initial 
    begin

        clk = 1'b0;
        forever #5 clk = ~clk;

    end

    task push_return_address;
        input [31:0] address;
        begin

            return_address = address;
            push = 1'b1;
            pop = 1'b0;
            #10;
            push = 1'b0;

        end
    endtask

    task pop_return_address;
        begin
            push = 1'b0;
            pop = 1'b1;

            #10;
            pop = 1'b0;

        end
    endtask

    initial 
    begin

        $dumpfile("waves/return_address_stack.vcd");
        $dumpvars(0, tb_return_address_stack);

        rst = 1'b1;
        push = 1'b0;
        pop = 1'b0;
        return_address = 32'h00000000;

        #12;
        rst = 1'b0;

        push_return_address(32'h00001000);
        push_return_address(32'h00002000);
        push_return_address(32'h00003000);

        pop_return_address;
        pop_return_address;
        pop_return_address;

        push_return_address(32'h00004000);
        push_return_address(32'h00005000);
        push_return_address(32'h00006000);
        push_return_address(32'h00007000);
        push_return_address(32'h00008000);
        push_return_address(32'h00009000);
        push_return_address(32'h0000A000);
        push_return_address(32'h0000B000);

        push_return_address(32'hDEADBEEF);

        pop_return_address;
        pop_return_address;
        pop_return_address;
        pop_return_address;
        pop_return_address;
        pop_return_address;
        pop_return_address;
        pop_return_address;
        pop_return_address;

        #10;
        $finish;

    end

endmodule