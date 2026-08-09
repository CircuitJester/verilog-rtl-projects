module i2c_slave_fsm (
    input wire scl,
    input wire rst,
    input wire start_detected,
    input wire address_match,
    input wire byte_done,
    input wire stop_detected,

    output reg shift_enable,
    output reg ack_enable,
    output reg busy
);

localparam IDLE        = 3'd0;
localparam ADDRESS     = 3'd1;
localparam ACK_ADDRESS = 3'd2;
localparam RECEIVE     = 3'd3;
localparam ACK_DATA    = 3'd4;
localparam STOP        = 3'd5;

reg [2:0] state;

always @(posedge scl or posedge rst) 

begin

    if (rst) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE:
                if (start_detected)
                    state <= ADDRESS;

            ADDRESS: begin
                if (byte_done) begin
                    if (address_match)
                        state <= ACK_ADDRESS;
                    else
                        state <= IDLE;
                end
            end

            ACK_ADDRESS:
                state <= RECEIVE;

            RECEIVE:
                if (byte_done)
                    state <= ACK_DATA;

            ACK_DATA:
                if (stop_detected)
                    state <= STOP;
                else
                    state <= RECEIVE;

            STOP:
                state <= IDLE;

            default:
                state <= IDLE;
        endcase
    end
end

always @(*) begin
    shift_enable = 1'b0;
    ack_enable = 1'b0;
    busy = 1'b0;

    case (state)
        ADDRESS: begin
            shift_enable = 1'b1;
            busy = 1'b1;
        end

        ACK_ADDRESS: begin
            ack_enable = 1'b1;
            busy = 1'b1;
        end

        RECEIVE: begin
            shift_enable = 1'b1;
            busy = 1'b1;
        end

        ACK_DATA: begin
            ack_enable = 1'b1;
            busy = 1'b1;
        end

        default: begin
            busy = 1'b0;
        end

    endcase
    
end

endmodule