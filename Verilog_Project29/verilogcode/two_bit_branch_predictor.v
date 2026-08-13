module two_bit_branch_predictor (
    input  wire clk,
    input  wire rst,
    input  wire update_enable,
    input  wire branch_taken_actual,

    output wire predict_taken
);

reg [1:0] prediction_state;

localparam STRONGLY_NOT_TAKEN = 2'b00;
localparam WEAKLY_NOT_TAKEN = 2'b01;
localparam WEAKLY_TAKEN = 2'b10;
localparam STRONGLY_TAKEN = 2'b11;


assign predict_taken = prediction_state[1];


always @(posedge clk) begin
    if (rst) begin
        prediction_state <= WEAKLY_NOT_TAKEN;
    end
    else if (update_enable) 

    begin

        case (prediction_state)
            STRONGLY_NOT_TAKEN: begin
                if (branch_taken_actual)
                    prediction_state <= WEAKLY_NOT_TAKEN;
            end

            WEAKLY_NOT_TAKEN: begin
                if (branch_taken_actual)
                    prediction_state <= WEAKLY_TAKEN;
                else
                    prediction_state <= STRONGLY_NOT_TAKEN;
            end

            WEAKLY_TAKEN: begin
                if (branch_taken_actual)
                    prediction_state <= STRONGLY_TAKEN;
                else
                    prediction_state <= WEAKLY_NOT_TAKEN;
            end

            STRONGLY_TAKEN: begin
                if (!branch_taken_actual)
                    prediction_state <= WEAKLY_TAKEN;
            end

            default:
                prediction_state <= WEAKLY_NOT_TAKEN;

        endcase
    end

end

endmodule