module i2c_master_fsm(

    input scl,
    input rst,
    input start,
    input done,
    input ack_received,

    output reg start_condition,
    output reg stop_condition,
    output reg load,
    output reg shift,
    output reg ack_enable,
    output reg busy

);

localparam IDLE  = 3'd0;
localparam START = 3'd1;
localparam LOAD  = 3'd2;
localparam SHIFT = 3'd3;
localparam ACK   = 3'd4;
localparam STOP  = 3'd5;
localparam DONE  = 3'd6;

reg [2:0] state;

always @(posedge scl or posedge rst)
begin

    if(rst)
        state <= IDLE;

    else
    begin

        case(state)

        IDLE:
            if(start)
                state <= START;

        START:
            state <= LOAD;

        LOAD:
            state <= SHIFT;

        SHIFT:
            if(done)
                state <= ACK;

        ACK:
        begin
            if(ack_received)
                state <= STOP;
            else
                state <= STOP;
        end

        STOP:
            state <= DONE;

        DONE:
            state <= IDLE;

        default:
            state <= IDLE;

        endcase

    end
end

always @(*)
begin

    start_condition = 0;
    stop_condition  = 0;
    load            = 0;
    shift           = 0;
    ack_enable      = 0;
    busy            = 0;

    case(state)

    IDLE:
    begin
        busy = 0;
    end

    START:
    begin
        start_condition = 1;
        busy = 1;
    end

    LOAD:
    begin
        load = 1;
        busy = 1;
    end

    SHIFT:
    begin
        shift = 1;
        busy = 1;
    end

    ACK:
    begin
        ack_enable = 1;
        busy = 1;
    end

    STOP:
    begin
        stop_condition = 1;
        busy = 1;
    end

    DONE:
    begin
        busy = 0;
    end

    endcase
end
endmodule