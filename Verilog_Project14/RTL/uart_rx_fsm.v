module uart_rx_fsm(

input wire clk,
input wire rst,
input wire rx,
input wire baud_tick,
input wire receive_done,

output reg sample_enable,
output reg busy,
output reg done
);

localparam IDLE    = 3'd0;
localparam START   = 3'd1;
localparam RECEIVE = 3'd2;
localparam STOP    = 3'd3;
localparam DONE    = 3'd4;

reg [2:0] state;

always @(posedge clk or posedge rst)

begin

    if(rst)

    begin
        state <= IDLE;
        sample_enable <= 0;
        busy <= 0;
        done <= 0;

    end
    else

    begin

        sample_enable <= 0;
        done <= 0;

        case(state)

        IDLE:
        begin
            busy <= 0;
            if(rx == 0)
                state <= START;

        end

        START:
        begin
            busy <= 1;
            if(baud_tick)
                state <= RECEIVE;

        end

        RECEIVE:
        begin
            sample_enable <= 1;
            if(receive_done)
                state <= STOP;

        end

        STOP:
        begin

            if(baud_tick)
                state <= DONE;

        end

        DONE:
        begin
            busy <= 0;
            done <= 1;
            state <= IDLE;

        end

        default:
            state <= IDLE;

        endcase
    end
end
endmodule