`timescale 1ns/1ps

module non_blocking_cache #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter INDEX_WIDTH = 2,
    parameter TAG_WIDTH = ADDR_WIDTH - INDEX_WIDTH - 2,
    parameter NUM_LINES = (1 << INDEX_WIDTH)
)(
    input  wire clk,
    input  wire rst,

    // CPU request interface
    input  wire req_valid,
    output wire req_ready,
    input  wire req_write,
    input  wire [ADDR_WIDTH-1:0] req_addr,
    input  wire [DATA_WIDTH-1:0] req_wdata,

    // CPU response interface
    output reg resp_valid,
    output reg resp_hit,
    output reg [DATA_WIDTH-1:0] resp_rdata,

    // Memory interface
    output reg mem_read,
    output reg [ADDR_WIDTH-1:0] mem_addr,
    input  wire [DATA_WIDTH-1:0] mem_rdata,
    input  wire mem_ready,

    // MSHR debug interface
    output wire miss_pending,
    output wire [ADDR_WIDTH-1:0] miss_addr_debug,
    output wire miss_write_debug
);

    reg [TAG_WIDTH-1:0]  tag_array [0:NUM_LINES-1];
    reg [DATA_WIDTH-1:0] data_array [0:NUM_LINES-1];
    reg valid_array [0:NUM_LINES-1];

    reg mshr_valid;
    reg mshr_write;
    reg [ADDR_WIDTH-1:0] mshr_addr;
    reg [DATA_WIDTH-1:0] mshr_wdata;

    wire [INDEX_WIDTH-1:0] req_index;
    wire [TAG_WIDTH-1:0] req_tag;

    assign req_index = req_addr[INDEX_WIDTH+1:2];
    assign req_tag = req_addr[ADDR_WIDTH-1:INDEX_WIDTH+2];

    wire [INDEX_WIDTH-1:0] mshr_index;
    wire [TAG_WIDTH-1:0]   mshr_tag;

    assign mshr_index = mshr_addr[INDEX_WIDTH+1:2];
    assign mshr_tag = mshr_addr[ADDR_WIDTH-1:INDEX_WIDTH+2];

    wire cache_hit;

    assign cache_hit =
        valid_array[req_index] &&
        (tag_array[req_index] == req_tag);


    assign req_ready =
        !rst &&
        (
            !mshr_valid ||
            cache_hit
        );

    assign miss_pending = mshr_valid;
    assign miss_addr_debug = mshr_addr;
    assign miss_write_debug = mshr_write;

    integer i;

    always @(posedge clk) begin

        if (rst) begin

            resp_valid <= 1'b0;
            resp_hit <= 1'b0;
            resp_rdata <= {DATA_WIDTH{1'b0}};

            mem_read <= 1'b0;
            mem_addr <= {ADDR_WIDTH{1'b0}};

            mshr_valid <= 1'b0;
            mshr_write <= 1'b0;
            mshr_addr <= {ADDR_WIDTH{1'b0}};
            mshr_wdata <= {DATA_WIDTH{1'b0}};

            for (i = 0; i < NUM_LINES; i = i + 1) 
            begin

                tag_array[i] <= {TAG_WIDTH{1'b0}};
                data_array[i] <= {DATA_WIDTH{1'b0}};
                valid_array[i] <= 1'b0;
            end

        end
        else begin

            resp_valid <= 1'b0;
            mem_read <= 1'b0;

            if (mshr_valid && mem_ready) 
            begin

                valid_array[mshr_index] <= 1'b1;
                tag_array[mshr_index] <= mshr_tag;

                if (mshr_write) begin

                    data_array[mshr_index] <= mshr_wdata;
                    resp_rdata <= mshr_wdata;

                end
                else 
                begin

                    data_array[mshr_index] <= mem_rdata;
                    resp_rdata <= mem_rdata;

                end

                // Miss response
                resp_valid <= 1'b1;
                resp_hit   <= 1'b0;

                // Release MSHR
                mshr_valid <= 1'b0;

            end

            else if (req_valid && req_ready) 
            begin

                if (cache_hit) 
                begin

                    resp_valid <= 1'b1;
                    resp_hit <= 1'b1;

                    if (req_write) 
                    begin

                        data_array[req_index] <= req_wdata;
                        resp_rdata <= req_wdata;

                    end
                    else 
                    begin

                        resp_rdata <= data_array[req_index];

                    end

                end

                else 
                begin

                    mshr_valid <= 1'b1;
                    mshr_write <= req_write;
                    mshr_addr <= req_addr;
                    mshr_wdata <= req_wdata;

                    mem_read <= 1'b1;
                    mem_addr <= req_addr;

                end

            end

        end

    end

endmodule
