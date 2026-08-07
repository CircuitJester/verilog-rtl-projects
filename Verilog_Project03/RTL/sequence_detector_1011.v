module sequence_detector_1011(
    input clk,
    input rst,
    input din,
    output reg detected
);

parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;

reg [2:0] state;

always @(posedge clk or posedge rst)
begin
    if(rst)
        state <= S0;

    else
    begin
        case(state)

            S0:
                if(din)
                    state <= S1;
                else
                    state <= S0;

            S1:
                if(din)
                    state <= S1;
                else
                    state <= S2;

            S2:
                if(din)
                    state <= S3;
                else
                    state <= S0;

            S3:
                if(din)
                    state <= S4;
                else
                    state <= S2;

            S4:
                if(din)
                    state <= S1;
                else
                    state <= S2;

            default:
                state <= S0;

        endcase
    end
end

always @(*)
begin
    if(state == S4)
        detected = 1'b1;
    else
        detected = 1'b0;
end
endmodule