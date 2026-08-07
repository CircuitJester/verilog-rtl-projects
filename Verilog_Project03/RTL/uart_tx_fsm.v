module uart_tx_fsm(
    input clk,
    input rst,
    input start,
    input [7:0] data_in,

    output reg tx,
    output reg busy
);
parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;

reg [1:0] state;
reg [2:0] bit_count;
reg [7:0] shift_reg;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        state <= IDLE;
        tx <= 1'b1;
        busy <= 1'b0;
        bit_count <= 0;
    end

    else
    begin
        case(state)

            IDLE:
            begin
                tx <= 1'b1;
                busy <= 1'b0;

                if(start)
                begin
                    shift_reg <= data_in;
                    state <= START;
                    busy <= 1'b1;
                end
            end

            START:
            begin
                tx <= 1'b0;
                bit_count <= 0;
                state <= DATA;
            end

            DATA:
            begin
                tx <= shift_reg[0];
                shift_reg <= shift_reg >> 1;

                if(bit_count == 7)
                    state <= STOP;
                else
                    bit_count <= bit_count + 1;
            end

            STOP:
            begin
                tx <= 1'b1;
                state <= IDLE;
                busy <= 1'b0;
            end

        endcase
    end
end
endmodule