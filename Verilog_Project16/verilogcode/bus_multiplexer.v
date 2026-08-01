module bus_multiplexer(

input wire [1:0] grant,
input wire [15:0] cpu_addr,
input wire [15:0] dma_addr,
input wire [15:0] eth_addr,
input wire [15:0] gpu_addr,
input wire [7:0] cpu_data,
input wire [7:0] dma_data,
input wire [7:0] eth_data,
input wire [7:0] gpu_data,

output reg [15:0] addr_out,
output reg [7:0] data_out
);

always @(*)

begin

    case(grant)

        2'b00:
        begin

            addr_out = cpu_addr;
            data_out = cpu_data;

        end

        2'b01:
        begin

            addr_out = dma_addr;
            data_out = dma_data;

        end

        2'b10:
        begin

            addr_out = eth_addr;
            data_out = eth_data;

        end

        2'b11:
        begin

            addr_out = gpu_addr;
            data_out = gpu_data;

        end

        default:
        begin

            addr_out = 16'h0000;
            data_out = 8'h00;

        end

    endcase

end
endmodule