module pwm_generator(

    input clk,
    input rst,
    input [7:0] duty,

    output reg pwm
);

reg [7:0] counter;

always @(posedge clk or posedge rst)
begin

    if(rst)
        counter <= 0;

    else
        counter <= counter + 1;

end

always @(*)
begin

    if(counter < duty)
        pwm = 1'b1;
    else
        pwm = 1'b0;

end
endmodule