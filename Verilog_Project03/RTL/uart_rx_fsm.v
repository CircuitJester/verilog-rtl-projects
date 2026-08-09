module uart_rx_fsm (
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
    if (rst) begin
        state     <= IDLE;
        bit_count <= 3'd0;
        done      <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                done <= 1'b0;

                if (!rx)
                    state <= START;
            end

            START: begin
                bit_count <= 3'd0;
                state <= DATA;
            end

            DATA: begin
                shift_reg[bit_count] <= rx;

                if (bit_count == 3'd7)
                    state <= STOP;
                else
                    bit_count <= bit_count + 1'b1;
            end

            STOP: begin
                if (rx) begin
                    data_out <= shift_reg;
                    state <= DONE;
                end else begin
                    state <= IDLE;
                end
            end

            DONE: begin
                done <= 1'b1;
                state <= IDLE;
            end

            default:
                state <= IDLE;
        endcase
    end
end

endmodule