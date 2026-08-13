module hazard_controller_fsm
(
    input wire clk,
    input wire rst,
    input wire stall,

    output reg pipeline_hold,
    output reg busy
);

// State Encoding
localparam IDLE   = 2'b00;
localparam WAIT   = 2'b01;
localparam RESUME = 2'b10;

reg [1:0] state;
reg [1:0] next_state;

// State Register
always @(posedge clk or posedge rst)
begin
    if (rst)
        state <= IDLE;
    else
        state <= next_state;
end

// Next-State Logic
always @(*)
begin

    case(state)

        IDLE:
        begin
            if(stall)
                next_state = WAIT;
            else
                next_state = IDLE;
        end

        WAIT:
        begin
            if(stall)
                next_state = WAIT;
            else
                next_state = RESUME;
        end

        RESUME:
        begin
            next_state = IDLE;
        end

        default:
            next_state = IDLE;

    endcase

end

// Output Logic
always @(*)
begin

    pipeline_hold = 0;
    busy = 0;

    case(state)

        IDLE:
        begin
            pipeline_hold = 0;
            busy = 0;
        end

        WAIT:
        begin
            pipeline_hold = 1;
            busy = 1;
        end

        RESUME:
        begin
            pipeline_hold = 0;
            busy = 1;
        end

    endcase
end

endmodule