module can_tx_fsm(

    input wire clk,
    input wire rst,
    input wire start,
    input wire stuffing_done,
    input wire crc_done,
    input wire tx_done,
    input wire ack_received,

    output reg load_frame,
    output reg start_stuffing,
    output reg start_crc,
    output reg transmit,
    output reg busy
);

// State Encoding

parameter IDLE          = 3'b000;
parameter LOAD_FRAME    = 3'b001;
parameter BIT_STUFFING  = 3'b010;
parameter CRC_CALC      = 3'b011;
parameter TRANSMIT_ST   = 3'b100;
parameter WAIT_ACK      = 3'b101;
parameter DONE          = 3'b110;

reg [2:0] state;
reg [2:0] next_state;

// State Register

always @(posedge clk or posedge rst)
begin
    if (rst)
        state <= IDLE;
    else
        state <= next_state;
end

// Next State Logic

always @(*)
begin

    next_state = state;

    case(state)

        IDLE:
        begin
            if(start)
                next_state = LOAD_FRAME;
        end

        LOAD_FRAME:
        begin
            next_state = BIT_STUFFING;
        end

        BIT_STUFFING:
        begin
            if(stuffing_done)
                next_state = CRC_CALC;
        end

        CRC_CALC:
        begin
            if(crc_done)
                next_state = TRANSMIT_ST;
        end

        TRANSMIT_ST:
        begin
            if(tx_done)
                next_state = WAIT_ACK;
        end

        WAIT_ACK:
        begin
            if(ack_received)
                next_state = DONE;
        end

        DONE:
        begin
            next_state = IDLE;
        end

        default:
        begin
            next_state = IDLE;
        end

    endcase
end

// Output Logic

always @(*)
begin

    load_frame      = 1'b0;
    start_stuffing  = 1'b0;
    start_crc       = 1'b0;
    transmit        = 1'b0;
    busy            = 1'b1;

    case(state)

        IDLE:
        begin
            busy = 1'b0;
        end

        LOAD_FRAME:
        begin
            load_frame = 1'b1;
        end

        BIT_STUFFING:
        begin
            start_stuffing = 1'b1;
        end

        CRC_CALC:
        begin
            start_crc = 1'b1;
        end

        TRANSMIT_ST:
        begin
            transmit = 1'b1;
        end

        WAIT_ACK:
        begin
            busy = 1'b1;
        end

        DONE:
        begin
            busy = 1'b0;
        end

        default:
        begin
            busy = 1'b0;
        end

    endcase
end
endmodule