`timescale 1ns/1ps

module tb_axi4lite_reg_bank;

    reg         aclk;
    reg         aresetn;

    reg  [31:0] s_axi_awaddr;
    reg         s_axi_awvalid;
    wire        s_axi_awready;

    reg  [31:0] s_axi_wdata;
    reg  [3:0]  s_axi_wstrb;
    reg         s_axi_wvalid;
    wire        s_axi_wready;

    wire [1:0]  s_axi_bresp;
    wire        s_axi_bvalid;
    reg         s_axi_bready;

    reg  [31:0] s_axi_araddr;
    reg         s_axi_arvalid;
    wire        s_axi_arready;

    wire [31:0] s_axi_rdata;
    wire [1:0]  s_axi_rresp;
    wire        s_axi_rvalid;
    reg         s_axi_rready;

    integer pass_count;
    integer fail_count;


    axi4lite_reg_bank dut (
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
     * Clock.
     */

    initial begin
        aclk = 1'b0;
        forever #5 aclk = ~aclk;
    end


    /*
     * AXI4-Lite write helper.
     */

    task write_register;
        input [31:0] address;
        input [31:0] data;
        input [3:0]  strobe;

        begin

            @(negedge aclk);

            s_axi_awaddr  = address;
            s_axi_awvalid = 1'b1;

            s_axi_wdata   = data;
            s_axi_wstrb   = strobe;
            s_axi_wvalid  = 1'b1;

            wait (s_axi_awready && s_axi_wready);

            @(posedge aclk);
            #1;

            s_axi_awvalid = 1'b0;
            s_axi_wvalid  = 1'b0;

            wait (s_axi_bvalid);

            s_axi_bready = 1'b1;

            @(posedge aclk);
            #1;

            s_axi_bready = 1'b0;

        end
    endtask


    /*
     * AXI4-Lite read helper.
     */

    task read_register;
        input [31:0] address;

        begin

            @(negedge aclk);

            s_axi_araddr  = address;
            s_axi_arvalid = 1'b1;

            wait (s_axi_arready);

            @(posedge aclk);
            #1;

            s_axi_arvalid = 1'b0;

            wait (s_axi_rvalid);

        end
    endtask


    /*
     * Main test.
     */

    initial begin

        pass_count = 0;
        fail_count = 0;

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


        /*
         * TEST 1
         *
         * Address arrives before write data.
         */

        $display("");
        $display("TEST 1: Address arrives before write data");
        $display("Expected: CONTROL = 11223344");

        @(negedge aclk);

        s_axi_awaddr  = 32'h00000000;
        s_axi_awvalid = 1'b1;

        wait (s_axi_awready);

        @(posedge aclk);
        #1;

        s_axi_awvalid = 1'b0;

        @(negedge aclk);

        s_axi_wdata   = 32'h11223344;
        s_axi_wstrb   = 4'b1111;
        s_axi_wvalid  = 1'b1;

        wait (s_axi_wready);

        @(posedge aclk);
        #1;

        s_axi_wvalid = 1'b0;

        wait (s_axi_bvalid);

        if (s_axi_bresp == 2'b00) begin
            $display("PASS: address-first write returned OKAY");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: address-first response = %b",
                s_axi_bresp
            );
            fail_count = fail_count + 1;
        end

        s_axi_bready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_bready = 1'b0;


        /*
         * TEST 2
         *
         * Write data arrives before address.
         */

        $display("");
        $display("TEST 2: Write data arrives before address");
        $display("Expected: DATA = 55667788");

        @(negedge aclk);

        s_axi_wdata   = 32'h55667788;
        s_axi_wstrb   = 4'b1111;
        s_axi_wvalid  = 1'b1;

        wait (s_axi_wready);

        @(posedge aclk);
        #1;

        s_axi_wvalid = 1'b0;

        @(negedge aclk);

        s_axi_awaddr  = 32'h00000008;
        s_axi_awvalid = 1'b1;

        wait (s_axi_awready);

        @(posedge aclk);
        #1;

        s_axi_awvalid = 1'b0;

        wait (s_axi_bvalid);

        if (s_axi_bresp == 2'b00) begin
            $display("PASS: data-first write returned OKAY");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: data-first response = %b",
                s_axi_bresp
            );
            fail_count = fail_count + 1;
        end

        s_axi_bready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_bready = 1'b0;


        /*
         * TEST 3
         *
         * Normal address and data transfer.
         */

        $display("");
        $display("TEST 3: Address and data arrive together");
        $display("Expected: CONFIG = A5A5A5A5");

        write_register(
            32'h0000000C,
            32'hA5A5A5A5,
            4'b1111
        );

        $display("PASS: normal write completed");
        pass_count = pass_count + 1;


        /*
         * TEST 4
         *
         * Read back the address-first write.
         */

        $display("");
        $display("TEST 4: Read back address-first CONTROL");
        $display("Expected: 11223344");

        read_register(32'h00000000);

        if (s_axi_rdata == 32'h11223344) begin
            $display("PASS: CONTROL = 11223344");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: CONTROL = %h",
                s_axi_rdata
            );
            fail_count = fail_count + 1;
        end

        if (s_axi_rresp == 2'b00) begin
            $display("PASS: CONTROL read response is OKAY");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: CONTROL read response = %b",
                s_axi_rresp
            );
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * TEST 5
         *
         * Read back the data-first write.
         */

        $display("");
        $display("TEST 5: Read back data-first DATA");
        $display("Expected: 55667788");

        read_register(32'h00000008);

        if (s_axi_rdata == 32'h55667788) begin
            $display("PASS: DATA = 55667788");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: DATA = %h",
                s_axi_rdata
            );
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * TEST 6
         *
         * Read back the normal write.
         */

        $display("");
        $display("TEST 6: Read back normal CONFIG");
        $display("Expected: A5A5A5A5");

        read_register(32'h0000000C);

        if (s_axi_rdata == 32'hA5A5A5A5) begin
            $display("PASS: CONFIG = A5A5A5A5");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: CONFIG = %h",
                s_axi_rdata
            );
            fail_count = fail_count + 1;
        end

        s_axi_rready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_rready = 1'b0;


        /*
         * Summary.
         */

        $display("");
        $display("================================================");
        $display("PROJECT 38 STEP 6 VERIFICATION SUMMARY");
        $display("================================================");

        $display(
            "PASS COUNT = %0d",
            pass_count
        );

        $display(
            "FAIL COUNT = %0d",
            fail_count
        );

        if (fail_count == 0) begin
            $display("");
            $display(
                "PROJECT 38 STEP 6 VERIFICATION: PASS"
            );
        end
        else begin
            $display("");
            $display(
                "PROJECT 38 STEP 6 VERIFICATION: FAIL"
            );
        end

        $display("================================================");

        $finish;

    end


    /*
     * Waveform dump.
     */

    initial begin
        $dumpfile("waves/axi4lite_reg_bank.vcd");
        $dumpvars(0, tb_axi4lite_reg_bank);
    end

endmodule