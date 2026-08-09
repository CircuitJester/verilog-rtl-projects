module axi_slave_write_response (
    input wire clk,
    input wire rst,
    input wire write_complete,
    input wire bready,

    output reg [1:0] bresp,
    output reg bvalid
);

always @(posedge clk or posedge rst) 

begin

    if (rst) begin
        bresp <= 2'b00;
        bvalid <= 1'b0;
    end else if (write_complete) 
    
    begin
        
        bresp <= 2'b00;
        bvalid <= 1'b1;
    end else if (bready) begin
        bvalid <= 1'b0;
    end
end

endmodule