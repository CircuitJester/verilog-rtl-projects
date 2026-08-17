module data_cache #(
    parameter CACHE_LINES = 8
)(
    input wire clk,
    input wire rst,

    input wire cpu_read,
    input wire cpu_write,
    input wire [31:0] cpu_address,
    input wire [31:0] cpu_write_data,

    output reg [31:0] cpu_read_data,
    output reg cpu_ready,

    output reg memory_read,
    output reg memory_write,
    output reg [31:0] memory_address,
    output reg [31:0] memory_write_data,

    input wire [31:0] memory_read_data,
    input wire memory_ready
);

    reg [31:0] cache_data [0:CACHE_LINES-1];
    reg [26:0] cache_tag [0:CACHE_LINES-1];

    reg valid_bit [0:CACHE_LINES-1];
    reg dirty_bit [0:CACHE_LINES-1];


    wire [2:0] current_index;
    wire [26:0] current_tag;

    assign current_index = cpu_address[4:2];
    assign current_tag = cpu_address[31:5];

    reg [31:0] saved_address;
    reg [31:0] saved_write_data;

    reg saved_read;
    reg saved_write;

    reg [2:0] saved_index;
    reg [26:0] saved_tag;


    localparam STATE_IDLE = 3'd0;
    localparam STATE_LOOKUP = 3'd1;
    localparam STATE_WRITEBACK = 3'd2;
    localparam STATE_REFILL = 3'd3;
    localparam STATE_COMPLETE = 3'd4;

    reg [2:0] state;

    integer entry;

    always @(posedge clk) 
    begin

        if (rst) begin

            cpu_read_data <= 32'b0;
            cpu_ready <= 1'b0;

            memory_read <= 1'b0;
            memory_write <= 1'b0;
            memory_address <= 32'b0;
            memory_write_data <= 32'b0;

            saved_address <= 32'b0;
            saved_write_data <= 32'b0;

            saved_read <= 1'b0;
            saved_write <= 1'b0;

            saved_index <= 3'b0;
            saved_tag <= 27'b0;

            state <= STATE_IDLE;

            for (entry = 0; entry < CACHE_LINES; entry = entry + 1) 
            begin
                cache_data[entry] <= 32'b0;
                cache_tag[entry] <= 27'b0;
                valid_bit[entry] <= 1'b0;
                dirty_bit[entry] <= 1'b0;
                
            end

        end

        else 
        begin

            cpu_ready <= 1'b0;
            memory_read <= 1'b0;
            memory_write <= 1'b0;

            case (state)

                STATE_IDLE: 
                begin

                    if (cpu_read || cpu_write) 
                    begin

                        saved_address <= cpu_address;
                        saved_write_data <= cpu_write_data;

                        saved_read <= cpu_read;
                        saved_write <= cpu_write;

                        saved_index <= current_index;
                        saved_tag <= current_tag;

                        state <= STATE_LOOKUP;
                    end

                end

               
                STATE_LOOKUP: 
                begin

                    
                    if (valid_bit[saved_index] &&
                        cache_tag[saved_index] == saved_tag)

                        begin

                        if (saved_read) 
                        begin
                            cpu_read_data <= cache_data[saved_index];
                        end


                        if (saved_write) begin
                            cache_data[saved_index] <= saved_write_data;

                            dirty_bit[saved_index] <= 1'b1;
                        end

                        state <= STATE_COMPLETE;
                    end

                    else 
                    begin

                        if (valid_bit[saved_index] &&
                            dirty_bit[saved_index]) begin

                            state <= STATE_WRITEBACK;
                        end

                        else 
                        begin

                            state <= STATE_REFILL;
                        end
                    end

                end


                STATE_WRITEBACK: 
                begin

                    memory_write <= 1'b1;

                    memory_address <= {
                        cache_tag[saved_index],
                        saved_index,
                        2'b00
                    };

                    memory_write_data <= cache_data[saved_index];

                    if (memory_ready) begin

                        dirty_bit[saved_index] <= 1'b0;

                        state <= STATE_REFILL;
                    end

                end


                STATE_REFILL: 
                begin

                    memory_read <= 1'b1;

                    memory_address <= saved_address;

                    if (memory_ready) begin

                        cache_data[saved_index] <= memory_read_data;
                        cache_tag[saved_index] <= saved_tag;

                        valid_bit[saved_index] <= 1'b1;
                        dirty_bit[saved_index] <= 1'b0;

                        
                        if (saved_write) 
                        begin

                            cache_data[saved_index] <= saved_write_data;
                            dirty_bit[saved_index] <= 1'b1;

                        end

                        
                        if (saved_read) 
                        begin
                            cpu_read_data <= memory_read_data;
                        end

                        state <= STATE_COMPLETE;
                    end

                end

                
                STATE_COMPLETE: 
                begin

                    cpu_ready <= 1'b1;

                    state <= STATE_IDLE;

                end

                default: 
                begin
                    state <= STATE_IDLE;

                end

            endcase
        end
    end

endmodule