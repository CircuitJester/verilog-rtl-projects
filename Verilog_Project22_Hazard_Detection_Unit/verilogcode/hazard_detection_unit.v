module hazard_detection_unit
(
    input wire clk,
    input wire rst,

    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [4:0] rd,
    input wire reg_write,

    output wire stall,
    output wire pc_write,
    output wire if_id_write,
    output wire pipeline_hold,
    output wire busy
);

// Internal Signal
wire stall_internal;

// Hazard Detection Logic
hazard_detection_logic hazard_logic
(
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),

    .reg_write(reg_write),
    .stall(stall_internal),
    .pc_write(pc_write),
    .if_id_write(if_id_write)
);

// Hazard Controller FSM
hazard_controller_fsm controller
(
    .clk(clk),
    .rst(rst),

    .stall(stall_internal),
    .pipeline_hold(pipeline_hold),
    .busy(busy)
);

// Output Assignment
assign stall = stall_internal;

endmodule