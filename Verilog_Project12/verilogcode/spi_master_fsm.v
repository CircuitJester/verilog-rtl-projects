module spi_master_fsm
(
    input  wire clk,
    input  wire rst,
    input  wire start,
    input  wire shift_done,

    output reg load,
    output reg cs_start,
    output reg shift_enable,
    output reg transfer_done,
    output reg busy
);

// State Encoding
parameter S_IDLE   = 3'd0;
parameter S_LOAD   = 3'd1;
parameter S_SELECT = 3'd2;
parameter S_SHIFT  = 3'd3;
parameter S_FINISH = 3'd4;

reg [2:0] state;

// FSM
always @(posedge clk or posedge rst)
begin

    if(rst)
    begin

        state <= S_IDLE;

        load <= 0;
        cs_start <= 0;
        shift_enable <= 0;
        transfer_done <= 0;
        busy <= 0;
    end

    else
    begin

        // Default Outputs

        load <= 0;
        cs_start <= 0;
        shift_enable <= 0;
        transfer_done <= 0;

        case(state)

        // IDLE
        S_IDLE:
        begin

            busy <= 0;
            if(start)
                state <= S_LOAD;

        end

        // LOAD
        S_LOAD:
        begin

            busy <= 1;
            load <= 1;
            state <= S_SELECT;

        end

        // SELECT SLAVE
        S_SELECT:
        begin

            busy <= 1;
            cs_start <= 1;
            state <= S_SHIFT;

        end

        // SHIFT DATA
        S_SHIFT:
        begin

            busy <= 1;
            shift_enable <= 1;

            if(shift_done)
                state <= S_FINISH;

        end

        // FINISH
        S_FINISH:
        begin

            busy <= 0;
            transfer_done <= 1;
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