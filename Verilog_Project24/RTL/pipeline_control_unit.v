module pipeline_control_unit (
    input  wire stall_request,
    input  wire flush_request,

    output reg  pc_write,
    output reg if_id_write,
    output reg id_ex_flush
);

    always @(*) begin
        pc_write    = 1'b1;
        if_id_write = 1'b1;
        id_ex_flush = 1'b0;

        if (flush_request) begin
            id_ex_flush = 1'b1;
        end
        
        else if (stall_request) begin
            pc_write    = 1'b0;
            if_id_write = 1'b0;
            id_ex_flush = 1'b1;
        end
    end

endmodule