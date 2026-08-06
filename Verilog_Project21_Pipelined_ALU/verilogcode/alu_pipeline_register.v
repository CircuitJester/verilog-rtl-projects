module alu_pipeline_register
#
(
    parameter DATA_WIDTH = 32
)
(
    input wire clk,
    input wire rst,

    input wire [DATA_WIDTH-1:0] result_in,
    input wire zero_in,
    input wire carry_in,
    input wire negative_in,
    input wire overflow_in,

    output reg [DATA_WIDTH-1:0] result_out,
    output reg zero_out,
    output reg carry_out,
    output reg negative_out,
    output reg overflow_out
);

// Pipeline Register
always @(posedge clk)
begin

    if(rst)
    begin

        result_out <= 0;

        zero_out <= 0;
        carry_out <= 0;
        negative_out <= 0;
        overflow_out <= 0;

    end

    else
    begin

        result_out <= result_in;

        zero_out <= zero_in;
        carry_out <= carry_in;
        negative_out <= negative_in;
        overflow_out <= overflow_in;

    end

end

endmodule