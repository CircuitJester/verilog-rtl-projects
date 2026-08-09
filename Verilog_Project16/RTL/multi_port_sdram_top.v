module multi_port_sdram_top(

input wire clk,
input wire rst,
input wire cpu_req,
input wire dma_req,
input wire eth_req,
input wire gpu_req,

output wire [1:0] grant,
output wire done
);

// Internal Signals
wire request_pending;
wire transfer_done;
wire read_fifo;
wire grant_enable;

// Request Pending 
assign request_pending =
       cpu_req |
       dma_req |
       eth_req |
       gpu_req;

// Dummy Transfer Complete
assign transfer_done = grant_enable;

// Round Robin Arbiter
round_robin_arbiter arbiter
(
    .clk(clk),
    .rst(rst),

    .cpu_req(cpu_req),
    .dma_req(dma_req),
    .eth_req(eth_req),
    .gpu_req(gpu_req),
    .grant(grant),
    .valid()
);

// Arbiter FSM
arbiter_fsm controller
(
    .clk(clk),
    .rst(rst),
    .request_pending(request_pending),
    .transfer_done(transfer_done),
    .read_fifo(read_fifo),
    .grant_enable(grant_enable),
    .done(done)
);
endmodule