module vending_machine_fsm (
    input clk,
    input rst,
    input coin_5,
    input coin_10,
    output reg dispense
);

parameter S0  = 2'b00;
parameter S5  = 2'b01;
parameter S10 = 2'b10;

reg [1:0] state;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= S0;
    end else begin
        case (state)
            S0: begin
                if (coin_10)
                    state <= S10;
                else if (coin_5)
                    state <= S5;
            end

            S5: begin
                if (coin_5 || coin_10)
                    state <= S10;
            end

            S10:
                state <= S0;

            default:
                state <= S0;
        endcase
    end
end

always @(*) begin
    dispense = (state == S10);
end

endmodule