module dma_controller_fsm
(
    input wire clk,
    input wire rst,

    input wire start,
    input wire transfer_done,

    output reg load,
    output reg increment,
    output reg decrement,
    output reg dma_busy,
    output reg dma_done
);


// State Encoding
localparam IDLE   = 3'd0;
localparam LOAD   = 3'd1;
localparam READ   = 3'd2;
localparam WRITE  = 3'd3;
localparam UPDATE = 3'd4;
localparam DONE   = 3'd5;

reg [2:0] state;

// FSM
always @(posedge clk or posedge rst)
begin

    if(rst)

    begin

        state <= IDLE;

        load <= 0;
        increment <= 0;
        decrement <= 0;

        dma_busy <= 0;
        dma_done <= 0;

    end

    else

    begin

        // Default Outputs
        load <= 0;
        increment <= 0;
        decrement <= 0;

        dma_done <= 0;

        case(state)


        // IDLE

        IDLE:

        begin

            dma_busy <= 0;

            if(start)

                state <= LOAD;

        end

        // LOAD

        LOAD:

        begin

            load <= 1;
            dma_busy <= 1;
            state <= READ;

        end

        // READ

        READ:

        begin
            state <= WRITE;

        end

        // WRITE

        WRITE:

        begin
            state <= UPDATE;

        end

        // UPDATE

        UPDATE:
        begin

            increment <= 1;

            decrement <= 1;

            if(transfer_done)
                state <= DONE;

            else

                state <= READ;
        end

        // DONE

        DONE:
        begin

            dma_busy <= 0;
            dma_done <= 1;
            state <= IDLE;

        end

        default:

            state <= IDLE;

        endcase
    end

end
endmodule