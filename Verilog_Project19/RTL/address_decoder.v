module address_decoder
(
    input wire [31:0] address,

    output reg [1:0] reg_select,
    output reg valid
);

// Address Decode Logic
always @(*)
begin

    valid = 1'b1;
    case(address)

        32'h00000000:
            reg_select = 2'd0;

        32'h00000004:
            reg_select = 2'd1;

        32'h00000008:
            reg_select = 2'd2;

        32'h0000000C:
            reg_select = 2'd3;

        default:
        begin

            reg_select = 2'd0;
            valid = 1'b0;

        end

    endcase
end
endmodule