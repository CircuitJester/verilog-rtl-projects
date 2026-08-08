module forwarding_control_logic
(
    input wire ex_mem_match_rs1,
    input wire mem_wb_match_rs1,
    input wire ex_mem_match_rs2,
    input wire mem_wb_match_rs2,

    output reg [1:0] forward_a,
    output reg [1:0] forward_b
);

    // Forwarding Selection Encoding
    // 00 = Register File
    // 01 = MEM/WB
    // 10 = EX/MEM
    always @(*)
    begin

        // Forwarding for ALU Operand A
        if (ex_mem_match_rs1)
            forward_a = 2'b10;

        else if (mem_wb_match_rs1)
            forward_a = 2'b01;

        else
            forward_a = 2'b00;


        // Forwarding for ALU Operand B
        if (ex_mem_match_rs2)
            forward_b = 2'b10;

        else if (mem_wb_match_rs2)
            forward_b = 2'b01;

        else
            forward_b = 2'b00;

    end
endmodule