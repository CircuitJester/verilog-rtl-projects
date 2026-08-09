module can_tx_fsm (
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

localparam IDLE         = 3'b000;
localparam LOAD_FRAME   = 3'b001;
localparam BIT_STUFFING = 3'b010;
localparam CRC_CALC     = 3'b011;
localparam TRANSMIT_ST  = 3'b100;
localparam WAIT_ACK     = 3'b101;
localparam DONE         = 3'b110;

reg [2:0] state;
reg [2:0] next_state;

always @(posedge clk or posedge rst) 

begin
    
    if (rst)
        state <= IDLE;
    else
        state <= next_state;
end

always @(*) 

begin

    next_state = state;

    case (state)
        IDLE:
            if (start)
                next_state = LOAD_FRAME;

        LOAD_FRAME:
            next_state = BIT_STUFFING;

        BIT_STUFFING:
            if (stuffing_done)
                next_state = CRC_CALC;

        CRC_CALC:
            if (crc_done)
                next_state = TRANSMIT_ST;

        TRANSMIT_ST:
            if (tx_done)
                next_state = WAIT_ACK;

        WAIT_ACK:
            if (ack_received)
                next_state = DONE;

        DONE:
            next_state = IDLE;

        default:
            next_state = IDLE;

    endcase

end

always @(*) 

begin

    load_frame = 1'b0;
    start_stuffing = 1'b0;
    start_crc = 1'b0;
    transmit = 1'b0;
    busy = 1'b1;

    case (state)
        IDLE:
            busy = 1'b0;

        LOAD_FRAME:
            load_frame = 1'b1;

        BIT_STUFFING:
            start_stuffing = 1'b1;

        CRC_CALC:
            start_crc = 1'b1;

        TRANSMIT_ST:
            transmit = 1'b1;

        WAIT_ACK:
            busy = 1'b1;

        DONE:
            busy = 1'b0;

        default:
            busy = 1'b0;
    endcase
end

endmodule