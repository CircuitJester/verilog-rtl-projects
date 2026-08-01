module priority_encoder(

input wire cpu_req,
input wire dma_req,
input wire eth_req,
input wire gpu_req,

output reg [1:0] grant,
output reg valid
);

always @(*)

begin

    valid = 1'b1;
    if(cpu_req)

        grant = 2'b00;

    else if(dma_req)

        grant = 2'b01;

    else if(eth_req)

        grant = 2'b10;

    else if(gpu_req)

        grant = 2'b11;

    else

    begin

        grant = 2'b00;
        valid = 1'b0;

    end

end
endmodule