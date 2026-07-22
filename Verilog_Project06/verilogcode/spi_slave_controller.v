module spi_slave_controller(

    input spi_clk,
    input rst,
    input cs,
    input done,

    output reg load,
    output reg busy

);

localparam IDLE     = 2'd0;
localparam LOAD     = 2'd1;
localparam SHIFT    = 2'd2;
localparam COMPLETE = 2'd3;

reg [1:0] state;

always @(posedge spi_clk or posedge rst)
begin

    if(rst)
        state <= IDLE;

    else
    begin

        case(state)

        IDLE:
        begin
            if(!cs)
                state <= LOAD;
        end

        LOAD:
        begin
            state <= SHIFT;
        end

        SHIFT:
        begin
            if(done)
                state <= COMPLETE;
        end

        COMPLETE:
        begin
            if(cs)
                state <= IDLE;
        end

        default:
            state <= IDLE;

        endcase
    end
end

always @(*)
begin

    load = 0;
    busy = 0;

    case(state)

    IDLE:
    begin
        load = 0;
        busy = 0;
    end

    LOAD:
    begin
        load = 1;
        busy = 1;
    end

    SHIFT:
    begin
        load = 0;
        busy = 1;
    end

    COMPLETE:
    begin
        load = 0;
        busy = 0;
    end
    endcase
end
endmodule