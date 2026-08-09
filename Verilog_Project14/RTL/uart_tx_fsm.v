module uart_tx_fsm(

input wire clk,
input wire rst,
input wire start,
input wire baud_tick,
input wire shift_done,

output reg load,
output reg start_bit,
output reg shift_enable,
output reg stop_bit,
output reg busy,
output reg done
);

// State Encoding
localparam IDLE  = 3'd0;
localparam LOAD  = 3'd1;
localparam START = 3'd2;
localparam SHIFT = 3'd3;
localparam STOP  = 3'd4;
localparam DONE  = 3'd5;

reg [2:0] state;

// FSM
always @(posedge clk or posedge rst)

begin

    if(rst)

    begin
        state <= IDLE;

        load <= 0;
        start_bit <= 0;
        shift_enable <= 0;
        stop_bit <= 0;
        busy <= 0;
        done <= 0;

    end
    else

    begin

        load <= 0;
        start_bit <= 0;
        shift_enable <= 0;
        stop_bit <= 0;
        done <= 0;

        case(state)

        IDLE:
        begin
            busy <= 0;
            if(start)
                state <= LOAD;

        end

        LOAD:
        begin
            load <= 1;
            busy <= 1;
            state <= START;

        end

        START:
        begin
            start_bit <= 1;
            if(baud_tick)
                state <= SHIFT;

        end

        SHIFT:
        begin
            shift_enable <= 1;
            if(shift_done)
                state <= STOP;

        end

        STOP:
        begin
            stop_bit <= 1;
            if(baud_tick)
                state <= DONE;

        end

        DONE:
        begin
            done <= 1;
            busy <= 0;
            state <= IDLE;

        end

        default:
            state <= IDLE;

        endcase

    end
end
endmodule