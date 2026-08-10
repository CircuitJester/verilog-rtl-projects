module interrupt_controller_fsm
(
    input wire clk,
    input wire rst,
    input wire valid,
    input wire cpu_ack,

    output reg cpu_interrupt,
    output reg clear_interrupt,
    output reg busy
);

// State Encoding
localparam IDLE             = 2'd0;
localparam ASSERT_INTERRUPT = 2'd1;
localparam WAIT_ACK         = 2'd2;
localparam CLEAR_INTERRUPT  = 2'd3;

reg [1:0] state;

// FSM
always @(posedge clk or posedge rst)
begin

    if(rst)

    begin

        state <= IDLE;

        cpu_interrupt <= 0;
        clear_interrupt <= 0;
        busy <= 0;

    end

    else

    begin

        clear_interrupt <= 0;

        case(state)

        IDLE:
        begin

            cpu_interrupt <= 0;
            busy <= 0;

            if(valid)
                state <= ASSERT_INTERRUPT;

        end

        ASSERT_INTERRUPT:
        begin

            cpu_interrupt <= 1;
            busy <= 1;
            state <= WAIT_ACK;

        end

        WAIT_ACK:
        begin

            cpu_interrupt <= 1;
            busy <= 1;

            if(cpu_ack)
                state <= CLEAR_INTERRUPT;

        end

        CLEAR_INTERRUPT:
        begin

            cpu_interrupt <= 0;
            busy <= 0;
            clear_interrupt <= 1;
            state <= IDLE;

        end

        default:
            state <= IDLE;

        endcase

    end
end
endmodule