module i2c_master_fsm(

input wire clk,
input wire rst,
input wire start,
input wire shift_done,
input wire ack,
input wire error,

output reg start_cmd,
output reg load,
output reg shift,
output reg check_ack,
output reg stop_cmd,
output reg busy,
output reg done
);

// State Encoding
parameter S_IDLE      = 3'd0;
parameter S_START     = 3'd1;
parameter S_LOAD      = 3'd2;
parameter S_SHIFT     = 3'd3;
parameter S_ACK       = 3'd4;
parameter S_STOP      = 3'd5;
parameter S_COMPLETE  = 3'd6;

reg [2:0] state;

always @(posedge clk or posedge rst)

begin

    if(rst)

    begin

        state <= S_IDLE;

        start_cmd <= 0;
        load <= 0;
        shift <= 0;
        check_ack <= 0;
        stop_cmd <= 0;
        busy <= 0;
        done <= 0;

    end
    else

    begin

        // Default Outputs
        start_cmd <= 0;
        load <= 0;
        shift <= 0;
        check_ack <= 0;
        stop_cmd <= 0;
        done <= 0;

        case(state)

        S_IDLE:
        begin

            busy <= 0;

            if(start)

            begin

                busy <= 1;
                state <= S_START;
            end

        end

        S_START:
        begin

            start_cmd <= 1;
            state <= S_LOAD;

        end

        S_LOAD:

        begin

            load <= 1;
            state <= S_SHIFT;

        end

        S_SHIFT:
        begin

            shift <= 1;

            if(shift_done)

                state <= S_ACK;

        end

        S_ACK:
        begin

            check_ack <= 1;

            if(ack)

                state <= S_STOP;

            else if(error)

                state <= S_STOP;

        end


        S_STOP:
        begin

            stop_cmd <= 1;
            state <= S_COMPLETE;

        end

        S_COMPLETE:

        begin

            done <= 1;
            busy <= 0;
            state <= S_IDLE;

        end

        default:

        begin

            state <= S_IDLE;

        end

        endcase

    end
end
endmodule