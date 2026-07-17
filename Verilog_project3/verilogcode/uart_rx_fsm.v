module uart_rx_fsm(
    input clk,
    input rst,
    input rx,

    output reg [7:0] data_out,
    output reg done
);
parameter IDLE  = 3'b000;
parameter START = 3'b001;
parameter DATA  = 3'b010;
parameter STOP  = 3'b011;
parameter DONE  = 3'b100;

reg [2:0] state;
reg [2:0] bit_count;
reg [7:0] shift_reg;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        state <= IDLE;
        bit_count <= 0;
        done <= 0;
    end

    else
    begin
        case(state)

            IDLE:
            begin
                done <= 0;

                if(rx == 0)
                    state <= START;
            end

            START:
            begin
                bit_count <= 0;
                state <= DATA;
            end

            DATA:
            begin
                shift_reg[bit_count] <= rx;

                if(bit_count == 7)
                    state <= STOP;
                else
                    bit_count <= bit_count + 1;
            end

            STOP:
            begin
                if(rx == 1)
                begin
                    data_out <= shift_reg;
                    state <= DONE;
                end
                else
                    state <= IDLE;
            end

            DONE:
            begin
                done <= 1;
                state <= IDLE;
            end

        endcase
    end
end
endmodule