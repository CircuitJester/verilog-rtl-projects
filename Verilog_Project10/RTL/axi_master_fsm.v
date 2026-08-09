module axi_master_fsm (
    input  wire clk,
    input  wire rst,
    input  wire start_write,
    input  wire start_read,
    input  wire aw_done,
    input  wire w_done,
    input  wire b_done,
    input  wire ar_done,
    input  wire r_done,

    output reg aw_start,
    output reg w_start,
    output reg ar_start,
    output reg done
);

parameter S_IDLE     = 3'd0;
parameter S_WADDR    = 3'd1;
parameter S_WDATA    = 3'd2;
parameter S_WRESP    = 3'd3;
parameter S_RADDR    = 3'd4;
parameter S_RDATA    = 3'd5;
parameter S_COMPLETE = 3'd6;

reg [2:0] state;

always @(posedge clk or posedge rst) 

begin

    if (rst) begin
        state    <= S_IDLE;
        aw_start <= 1'b0;
        w_start  <= 1'b0;
        ar_start <= 1'b0;
        done     <= 1'b0;
    end 

    else 

    begin
        aw_start <= 1'b0;
        w_start  <= 1'b0;
        ar_start <= 1'b0;
        done     <= 1'b0;

        case (state)
            S_IDLE: begin
                if (start_write)
                    state <= S_WADDR;
                else if (start_read)
                    state <= S_RADDR;
            end

            S_WADDR: begin
                aw_start <= 1'b1;

                if (aw_done)
                    state <= S_WDATA;
            end

            S_WDATA: begin
                w_start <= 1'b1;

                if (w_done)
                    state <= S_WRESP;
            end

            S_WRESP: begin
                if (b_done)
                    state <= S_COMPLETE;
            end

            S_RADDR: begin
                ar_start <= 1'b1;

                if (ar_done)
                    state <= S_RDATA;
            end

            S_RDATA: begin
                if (r_done)
                    state <= S_COMPLETE;
            end

            S_COMPLETE: begin
                done  <= 1'b1;
                state <= S_IDLE;
            end

            default:
                state <= S_IDLE;

        endcase

    end
    
end

endmodule