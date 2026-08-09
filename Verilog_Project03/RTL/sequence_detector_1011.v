module sequence_detector_1011 (
    input  clk,
    input  rst,
    input  din,
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
    if (rst) begin
        state <= S0;
    end else begin
        case (state)
            S0:
                state <= din ? S1 : S0;

            S1:
                state <= din ? S1 : S2;

            S2:
                state <= din ? S3 : S0;

            S3:
                state <= din ? S4 : S2;

            S4:
                state <= din ? S1 : S2;

            default:
                state <= S0;
        endcase
    end
end

always @(*) begin
    detected = (state == S4);
end

endmodule