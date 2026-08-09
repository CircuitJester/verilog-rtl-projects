module traffic_light_fsm (
    input clk,
    input rst,

    output reg north_red,
    output reg north_yellow,
    output reg north_green,

    output reg south_red,
    output reg south_yellow,
    output reg south_green
);

parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;

reg [1:0] state;

always @(posedge clk or posedge rst)

 begin
    if (rst) begin
        state <= S0;
    end else begin
        case (state)
            S0: state <= S1;
            S1: state <= S2;
            S2: state <= S3;
            S3: state <= S0;
            default: state <= S0;
        endcase
    end
end

always @(*) begin
    north_red    = 1'b0;
    north_yellow = 1'b0;
    north_green  = 1'b0;

    south_red    = 1'b0;
    south_yellow = 1'b0;
    south_green  = 1'b0;

    case (state)
        S0: begin
            north_green = 1'b1;
            south_red   = 1'b1;
        end

        S1: begin
            north_yellow = 1'b1;
            south_red    = 1'b1;
        end

        S2: begin
            north_red   = 1'b1;
            south_green = 1'b1;
        end

        S3: begin
            north_red    = 1'b1;
            south_yellow = 1'b1;
        end
    endcase
end

endmodule