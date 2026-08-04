module register_file
#(
    parameter DATA_WIDTH = 32,
    parameter NUM_REGS   = 4
)
(
    input wire clk,
    input wire rst,
    input wire write_enable,
    input wire [1:0] write_addr,
    input wire [DATA_WIDTH-1:0] write_data,
    input wire [1:0] read_addr,

    output reg [DATA_WIDTH-1:0] read_data
);

// Register Bank
reg [DATA_WIDTH-1:0] reg_bank [0:NUM_REGS-1];

integer i;

// Write Logic
always @(posedge clk or posedge rst)
begin

    if(rst)
    begin

        for(i = 0; i < NUM_REGS; i = i + 1)
            reg_bank[i] <= 0;

    end

    else

    begin

        if(write_enable)
            reg_bank[write_addr] <= write_data;

    end
end

// Read Logic
always @(*)
begin

    read_data = reg_bank[read_addr];

end
endmodule