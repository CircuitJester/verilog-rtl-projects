module axi_slave_controller (
    input wire clk,
    input wire rst,
    input wire start_write,
    input wire start_read,
    input wire write_complete,
    input wire response_done,
    input wire read_complete,

    output reg write_enable,
    output reg read_enable,
    output reg send_response,
    output reg busy
    
);

parameter IDLE       = 3'd0;
parameter WRITE_ADDR = 3'd1;
parameter WRITE_DATA = 3'd2;
parameter WRITE_RESP = 3'd3;
parameter READ_ADDR  = 3'd4;
parameter READ_DATA  = 3'd5;

reg [2:0] state;

always @(posedge clk or posedge rst) 

begin

    if (rst) begin
        state <= IDLE;
        write_enable <= 0;
        read_enable <= 0;
        send_response <= 0;
        busy <= 0;
    end else begin
        write_enable <= 0;
        read_enable <= 0;
        send_response <= 0;

        case (state)
            IDLE: begin
                busy <= 0;

                if (start_write)
                    state <= WRITE_ADDR;
                else if (start_read)
                    state <= READ_ADDR;
            end

            WRITE_ADDR: begin
                busy <= 1;
                state <= WRITE_DATA;
            end

            WRITE_DATA: begin
                write_enable <= 1;

                if (write_complete)
                    state <= WRITE_RESP;
            end

            WRITE_RESP: begin
                send_response <= 1;

                if (response_done)
                    state <= IDLE;
            end

            READ_ADDR: begin
                busy <= 1;
                state <= READ_DATA;
            end

            READ_DATA: begin
                read_enable <= 1;

                if (read_complete)
                    state <= IDLE;
            end

            default:
                state <= IDLE;
        endcase

    end

end

endmodule