module axi4lite_reg_bank #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(
    input  wire                     aclk,
    input  wire                     aresetn,

    input  wire [ADDR_WIDTH-1:0]    s_axi_awaddr,
    input  wire                     s_axi_awvalid,
    output reg                      s_axi_awready,

    input  wire [DATA_WIDTH-1:0]    s_axi_wdata,
    input  wire [DATA_WIDTH/8-1:0]  s_axi_wstrb,
    input  wire                     s_axi_wvalid,
    output reg                      s_axi_wready,

    output reg [1:0]                s_axi_bresp,
    output reg                      s_axi_bvalid,
    input  wire                     s_axi_bready,

    input  wire [ADDR_WIDTH-1:0]    s_axi_araddr,
    input  wire                     s_axi_arvalid,
    output reg                      s_axi_arready,

    output reg [DATA_WIDTH-1:0]     s_axi_rdata,
    output reg [1:0]                s_axi_rresp,
    output reg                      s_axi_rvalid,
    input  wire                     s_axi_rready
);

    reg [DATA_WIDTH-1:0] control_reg;
    reg [DATA_WIDTH-1:0] status_reg;
    reg [DATA_WIDTH-1:0] data_reg;
    reg [DATA_WIDTH-1:0] config_reg;

    reg [ADDR_WIDTH-1:0] write_addr;
    reg [DATA_WIDTH-1:0] write_data;
    reg [DATA_WIDTH/8-1:0] write_strb;

    reg write_addr_valid;
    reg write_data_valid;

    always @(posedge aclk) begin

        if (!aresetn) begin

            s_axi_awready <= 1'b0;
            s_axi_wready  <= 1'b0;

            s_axi_bresp   <= 2'b00;
            s_axi_bvalid  <= 1'b0;

            s_axi_arready <= 1'b0;
            s_axi_rdata   <= 32'b0;
            s_axi_rresp   <= 2'b00;
            s_axi_rvalid  <= 1'b0;

            control_reg   <= 32'b0;
            status_reg    <= 32'b0;
            data_reg      <= 32'b0;
            config_reg    <= 32'b0;

            write_addr    <= 32'b0;
            write_data    <= 32'b0;
            write_strb    <= 4'b0;

            write_addr_valid <= 1'b0;
            write_data_valid <= 1'b0;

        end
        else begin

            if (s_axi_awvalid && s_axi_awready) begin
                write_addr <= s_axi_awaddr;
                write_addr_valid <= 1'b1;
            end

            if (s_axi_wvalid && s_axi_wready) begin
                write_data <= s_axi_wdata;
                write_strb <= s_axi_wstrb;
                write_data_valid <= 1'b1;
            end

            if (write_addr_valid && write_data_valid &&
                !s_axi_bvalid) begin

                case (write_addr[5:2])

                    4'h0: begin

                        if (write_strb[0])
                            control_reg[7:0] <= write_data[7:0];

                        if (write_strb[1])
                            control_reg[15:8] <= write_data[15:8];

                        if (write_strb[2])
                            control_reg[23:16] <= write_data[23:16];

                        if (write_strb[3])
                            control_reg[31:24] <= write_data[31:24];

                    end

                    4'h2: begin

                        if (write_strb[0])
                            data_reg[7:0] <= write_data[7:0];

                        if (write_strb[1])
                            data_reg[15:8] <= write_data[15:8];

                        if (write_strb[2])
                            data_reg[23:16] <= write_data[23:16];

                        if (write_strb[3])
                            data_reg[31:24] <= write_data[31:24];

                    end

                    4'h3: begin

                        if (write_strb[0])
                            config_reg[7:0] <= write_data[7:0];

                        if (write_strb[1])
                            config_reg[15:8] <= write_data[15:8];

                        if (write_strb[2])
                            config_reg[23:16] <= write_data[23:16];

                        if (write_strb[3])
                            config_reg[31:24] <= write_data[31:24];

                    end

                    default: begin
                    end

                endcase

                s_axi_bresp <= 2'b00;
                s_axi_bvalid <= 1'b1;

                write_addr_valid <= 1'b0;
                write_data_valid <= 1'b0;

            end

            if (s_axi_bvalid && s_axi_bready)
                s_axi_bvalid <= 1'b0;

            s_axi_awready <= !write_addr_valid && !s_axi_bvalid;
            s_axi_wready  <= !write_data_valid && !s_axi_bvalid;

            s_axi_arready <= 1'b0;
            s_axi_rvalid  <= 1'b0;

        end

    end

endmodule
