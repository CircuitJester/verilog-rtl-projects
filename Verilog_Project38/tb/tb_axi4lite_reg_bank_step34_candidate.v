`timescale 1ns/1ps

module tb_axi4lite_reg_bank;

    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 32;

    reg aclk;
    reg aresetn;

    reg  [ADDR_WIDTH-1:0] s_axi_awaddr;
    reg                   s_axi_awvalid;
    wire                  s_axi_awready;

    reg  [DATA_WIDTH-1:0] s_axi_wdata;
    reg  [DATA_WIDTH/8-1:0] s_axi_wstrb;
    reg                   s_axi_wvalid;
    wire                  s_axi_wready;

    wire [1:0]             s_axi_bresp;
    wire                  s_axi_bvalid;
    reg                    s_axi_bready;

    reg  [ADDR_WIDTH-1:0] s_axi_araddr;
    reg                   s_axi_arvalid;
    wire                  s_axi_arready;

    wire [DATA_WIDTH-1:0] s_axi_rdata;
    wire [1:0]             s_axi_rresp;
    wire                  s_axi_rvalid;
    reg                    s_axi_rready;

    integer pass_count;
    integer fail_count;
    reg [31:0] stalled_rdata;


    /*
     * ------------------------------------------------------------
     * DUT
     * ------------------------------------------------------------
     */

    axi4lite_reg_bank #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .aclk(aclk),
        .aresetn(aresetn),

        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_awready(s_axi_awready),

        .s_axi_wdata(s_axi_wdata),
        .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wvalid(s_axi_wvalid),
        .s_axi_wready(s_axi_wready),

        .s_axi_bresp(s_axi_bresp),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_bready(s_axi_bready),

        .s_axi_araddr(s_axi_araddr),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_arready(s_axi_arready),

        .s_axi_rdata(s_axi_rdata),
        .s_axi_rresp(s_axi_rresp),
        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_rready(s_axi_rready)
    );


    /*
     * ------------------------------------------------------------
     * Clock
     * ------------------------------------------------------------
     */

    initial begin
        aclk = 1'b0;

        forever
            #5 aclk = ~aclk;
    end


    /*
     * ------------------------------------------------------------
     * Write helper
     *
     * AW channel arrives first.
     * ------------------------------------------------------------
     */

    task write_aw_first;

        input [31:0] addr;
        input [31:0] data;

        begin

            /*
             * Present AW.
             */
            s_axi_awaddr  = addr;
            s_axi_awvalid = 1'b1;

            /*
             * Wait until AWREADY is visible.
             */
            while (!s_axi_awready) begin
                @(posedge aclk);
                #1;
            end

            /*
             * Perform the actual AW handshake.
             */
            @(posedge aclk);
            #1;

            s_axi_awvalid = 1'b0;

            /*
             * IMPORTANT:
             * Do NOT wait another clock here.
             *
             * WREADY is still available for the next clock edge.
             */
            s_axi_wdata  = data;
            s_axi_wstrb  = 4'b1111;
            s_axi_wvalid = 1'b1;

            /*
             * Wait for W handshake.
             */
            while (!s_axi_wready) begin
                @(posedge aclk);
                #1;
            end

            @(posedge aclk);
            #1;

            s_axi_wvalid = 1'b0;

            /*
             * Both AW and W are now stored.
             * Wait for write response.
             */
            while (!s_axi_bvalid)
                @(posedge aclk);

            s_axi_bready = 1'b1;

            @(posedge aclk);
            #1;

            s_axi_bready = 1'b0;

            /*
             * Return to idle.
             */
            @(posedge aclk);
            #1;

        end

    endtask


    /*
     * ------------------------------------------------------------
     * Write helper: AW first, then W with custom WSTRB
     * ------------------------------------------------------------
     */

    task write_aw_first_strobe;

        input [31:0] addr;
        input [31:0] data;
        input [3:0]  strb;

        begin

            /*
             * Present AW.
             */
            s_axi_awaddr  = addr;
            s_axi_awvalid = 1'b1;

            while (!s_axi_awready) begin
                @(posedge aclk);
                #1;
            end

            @(posedge aclk);
            #1;

            s_axi_awvalid = 1'b0;


            /*
             * Present W with the requested byte enables.
             */
            s_axi_wdata  = data;
            s_axi_wstrb  = strb;
            s_axi_wvalid = 1'b1;

            while (!s_axi_wready) begin
                @(posedge aclk);
                #1;
            end

            @(posedge aclk);
            #1;

            s_axi_wvalid = 1'b0;


            /*
             * Wait for write response.
             */
            while (!s_axi_bvalid)
                @(posedge aclk);

            s_axi_bready = 1'b1;

            @(posedge aclk);
            #1;

            s_axi_bready = 1'b0;


            /*
             * Return to idle.
             */
            @(posedge aclk);
            #1;

        end

    endtask


    /*
     * ------------------------------------------------------------
     * Write helper: W first, then AW
     * ------------------------------------------------------------
     */

    task write_w_first;

        input [31:0] addr;
        input [31:0] data;

        begin

            /*
             * Present W.
             */
            s_axi_wdata  = data;
            s_axi_wstrb  = 4'b1111;
            s_axi_wvalid = 1'b1;

            /*
             * Wait until WREADY is visible.
             */
            while (!s_axi_wready) begin
                @(posedge aclk);
                #1;
            end

            /*
             * Perform the actual W handshake.
             */
            @(posedge aclk);
            #1;

            s_axi_wvalid = 1'b0;

            /*
             * IMPORTANT:
             * Do NOT wait another clock here.
             *
             * AWREADY is still available for the next clock edge.
             */
            s_axi_awaddr  = addr;
            s_axi_awvalid = 1'b1;

            /*
             * Wait for AW handshake.
             */
            while (!s_axi_awready) begin
                @(posedge aclk);
                #1;
            end

            @(posedge aclk);
            #1;

            s_axi_awvalid = 1'b0;

            /*
             * Both W and AW are now stored.
             * Wait for write response.
             */
            while (!s_axi_bvalid)
                @(posedge aclk);

            s_axi_bready = 1'b1;

            @(posedge aclk);
            #1;

            s_axi_bready = 1'b0;

            /*
             * Return to idle.
             */
            @(posedge aclk);
            #1;

        end

    endtask


    /*
     * ------------------------------------------------------------
     * Read helper
     * ------------------------------------------------------------
     */

    task read_register;

        input [31:0] addr;

        integer timeout;

        begin

            timeout = 0;

            s_axi_araddr  = addr;
            s_axi_arvalid = 1'b1;

            /*
             * Wait until registered ARREADY becomes visible.
             */
            while (!s_axi_arready) begin

                @(posedge aclk);
                #1;

                timeout = timeout + 1;

                if (timeout > 20) begin
                    $display("ERROR: ARREADY timeout");
                    $finish;
                end

            end

            /*
             * Actual AR handshake edge.
             */
            @(posedge aclk);
            #1;

            s_axi_arvalid = 1'b0;

            /*
             * Wait for read response.
             */
            timeout = 0;

            while (!s_axi_rvalid) begin

                @(posedge aclk);
                #1;

                timeout = timeout + 1;

                if (timeout > 20) begin
                    $display("ERROR: RVALID timeout");
                    $finish;
                end

            end

        end

    endtask


    /*
     * ------------------------------------------------------------
     * Main verification
     * ------------------------------------------------------------
     */

    initial begin

        pass_count = 0;
        fail_count = 0;


        /*
         * --------------------------------------------------------
         * Reset
         * --------------------------------------------------------
         */

        aresetn = 1'b0;

        s_axi_awaddr  = 32'b0;
        s_axi_awvalid = 1'b0;

        s_axi_wdata   = 32'b0;
        s_axi_wstrb   = 4'b0;
        s_axi_wvalid  = 1'b0;

        s_axi_bready  = 1'b0;

        s_axi_araddr  = 32'b0;
        s_axi_arvalid = 1'b0;

        s_axi_rready  = 1'b0;

        #20;

        aresetn = 1'b1;

        @(posedge aclk);
        #1;


        /*
         * --------------------------------------------------------
         * TEST 1
         * AW channel arrives before W.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 1: AW channel arrives before W");
        $display("Expected: CONTROL = 12345678");

        write_aw_first(
            32'h00000000,
            32'h12345678
        );

        read_register(32'h00000000);

        if (s_axi_rdata == 32'h12345678) begin
            $display("PASS: AW-first write completed");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: CONTROL = %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 2
         * W channel arrives before AW.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 2: W channel arrives before AW");
        $display("Expected: DATA = AABBCCDD");

        write_w_first(
            32'h00000008,
            32'hAABBCCDD
        );

        read_register(32'h00000008);

        if (s_axi_rdata == 32'hAABBCCDD) begin
            $display("PASS: W-first write completed");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: DATA = %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 3
         * AW-only transaction.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 3: AW-only transaction");
        $display("Expected: no BVALID before W arrives");

        s_axi_awaddr  = 32'h00000000;
        s_axi_awvalid = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_awvalid = 1'b0;

        if (!s_axi_bvalid) begin
            $display("PASS: AW-only did not generate response");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: unexpected BVALID");
            fail_count = fail_count + 1;
        end


        s_axi_wdata  = 32'hDEADBEEF;
        s_axi_wstrb  = 4'b1111;
        s_axi_wvalid = 1'b1;

        while (s_axi_wvalid) begin

            @(posedge aclk);
            #1;

            if (s_axi_wready)
                s_axi_wvalid = 1'b0;

        end


        while (!s_axi_bvalid)
            @(posedge aclk);

        s_axi_bready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_bready = 1'b0;

        @(posedge aclk);
        #1;

        read_register(32'h00000000);

        if (s_axi_rdata == 32'hDEADBEEF) begin
            $display("PASS: AW-only transaction completed after W");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: CONTROL = %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 4
         * W-only transaction.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 4: W-only transaction");
        $display("Expected: no BVALID before AW arrives");

        s_axi_wdata  = 32'hCAFEBABE;
        s_axi_wstrb  = 4'b1111;
        s_axi_wvalid = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_wvalid = 1'b0;

        if (!s_axi_bvalid) begin
            $display("PASS: W-only did not generate response");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: unexpected BVALID");
            fail_count = fail_count + 1;
        end


        /*
         * --------------------------------------------------------
         * TEST 5
         * Complete W-only transaction.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 5: Verify W-only completion");
        $display("Expected: CONTROL = CAFEBABE");

        /*
         * Complete the previously stored W transaction with AW.
         */

        s_axi_awaddr  = 32'h00000000;
        s_axi_awvalid = 1'b1;

        while (s_axi_awvalid) begin

            @(posedge aclk);
            #1;

            if (s_axi_awready)
                s_axi_awvalid = 1'b0;

        end


        while (!s_axi_bvalid)
            @(posedge aclk);

        s_axi_bready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_bready = 1'b0;

        @(posedge aclk);
        #1;


        /*
         * Read CONTROL.
         */

        read_register(32'h00000000);

        if (s_axi_rdata == 32'hCAFEBABE) begin
            $display("PASS: W-only transaction completed after AW");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: CONTROL = %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 6
         * Normal transaction recovery.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 6: Normal transaction recovery");
        $display("Expected: CONFIG = 55AA55AA");

        write_aw_first(
            32'h0000000C,
            32'h55AA55AA
        );

        read_register(32'h0000000C);

        if (s_axi_rdata == 32'h55AA55AA) begin
            $display("PASS: normal transaction recovered");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: CONFIG = %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 7
         * Register independence after split-channel writes.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 7: Register independence");
        $display("Expected: DATA=AABBCCDD CONTROL=CAFEBABE");

        read_register(32'h00000008);

        if (s_axi_rdata == 32'hAABBCCDD) begin
            $display("PASS: DATA preserved");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: DATA = %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        read_register(32'h00000000);

        if (s_axi_rdata == 32'hCAFEBABE) begin
            $display("PASS: CONTROL preserved");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: CONTROL = %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 8
         * Final split-channel recovery.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 8: Final split-channel recovery");

        write_aw_first(
            32'h00000008,
            32'h11223344
        );

        write_w_first(
            32'h0000000C,
            32'h55667788
        );


        read_register(32'h00000008);

        if (s_axi_rdata == 32'h11223344) begin
            $display("PASS: DATA final value correct");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: DATA = %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        read_register(32'h0000000C);

        if (s_axi_rdata == 32'h55667788) begin
            $display("PASS: CONFIG final value correct");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: CONFIG = %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 9
         * Back-to-back split-channel transaction reuse.
         *
         * Reuse AW and W channels repeatedly after completed
         * independent transactions.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 9: Back-to-back split-channel reuse");


        /*
         * AW first -> W second.
         */

        write_aw_first(
            32'h00000000,
            32'h11112222
        );

        read_register(32'h00000000);

        if (s_axi_rdata == 32'h11112222) begin
            $display("PASS: AW-first transaction 1");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: CONTROL = %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * W first -> AW second.
         */

        write_w_first(
            32'h00000008,
            32'h33334444
        );

        read_register(32'h00000008);

        if (s_axi_rdata == 32'h33334444) begin
            $display("PASS: W-first transaction 1");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: DATA = %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * AW first -> W second again.
         */

        write_aw_first(
            32'h0000000C,
            32'h55556666
        );

        read_register(32'h0000000C);

        if (s_axi_rdata == 32'h55556666) begin
            $display("PASS: AW-first transaction 2");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: CONFIG = %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * W first -> AW second again.
         */

        write_w_first(
            32'h00000000,
            32'h77778888
        );

        read_register(32'h00000000);

        if (s_axi_rdata == 32'h77778888) begin
            $display("PASS: W-first transaction 2");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: CONTROL = %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 10
         * Final transaction recovery.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 10: Final transaction recovery");
        $display("Expected: CONTROL = 0F0F0F0F");

        write_aw_first(
            32'h00000000,
            32'h0F0F0F0F
        );

        read_register(32'h00000000);

        if (s_axi_rdata == 32'h0F0F0F0F) begin
            $display("PASS: final transaction completed");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: CONTROL = %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 11
         * Single-byte WSTRB writes.
         *
         * Start with CONTROL = 11223344.
         * Update only byte 0.
         *
         * WDATA = AABBCCDD
         * WSTRB = 0001
         *
         * Expected:
         * CONTROL = 112233DD
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 11: Single-byte WSTRB write");
        $display("Expected: CONTROL = 0F0F0FDD");

        write_aw_first_strobe(
            32'h00000000,
            32'hAABBCCDD,
            4'b0001
        );

        read_register(32'h00000000);

        if (s_axi_rdata == 32'h0F0F0FDD) begin
            $display("PASS: byte 0 updated correctly");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: CONTROL = %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 12
         * Upper-byte WSTRB write.
         *
         * Current CONTROL = 112233DD.
         *
         * WDATA = EEFF0011
         * WSTRB = 1000
         *
         * Expected:
         * CONTROL = EE2233DD
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 12: Upper-byte WSTRB write");
        $display("Expected: CONTROL = EE0F0FDD");

        write_aw_first_strobe(
            32'h00000000,
            32'hEEFF0011,
            4'b1000
        );

        read_register(32'h00000000);

        if (s_axi_rdata == 32'hEE0F0FDD) begin
            $display("PASS: byte 3 updated correctly");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: CONTROL = %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 13
         * Multi-byte WSTRB write.
         *
         * Current CONTROL = EE2233DD.
         *
         * WDATA = A1B2C3D4
         * WSTRB = 0110
         *
         * Bytes 1 and 2 are updated.
         *
         * Expected:
         * CONTROL = EEC2B3DD
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 13: Multi-byte WSTRB write");
        $display("Expected: CONTROL = EEB2C3DD");

        write_aw_first_strobe(
            32'h00000000,
            32'hA1B2C3D4,
            4'b0110
        );

        read_register(32'h00000000);

        if (s_axi_rdata == 32'hEEB2C3DD) begin
            $display("PASS: bytes 1 and 2 updated correctly");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: CONTROL = %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 14
         * Zero WSTRB.
         *
         * No byte lanes are enabled.
         *
         * Expected:
         * CONTROL remains EEC2B3DD.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 14: Zero WSTRB preserves register");
        $display("Expected: CONTROL = EEB2C3DD");

        write_aw_first_strobe(
            32'h00000000,
            32'hFFFFFFFF,
            4'b0000
        );

        read_register(32'h00000000);

        if (s_axi_rdata == 32'hEEB2C3DD) begin
            $display("PASS: zero WSTRB preserved CONTROL");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: CONTROL = %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 15
         * WSTRB isolation across registers.
         *
         * DATA starts as 12345678.
         *
         * Update only bytes 0 and 2.
         *
         * WDATA = AABBCCDD
         * WSTRB = 0101
         *
         * Expected:
         * DATA = 12CC56DD
         *
         * This also verifies that WSTRB affects only the targeted
         * register.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 15: WSTRB isolation across registers");
        $display("Expected: DATA = 12BB56DD");

        write_aw_first(
            32'h00000008,
            32'h12345678
        );

        write_aw_first_strobe(
            32'h00000008,
            32'hAABBCCDD,
            4'b0101
        );

        read_register(32'h00000008);

        if (s_axi_rdata == 32'h12BB56DD) begin
            $display("PASS: DATA byte enables isolated correctly");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: DATA = %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * Verify CONTROL was not affected by DATA WSTRB operation.
         * --------------------------------------------------------
         */

        read_register(32'h00000000);

        if (s_axi_rdata == 32'hEEB2C3DD) begin
            $display("PASS: CONTROL isolated from DATA WSTRB");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: CONTROL = %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 16
         * Write response backpressure.
         *
         * Generate a write response but deliberately keep
         * BREADY low for several cycles.
         *
         * Expected:
         * BVALID remains asserted and BREADY remains low.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 16: BVALID backpressure");
        $display("Expected: BVALID remains asserted while BREADY = 0");

        s_axi_awaddr  = 32'h00000000;
        s_axi_awvalid = 1'b1;

        while (!s_axi_awready) begin
            @(posedge aclk);
            #1;
        end

        @(posedge aclk);
        #1;

        s_axi_awvalid = 1'b0;

        s_axi_wdata  = 32'hCAFEBEEF;
        s_axi_wstrb  = 4'b1111;
        s_axi_wvalid = 1'b1;

        while (!s_axi_wready) begin
            @(posedge aclk);
            #1;
        end

        @(posedge aclk);
        #1;

        s_axi_wvalid = 1'b0;

        /*
         * Wait until BVALID appears.
         */
        while (!s_axi_bvalid)
            @(posedge aclk);

        /*
         * Keep BREADY low and verify that BVALID remains high.
         */
        if (!s_axi_bready && s_axi_bvalid) begin
            $display("PASS: BVALID asserted with BREADY low");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: BVALID/BREADY state unexpected");
            fail_count = fail_count + 1;
        end

        repeat (4) begin
            @(posedge aclk);
            #1;

            if (!s_axi_bvalid) begin
                $display("FAIL: BVALID dropped while BREADY was low");
                fail_count = fail_count + 1;
            end
        end

        /*
         * Finally accept the response.
         */
        s_axi_bready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_bready = 1'b0;

        @(posedge aclk);
        #1;

        if (!s_axi_bvalid) begin
            $display("PASS: BVALID cleared after BREADY");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: BVALID remained asserted after handshake");
            fail_count = fail_count + 1;
        end


        /*
         * --------------------------------------------------------
         * TEST 17
         * Read response backpressure.
         *
         * Request CONTROL while RREADY remains low.
         *
         * Expected:
         * RVALID remains asserted.
         * RDATA remains stable.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 17: RVALID backpressure");
        $display("Expected: RVALID and RDATA remain stable while RREADY = 0");

        /*
         * Establish a known CONTROL value.
         */
        write_aw_first(
            32'h00000000,
            32'h13579BDF
        );

        /*
         * Present read address.
         */
        s_axi_araddr  = 32'h00000000;
        s_axi_arvalid = 1'b1;

        while (!s_axi_arready) begin
            @(posedge aclk);
            #1;
        end

        @(posedge aclk);
        #1;

        s_axi_arvalid = 1'b0;

        /*
         * Wait for RVALID.
         */
        while (!s_axi_rvalid)
            @(posedge aclk);

        if (s_axi_rdata == 32'h13579BDF) begin
            $display("PASS: RDATA correct before response handshake");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: RDATA = %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        /*
         * Keep RREADY low and capture the response.
         */
        begin : read_backpressure_check

            reg [31:0] held_rdata;
            reg [1:0]  held_rresp;

            held_rdata = s_axi_rdata;
            held_rresp = s_axi_rresp;

            if (!s_axi_rready && s_axi_rvalid) begin
                $display("PASS: RVALID asserted with RREADY low");
                pass_count = pass_count + 1;
            end
            else begin
                $display("FAIL: RVALID/RREADY state unexpected");
                fail_count = fail_count + 1;
            end

            repeat (4) begin

                @(posedge aclk);
                #1;

                if (!s_axi_rvalid) begin
                    $display("FAIL: RVALID dropped while RREADY was low");
                    fail_count = fail_count + 1;
                end

                if (s_axi_rdata != held_rdata) begin
                    $display(
                        "FAIL: RDATA changed during stall: %h -> %h",
                        held_rdata,
                        s_axi_rdata
                    );
                    fail_count = fail_count + 1;
                end

                if (s_axi_rresp != held_rresp) begin
                    $display(
                        "FAIL: RRESP changed during stall: %b -> %b",
                        held_rresp,
                        s_axi_rresp
                    );
                    fail_count = fail_count + 1;
                end

            end

            /*
             * Accept the read response.
             */
            s_axi_rready = 1'b1;

            @(posedge aclk);
            #1;

            s_axi_rready = 1'b0;

            @(posedge aclk);
            #1;

            if (!s_axi_rvalid) begin
                $display("PASS: RVALID cleared after RREADY");
                pass_count = pass_count + 1;
            end
            else begin
                $display("FAIL: RVALID remained asserted after handshake");
                fail_count = fail_count + 1;
            end

        end


        /*
         * --------------------------------------------------------
         * TEST 18
         * Recovery after response backpressure.
         *
         * Verify that a new write and read work normally after
         * the stalled B and R responses have been accepted.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 18: Response backpressure recovery");
        $display("Expected: normal transaction works after stalls");

        write_w_first(
            32'h00000008,
            32'h2468ACE0
        );

        read_register(32'h00000008);

        if (s_axi_rdata == 32'h2468ACE0) begin
            $display("PASS: write/read recovery successful");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: DATA after recovery = %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 19
         * Verify response channels return completely to idle.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 19: Response channels idle after recovery");
        $display("Expected: BVALID = 0, RVALID = 0");

        if (!s_axi_bvalid && !s_axi_rvalid) begin
            $display("PASS: response channels returned to idle");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: BVALID=%b RVALID=%b",
                s_axi_bvalid,
                s_axi_rvalid
            );
            fail_count = fail_count + 1;
        end



        /*
         * --------------------------------------------------------
         * TEST 20
         * Write response blocks new write acceptance.
         *
         * Hold BVALID with BREADY low and verify that AWREADY
         * and WREADY remain low.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 20: Write response blocks new write acceptance");
        $display("Expected: AWREADY = 0, WREADY = 0 while BVALID = 1");

        s_axi_awaddr  = 32'h00000000;
        s_axi_awvalid = 1'b1;

        while (!s_axi_awready) begin
            @(posedge aclk);
            #1;
        end

        @(posedge aclk);
        #1;

        s_axi_awvalid = 1'b0;

        s_axi_wdata  = 32'hABCDEF01;
        s_axi_wstrb  = 4'b1111;
        s_axi_wvalid = 1'b1;

        while (!s_axi_wready) begin
            @(posedge aclk);
            #1;
        end

        @(posedge aclk);
        #1;

        s_axi_wvalid = 1'b0;

        while (!s_axi_bvalid)
            @(posedge aclk);

        if (s_axi_bvalid && !s_axi_bready) begin
            $display("PASS: BVALID held with BREADY low");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: BVALID/BREADY state unexpected");
            fail_count = fail_count + 1;
        end

        if (!s_axi_awready && !s_axi_wready) begin
            $display("PASS: write channels blocked during BVALID");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: AWREADY=%b WREADY=%b during BVALID",
                s_axi_awready,
                s_axi_wready
            );
            fail_count = fail_count + 1;
        end

        repeat (2) begin
            @(posedge aclk);
            #1;

            if (!s_axi_bvalid) begin
                $display("FAIL: BVALID dropped during stall");
                fail_count = fail_count + 1;
            end
        end

        s_axi_bready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_bready = 1'b0;

        @(posedge aclk);
        #1;

        if (!s_axi_bvalid) begin
            $display("PASS: BVALID cleared after release");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: BVALID remained asserted");
            fail_count = fail_count + 1;
        end


        /*
         * --------------------------------------------------------
         * TEST 21
         * Read response remains independent of write response.
         *
         * Hold RVALID with RREADY low and verify that the read
         * response remains stable.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 21: Read response independence");
        $display("Expected: RVALID and RDATA remain stable");

        write_aw_first(
            32'h00000000,
            32'hA5A55A5A
        );

        s_axi_araddr  = 32'h00000000;
        s_axi_arvalid = 1'b1;

        while (!s_axi_arready) begin
            @(posedge aclk);
            #1;
        end

        @(posedge aclk);
        #1;

        s_axi_arvalid = 1'b0;

        while (!s_axi_rvalid)
            @(posedge aclk);

        if (s_axi_rvalid && s_axi_rdata == 32'hA5A55A5A) begin
            $display("PASS: RVALID and RDATA correct");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: RVALID=%b RDATA=%h",
                s_axi_rvalid,
                s_axi_rdata
            );
            fail_count = fail_count + 1;
        end

        begin : read_response_hold_check

            reg [31:0] held_rdata;
            reg [1:0]  held_rresp;

            held_rdata = s_axi_rdata;
            held_rresp = s_axi_rresp;

            repeat (3) begin
                @(posedge aclk);
                #1;

                if (!s_axi_rvalid) begin
                    $display("FAIL: RVALID dropped while stalled");
                    fail_count = fail_count + 1;
                end

                if (s_axi_rdata != held_rdata) begin
                    $display(
                        "FAIL: RDATA changed: %h -> %h",
                        held_rdata,
                        s_axi_rdata
                    );
                    fail_count = fail_count + 1;
                end

                if (s_axi_rresp != held_rresp) begin
                    $display(
                        "FAIL: RRESP changed: %b -> %b",
                        held_rresp,
                        s_axi_rresp
                    );
                    fail_count = fail_count + 1;
                end
            end

        end


        /*
         * --------------------------------------------------------
         * TEST 22
         * Release write response without affecting read response.
         *
         * A stalled read response must remain valid while the
         * write side is idle.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 22: Write response release with read response stalled");
        $display("Expected: RVALID remains asserted");

        if (s_axi_rvalid && !s_axi_rready) begin
            $display("PASS: RVALID remains stalled independently");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: RVALID/RREADY state unexpected");
            fail_count = fail_count + 1;
        end

        if (!s_axi_bvalid) begin
            $display("PASS: BVALID remains idle");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: BVALID unexpectedly asserted");
            fail_count = fail_count + 1;
        end

        @(posedge aclk);
        #1;

        if (s_axi_rvalid && s_axi_rdata == 32'hA5A55A5A) begin
            $display("PASS: stalled RDATA remains valid");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: RVALID=%b RDATA=%h",
                s_axi_rvalid,
                s_axi_rdata
            );
            fail_count = fail_count + 1;
        end


        /*
         * --------------------------------------------------------
         * TEST 23
         * Final response-channel recovery.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 23: Final response-channel recovery");
        $display("Expected: RVALID clears and interface returns idle");

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;

        @(posedge aclk);
        #1;

        if (!s_axi_rvalid) begin
            $display("PASS: RVALID cleared after RREADY");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: RVALID remained asserted");
            fail_count = fail_count + 1;
        end

        if (!s_axi_bvalid) begin
            $display("PASS: BVALID remains idle");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: BVALID unexpectedly asserted");
            fail_count = fail_count + 1;
        end


        /*
         * --------------------------------------------------------
         * TEST 24
         * STATUS register read.
         *
         * STATUS is currently read-only and reset to zero.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 24: STATUS register read");
        $display("Expected: STATUS = 00000000");

        read_register(32'h00000004);

        if (s_axi_rdata == 32'h00000000 &&
            s_axi_rresp == 2'b00) begin
            $display("PASS: STATUS read returned reset value");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: STATUS RDATA=%h RRESP=%b",
                s_axi_rdata,
                s_axi_rresp
            );
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 25
         * STATUS write protection.
         *
         * A write to STATUS must not modify the register.
         * The slave still returns an OKAY write response.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 25: STATUS write protection");
        $display("Expected: STATUS remains 00000000");

        write_aw_first_strobe(
            32'h00000004,
            32'hDEADBEEF,
            4'b1111
        );

        read_register(32'h00000004);

        if (s_axi_rdata == 32'h00000000 &&
            s_axi_rresp == 2'b00) begin
            $display("PASS: STATUS write was ignored");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: STATUS changed to %h RRESP=%b",
                s_axi_rdata,
                s_axi_rresp
            );
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 26
         * Undefined register read.
         *
         * Address 0x10 is outside the defined register map.
         * The current design returns zero with an OKAY response.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 26: Undefined register read");
        $display("Expected: RDATA = 00000000, RRESP = OKAY");

        read_register(32'h00000010);

        if (s_axi_rdata == 32'h00000000 &&
            s_axi_rresp == 2'b00) begin
            $display("PASS: undefined read returned zero/OKAY");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: undefined read RDATA=%h RRESP=%b",
                s_axi_rdata,
                s_axi_rresp
            );
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 27
         * Undefined register write.
         *
         * Address 0x10 must not modify any defined register.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 27: Undefined register write");
        $display("Expected: defined registers remain unchanged");

        write_aw_first_strobe(
            32'h00000010,
            32'hA5A5A5A5,
            4'b1111
        );

        read_register(32'h00000000);

        if (s_axi_rdata == 32'hA5A55A5A) begin
            $display("PASS: CONTROL unaffected by undefined write");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: CONTROL changed to %h",
                s_axi_rdata
            );
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 28
         * Additional unmapped address protection.
         *
         * Address 0x14 must also have no effect.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 28: Additional unmapped address protection");
        $display("Expected: DATA remains 2468ACE0");

        read_register(32'h00000008);

        if (s_axi_rdata == 32'h2468ACE0) begin
            $display("PASS: DATA baseline confirmed");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: DATA baseline = %h",
                s_axi_rdata
            );
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;

        write_aw_first_strobe(
            32'h00000014,
            32'hCAFEBABE,
            4'b1111
        );

        read_register(32'h00000008);

        if (s_axi_rdata == 32'h2468ACE0) begin
            $display("PASS: DATA unaffected by unmapped write");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: DATA changed to %h",
                s_axi_rdata
            );
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 29
         * Recovery after invalid accesses.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 29: Recovery after invalid accesses");
        $display("Expected: CONTROL = 55AA33CC");

        write_w_first(
            32'h00000000,
            32'h55AA33CC
        );

        read_register(32'h00000000);

        if (s_axi_rdata == 32'h55AA33CC &&
            s_axi_rresp == 2'b00) begin
            $display("PASS: valid transaction recovered normally");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: recovery CONTROL=%h RRESP=%b",
                s_axi_rdata,
                s_axi_rresp
            );
            fail_count = fail_count + 1;
          end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 30
         * Unaligned CONTROL read.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 30: Unaligned CONTROL read");
        $display("Expected: RDATA = 00000000");

        read_register(32'h00000001);

        if (s_axi_rdata == 32'h00000000) begin
            $display("PASS: unaligned CONTROL read returned zero");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: unaligned CONTROL read returned %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 31
         * Unaligned STATUS read.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 31: Unaligned STATUS read");
        $display("Expected: RDATA = 00000000");

        read_register(32'h00000005);

        if (s_axi_rdata == 32'h00000000) begin
            $display("PASS: unaligned STATUS read returned zero");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: unaligned STATUS read returned %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 32
         * Unaligned DATA read.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 32: Unaligned DATA read");
        $display("Expected: RDATA = 00000000");

        read_register(32'h00000009);

        if (s_axi_rdata == 32'h00000000) begin
            $display("PASS: unaligned DATA read returned zero");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: unaligned DATA read returned %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 33
         * Unaligned CONFIG read.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 33: Unaligned CONFIG read");
        $display("Expected: RDATA = 00000000");

        read_register(32'h0000000D);

        if (s_axi_rdata == 32'h00000000) begin
            $display("PASS: unaligned CONFIG read returned zero");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: unaligned CONFIG read returned %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 34
         * Unaligned CONTROL write protection.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 34: Unaligned CONTROL write protection");
        $display("Expected: CONTROL remains 55AA33CC");

        write_aw_first_strobe(
            32'h00000001,
            32'hAAAAAAAA,
            4'b1111
        );

        read_register(32'h00000000);

        if (s_axi_rdata == 32'h55AA33CC) begin
            $display("PASS: unaligned CONTROL write was ignored");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: CONTROL changed to %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 35
         * Unaligned DATA write protection.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 35: Unaligned DATA write protection");
        $display("Expected: DATA remains 2468ACE0");

        write_aw_first_strobe(
            32'h00000009,
            32'hBBBBBBBB,
            4'b1111
        );

        read_register(32'h00000008);

        if (s_axi_rdata == 32'h2468ACE0) begin
            $display("PASS: unaligned DATA write was ignored");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: DATA changed to %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 36
         * Unaligned CONFIG write protection.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 36: Unaligned CONFIG write protection");
        $display("Expected: CONFIG remains 55556666");

        write_aw_first_strobe(
            32'h0000000D,
            32'hCCCCCCCC,
            4'b1111
        );

        read_register(32'h0000000C);

        if (s_axi_rdata == 32'h55556666) begin
            $display("PASS: unaligned CONFIG write was ignored");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: CONFIG changed to %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 37
         * Recovery after unaligned accesses.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 37: Recovery after unaligned accesses");
        $display("Expected: valid aligned transactions still work");

        write_w_first(
            32'h00000008,
            32'hDEADBEEF
        );

        read_register(32'h00000008);

        if (s_axi_rdata == 32'hDEADBEEF &&
            s_axi_rresp == 2'b00) begin
            $display("PASS: aligned transaction recovered normally");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: recovery DATA=%h RRESP=%b",
                s_axi_rdata,
                s_axi_rresp
            );
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 38
         *
         * Simultaneous AW and W acceptance.
         *
         * Both write channels are presented in the same cycle.
         * The register bank must accept both independently and
         * complete the write transaction normally.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 38: Simultaneous AW + W acceptance");
        $display("Expected: CONTROL = DEADBEEF");

        s_axi_awaddr  = 32'h00000000;
        s_axi_awvalid = 1'b1;

        s_axi_wdata   = 32'hDEADBEEF;
        s_axi_wstrb   = 4'b1111;
        s_axi_wvalid  = 1'b1;

        while (!(s_axi_awready && s_axi_wready))
            @(posedge aclk);

        @(posedge aclk);
        #1;

        s_axi_awvalid = 1'b0;
        s_axi_wvalid  = 1'b0;

        while (!s_axi_bvalid)
            @(posedge aclk);

        s_axi_bready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_bready = 1'b0;

        read_register(32'h00000000);

        if (s_axi_rdata == 32'hDEADBEEF &&
            s_axi_rresp == 2'b00) begin
            $display("PASS: simultaneous AW + W transaction completed");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: simultaneous write CONTROL=%h RRESP=%b",
                s_axi_rdata,
                s_axi_rresp
            );
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 39
         *
         * AWVALID held while W channel is not presented.
         *
         * The slave must accept AW only through an actual
         * AWVALID/AWREADY handshake and must not generate BVALID
         * until W data is also accepted.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 39: AWVALID held without W");
        $display("Expected: AW accepted, no BVALID until W arrives");

        s_axi_awaddr  = 32'h00000000;
        s_axi_awvalid = 1'b1;

        while (!s_axi_awready)
            @(posedge aclk);

        @(posedge aclk);
        #1;

        if (s_axi_bvalid == 1'b0) begin
            $display("PASS: AW-only hold produced no BVALID");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: BVALID asserted before W acceptance");
            fail_count = fail_count + 1;
        end

        s_axi_wdata  = 32'h13572468;
        s_axi_wstrb  = 4'b1111;
        s_axi_wvalid = 1'b1;
        s_axi_awvalid = 1'b0;

        while (!s_axi_wready)
            @(posedge aclk);

        @(posedge aclk);
        #1;

        s_axi_wvalid = 1'b0;

        while (!s_axi_bvalid)
            @(posedge aclk);

        s_axi_bready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_bready = 1'b0;

        read_register(32'h00000000);

        if (s_axi_rdata == 32'h13572468 &&
            s_axi_rresp == 2'b00) begin
            $display("PASS: held AW transaction completed correctly");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: held AW recovery CONTROL=%h RRESP=%b",
                s_axi_rdata,
                s_axi_rresp
            );
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 40
         *
         * WVALID held while AW channel is not presented.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 40: WVALID held without AW");
        $display("Expected: W accepted, no BVALID until AW arrives");

        s_axi_wdata  = 32'h2468ACE0;
        s_axi_wstrb  = 4'b1111;
        s_axi_wvalid = 1'b1;

        while (!s_axi_wready)
            @(posedge aclk);

        @(posedge aclk);
        #1;

        if (s_axi_bvalid == 1'b0) begin
            $display("PASS: W-only hold produced no BVALID");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: BVALID asserted before AW acceptance");
            fail_count = fail_count + 1;
        end

        s_axi_awaddr  = 32'h00000008;
        s_axi_awvalid = 1'b1;
        s_axi_wvalid  = 1'b0;

        while (!s_axi_awready)
            @(posedge aclk);

        @(posedge aclk);
        #1;

        s_axi_awvalid = 1'b0;

        while (!s_axi_bvalid)
            @(posedge aclk);

        s_axi_bready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_bready = 1'b0;

        read_register(32'h00000008);

        if (s_axi_rdata == 32'h2468ACE0 &&
            s_axi_rresp == 2'b00) begin
            $display("PASS: held W transaction completed correctly");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: held W recovery DATA=%h RRESP=%b",
                s_axi_rdata,
                s_axi_rresp
            );
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 41
         *
         * New write channels must remain blocked while BVALID
         * is asserted. The pending transaction must not be
         * accepted until the response is released.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 41: AW/W blocked during BVALID");
        $display("Expected: AWREADY/WREADY remain low while BVALID is active");

        /*
         * Create an outstanding write response.
         */
        s_axi_awaddr  = 32'h00000000;
        s_axi_awvalid = 1'b1;

        while (!s_axi_awready)
            @(posedge aclk);

        @(posedge aclk);
        #1;

        s_axi_awvalid = 1'b0;

        s_axi_wdata  = 32'h11112222;
        s_axi_wstrb  = 4'b1111;
        s_axi_wvalid = 1'b1;

        while (!s_axi_wready)
            @(posedge aclk);

        @(posedge aclk);
        #1;

        s_axi_wvalid = 1'b0;

        while (!s_axi_bvalid)
            @(posedge aclk);

        /*
         * Keep BREADY low so BVALID remains asserted.
         */
        s_axi_bready = 1'b0;

        /*
         * Present a second write while the first response
         * is still outstanding.
         */
        s_axi_awaddr  = 32'h00000008;
        s_axi_awvalid = 1'b1;

        s_axi_wdata  = 32'h33334444;
        s_axi_wstrb  = 4'b1111;
        s_axi_wvalid = 1'b1;

        @(posedge aclk);
        #1;

        if (s_axi_awready == 1'b0 &&
            s_axi_wready == 1'b0) begin
            $display("PASS: new write channels blocked by BVALID");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: AWREADY=%b WREADY=%b during BVALID",
                s_axi_awready,
                s_axi_wready
            );
            fail_count = fail_count + 1;
        end

        /*
         * Important:
         * Remove the second transaction BEFORE releasing BREADY.
         * Otherwise it would legitimately handshake immediately
         * after BVALID clears.
         */
        s_axi_awvalid = 1'b0;
        s_axi_wvalid  = 1'b0;

        /*
         * Release the original response.
         */
        s_axi_bready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_bready = 1'b0;

        /*
         * Verify the blocked transaction was never accepted.
         */
        read_register(32'h00000008);

        if (s_axi_rdata == 32'h2468ACE0 &&
            s_axi_rresp == 2'b00) begin
            $display("PASS: blocked write did not modify DATA");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: DATA changed to %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 42
         *
         * Recovery after READY backpressure.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 42: Recovery after write-channel blocking");
        $display("Expected: normal aligned write still works");

        write_aw_first(
            32'h0000000C,
            32'hCAFEBABE
        );

        read_register(32'h0000000C);

        if (s_axi_rdata == 32'hCAFEBABE &&
            s_axi_rresp == 2'b00) begin
            $display("PASS: write-channel recovery successful");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: recovery CONFIG=%h RRESP=%b",
                s_axi_rdata,
                s_axi_rresp
            );
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 43
         *
         * Back-to-back writes after response handshake.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 43: Back-to-back writes after response handshake");
        $display("Expected: both writes complete correctly");

        write_aw_first(
            32'h00000000,
            32'h11223344
        );

        write_w_first(
            32'h00000008,
            32'h55667788
        );

        read_register(32'h00000000);

        if (s_axi_rdata == 32'h11223344 &&
            s_axi_rresp == 2'b00) begin
            $display("PASS: first back-to-back write preserved CONTROL");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: first write CONTROL=%h RRESP=%b",
                s_axi_rdata,
                s_axi_rresp
            );
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;

        read_register(32'h00000008);

        if (s_axi_rdata == 32'h55667788 &&
            s_axi_rresp == 2'b00) begin
            $display("PASS: second back-to-back write preserved DATA");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: second write DATA=%h RRESP=%b",
                s_axi_rdata,
                s_axi_rresp
            );
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 44
         * AR blocked while RVALID is stalled.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 44: AR blocked while RVALID is stalled");
        $display("Expected: RVALID/RDATA remain stable and ARREADY stays low");

        /*
         * Start a fresh read while keeping RREADY low.
         * This intentionally creates a stalled read response.
         */
        s_axi_rready = 1'b0;
        s_axi_araddr = 32'h00000008;
        s_axi_arvalid = 1'b1;

        while (!s_axi_arready) begin
            @(posedge aclk);
            #1;
        end

        @(posedge aclk);
        #1;

        s_axi_arvalid = 1'b0;

        /*
         * Allow the registered read response to become visible.
         */
        @(posedge aclk);
        #1;

        if (s_axi_rvalid &&
            s_axi_rdata == 32'h55667788 &&
            s_axi_rresp == 2'b00) begin
            $display("PASS: read response stalled correctly");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: stalled response RVALID=%b RDATA=%h RRESP=%b",
                s_axi_rvalid,
                s_axi_rdata,
                s_axi_rresp
            );
            fail_count = fail_count + 1;
        end

        /*
         * While RVALID is stalled, ARREADY must remain low.
         */
        if (!s_axi_arready) begin
            $display("PASS: ARREADY blocked during stalled RVALID");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: ARREADY asserted during stalled RVALID");
            fail_count = fail_count + 1;
        end

        /*
         * Attempt another read while the previous response
         * is still waiting. The address must not be accepted.
         */
        s_axi_araddr = 32'h00000000;
        s_axi_arvalid = 1'b1;

        @(posedge aclk);
        #1;

        if (!s_axi_arready) begin
            $display("PASS: second AR transaction remained blocked");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: second AR transaction was accepted");
            fail_count = fail_count + 1;
        end

        /*
         * Original response must remain unchanged.
         */
        if (s_axi_rvalid &&
            s_axi_rdata == 32'h55667788 &&
            s_axi_rresp == 2'b00) begin
            $display("PASS: stalled RDATA remained stable");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: stalled response changed RVALID=%b RDATA=%h RRESP=%b",
                s_axi_rvalid,
                s_axi_rdata,
                s_axi_rresp
            );
            fail_count = fail_count + 1;
        end

        s_axi_arvalid = 1'b0;

        /*
         * Release the stalled response.
         */
        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        if (!s_axi_rvalid) begin
            $display("PASS: stalled read response released");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: RVALID remained asserted after release");
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * TEST 45
         * Write channel remains independent while RVALID is stalled.
         * --------------------------------------------------------
         */

        $display("");
        $display("TEST 45: Write during stalled read response");
        $display("Expected: write completes while RVALID/RDATA remain stable");

        /*
         * Create a fresh stalled read response.
         */
        s_axi_rready = 1'b0;
        s_axi_araddr = 32'h00000008;
        s_axi_arvalid = 1'b1;

        while (!s_axi_arready) begin
            @(posedge aclk);
            #1;
        end

        @(posedge aclk);
        #1;

        s_axi_arvalid = 1'b0;

        @(posedge aclk);
        #1;

        if (s_axi_rvalid &&
            s_axi_rdata == 32'h55667788 &&
            s_axi_rresp == 2'b00) begin
            $display("PASS: read response is stalled");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: unable to establish stalled read RVALID=%b RDATA=%h RRESP=%b",
                s_axi_rvalid,
                s_axi_rdata,
                s_axi_rresp
            );
            fail_count = fail_count + 1;
        end

        /*
         * Capture the stalled read response.
         */

        stalled_rdata = s_axi_rdata;

        /*
         * Perform a normal write while the read response remains stalled.
         */
        write_aw_first(
            32'h00000000,
            32'hA5A55A5A
        );

        /*
         * Verify that the write completed.
         */
        if (!s_axi_bvalid) begin
            $display("PASS: write response completed normally");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: BVALID remained asserted after write");
            fail_count = fail_count + 1;
        end

        /*
         * The stalled read response must still be intact.
         */
        if (s_axi_rvalid &&
            s_axi_rdata == stalled_rdata &&
            s_axi_rresp == 2'b00) begin
            $display("PASS: stalled read response remained stable");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: read response changed RVALID=%b RDATA=%h RRESP=%b",
                s_axi_rvalid,
                s_axi_rdata,
                s_axi_rresp
            );
            fail_count = fail_count + 1;
        end

        /*
         * Release the read response.
         */
        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        if (!s_axi_rvalid) begin
            $display("PASS: stalled read response released");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: read response did not release");
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b0;


        /*
         * --------------------------------------------------------
         * Verification summary.
         * --------------------------------------------------------
         */

        $display("");
        $display("================================================");
        $display("PROJECT 38 STEP 34 VERIFICATION SUMMARY");
        $display("================================================");
        $display("PASS COUNT = %0d", pass_count);
        $display("FAIL COUNT = %0d", fail_count);

        if (fail_count == 0) begin
            $display("PROJECT 38 STEP 34 VERIFICATION: PASS");
        end
        else begin
            $display("PROJECT 38 STEP 34 VERIFICATION: FAIL");
        end

        $display("================================================");

        $finish;

    end


    /*
     * ------------------------------------------------------------
     * Waveform dump
     * ------------------------------------------------------------
     */

    initial begin

        $dumpfile("waves/axi4lite_reg_bank.vcd");

        $dumpvars(
            0,
            tb_axi4lite_reg_bank
        );

    end

endmodule

