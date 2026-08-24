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
         * Create a write and keep BREADY low.
         */

        $display("");
        $display("TEST 1: Hold write response");
        $display("Expected: BVALID remains high");

        @(negedge aclk);

        s_axi_awaddr  = 32'h00000000;
        s_axi_awvalid = 1'b1;

        s_axi_wdata   = 32'hCAFEBABE;
        s_axi_wstrb   = 4'b1111;
        s_axi_wvalid  = 1'b1;

        wait (s_axi_awready && s_axi_wready);

        @(posedge aclk);
        #1;

        s_axi_awvalid = 1'b0;
        s_axi_wvalid  = 1'b0;

        wait (s_axi_bvalid);

        if (s_axi_bvalid) begin
            $display("PASS: BVALID is asserted");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: BVALID was not asserted");
            fail_count = fail_count + 1;
        end

        if (s_axi_bresp == 2'b00) begin
            $display("PASS: write response is OKAY");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: BRESP = %b", s_axi_bresp);
            fail_count = fail_count + 1;
        end


        /*
         * TEST 2
         *
         * Leave BREADY low for another cycle.
         */

        $display("");
        $display("TEST 2: Keep BREADY low");
        $display("Expected: BVALID stays high");

        @(posedge aclk);
        #1;

        if (s_axi_bvalid) begin
            $display("PASS: BVALID held while BREADY is low");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: BVALID cleared too early");
            fail_count = fail_count + 1;
        end


        /*
         * TEST 3
         *
         * Accept the write response.
         */

        $display("");
        $display("TEST 3: Accept write response");
        $display("Expected: BVALID clears");

        s_axi_bready = 1'b1;

        @(posedge aclk);
        #1;

        if (!s_axi_bvalid) begin
            $display("PASS: BVALID cleared after BREADY");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: BVALID remained asserted");
            fail_count = fail_count + 1;
        end

        s_axi_bready = 1'b0;


        /*
         * TEST 4
         *
         * Confirm the write was stored.
         */

        $display("");
        $display("TEST 4: Verify CONTROL after write");
        $display("Expected: CAFEBABE");

        read_register(32'h00000000);

        if (s_axi_rdata == 32'hCAFEBABE) begin
            $display("PASS: CONTROL = CAFEBABE");
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
         * TEST 5
         *
         * Generate a read response while RREADY is low.
         */

        $display("");
        $display("TEST 5: Hold read response");
        $display("Expected: RVALID remains high");

        read_register(32'h00000000);

        if (s_axi_rvalid) begin
            $display("PASS: RVALID is asserted");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: RVALID was not asserted");
            fail_count = fail_count + 1;
        end

        if (s_axi_rdata == 32'hCAFEBABE) begin
            $display("PASS: read data is CAFEBABE");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: read data = %h", s_axi_rdata);
            fail_count = fail_count + 1;
        end


        /*
         * TEST 6
         *
         * Leave RREADY low for another cycle.
         */

        $display("");
        $display("TEST 6: Keep RREADY low");
        $display("Expected: RVALID stays high");

        @(posedge aclk);
        #1;

        if (s_axi_rvalid) begin
            $display("PASS: RVALID held while RREADY is low");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: RVALID cleared too early");
            fail_count = fail_count + 1;
        end


        /*
         * TEST 7
         *
         * Accept the read response.
         */

        $display("");
        $display("TEST 7: Accept read response");
        $display("Expected: RVALID clears");

        s_axi_rready = 1'b1;

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

        s_axi_rready = 1'b0;


        /*
         * Summary.
         */

        $display("");
        $display("================================================");
        $display("PROJECT 38 STEP 8 VERIFICATION SUMMARY");
        $display("================================================");
        $display("PASS COUNT = %0d", pass_count);
        $display("FAIL COUNT = %0d", fail_count);

        if (fail_count == 0) begin
            $display("PROJECT 38 STEP 8 VERIFICATION: PASS");
        end
        else begin
            $display("PROJECT 38 STEP 8 VERIFICATION: FAIL");
        end

        $display("================================================");

        $finish;

    end
    initial begin
        $dumpfile("waves/axi4lite_reg_bank.vcd");
        $dumpvars(0, tb_axi4lite_reg_bank);
    end

endmodule
