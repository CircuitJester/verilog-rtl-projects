module axi_register_file #

(

parameter DATA_WIDTH = 32,
parameter ADDR_WIDTH = 32

)
(

input wire clk,
input wire rst,

// Write Interface

input wire [ADDR_WIDTH-1:0] write_address,
input wire [DATA_WIDTH-1:0] write_data,
input wire write_enable,

// Read Interface

input wire [ADDR_WIDTH-1:0] read_address,

output reg [DATA_WIDTH-1:0] read_data

);

// Internal Registers

reg [DATA_WIDTH-1:0] reg0;
reg [DATA_WIDTH-1:0] reg1;
reg [DATA_WIDTH-1:0] reg2;
reg [DATA_WIDTH-1:0] reg3;

// Write Logic

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin

        reg0 <= 0;
        reg1 <= 0;
        reg2 <= 0;
        reg3 <= 0;

    end

    else
    begin

        if(write_enable)
        begin

            case(write_address)

                32'h00000000:
                    reg0 <= write_data;

                32'h00000004:
                    reg1 <= write_data;

                32'h00000008:
                    reg2 <= write_data;

                32'h0000000C:
                    reg3 <= write_data;

            endcase
        end
    end
end

// Read Logic

always @(*)
begin

    case(read_address)

        32'h00000000:
            read_data = reg0;

        32'h00000004:
            read_data = reg1;

        32'h00000008:
            read_data = reg2;

        32'h0000000C:
            read_data = reg3;

        default:
            read_data = 0;

    endcase
end
endmodule