module forwarding_mux
(
    input wire [31:0] reg_value,
    input wire [31:0] ex_mem_value,
    input wire [31:0] mem_wb_value,
    input wire [1:0] forward_select,

    output reg [31:0] mux_output
);

    // Forwarding Selection
    // 00 = Register File
    // 01 = MEM/WB
    // 10 = EX/MEM
    // 11 = Reserved
    always @(*)
    begin

        case (forward_select)

            2'b00:
                mux_output = reg_value;

            2'b01:
                mux_output = mem_wb_value;

            2'b10:
                mux_output = ex_mem_value;

            default:
                mux_output = reg_value;

        endcase
    end

endmodule