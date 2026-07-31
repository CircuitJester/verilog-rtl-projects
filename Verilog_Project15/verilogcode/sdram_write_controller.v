module sdram_write_controller(

input wire clk,
input wire rst,
input wire write_request,
input wire delay_done,

output reg start_delay,
output reg activate,
output reg write_cmd,
output reg write_done

);

localparam IDLE      = 3'd0;
localparam ACTIVATE  = 3'd1;
localparam WAIT_TRCD = 3'd2;
localparam WRITE     = 3'd3;
localparam DONE      = 3'd4;

reg [2:0] state;

always @(posedge clk or posedge rst)

begin

    if(rst)

    begin

        state <= IDLE;
        activate <= 0;
        write_cmd <= 0;
        write_done <= 0;
        start_delay <= 0;

    end

    else
    begin

        activate <= 0;
        write_cmd <= 0;
        write_done <= 0;
        start_delay <= 0;

        case(state)


        IDLE:
        begin

            if(write_request)
                state <= ACTIVATE;

        end

        ACTIVATE:
        begin

            activate <= 1;
            start_delay <= 1;
            state <= WAIT_TRCD;

        end

        WAIT_TRCD:
        begin

            start_delay <= 1;
            if(delay_done)
                state <= WRITE;

        end

        WRITE:
        begin

            write_cmd <= 1;
            state <= DONE;

        end

        DONE:
        begin
            write_done <= 1;
            state <= IDLE;

        end

        default:
            state <= IDLE;

        endcase

    end
end
endmodule