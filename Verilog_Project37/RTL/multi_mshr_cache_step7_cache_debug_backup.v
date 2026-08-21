`timescale 1ns/1ps

module multi_mshr_cache #(
    parameter MSHR_COUNT  = 4,
    parameter CACHE_LINES = 4
)(
    input  wire        clk,
    input  wire        rst,

    /*
     * ============================================================
     * CPU REQUEST INTERFACE
     * ============================================================
     */

    input  wire        req_valid,
    output wire        req_ready,

    input  wire [31:0] req_addr,
    input  wire        req_write,
    input  wire [31:0] req_wdata,


    /*
     * ============================================================
     * MSHR ALLOCATION DEBUG
     * ============================================================
     */

    output wire        mshr_alloc_valid,
    output wire [1:0]  mshr_alloc_index,


    /*
     * ============================================================
     * MEMORY REQUEST INTERFACE
     * ============================================================
     */

    output reg         mem_req_valid,
    output reg  [1:0]  mem_req_mshr,
    output reg  [31:0] mem_req_addr,
    output reg         mem_req_write,
    output reg  [31:0] mem_req_wdata,


    /*
     * ============================================================
     * MEMORY RESPONSE INTERFACE
     * ============================================================
     */

    input  wire        mem_resp_valid,
    input  wire [1:0]  mem_resp_mshr,
    input  wire [31:0] mem_resp_rdata,


    /*
     * ============================================================
     * EXPLICIT MSHR RELEASE
     * ============================================================
     */

    input  wire        mshr_release_valid,
    input  wire [1:0]  mshr_release_index,


    /*
     * ============================================================
     * DEBUG OUTPUTS
     * ============================================================
     */

    output wire [MSHR_COUNT-1:0] mshr_valid_debug,
    output wire [MSHR_COUNT-1:0] mshr_write_debug,
    output wire [31:0] mshr_addr_debug [0:MSHR_COUNT-1],


    /*
     * ============================================================
     * CPU RESPONSE
     * ============================================================
     */

    output reg         resp_valid,
    output reg         resp_hit,
    output reg  [31:0] resp_rdata
);


    /*
     * ============================================================
     * CACHE STORAGE
     * ============================================================
     *
     * Direct-mapped cache.
     *
     * Address format:
     *
     *   [31:6] = tag
     *   [5:4]  = cache index
     *   [3:0]  = byte/line offset
     *
     * Four cache lines are implemented.
     */

    reg        cache_valid [0:CACHE_LINES-1];

    reg [25:0] cache_tag   [0:CACHE_LINES-1];

    reg [31:0] cache_data  [0:CACHE_LINES-1];


    /*
     * ============================================================
     * MSHR TABLE
     * ============================================================
     *
     * Each MSHR stores one outstanding CPU request.
     *
     * mshr_valid:
     *      MSHR is allocated.
     *
     * mshr_mem_sent:
     *      Memory request has already been issued.
     *
     * mshr_addr:
     *      Original CPU address.
     *
     * mshr_write:
     *      Original read/write operation.
     *
     * mshr_wdata:
     *      Original CPU write data.
     */

    reg [MSHR_COUNT-1:0] mshr_valid;

    reg [MSHR_COUNT-1:0] mshr_mem_sent;

    reg [31:0] mshr_addr  [0:MSHR_COUNT-1];

    reg        mshr_write [0:MSHR_COUNT-1];

    reg [31:0] mshr_wdata [0:MSHR_COUNT-1];


    /*
     * ============================================================
     * CPU ADDRESS DECODE
     * ============================================================
     */

    wire [1:0] req_index;

    wire [25:0] req_tag;


    assign req_index = req_addr[5:4];

    assign req_tag = req_addr[31:6];


    /*
     * ============================================================
     * CACHE HIT DETECTION
     * ============================================================
     */

    wire req_cache_hit;


    assign req_cache_hit =
        cache_valid[req_index] &&
        (cache_tag[req_index] == req_tag);


    /*
     * ============================================================
     * MSHR ALLOCATION
     * ============================================================
     *
     * First-free allocation policy.
     *
     * Priority:
     *
     *   MSHR 0
     *   MSHR 1
     *   MSHR 2
     *   MSHR 3
     */

    reg       alloc_valid_int;

    reg [1:0] alloc_index_int;


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


    /*
     * ============================================================
     * REQUEST READY
     * ============================================================
     *
     * A CPU request can be accepted when:
     *
     *   1. It is a cache hit, or
     *   2. A free MSHR exists.
     */

    assign req_ready =
        req_cache_hit ||
        alloc_valid_int;


    /*
     * ============================================================
     * MSHR ALLOCATION DEBUG OUTPUTS
     * ============================================================
     */

    assign mshr_alloc_valid =
        alloc_valid_int;


    assign mshr_alloc_index =
        alloc_index_int;


    /*
     * ============================================================
     * MEMORY REQUEST GENERATION
     * ============================================================
     *
     * Only one unsent MSHR is presented at a time.
     *
     * Priority:
     *
     *   MSHR 0
     *   MSHR 1
     *   MSHR 2
     *   MSHR 3
     */

    always @(*) begin

        mem_req_valid = 1'b0;

        mem_req_mshr = 2'd0;

        mem_req_addr = 32'b0;

        mem_req_write = 1'b0;

        mem_req_wdata = 32'b0;


        if (mshr_valid[0] &&
            !mshr_mem_sent[0]) begin

            mem_req_valid = 1'b1;

            mem_req_mshr = 2'd0;

            mem_req_addr = mshr_addr[0];

            mem_req_write = mshr_write[0];

            mem_req_wdata = mshr_wdata[0];

        end

        else if (mshr_valid[1] &&
                 !mshr_mem_sent[1]) begin

            mem_req_valid = 1'b1;

            mem_req_mshr = 2'd1;

            mem_req_addr = mshr_addr[1];

            mem_req_write = mshr_write[1];

            mem_req_wdata = mshr_wdata[1];

        end

        else if (mshr_valid[2] &&
                 !mshr_mem_sent[2]) begin

            mem_req_valid = 1'b1;

            mem_req_mshr = 2'd2;

            mem_req_addr = mshr_addr[2];

            mem_req_write = mshr_write[2];

            mem_req_wdata = mshr_wdata[2];

        end

        else if (mshr_valid[3] &&
                 !mshr_mem_sent[3]) begin

            mem_req_valid = 1'b1;

            mem_req_mshr = 2'd3;

            mem_req_addr = mshr_addr[3];

            mem_req_write = mshr_write[3];

            mem_req_wdata = mshr_wdata[3];

        end

    end


    /*
     * ============================================================
     * SEQUENTIAL CONTROL
     * ============================================================
     */

    integer i;


    always @(posedge clk) begin

        /*
         * ========================================================
         * RESET
         * ========================================================
         */

        if (rst) begin

            /*
             * Reset MSHRs.
             */

            for (
                i = 0;
                i < MSHR_COUNT;
                i = i + 1
            ) begin

                mshr_valid[i] <= 1'b0;

                mshr_addr[i] <= 32'b0;

                mshr_write[i] <= 1'b0;

                mshr_wdata[i] <= 32'b0;

                mshr_mem_sent[i] <= 1'b0;

            end


            /*
             * Reset cache.
             */

            for (
                i = 0;
                i < CACHE_LINES;
                i = i + 1
            ) begin

                cache_valid[i] <= 1'b0;

                cache_tag[i] <= 26'b0;

                cache_data[i] <= 32'b0;

            end


            /*
             * Reset response.
             */

            resp_valid <= 1'b0;

            resp_hit <= 1'b0;

            resp_rdata <= 32'b0;

        end


        /*
         * ========================================================
         * NORMAL OPERATION
         * ========================================================
         */

        else begin

            /*
             * Response is a one-cycle pulse.
             */

            resp_valid <= 1'b0;


            /*
             * ====================================================
             * CPU REQUEST
             * ====================================================
             */

            if (req_valid && req_ready) begin

                /*
                 * ------------------------------------------------
                 * CACHE HIT
                 * ------------------------------------------------
                 */

                if (req_cache_hit) begin

                    resp_valid <= 1'b1;

                    resp_hit <= 1'b1;


                    /*
                     * READ HIT
                     */

                    if (!req_write) begin

                        resp_rdata <=
                            cache_data[req_index];

                    end


                    /*
                     * WRITE HIT
                     */

                    else begin

                        cache_data[req_index] <=
                            req_wdata;

                        resp_rdata <=
                            req_wdata;

                    end

                end


                /*
                 * ------------------------------------------------
                 * CACHE MISS
                 * ------------------------------------------------
                 */

                else begin

                    /*
                     * Allocate the selected MSHR.
                     */

                    mshr_valid[alloc_index_int] <=
                        1'b1;

                    mshr_addr[alloc_index_int] <=
                        req_addr;

                    mshr_write[alloc_index_int] <=
                        req_write;

                    mshr_wdata[alloc_index_int] <=
                        req_wdata;

                    mshr_mem_sent[alloc_index_int] <=
                        1'b0;

                end

            end


            /*
             * ====================================================
             * MEMORY REQUEST ACCEPTED
             * ====================================================
             *
             * Mark only the MSHR that generated the request.
             */

            if (mem_req_valid) begin

                if (mshr_valid[mem_req_mshr]) begin

                    mshr_mem_sent[mem_req_mshr] <=
                        1'b1;

                end

            end


            /*
             * ====================================================
             * MEMORY RESPONSE
             * ====================================================
             *
             * The response identifies the MSHR directly.
             *
             * Therefore responses may arrive in any order.
             */

            if (mem_resp_valid) begin

                if (mshr_valid[mem_resp_mshr] &&
                    mshr_mem_sent[mem_resp_mshr]) begin


                    /*
                     * ------------------------------------------------
                     * TEMPORARY DEBUG
                     * ------------------------------------------------
                     *
                     * Capture the exact MSHR contents at the moment
                     * the response is consumed.
                     *
                     * This is specifically being used to diagnose
                     * the Step 7 mixed-reuse/index-collision failure.
                     */

                    $display(
                        "DEBUG REFILL: mshr=%0d addr=%h index=%0d tag=%h write=%b wdata=%h resp=%h",
                        mem_resp_mshr,
                        mshr_addr[mem_resp_mshr],
                        mshr_addr[mem_resp_mshr][5:4],
                        mshr_addr[mem_resp_mshr][31:6],
                        mshr_write[mem_resp_mshr],
                        mshr_wdata[mem_resp_mshr],
                        mem_resp_rdata
                    );


                    /*
                     * ------------------------------------------------
                     * READ MISS
                     * ------------------------------------------------
                     *
                     * Use the original MSHR address to determine:
                     *
                     *   cache index
                     *   cache tag
                     *   cache data
                     */

                    if (!mshr_write[mem_resp_mshr]) begin

                        cache_valid[
                            mshr_addr[mem_resp_mshr][5:4]
                        ] <= 1'b1;


                        cache_tag[
                            mshr_addr[mem_resp_mshr][5:4]
                        ] <=
                            mshr_addr[mem_resp_mshr][31:6];


                        cache_data[
                            mshr_addr[mem_resp_mshr][5:4]
                        ] <=
                            mem_resp_rdata;


                        resp_rdata <=
                            mem_resp_rdata;

                    end


                    /*
                     * ------------------------------------------------
                     * WRITE MISS
                     * ------------------------------------------------
                     *
                     * The memory response data is not used as the
                     * CPU-visible cache value.
                     *
                     * The original CPU write data is installed into
                     * the cache.
                     */

                    else begin

                        cache_valid[
                            mshr_addr[mem_resp_mshr][5:4]
                        ] <= 1'b1;


                        cache_tag[
                            mshr_addr[mem_resp_mshr][5:4]
                        ] <=
                            mshr_addr[mem_resp_mshr][31:6];


                        cache_data[
                            mshr_addr[mem_resp_mshr][5:4]
                        ] <=
                            mshr_wdata[mem_resp_mshr];


                        resp_rdata <=
                            mshr_wdata[mem_resp_mshr];

                    end


                    /*
                     * ------------------------------------------------
                     * MISS RESPONSE
                     * ------------------------------------------------
                     */

                    resp_valid <= 1'b1;

                    resp_hit <= 1'b0;


                    /*
                     * ------------------------------------------------
                     * RELEASE COMPLETED MSHR
                     * ------------------------------------------------
                     *
                     * Only the MSHR identified by the memory
                     * response is released.
                     */

                    mshr_valid[mem_resp_mshr] <=
                        1'b0;

                    mshr_mem_sent[mem_resp_mshr] <=
                        1'b0;

                end

            end


            /*
             * ====================================================
             * EXPLICIT MSHR RELEASE
             * ====================================================
             *
             * This interface is retained for compatibility with
             * the existing testbench.
             */

            if (mshr_release_valid) begin

                mshr_valid[mshr_release_index] <=
                    1'b0;

                mshr_mem_sent[mshr_release_index] <=
                    1'b0;

            end

        end

    end


    /*
     * ============================================================
     * DEBUG OUTPUTS
     * ============================================================
     */

    assign mshr_valid_debug =
        mshr_valid;


    /*
     * Array elements cannot be assigned directly as a vector.
     *
     * Explicit concatenation preserves:
     *
     * debug[0] = MSHR 0
     * debug[1] = MSHR 1
     * debug[2] = MSHR 2
     * debug[3] = MSHR 3
     */

    assign mshr_write_debug = {
        mshr_write[3],
        mshr_write[2],
        mshr_write[1],
        mshr_write[0]
    };


    assign mshr_addr_debug[0] =
        mshr_addr[0];

    assign mshr_addr_debug[1] =
        mshr_addr[1];

    assign mshr_addr_debug[2] =
        mshr_addr[2];

    assign mshr_addr_debug[3] =
        mshr_addr[3];


endmodule