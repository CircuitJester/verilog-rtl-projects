module return_address_stack #(
    parameter STACK_DEPTH = 8
) (
    input  wire clk,
    input  wire rst,

    input  wire push,
    input  wire pop,
    input  wire [31:0] return_address,

    output wire [31:0] predicted_return_address,
    output wire empty,
    output wire full

);

    reg [31:0] return_stack [0:STACK_DEPTH-1];
    reg [3:0] stack_pointer;

    assign empty = (stack_pointer == 4'd0);
    assign full  = (stack_pointer == STACK_DEPTH);

    assign predicted_return_address = empty ? 32'b0 : return_stack[stack_pointer - 1'b1];

    always @(posedge clk) 
    begin
        if (rst) 
        begin
            stack_pointer <= 4'd0;

        end

        else 
        begin

            case ({push, pop})
                2'b10: 
                begin
                    if (!full) 
                    begin
                        return_stack[stack_pointer] <= return_address;
                        stack_pointer <= stack_pointer + 1'b1;

                    end
                end

                2'b01: 
                begin
                    if (!empty) begin
                        stack_pointer <= stack_pointer - 1'b1;
                        
                    end

                end

                default: 
                begin
                    stack_pointer <= stack_pointer;

                end

            endcase

        end
    end

endmodule