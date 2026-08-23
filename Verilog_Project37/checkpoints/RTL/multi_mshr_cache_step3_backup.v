`timescale 1ns/1ps

module multi_mshr_cache #(
    parameter MSHR_COUNT = 4
)(
    input  wire        clk,
    input  wire        rst,

    // CPU request interface
    input  wire        req_valid,
    output wire        req_ready,
    input  wire [31:0] req_addr,
    input  wire        req_write,
    input  wire [31:0] req_wdata,

    // MSHR allocation information
    output wire        mshr_alloc_valid,
    output wire [1:0]  mshr_alloc_index,

    // Memory request interface
    output reg         mem_req_valid,
    output reg  [1:0]  mem_req_mshr,
    output reg  [31:0] mem_req_addr,
    output reg         mem_req_write,
    output reg  [31:0] mem_req_wdata,

    // Memory completion interface
    input  wire        mem_resp_valid,
    input  wire [1:0]  mem_resp_mshr,
    input  wire [31:0] mem_resp_rdata,

    // Explicit MSHR release
    input  wire        mshr_release_valid,
    input  wire [1:0]  mshr_release_index,

    // Debug
    output wire [MSHR_COUNT-1:0] mshr_valid_debug,
    output wire [31:0] mshr_addr_debug [0:MSHR_COUNT-1],
    output wire [MSHR_COUNT-1:0] mshr_write_debug
);

    reg [MSHR_COUNT-1:0] mshr_valid;

    reg [31:0] mshr_addr [0:MSHR_COUNT-1];
    reg        mshr_write [0:MSHR_COUNT-1];
    reg [31:0] mshr_wdata [0:MSHR_COUNT-1];

    reg [MSHR_COUNT-1:0] mshr_mem_sent;

    reg        alloc_valid_int;
    reg [1:0]  alloc_index_int;

    integer i;


    /*
     * First-free MSHR allocator.
     */
    always @(*) begin

        alloc_valid_int = 1'b0;
        alloc_index_int = 2'd0;

        if (!mshr_valid[0]) begin
            alloc_valid_int = 1'b1;
            alloc_index_int = 2'd0;
        end
        else if (!mshr_valid[1]) begin
            alloc_valid_int = 1'b1;
            alloc_index_int = 2'd1;
        end
        else if (!mshr_valid[2]) begin
            alloc_valid_int = 1'b1;
            alloc_index_int = 2'd2;
        end
        else if (!mshr_valid[3]) begin
            alloc_valid_int = 1'b1;
            alloc_index_int = 2'd3;
        end

    end


    assign mshr_alloc_valid = alloc_valid_int;
    assign mshr_alloc_index = alloc_index_int;

    /*
     * CPU can accept a request whenever
     * at least one MSHR is free.
     */
    assign req_ready = alloc_valid_int;


    /*
     * Debug outputs.
     */
    assign mshr_valid_debug = mshr_valid;

    assign mshr_write_debug = {
        mshr_write[3],
        mshr_write[2],
        mshr_write[1],
        mshr_write[0]
    };

    assign mshr_addr_debug[0] = mshr_addr[0];
    assign mshr_addr_debug[1] = mshr_addr[1];
    assign mshr_addr_debug[2] = mshr_addr[2];
    assign mshr_addr_debug[3] = mshr_addr[3];


    /*
     * Memory request generation.
     *
     * Only an MSHR whose memory transaction has not
     * yet been sent is selected.
     */
    always @(*) begin

        mem_req_valid = 1'b0;
        mem_req_mshr  = 2'd0;
        mem_req_addr  = 32'b0;
        mem_req_write = 1'b0;
        mem_req_wdata = 32'b0;

        if (mshr_valid[0] && !mshr_mem_sent[0]) begin

            mem_req_valid = 1'b1;
            mem_req_mshr  = 2'd0;
            mem_req_addr  = mshr_addr[0];
            mem_req_write = mshr_write[0];
            mem_req_wdata = mshr_wdata[0];

        end
        else if (mshr_valid[1] && !mshr_mem_sent[1]) begin

            mem_req_valid = 1'b1;
            mem_req_mshr  = 2'd1;
            mem_req_addr  = mshr_addr[1];
            mem_req_write = mshr_write[1];
            mem_req_wdata = mshr_wdata[1];

        end
        else if (mshr_valid[2] && !mshr_mem_sent[2]) begin

            mem_req_valid = 1'b1;
            mem_req_mshr  = 2'd2;
            mem_req_addr  = mshr_addr[2];
            mem_req_write = mshr_write[2];
            mem_req_wdata = mshr_wdata[2];

        end
        else if (mshr_valid[3] && !mshr_mem_sent[3]) begin

            mem_req_valid = 1'b1;
            mem_req_mshr  = 2'd3;
            mem_req_addr  = mshr_addr[3];
            mem_req_write = mshr_write[3];
            mem_req_wdata = mshr_wdata[3];

        end

    end


    /*
     * Sequential MSHR state.
     */
    always @(posedge clk) begin

        if (rst) begin

            for (i = 0; i < MSHR_COUNT; i = i + 1) begin

                mshr_valid[i]    <= 1'b0;
                mshr_addr[i]     <= 32'b0;
                mshr_write[i]    <= 1'b0;
                mshr_wdata[i]    <= 32'b0;
                mshr_mem_sent[i] <= 1'b0;

            end

        end
        else begin

            /*
             * Allocate an MSHR.
             */
            if (req_valid && req_ready) begin

                mshr_valid[alloc_index_int] <= 1'b1;

                mshr_addr[alloc_index_int] <= req_addr;

                mshr_write[alloc_index_int] <= req_write;

                mshr_wdata[alloc_index_int] <= req_wdata;

                mshr_mem_sent[alloc_index_int] <= 1'b0;

            end


            /*
             * Mark the selected memory transaction as sent.
             */
            if (mem_req_valid) begin

                mshr_mem_sent[mem_req_mshr] <= 1'b1;

            end


            /*
             * Memory completion releases the MSHR.
             */
            if (mem_resp_valid) begin

                if (mshr_valid[mem_resp_mshr]) begin

                    mshr_valid[mem_resp_mshr] <= 1'b0;

                    mshr_mem_sent[mem_resp_mshr] <= 1'b0;

                end

            end


            /*
             * Explicit release.
             */
            if (mshr_release_valid) begin

                mshr_valid[mshr_release_index] <= 1'b0;

                mshr_mem_sent[mshr_release_index] <= 1'b0;

                mshr_addr[mshr_release_index] <= 32'b0;

                mshr_write[mshr_release_index] <= 1'b0;

                mshr_wdata[mshr_release_index] <= 32'b0;

            end

        end

    end

endmodule