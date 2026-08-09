module sdram_init_fsm(

input wire clk,
input wire rst,
input wire delay_done,

output reg start_delay,
output reg precharge,
output reg refresh,
output reg load_mode,
output reg init_done
);

localparam IDLE        = 3'd0;
localparam WAIT_POWER  = 3'd1;
localparam PRECHARGE   = 3'd2;
localparam REFRESH     = 3'd3;
localparam LOAD_MODE   = 3'd4;
localparam READY       = 3'd5;

reg [2:0] state;

always @(posedge clk or posedge rst)

begin

    if(rst)

    begin

        state <= IDLE;
        start_delay <= 0;
        precharge <= 0;
        refresh <= 0;
        load_mode <= 0;
        init_done <= 0;

    end
    else

    begin

        start_delay <= 0;
        precharge <= 0;
        refresh <= 0;
        load_mode <= 0;

        case(state)

        IDLE:
        begin

            start_delay <= 1;
            state <= WAIT_POWER;

        end

        WAIT_POWER:
        begin

            start_delay <= 1;

            if(delay_done)
                state <= PRECHARGE;

        end

        PRECHARGE:
        begin

            precharge <= 1;
            state <= REFRESH;

        end

        REFRESH:
        begin

            refresh <= 1;
            state <= LOAD_MODE;

        end

        LOAD_MODE:

        begin

            load_mode <= 1;
            state <= READY;

        end

        READY:
        begin

            init_done <= 1;

        end

        default:

            state <= IDLE;

        endcase

    end
end
endmodule