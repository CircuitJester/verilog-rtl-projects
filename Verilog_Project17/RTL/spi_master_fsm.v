module spi_master_fsm(

input wire clk,
input wire rst,
input wire start,
input wire shift_done,

output reg load,
output reg shift_enable,
output reg cs_enable,
output reg done
);

reg [1:0] state;

parameter IDLE      = 2'd0;
parameter LOAD      = 2'd1;
parameter TRANSFER  = 2'd2;
parameter COMPLETE  = 2'd3;

always @(posedge clk or posedge rst)

begin

    if(rst)

    begin

        state <= IDLE;

        load <= 0;
        shift_enable <= 0;
        cs_enable <= 0;
        done <= 0;

    end
    else

    begin

        load <= 0;
        shift_enable <= 0;
        done <= 0;

        case(state)

        IDLE:
        begin
            cs_enable <= 0;
            if(start)
                state <= LOAD;

        end

        LOAD:
        begin
            load <= 1;
            cs_enable <= 1;
            state <= TRANSFER;

        end

        TRANSFER:
        begin
            shift_enable <= 1;
            cs_enable <= 1;
            if(shift_done)
                state <= COMPLETE;

        end

        COMPLETE:
        begin
            done <= 1;
            cs_enable <= 0;
            state <= IDLE;

        end

        endcase

    end
end
endmodule