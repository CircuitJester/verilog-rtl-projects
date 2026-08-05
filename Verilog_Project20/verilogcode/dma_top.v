module dma_top
(
    input wire clk,
    input wire rst,

    // CPU Interface
    input wire start,

    input wire [31:0] src_addr_in,
    input wire [31:0] dst_addr_in,
    input wire [15:0] transfer_length,

    // Outputs
    output wire [31:0] src_addr,
    output wire [31:0] dst_addr,

    output wire dma_busy,
    output wire dma_done
);

// Internal Signals
wire start_reg;
wire busy_reg;
wire done_reg;
wire load;
wire increment;
wire decrement;
wire transfer_done;
wire [15:0] count;


// Control Register
dma_control_register control_reg
(
    .clk(clk),
    .rst(rst),

    .start(start),
    .dma_busy(dma_busy),
    .dma_done(dma_done),
    .start_reg(start_reg),
    .busy_reg(busy_reg),
    .done_reg(done_reg)
);

// Address Generator
dma_address_generator address_gen
(
    .clk(clk),
    .rst(rst),

    .load(load),

    .increment(increment),
    .src_addr_in(src_addr_in),
    .dst_addr_in(dst_addr_in),
    .src_addr(src_addr),
    .dst_addr(dst_addr)
);

// Transfer Counter
dma_transfer_counter counter
(
    .clk(clk),
    .rst(rst),

    .load(load),

    .decrement(decrement),
    .transfer_length(transfer_length),
    .count(count),
    .transfer_done(transfer_done)
);

// DMA FSM
dma_controller_fsm controller
(
    .clk(clk),
    .rst(rst),

    .start(start_reg),
    .transfer_done(transfer_done),

    .load(load),

    .increment(increment),
    .decrement(decrement),
    .dma_busy(dma_busy),
    .dma_done(dma_done)
);

endmodule