module timer (
    input clk,
    input rst,
    input enable,
    input [7:0] period,

    output reg timeout
);

reg [7:0] counter;

always @(posedge clk or posedge rst) 

begin

    if (rst) begin
        counter <= 8'd0;
        timeout <= 1'b0;
    end else if (enable) 
    
    begin

        if (counter == period) begin
            counter <= 8'd0;
            timeout <= 1'b1;
        end else begin
            counter <= counter + 1'b1;
            timeout <= 1'b0;
        end

    end else begin
        
        timeout <= 1'b0;
    end
end

endmodule