module branch_target_buffer (
    input  wire clk,
    input  wire rst,

    input  wire [31:0] lookup_pc,
    input  wire update_enable,
    input  wire [31:0] branch_pc,
    input  wire [31:0] branch_target,

    output wire hit,
    output wire [31:0] target_pc
);

    reg valid_entries [0:3];
    reg [27:0] stored_tags   [0:3];
    reg [31:0] stored_targets[0:3];

    wire [1:0] lookup_index;
    wire [27:0] lookup_tag;

    assign lookup_index = lookup_pc[3:2];
    assign lookup_tag = lookup_pc[31:4];

    assign hit =
        valid_entries[lookup_index] &&
        stored_tags[lookup_index] == lookup_tag;

    assign target_pc = hit ? stored_targets[lookup_index] : 32'b0;

    always @(posedge clk) begin
        if (rst) 
        
        begin

            valid_entries[0] <= 1'b0;
            valid_entries[1] <= 1'b0;
            valid_entries[2] <= 1'b0;
            valid_entries[3] <= 1'b0;
            
        end

        else if (update_enable) 
        
        begin

            valid_entries[branch_pc[3:2]] <= 1'b1;
            stored_tags[branch_pc[3:2]] <= branch_pc[31:4];
            stored_targets[branch_pc[3:2]] <= branch_target;

        end

    end

endmodule