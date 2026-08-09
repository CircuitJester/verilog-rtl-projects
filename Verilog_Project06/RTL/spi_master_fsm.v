module spi_master_fsm (
    input clk,
    input rst,
    input start,
    input done,

    output reg load,
    output reg shift,
    output reg enable,
    output reg busy,
    output reg cs
);

localparam IDLE  = 2'b00;
localparam LOAD  = 2'b01;
localparam SHIFT = 2'b10;
localparam DONE  = 2'b11;

reg [1:0] state;
reg [1:0] next_state;

always @(posedge clk or posedge rst) 

begin

    if (rst)
        state <= IDLE;
    else
        state <= next_state;
        
end

always @(*) 
begin
    case (state)
        IDLE:
            next_state = start ? LOAD : IDLE;

        LOAD:
            next_state = SHIFT;

        SHIFT:
            next_state = done ? DONE : SHIFT;

        DONE:
            next_state = IDLE;

        default:
            next_state = IDLE;
    endcase
end

always @(*) 

begin
    load = 1'b0;
    shift = 1'b0;
    enable = 1'b0;
    busy = 1'b0;
    cs = 1'b1;

    case (state)
        LOAD: begin
            load = 1'b1;
            busy = 1'b1;
            cs = 1'b0;
        end

        SHIFT: begin
            shift = 1'b1;
            enable = 1'b1;
            busy = 1'b1;
            cs = 1'b0;
        end

        DONE: begin
            busy = 1'b0;
            cs = 1'b1;
        end
    endcase
end

endmodule