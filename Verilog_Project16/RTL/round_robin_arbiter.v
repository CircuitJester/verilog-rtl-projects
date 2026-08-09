module round_robin_arbiter(

input wire clk,
input wire rst,

input wire cpu_req,
input wire dma_req,
input wire eth_req,
input wire gpu_req,

output reg [1:0] grant,
output reg valid
);

reg [1:0] pointer;

always @(posedge clk or posedge rst)

begin

    if(rst)

    begin

        pointer <= 2'd0;
        grant <= 2'd0;
        valid <= 1'b0;

    end
    else

    begin

        valid <= 1'b0;

        case(pointer)

        // CPU First
        2'd0:
        begin

            if(cpu_req)

            begin

                grant <= 2'd0;
                valid <= 1'b1;
                pointer <= 2'd1;

            end

            else if(dma_req)
            begin

                grant <= 2'd1;
                valid <= 1'b1;
                pointer <= 2'd2;

            end
            else if(eth_req)
            begin

                grant <= 2'd2;
                valid <= 1'b1;
                pointer <= 2'd3;

            end

            else if(gpu_req)

            begin
                grant <= 2'd3;
                valid <= 1'b1;
                pointer <= 2'd0;

            end

        end

        // DMA First
        2'd1:
        begin

            if(dma_req)

            begin

                grant <= 2'd1;
                valid <= 1'b1;
                pointer <= 2'd2;

            end
            else if(eth_req)

            begin

                grant <= 2'd2;
                valid <= 1'b1;
                pointer <= 2'd3;

            end

            else if(gpu_req)
            begin

                grant <= 2'd3;
                valid <= 1'b1;
                pointer <= 2'd0;

            end

            else if(cpu_req)

            begin

                grant <= 2'd0;
                valid <= 1'b1;
                pointer <= 2'd1;
            end

        end

        // Ethernet First
        2'd2:
        begin

            if(eth_req)

            begin
                grant <= 2'd2;
                valid <= 1'b1;
                pointer <= 2'd3;

            end

            else if(gpu_req)

            begin

                grant <= 2'd3;
                valid <= 1'b1;
                pointer <= 2'd0;

            end

            else if(cpu_req)

            begin
                grant <= 2'd0;
                valid <= 1'b1;
                pointer <= 2'd1;

            end

            else if(dma_req)

            begin
                grant <= 2'd1;
                valid <= 1'b1;
                pointer <= 2'd2;

            end

        end

        // GPU First
        2'd3:
        begin

            if(gpu_req)

            begin

                grant <= 2'd3;
                valid <= 1'b1;
                pointer <= 2'd0;

            end
            else if(cpu_req)

            begin

                grant <= 2'd0;
                valid <= 1'b1;
                pointer <= 2'd1;

            end

            else if(dma_req)
            begin

                grant <= 2'd1;
                valid <= 1'b1;
                pointer <= 2'd2;

            end

            else if(eth_req)

            begin

                grant <= 2'd2;
                valid <= 1'b1;
                pointer <= 2'd3;

            end

        end

        endcase

    end
end
endmodule