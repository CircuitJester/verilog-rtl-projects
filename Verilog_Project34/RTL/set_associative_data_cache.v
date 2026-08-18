module set_associative_data_cache #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter SETS = 4
)(
    input  wire clk,
    input  wire rst,

    input  wire req_valid,
    input  wire req_write,
    input  wire [ADDR_WIDTH-1:0] req_addr,
    input  wire [DATA_WIDTH-1:0] req_wdata,

    output reg resp_valid,
    output reg resp_hit,
    output reg [DATA_WIDTH-1:0] resp_rdata,

    output reg mem_read,
    output reg [ADDR_WIDTH-1:0] mem_addr,
    input  wire [DATA_WIDTH-1:0] mem_rdata,
    input  wire mem_ready,

    output reg mem_write,
    output reg [ADDR_WIDTH-1:0] mem_write_addr,
    output reg [DATA_WIDTH-1:0] mem_write_data,
    input  wire mem_write_ready
);

    localparam SET_BITS = 2;
    localparam TAG_BITS = ADDR_WIDTH - SET_BITS - 2;

    localparam IDLE = 3'd0;
    localparam LOOKUP = 3'd1;
    localparam CHECK_MISS = 3'd2;
    localparam WRITE_BACK = 3'd3;
    localparam REFILL = 3'd4;

    reg [2:0] state;

    reg [TAG_BITS-1:0] tag_array [0:1][0:SETS-1];

    reg [DATA_WIDTH-1:0] data_array [0:1][0:SETS-1];

    reg valid_array [0:1][0:SETS-1];

    reg dirty_array [0:1][0:SETS-1];

    reg lru_array [0:SETS-1];

    reg [ADDR_WIDTH-1:0] pending_addr;

    reg [DATA_WIDTH-1:0] pending_wdata;

    reg pending_write;
    reg miss_way;

    reg [SET_BITS-1:0] miss_set;

    reg [TAG_BITS-1:0] miss_tag;

    reg victim_way;

    reg [TAG_BITS-1:0] victim_tag;

    reg [DATA_WIDTH-1:0] victim_data;

    wire [SET_BITS-1:0] request_set;

    wire [TAG_BITS-1:0] request_tag;

    assign request_set =
        pending_addr[SET_BITS+1:2];

    assign request_tag =
        pending_addr[ADDR_WIDTH-1:SET_BITS+2];


    integer way;
    integer set;

    always @(posedge clk) begin

        if (rst) begin

            state <= IDLE;

            resp_valid <= 1'b0;
            resp_hit   <= 1'b0;
            resp_rdata <= {DATA_WIDTH{1'b0}};

            mem_read <= 1'b0;
            mem_addr <= {ADDR_WIDTH{1'b0}};

            mem_write <= 1'b0;
            mem_write_addr <= {ADDR_WIDTH{1'b0}};
            mem_write_data <= {DATA_WIDTH{1'b0}};

            pending_addr  <= {ADDR_WIDTH{1'b0}};
            pending_wdata <= {DATA_WIDTH{1'b0}};
            pending_write <= 1'b0;

            miss_way <= 1'b0;
            miss_set <= {SET_BITS{1'b0}};
            miss_tag <= {TAG_BITS{1'b0}};

            victim_way  <= 1'b0;
            victim_tag  <= {TAG_BITS{1'b0}};
            victim_data <= {DATA_WIDTH{1'b0}};

            for (set = 0; set < SETS; set = set + 1) begin

                lru_array[set] <= 1'b0;

                for (way = 0; way < 2; way = way + 1) begin

                    valid_array[way][set] <= 1'b0;

                    dirty_array[way][set] <= 1'b0;

                    tag_array[way][set] <=
                        {TAG_BITS{1'b0}};

                    data_array[way][set] <=
                        {DATA_WIDTH{1'b0}};

                end

            end

        end

        else begin

            resp_valid <= 1'b0;
            resp_hit   <= 1'b0;

            mem_read  <= 1'b0;
            mem_write <= 1'b0;

            case (state)
                IDLE: begin

                    if (req_valid) begin

                        pending_addr <= req_addr;

                        pending_wdata <= req_wdata;

                        pending_write <= req_write;

                        state <= LOOKUP;

                    end

                end

                LOOKUP: begin

                    if (valid_array[0][request_set] &&
                        tag_array[0][request_set] == request_tag) begin

                        resp_valid <= 1'b1;

                        resp_hit <= 1'b1;

                        if (pending_write) begin

                            data_array[0][request_set] <=
                                pending_wdata;

                            dirty_array[0][request_set] <=
                                1'b1;

                            resp_rdata <=
                                pending_wdata;

                        end

                        else begin

                            resp_rdata <=
                                data_array[0][request_set];

                        end

                        lru_array[request_set] <= 1'b1;

                        state <= IDLE;

                    end

                    else if (valid_array[1][request_set] &&
                             tag_array[1][request_set] == request_tag) begin

                        resp_valid <= 1'b1;

                        resp_hit <= 1'b1;

                        if (pending_write) begin

                            data_array[1][request_set] <=
                                pending_wdata;

                            dirty_array[1][request_set] <=
                                1'b1;

                            resp_rdata <=
                                pending_wdata;

                        end

                        else begin

                            resp_rdata <=
                                data_array[1][request_set];

                        end

                        lru_array[request_set] <= 1'b0;

                        state <= IDLE;

                    end

                    else begin

                        miss_set <= request_set;

                        miss_tag <= request_tag;

                        if (!valid_array[0][request_set]) begin

                            miss_way <= 1'b0;

                        end

                        else if (!valid_array[1][request_set]) begin

                            miss_way <= 1'b1;

                        end

                        else begin

                            miss_way <=
                                lru_array[request_set];

                        end

                        state <= CHECK_MISS;

                    end

                end

                CHECK_MISS: begin

                    victim_way <= miss_way;

                    victim_tag <=
                        tag_array[miss_way][miss_set];

                    victim_data <=
                        data_array[miss_way][miss_set];

                    if (valid_array[miss_way][miss_set] &&
                        dirty_array[miss_way][miss_set]) begin

                        state <= WRITE_BACK;

                    end

                    else begin

                        state <= REFILL;

                    end

                end

                WRITE_BACK: begin

                    mem_write <= 1'b1;

                    mem_write_addr <=
                        {victim_tag,
                         miss_set,
                         2'b00};

                    mem_write_data <=
                        victim_data;

                    if (mem_write_ready) begin

                        dirty_array[victim_way][miss_set] <=
                            1'b0;

                        state <= REFILL;

                    end

                end

                REFILL: begin

                    mem_read <= 1'b1;

                    mem_addr <=
                        pending_addr;

                    if (mem_ready) begin

                        tag_array[miss_way][miss_set] <=
                            miss_tag;

                        valid_array[miss_way][miss_set] <=
                            1'b1;

                        if (!pending_write) begin

                            data_array[miss_way][miss_set] <=
                                mem_rdata;

                            dirty_array[miss_way][miss_set] <=
                                1'b0;

                            resp_rdata <=
                                mem_rdata;

                        end

                        else begin

                            data_array[miss_way][miss_set] <=
                                pending_wdata;

                            dirty_array[miss_way][miss_set] <=
                                1'b1;

                            resp_rdata <=
                                pending_wdata;

                        end

                        resp_valid <= 1'b1;

                        resp_hit <= 1'b0;

                        lru_array[miss_set] <=
                            ~miss_way;

                        state <= IDLE;

                    end

                end

                default: begin

                    state <= IDLE;

                end

            endcase

        end

    end

endmodule