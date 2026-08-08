module i2c_slave_fsm(

    input  wire scl,
    input  wire rst,
    input  wire start_detected,
    input  wire address_match,
    input  wire byte_done,
    input  wire stop_detected,

    output reg shift_enable,
    output reg ack_enable,
    output reg busy

);

    // State Encoding

    localparam IDLE        = 3'd0;
    localparam ADDRESS     = 3'd1;
    localparam ACK_ADDRESS = 3'd2;
    localparam RECEIVE     = 3'd3;
    localparam ACK_DATA    = 3'd4;
    localparam STOP        = 3'd5;

    reg [2:0] state;

    // State Register
    
    always @(posedge scl or posedge rst)
    begin

        if(rst)
        begin
            state <= IDLE;
        end

        else
        begin

            case(state)

                IDLE:
                begin
                    if(start_detected)
                        state <= ADDRESS;
                end

                ADDRESS:
                begin
                    if(byte_done)
                    begin
                        if(address_match)
                            state <= ACK_ADDRESS;
                        else
                            state <= IDLE;
                    end
                end

                ACK_ADDRESS:
                begin
                    state <= RECEIVE;
                end

                RECEIVE:
                begin
                    if(byte_done)
                        state <= ACK_DATA;
                end

                ACK_DATA:
                begin
                    if(stop_detected)
                        state <= STOP;
                    else
                        state <= RECEIVE;
                end
               
                STOP:
                begin
                    state <= IDLE;
                end

                default:
                begin
                    state <= IDLE;
                end

            endcase

        end

    end

    // Output Logic

    always @(*)
    begin

        shift_enable = 1'b0;
        ack_enable = 1'b0;
        busy = 1'b0;

        case(state)

            IDLE:
            begin
                busy = 1'b0;
            end

            ADDRESS:
            begin
                shift_enable = 1'b1;
                busy = 1'b1;
            end

            ACK_ADDRESS:
            begin
                ack_enable = 1'b1;
                busy = 1'b1;
            end

            RECEIVE:
            begin
                shift_enable = 1'b1;
                busy = 1'b1;
            end

            ACK_DATA:
            begin
                ack_enable = 1'b1;
                busy = 1'b1;
            end

            STOP:
            begin
                busy = 1'b0;
            end

            default:
            begin
                shift_enable = 1'b0;
                ack_enable = 1'b0;
                busy = 1'b0;
            end

        endcase
    end
endmodule