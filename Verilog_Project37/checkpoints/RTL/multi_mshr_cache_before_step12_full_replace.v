`timescale 1ns/1ps

module multi_mshr_cache #(
    parameter CACHE_LINES = 4,
    parameter MSHR_COUNT  = 4
)(
    input wire         clk,
    input wire         rst,

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
     * MSHR RELEASE INTERFACE
     * ============================================================
     *
     * Retained for compatibility with the existing project
     * interface. Normal completion is handled internally through
     * mem_resp_valid.
     */

    input  wire        mshr_release_valid,
    input  wire [1:0]  mshr_release_index,


    /*
     * ============================================================
     * MSHR DEBUG OUTPUTS
     * ============================================================
     */

    output wire [MSHR_COUNT-1:0] mshr_valid_debug,

    output wire [31:0] mshr_addr_debug [0:MSHR_COUNT-1],

    output wire [MSHR_COUNT-1:0] mshr_write_debug,


    /*
     * ============================================================
     * STEP 12 MSHR OWNER LOOKUP DEBUG
     * ============================================================
     */

    output wire        req_mshr_match_debug,
    output wire [1:0]  req_mshr_index_debug,


    /*
     * ============================================================
     * CPU RESPONSE INTERFACE
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
     * Direct-mapped cache:
     *
     * Address bits:
     *
     *   [5:4]  = cache index
     *   [31:6] = tag
     *
     */

    reg        cache_valid [0:CACHE_LINES-1];

    reg [25:0] cache_tag   [0:CACHE_LINES-1];

    reg [31:0] cache_data  [0:CACHE_LINES-1];


    /*
     * ============================================================
     * CACHE GENERATION
     * ============================================================
     *
     * Every new miss to a cache index increments its generation.
     *
     * This allows multiple outstanding requests to the same cache
     * index without allowing an older response to overwrite the
     * newest request.
     */

    reg [7:0] cache_generation [0:CACHE_LINES-1];


    /*
     * ============================================================
     * MSHR TABLE
     * ============================================================
     */

    reg [MSHR_COUNT-1:0] mshr_valid;

    reg [MSHR_COUNT-1:0] mshr_mem_sent;

    reg [31:0] mshr_addr [0:MSHR_COUNT-1];

    reg        mshr_write [0:MSHR_COUNT-1];

    reg [31:0] mshr_wdata [0:MSHR_COUNT-1];

    reg [7:0]  mshr_generation [0:MSHR_COUNT-1];


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
     * STEP 12
     * OUTSTANDING MSHR OWNER LOOKUP
     * ============================================================
     *
     * Determines whether the requested CPU address is already
     * tracked by an active MSHR.
     *
     * req_mshr_match:
     *      1 when an active MSHR owns req_addr.
     *
     * req_mshr_index:
     *      Index of the owning MSHR.
     *
     * Priority:
     *
     *      MSHR 0
     *      MSHR 1
     *      MSHR 2
     *      MSHR 3
     */

    wire       req_mshr_match;

    reg [1:0]  req_mshr_index;


    always @(*) begin

        req_mshr_match = 1'b0;

        req_mshr_index = 2'd0;


        if (mshr_valid[0] &&
            (mshr_addr[0] == req_addr)) begin

            req_mshr_match = 1'b1;

            req_mshr_index = 2'd0;

        end

        else if (mshr_valid[1] &&
                 (mshr_addr[1] == req_addr)) begin

            req_mshr_match = 1'b1;

            req_mshr_index = 2'd1;

        end

        else if (mshr_valid[2] &&
                 (mshr_addr[2] == req_addr)) begin

            req_mshr_match = 1'b1;

            req_mshr_index = 2'd2;

        end

        else if (mshr_valid[3] &&
                 (mshr_addr[3] == req_addr)) begin

            req_mshr_match = 1'b1;

            req_mshr_index = 2'd3;

        end

    end


    /*
     * ============================================================
     * STEP 11 COMPATIBILITY ALIAS
     * ============================================================
     */

    wire req_mshr_duplicate;

    assign req_mshr_duplicate =
        req_mshr_match;


    /*
     * ============================================================
     * MSHR ALLOCATION
     * ============================================================
     *
     * First-free allocation.
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


    assign mshr_alloc_valid =
        alloc_valid_int;


    assign mshr_alloc_index =
        alloc_index_int;


    /*
     * ============================================================
     * CPU READY
     * ============================================================
     *
     * A request can be accepted when:
     *
     *   1. It is a cache hit, OR
     *   2. A free MSHR exists AND the request is not already
     *      tracked by an active MSHR.
     */

    assign req_ready =
        req_cache_hit ||
        (alloc_valid_int && !req_mshr_duplicate);


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

            mshr_valid <= 4'b0000;

            mshr_mem_sent <= 4'b0000;

            resp_valid <= 1'b0;

            resp_hit <= 1'b0;

            resp_rdata <= 32'b0;


            for (i = 0; i < CACHE_LINES; i = i + 1) begin

                cache_valid[i] <= 1'b0;

                cache_tag[i] <= 26'b0;

                cache_data[i] <= 32'b0;

                cache_generation[i] <= 8'b0;

            end


            for (i = 0; i < MSHR_COUNT; i = i + 1) begin

                mshr_addr[i] <= 32'b0;

                mshr_write[i] <= 1'b0;

                mshr_wdata[i] <= 32'b0;

                mshr_generation[i] <= 8'b0;

            end

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
                     * Allocate first free MSHR.
                     */

                    mshr_valid[alloc_index_int] <=
                        1'b1;


                    /*
                     * Store original request.
                     */

                    mshr_addr[alloc_index_int] <=
                        req_addr;

                    mshr_write[alloc_index_int] <=
                        req_write;

                    mshr_wdata[alloc_index_int] <=
                        req_wdata;


                    /*
                     * Memory request has not been issued.
                     */

                    mshr_mem_sent[alloc_index_int] <=
                        1'b0;


                    /*
                     * Newest request for this cache index.
                     */

                    cache_generation[req_index] <=
                        cache_generation[req_index] + 8'd1;


                    /*
                     * Store generation belonging to this MSHR.
                     */

                    mshr_generation[alloc_index_int] <=
                        cache_generation[req_index] + 8'd1;

                end

            end


            /*
             * ====================================================
             * MEMORY REQUEST ACCEPTED
             * ====================================================
             *
             * Mark only the MSHR that generated the current memory
             * request.
             */

            if (mem_req_valid) begin

                mshr_mem_sent[mem_req_mshr] <=
                    1'b1;

            end


            /*
             * ====================================================
             * EXTERNAL MSHR RELEASE
             * ====================================================
             *
             * Retained for compatibility with the project
             * interface.
             */

            if (mshr_release_valid) begin

                mshr_valid[mshr_release_index] <=
                    1'b0;

                mshr_mem_sent[mshr_release_index] <=
                    1'b0;

            end


            /*
             * ====================================================
             * MEMORY RESPONSE
             * ====================================================
             */

            if (mem_resp_valid) begin

                /*
                 * Only process a response for an active MSHR.
                 */

                if (mshr_valid[mem_resp_mshr]) begin

                    /*
                     * ============================================
                     * CURRENT VS STALE REFILL
                     * ============================================
                     *
                     * A refill is current only if its generation
                     * matches the newest generation for its cache
                     * index.
                     */

                    if (
                        mshr_generation[mem_resp_mshr] ==
                        cache_generation[
                            mshr_addr[mem_resp_mshr][5:4]
                        ]
                    ) begin

                        /*
                         * ----------------------------------------
                         * CURRENT REFILL
                         * ----------------------------------------
                         */

                        cache_valid[
                            mshr_addr[mem_resp_mshr][5:4]
                        ] <=
                            1'b1;


                        cache_tag[
                            mshr_addr[mem_resp_mshr][5:4]
                        ] <=
                            mshr_addr[mem_resp_mshr][31:6];


                        /*
                         * READ MISS
                         */

                        if (!mshr_write[mem_resp_mshr]) begin

                            cache_data[
                                mshr_addr[mem_resp_mshr][5:4]
                            ] <=
                                mem_resp_rdata;

                            resp_rdata <=
                                mem_resp_rdata;

                        end


                        /*
                         * WRITE MISS
                         */

                        else begin

                            cache_data[
                                mshr_addr[mem_resp_mshr][5:4]
                            ] <=
                                mshr_wdata[mem_resp_mshr];

                            resp_rdata <=
                                mshr_wdata[mem_resp_mshr];

                        end

                    end


                    /*
                     * ============================================
                     * COMPLETE CPU RESPONSE
                     * ============================================
                     */

                    resp_valid <= 1'b1;

                    resp_hit <= 1'b0;


                    /*
                     * ============================================
                     * RELEASE MSHR
                     * ============================================
                     */

                    mshr_valid[mem_resp_mshr] <=
                        1'b0;

                    mshr_mem_sent[mem_resp_mshr] <=
                        1'b0;

                end

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
     * Convert unpacked mshr_write array into packed vector.
     *
     * [3] = MSHR 3
     * [2] = MSHR 2
     * [1] = MSHR 1
     * [0] = MSHR 0
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


    /*
     * ============================================================
     * STEP 12 OWNER LOOKUP DEBUG
     * ============================================================
     */

    assign req_mshr_match_debug =
        req_mshr_match;

    assign req_mshr_index_debug =
        req_mshr_index;


endmodule