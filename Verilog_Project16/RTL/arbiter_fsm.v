module arbiter_fsm(

input wire clk,
input wire rst,
input wire request_pending,
input wire transfer_done,

output reg read_fifo,
output reg grant_enable,
output reg done

);
reg [1:0] state;

parameter IDLE       = 2'd0;
parameter READ_FIFO  = 2'd1;
parameter GRANT_BUS  = 2'd2;
parameter COMPLETE   = 2'd3;

always @(posedge clk or posedge rst)

begin

    if(rst)

    begin

        state <= IDLE;

        read_fifo <= 0;
        grant_enable <= 0;
        done <= 0;

    end
    else

    begin

        read_fifo <= 0;
        grant_enable <= 0;
        done <= 0;

        case(state)

        IDLE:
        begin
            if(request_pending)
                state <= READ_FIFO;

        end

        READ_FIFO:
        begin
            read_fifo <= 1;
            state <= GRANT_BUS;

        end

        GRANT_BUS:
        begin

            grant_enable <= 1;
            if(transfer_done)
                state <= COMPLETE;

        end

        COMPLETE:
        begin
            done <= 1;
            state <= IDLE;

        end

        endcase

    end
end
endmodule