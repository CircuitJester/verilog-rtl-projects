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

        /*
         * Start with reset asserted.
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


        /*
         * TEST 1
         *
         * Check register values while reset is active.
         */

        $display("");
        $display("TEST 1: Reset register values");
        $display("Expected: all registers = 00000000");

        #20;

        if (dut.control_reg == 32'h00000000) begin
            $display("PASS: CONTROL reset to zero");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: CONTROL = %h", dut.control_reg);
            fail_count = fail_count + 1;
        end

        if (dut.status_reg == 32'h00000000) begin
            $display("PASS: STATUS reset to zero");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: STATUS = %h", dut.status_reg);
            fail_count = fail_count + 1;
        end

        if (dut.data_reg == 32'h00000000) begin
            $display("PASS: DATA reset to zero");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: DATA = %h", dut.data_reg);
            fail_count = fail_count + 1;
        end

        if (dut.config_reg == 32'h00000000) begin
            $display("PASS: CONFIG reset to zero");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: CONFIG = %h", dut.config_reg);
            fail_count = fail_count + 1;
        end


        /*
         * TEST 2
         *
         * Check response signals during reset.
         */

        $display("");
        $display("TEST 2: Reset AXI response signals");
        $display("Expected: BVALID and RVALID are low");

        if (!s_axi_bvalid) begin
            $display("PASS: BVALID reset to zero");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: BVALID is high during reset");
            fail_count = fail_count + 1;
        end

        if (!s_axi_rvalid) begin
            $display("PASS: RVALID reset to zero");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: RVALID is high during reset");
            fail_count = fail_count + 1;
        end

        if (s_axi_bresp == 2'b00) begin
            $display("PASS: BRESP reset to OKAY");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: BRESP = %b", s_axi_bresp);
            fail_count = fail_count + 1;
        end

        if (s_axi_rresp == 2'b00) begin
            $display("PASS: RRESP reset to OKAY");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: RRESP = %b", s_axi_rresp);
            fail_count = fail_count + 1;
        end


        /*
         * TEST 3
         *
         * Release reset and check that the interface becomes ready.
         */

        $display("");
        $display("TEST 3: Release reset");
        $display("Expected: AXI interface becomes ready");

        aresetn = 1'b1;

        @(posedge aclk);
        #1;

        if (s_axi_awready) begin
            $display("PASS: AWREADY asserted");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: AWREADY not asserted");
            fail_count = fail_count + 1;
        end

        if (s_axi_wready) begin
            $display("PASS: WREADY asserted");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: WREADY not asserted");
            fail_count = fail_count + 1;
        end

        if (s_axi_arready) begin
            $display("PASS: ARREADY asserted");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: ARREADY not asserted");
            fail_count = fail_count + 1;
        end


        /*
         * TEST 4
         *
         * Write a value after reset and read it back.
         */

        $display("");
        $display("TEST 4: Write after reset");
        $display("Expected: CONTROL = 55AA55AA");

        write_register(
            32'h00000000,
            32'h55AA55AA,
            4'b1111
        );

        read_register(32'h00000000);

        if (s_axi_rdata == 32'h55AA55AA) begin
            $display("PASS: CONTROL = 55AA55AA");
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
         * Assert reset again and make sure the register clears.
         */

        $display("");
        $display("TEST 5: Reset after register activity");
        $display("Expected: CONTROL returns to zero");

        aresetn = 1'b0;

        @(posedge aclk);
        #1;

        if (dut.control_reg == 32'h00000000) begin
            $display("PASS: CONTROL cleared by reset");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: CONTROL = %h", dut.control_reg);
            fail_count = fail_count + 1;
        end

        if (!s_axi_bvalid && !s_axi_rvalid) begin
            $display("PASS: AXI responses cleared by reset");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: AXI response still active");
            fail_count = fail_count + 1;
        end


        /*
         * Summary.
         */

        $display("");
        $display("================================================");
        $display("PROJECT 38 STEP 9 VERIFICATION SUMMARY");
        $display("================================================");
        $display("PASS COUNT = %0d", pass_count);
        $display("FAIL COUNT = %0d", fail_count);

        if (fail_count == 0) begin
            $display("PROJECT 38 STEP 9 VERIFICATION: PASS");
        end
        else begin
            $display("PROJECT 38 STEP 9 VERIFICATION: FAIL");
        end

        $display("================================================");

        $finish;

    end
    initial begin
        $dumpfile("waves/axi4lite_reg_bank.vcd");
        $dumpvars(0, tb_axi4lite_reg_bank);
    end

endmodule
