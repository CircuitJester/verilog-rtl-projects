module i2c_shift_register #(
    parameter DATA_WIDTH = 8
)(
    input scl,
    input rst,
    input load,
    input shift,
    input [DATA_WIDTH-1:0] data_in,

    output sda,
    output reg [DATA_WIDTH-1:0] shift_reg
);

assign sda = shift_reg[DATA_WIDTH-1];

always @(posedge scl or posedge rst)
begin

    if(rst)
    begin

        shift_reg <= 0;

    end

    else if(load)
    begin

        shift_reg <= data_in;

    end

    else if(shift)
    begin

        shift_reg <= {shift_reg[DATA_WIDTH-2:0],1'b0};

    end
end
endmodule