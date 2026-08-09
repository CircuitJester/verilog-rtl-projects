module sdram_main_fsm(

input wire clk,
input wire rst,
input wire init_done,
input wire refresh_request,
input wire read_request,
input wire write_request,
input wire read_done,
input wire write_done,

output reg start_init,
output reg start_refresh,
output reg start_read,
output reg start_write

);

localparam RESET_STATE = 3'd0;
localparam INIT        = 3'd1;
localparam IDLE        = 3'd2;
localparam REFRESH     = 3'd3;
localparam READ        = 3'd4;
localparam WRITE       = 3'd5;

reg [2:0] state;

always @(posedge clk or posedge rst)

begin

    if(rst)

    begin

        state <= RESET_STATE;
        start_init <= 0;
        start_refresh <= 0;
        start_read <= 0;
        start_write <= 0;

    end
    else

    begin

        start_init <= 0;
        start_refresh <= 0;
        start_read <= 0;
        start_write <= 0;

        case(state)

        RESET_STATE:
        begin

            start_init <= 1;
            state <= INIT;

        end

        INIT:
        begin

            start_init <= 1;
            if(init_done)
                state <= IDLE;

        end

        IDLE:
        begin

            if(refresh_request)
                state <= REFRESH;
            else if(read_request)
                state <= READ;
            else if(write_request)
                state <= WRITE;

        end

        REFRESH:
        begin

            start_refresh <= 1;
            state <= IDLE;

        end

        READ:
        begin

            start_read <= 1;
            if(read_done)
                state <= IDLE;

        end

        WRITE:
        begin

            start_write <= 1;
            if(write_done)
                state <= IDLE;

        end

        default:
            state <= RESET_STATE;

        endcase

    end
end
endmodule