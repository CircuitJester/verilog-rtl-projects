module spi_master_fsm(

    input clk,
    input rst,
    input start,
    input done,

    output reg load,
    output reg shift,
    output reg enable,
    output reg busy

);

// State Encoding

localparam IDLE  = 2'b00;
localparam LOAD  = 2'b01;
localparam SHIFT = 2'b10;
localparam DONE  = 2'b11;

reg [1:0] state;
reg [1:0] next_state;

// State Register.

always @(posedge clk or posedge rst)
begin

    if(rst)
        state <= IDLE;

    else
        state <= next_state;

end

// Next State Logic.

always @(*)
begin

    case(state)

        IDLE:
        begin
            if(start)
                next_state = LOAD;
            else
                next_state = IDLE;
        end

        LOAD:
        begin
            next_state = SHIFT;
        end

        SHIFT:
        begin
            if(done)
                next_state = DONE;
            else
                next_state = SHIFT;
        end

        DONE:
        begin
            next_state = IDLE;
        end

        default:
            next_state = IDLE;

    endcase
end

// Output Logic.

always @(*)
begin

    load   = 0;
    shift  = 0;
    enable = 0;
    busy   = 0;

    case(state)

        IDLE:
        begin
            busy = 0;
        end

        LOAD:
        begin
            load = 1;
            busy = 1;
        end

        SHIFT:
        begin
            shift  = 1;
            enable = 1;
            busy   = 1;
        end

        DONE:
        begin
            busy = 0;
        end

    endcase

end
endmodule