module axi4lite_reg_bank #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(
    input  wire                     aclk,
    input  wire                     aresetn,

    /*
     * AXI4-Lite write address channel.
     */
    input  wire [ADDR_WIDTH-1:0]    s_axi_awaddr,
    input  wire                     s_axi_awvalid,
    output reg                      s_axi_awready,

    /*
     * AXI4-Lite write data channel.
     */
    input  wire [DATA_WIDTH-1:0]    s_axi_wdata,
    input  wire [DATA_WIDTH/8-1:0]  s_axi_wstrb,
    input  wire                     s_axi_wvalid,
    output reg                      s_axi_wready,

    /*
     * AXI4-Lite write response channel.
     */
    output reg [1:0]                s_axi_bresp,
    output reg                      s_axi_bvalid,
    input  wire                     s_axi_bready,

    /*
     * AXI4-Lite read address channel.
     */
    input  wire [ADDR_WIDTH-1:0]    s_axi_araddr,
    input  wire                     s_axi_arvalid,
    output reg                      s_axi_arready,

    /*
     * AXI4-Lite read data channel.
     */
    output reg [DATA_WIDTH-1:0]     s_axi_rdata,
    output reg [1:0]                s_axi_rresp,
    output reg                      s_axi_rvalid,
    input  wire                     s_axi_rready
);


    /*
     * ------------------------------------------------------------
     * Register bank
     * ------------------------------------------------------------
     *
     * 0x00 : CONTROL
     * 0x04 : STATUS
     * 0x08 : DATA
     * 0x0C : CONFIG
     */

    reg [DATA_WIDTH-1:0] control_reg;
    reg [DATA_WIDTH-1:0] status_reg;
    reg [DATA_WIDTH-1:0] data_reg;
    reg [DATA_WIDTH-1:0] config_reg;


    /*
     * ------------------------------------------------------------
     * Write transaction storage
     * ------------------------------------------------------------
     */

    reg [ADDR_WIDTH-1:0]   write_addr;
    reg [DATA_WIDTH-1:0]   write_data;
    reg [DATA_WIDTH/8-1:0] write_strb;

    reg write_addr_valid;
    reg write_data_valid;


    /*
     * ------------------------------------------------------------
     * Main AXI4-Lite logic
     * ------------------------------------------------------------
     */

    always @(posedge aclk) begin

        if (!aresetn) begin

            /*
             * Write channel reset.
             */
            s_axi_awready <= 1'b0;
            s_axi_wready  <= 1'b0;

            s_axi_bresp   <= 2'b00;
            s_axi_bvalid  <= 1'b0;


            /*
             * Read channel reset.
             */
            s_axi_arready <= 1'b0;
            s_axi_rdata   <= 32'b0;
            s_axi_rresp   <= 2'b00;
            s_axi_rvalid  <= 1'b0;


            /*
             * Register reset.
             */
            control_reg   <= 32'b0;
            status_reg    <= 32'b0;
            data_reg      <= 32'b0;
            config_reg    <= 32'b0;


            /*
             * Write transaction reset.
             */
            write_addr    <= 32'b0;
            write_data    <= 32'b0;
            write_strb    <= 4'b0;

            write_addr_valid <= 1'b0;
            write_data_valid <= 1'b0;

        end

        else begin

            /*
             * --------------------------------------------------------
             * Accept write address.
             * --------------------------------------------------------
             */

            if (s_axi_awvalid && s_axi_awready) begin

                write_addr <= s_axi_awaddr;
                write_addr_valid <= 1'b1;

            end


            /*
             * --------------------------------------------------------
             * Accept write data.
             * --------------------------------------------------------
             */

            if (s_axi_wvalid && s_axi_wready) begin

                write_data <= s_axi_wdata;
                write_strb <= s_axi_wstrb;
                write_data_valid <= 1'b1;

            end


            /*
             * --------------------------------------------------------
             * Perform write when both address and data are available.
             * --------------------------------------------------------
             */

            if (write_addr_valid &&
                write_data_valid &&
                !s_axi_bvalid) begin

                /*
                 * Only naturally aligned 32-bit addresses may
                 * modify registers.
                 *
                 * Unaligned writes still receive an AXI OKAY
                 * response, but must have no register side effect.
                 */
                if (write_addr[1:0] == 2'b00) begin

                    case (write_addr[5:2])

                        /*
                         * CONTROL register - 0x00
                         */
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


                    /*
                     * DATA register - 0x08
                     */
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


                    /*
                     * CONFIG register - 0x0C
                     */
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


                    /*
                     * STATUS and undefined addresses are read-only.
                     */
                    default: begin
                    end

                    endcase

                end


                /*
                 * Generate AXI OKAY write response.
                 */

                s_axi_bresp  <= 2'b00;
                s_axi_bvalid <= 1'b1;

                write_addr_valid <= 1'b0;
                write_data_valid <= 1'b0;

            end


            /*
             * --------------------------------------------------------
             * Complete write response.
             * --------------------------------------------------------
             */

            if (s_axi_bvalid && s_axi_bready)
                s_axi_bvalid <= 1'b0;


            /*
             * --------------------------------------------------------
             * Write channel ready signals.
             * --------------------------------------------------------
             */

            s_axi_awready <=
                !write_addr_valid && !s_axi_bvalid;

            s_axi_wready <=
                !write_data_valid && !s_axi_bvalid;


            /*
             * --------------------------------------------------------
             * AXI4-Lite read address channel.
             *
             * A new read address is accepted only when there
             * is no previous response waiting for the master.
             * --------------------------------------------------------
             */

            s_axi_arready <= !s_axi_rvalid;


            if (s_axi_arvalid && s_axi_arready) begin

                /*
                 * Decode the requested register.
                 *
                 * Address bits [5:2] select the 32-bit register.
                 */

                /*
                 * Register accesses must be 32-bit word aligned.
                 * Unaligned addresses return zero.
                 */
                if (s_axi_araddr[1:0] == 2'b00) begin

                    case (s_axi_araddr[5:2])

                        /*
                         * CONTROL - 0x00
                         */
                        4'h0: begin
                            s_axi_rdata <= control_reg;
                        end


                        /*
                         * STATUS - 0x04
                         */
                        4'h1: begin
                            s_axi_rdata <= status_reg;
                        end


                        /*
                         * DATA - 0x08
                         */
                        4'h2: begin
                            s_axi_rdata <= data_reg;
                        end


                        /*
                         * CONFIG - 0x0C
                         */
                        4'h3: begin
                            s_axi_rdata <= config_reg;
                        end


                        /*
                         * Undefined address.
                         */
                        default: begin
                            s_axi_rdata <= 32'b0;
                        end

                    endcase

                end
                else begin
                    s_axi_rdata <= 32'b0;
                end


                /*
                 * AXI4-Lite read response.
                 *
                 * 2'b00 = OKAY.
                 */

                s_axi_rresp  <= 2'b00;
                s_axi_rvalid <= 1'b1;

            end


            /*
             * --------------------------------------------------------
             * Complete read response.
             *
             * RVALID remains asserted until RREADY is observed.
             * --------------------------------------------------------
             */

            if (s_axi_rvalid && s_axi_rready) begin
                s_axi_rvalid <= 1'b0;
            end

        end

    end

endmodule