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
         * Verification summary.
         * --------------------------------------------------------
         */

        $display("");
        $display("================================================");
        $display("PROJECT 38 STEP 24 VERIFICATION SUMMARY");
        $display("================================================");
        $display("PASS COUNT = %0d", pass_count);
        $display("FAIL COUNT = %0d", fail_count);

        if (fail_count == 0) begin
            $display("PROJECT 38 STEP 24 VERIFICATION: PASS");
        end
        else begin
            $display("PROJECT 38 STEP 24 VERIFICATION: FAIL");
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

