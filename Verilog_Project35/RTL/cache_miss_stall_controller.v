module cache_miss_stall_controller #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter SETS       = 4
)(
    input  wire                  clk,
    input  wire                  rst,

    // ============================================================
    // CPU request interface
    // ============================================================

    input  wire                  req_valid,
    output wire                  req_ready,

    input  wire                  req_write,
    input  wire [ADDR_WIDTH-1:0] req_addr,
    input  wire [DATA_WIDTH-1:0] req_wdata,

    // ============================================================
    // CPU response interface
    // ============================================================

    output reg                   resp_valid,
    output reg                   resp_hit,
    output reg  [DATA_WIDTH-1:0] resp_rdata,

    // ============================================================
    // Backing memory read interface
    // ============================================================

    output reg                   mem_read,
    output reg  [ADDR_WIDTH-1:0] mem_addr,

    input  wire [DATA_WIDTH-1:0] mem_rdata,
    input  wire                  mem_ready,

    // ============================================================
    // Backing memory write interface
    // ============================================================

    output reg                   mem_write,
    output reg  [ADDR_WIDTH-1:0] mem_write_addr,
    output reg  [DATA_WIDTH-1:0] mem_write_data,

    input  wire                  mem_write_ready
);

    // ============================================================
    // Cache configuration
    //
    // 4 direct-mapped sets
    // 1 x 32-bit word per cache line
    //
    // Address:
    //
    // [31:4] TAG
    // [3:2]  SET
    // [1:0]  BYTE OFFSET
    // ============================================================

    localparam SET_BITS = 2;
    localparam TAG_BITS = ADDR_WIDTH - SET_BITS - 2;

    // ============================================================
    // Controller states
    // ============================================================

    localparam STATE_IDLE        = 4'd0;
    localparam STATE_LOOKUP      = 4'd1;
    localparam STATE_MEM_REQUEST = 4'd2;
    localparam STATE_MEM_WAIT    = 4'd3;
    localparam STATE_WRITE_REQ   = 4'd4;
    localparam STATE_WRITE_WAIT  = 4'd5;
    localparam STATE_REFILL      = 4'd6;
    localparam STATE_RESPONSE    = 4'd7;

    reg [3:0] state;

    // ============================================================
    // Cache arrays
    // ============================================================

    reg [TAG_BITS-1:0] tag_array [0:SETS-1];

    reg [DATA_WIDTH-1:0] data_array [0:SETS-1];

    reg valid_array [0:SETS-1];

    reg dirty_array [0:SETS-1];

    // ============================================================
    // Latched CPU request
    // ============================================================

    reg                  pending_write;
    reg [ADDR_WIDTH-1:0] pending_addr;
    reg [DATA_WIDTH-1:0] pending_wdata;

    // ============================================================
    // Address decomposition
    // ============================================================

    wire [SET_BITS-1:0] pending_set;

    wire [TAG_BITS-1:0] pending_tag;

    assign pending_set =
        pending_addr[SET_BITS+1:2];

    assign pending_tag =
        pending_addr[ADDR_WIDTH-1:SET_BITS+2];

    // ============================================================
    // Cache hit
    // ============================================================

    wire cache_hit;

    assign cache_hit =
        valid_array[pending_set] &&
        tag_array[pending_set] == pending_tag;

    // ============================================================
    // Victim dirty status
    // ============================================================

    wire victim_dirty;

    assign victim_dirty =
        valid_array[pending_set] &&
        dirty_array[pending_set];

    // ============================================================
    // Victim address
    //
    // Reconstruct the original memory address from:
    //
    // victim tag + set + zero byte offset
    // ============================================================

    wire [ADDR_WIDTH-1:0] victim_addr;

    assign victim_addr = {
        tag_array[pending_set],
        pending_set,
        2'b00
    };

    // ============================================================
    // CPU ready
    //
    // The CPU can submit a request only while IDLE.
    // ============================================================

    assign req_ready =
        (state == STATE_IDLE);

    // ============================================================
    // Loop variable
    // ============================================================

    integer set;

    // ============================================================
    // Main controller
    // ============================================================

    always @(posedge clk) begin

        if (rst) begin

            // ----------------------------------------------------
            // Controller
            // ----------------------------------------------------

            state <= STATE_IDLE;

            // ----------------------------------------------------
            // CPU request registers
            // ----------------------------------------------------

            pending_write <= 1'b0;
            pending_addr  <= {ADDR_WIDTH{1'b0}};
            pending_wdata <= {DATA_WIDTH{1'b0}};

            // ----------------------------------------------------
            // CPU response
            // ----------------------------------------------------

            resp_valid <= 1'b0;
            resp_hit   <= 1'b0;
            resp_rdata <= {DATA_WIDTH{1'b0}};

            // ----------------------------------------------------
            // Memory read interface
            // ----------------------------------------------------

            mem_read <= 1'b0;
            mem_addr <= {ADDR_WIDTH{1'b0}};

            // ----------------------------------------------------
            // Memory write interface
            // ----------------------------------------------------

            mem_write <= 1'b0;
            mem_write_addr <= {ADDR_WIDTH{1'b0}};
            mem_write_data <= {DATA_WIDTH{1'b0}};

            // ----------------------------------------------------
            // Cache initialization
            // ----------------------------------------------------

            for (set = 0; set < SETS; set = set + 1) begin

                valid_array[set] <= 1'b0;

                dirty_array[set] <= 1'b0;

                tag_array[set] <=
                    {TAG_BITS{1'b0}};

                data_array[set] <=
                    {DATA_WIDTH{1'b0}};

            end

        end

        else begin

            // ====================================================
            // Default pulse outputs
            // ====================================================

            resp_valid <= 1'b0;

            // Memory read is a one-cycle pulse.

            mem_read <= 1'b0;

            // Memory write is a one-cycle pulse.

            mem_write <= 1'b0;

            case (state)

                // =================================================
                // IDLE
                // =================================================

                STATE_IDLE: begin

                    if (req_valid && req_ready) begin

                        pending_write <= req_write;

                        pending_addr <= req_addr;

                        pending_wdata <= req_wdata;

                        state <= STATE_LOOKUP;

                    end

                end

                // =================================================
                // LOOKUP
                // =================================================

                STATE_LOOKUP: begin

                    if (cache_hit) begin

                        // ------------------------------------------------
                        // CACHE HIT
                        // ------------------------------------------------

                        resp_hit <= 1'b1;

                        if (!pending_write) begin

                            // ------------------------------------------------
                            // Read hit
                            // ------------------------------------------------

                            resp_rdata <=
                                data_array[pending_set];

                        end

                        else begin

                            // ------------------------------------------------
                            // Write hit
                            //
                            // Update data and mark line dirty.
                            // ------------------------------------------------

                            data_array[pending_set] <=
                                pending_wdata;

                            dirty_array[pending_set] <=
                                1'b1;

                            resp_rdata <=
                                pending_wdata;

                        end

                        state <= STATE_RESPONSE;

                    end

                    else begin

                        // ------------------------------------------------
                        // CACHE MISS
                        // ------------------------------------------------

                        resp_hit <= 1'b0;

                        // ------------------------------------------------
                        // If the victim is valid and dirty, write it back.
                        // ------------------------------------------------

                        if (victim_dirty) begin

                            state <= STATE_WRITE_REQ;

                        end

                        else begin

                            // ------------------------------------------------
                            // Clean miss.
                            // Go directly to memory refill.
                            // ------------------------------------------------

                            mem_addr <= pending_addr;

                            state <= STATE_MEM_REQUEST;

                        end

                    end

                end

                // =================================================
                // WRITE-BACK REQUEST
                //
                // mem_write is asserted for exactly ONE cycle.
                // =================================================

                STATE_WRITE_REQ: begin

                    mem_write <= 1'b1;

                    mem_write_addr <=
                        victim_addr;

                    mem_write_data <=
                        data_array[pending_set];

                    state <= STATE_WRITE_WAIT;

                end

                // =================================================
                // WRITE-BACK WAIT
                // =================================================

                STATE_WRITE_WAIT: begin

                    // Keep write information stable while waiting.

                    mem_write_addr <=
                        victim_addr;

                    mem_write_data <=
                        data_array[pending_set];

                    if (mem_write_ready) begin

                        // ------------------------------------------------
                        // Victim is now clean.
                        // ------------------------------------------------

                        dirty_array[pending_set] <=
                            1'b0;

                        // ------------------------------------------------
                        // Begin refill of requested address.
                        // ------------------------------------------------

                        mem_addr <=
                            pending_addr;

                        state <=
                            STATE_MEM_REQUEST;

                    end

                end

                // =================================================
                // MEMORY READ REQUEST
                //
                // One-cycle pulse.
                // =================================================

                STATE_MEM_REQUEST: begin

                    mem_read <= 1'b1;

                    mem_addr <=
                        pending_addr;

                    state <=
                        STATE_MEM_WAIT;

                end

                // =================================================
                // MEMORY READ WAIT
                // =================================================

                STATE_MEM_WAIT: begin

                    mem_addr <=
                        pending_addr;

                    if (mem_ready) begin

                        state <=
                            STATE_REFILL;

                    end

                end

                // =================================================
                // REFILL
                // =================================================

                STATE_REFILL: begin

                    // ------------------------------------------------
                    // Install memory line.
                    // ------------------------------------------------

                    valid_array[pending_set] <=
                        1'b1;

                    tag_array[pending_set] <=
                        pending_tag;

                    data_array[pending_set] <=
                        mem_rdata;

                    // ------------------------------------------------
                    // A refill begins clean.
                    // ------------------------------------------------

                    if (pending_write) begin

                        // ------------------------------------------------
                        // Write miss:
                        // install memory line then modify it.
                        // ------------------------------------------------

                        data_array[pending_set] <=
                            pending_wdata;

                        dirty_array[pending_set] <=
                            1'b1;

                        resp_rdata <=
                            pending_wdata;

                    end

                    else begin

                        // ------------------------------------------------
                        // Read miss.
                        // ------------------------------------------------

                        dirty_array[pending_set] <=
                            1'b0;

                        resp_rdata <=
                            mem_rdata;

                    end

                    resp_hit <=
                        1'b0;

                    state <=
                        STATE_RESPONSE;

                end

                // =================================================
                // RESPONSE
                // =================================================

                STATE_RESPONSE: begin

                    resp_valid <=
                        1'b1;

                    state <=
                        STATE_IDLE;

                end

                // =================================================
                // Safety fallback
                // =================================================

                default: begin

                    state <=
                        STATE_IDLE;

                end

            endcase

        end

    end

endmodule