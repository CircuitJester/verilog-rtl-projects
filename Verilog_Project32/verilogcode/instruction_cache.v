module instruction_cache #(
    parameter CACHE_LINES = 8
    
) (
    input  wire clk,
    input  wire rst,

    input  wire cpu_request,
    input  wire [31:0] cpu_address,

    output reg cpu_hit,
    output reg [31:0] cpu_instruction,

    output reg memory_request,
    output reg [31:0] memory_address,
    input  wire [31:0] memory_data,
    input  wire memory_ready
);

    reg [31:0] instruction_data [0:CACHE_LINES-1];
    reg [26:0] address_tag [0:CACHE_LINES-1];
    reg valid_entry [0:CACHE_LINES-1];

    reg refill_pending;
    reg [31:0] refill_address;
    reg [2:0] refill_index;
    reg [26:0] refill_tag;

    integer entry;

    wire [2:0] requested_index;
    wire [26:0] requested_tag;

    assign requested_index = cpu_address[4:2];
    assign requested_tag = cpu_address[31:5];

    always @(*) 
    begin

        cpu_hit = 1'b0;
        cpu_instruction = 32'b0;

        memory_request = 1'b0;
        memory_address = 32'b0;

        if (refill_pending) 
        begin

            memory_request = 1'b1;
            memory_address = refill_address;
        end

        else if (cpu_request) 
        begin

            if (valid_entry[requested_index] &&
                address_tag[requested_index] == requested_tag) 
            
            begin

                cpu_hit = 1'b1;
                cpu_instruction = instruction_data[requested_index];
            end

            else 
            begin
                memory_request = 1'b1;
                memory_address = cpu_address;

            end
        end
    end

    always @(posedge clk) 
    begin
        if (rst) begin
            refill_pending <= 1'b0;
            refill_address <= 32'b0;
            refill_index <= 3'b0;
            refill_tag <= 27'b0;

            for (entry = 0; entry < CACHE_LINES; entry = entry + 1) 
            
            begin
                instruction_data[entry] <= 32'b0;
                address_tag[entry] <= 27'b0;
                valid_entry[entry] <= 1'b0;
            end
        end

        else 
        begin

            if (cpu_request &&
                !refill_pending &&
                (!valid_entry[requested_index] ||
                 address_tag[requested_index] != requested_tag)) 

            begin

                refill_pending <= 1'b1;
                refill_address <= cpu_address;
                refill_index <= requested_index;
                refill_tag <= requested_tag;
            end

            if (refill_pending && memory_ready) 
            begin

                instruction_data[refill_index] <= memory_data;
                address_tag[refill_index] <= refill_tag;
                valid_entry[refill_index] <= 1'b1;

                refill_pending <= 1'b0;

            end
        end
    end

endmodule