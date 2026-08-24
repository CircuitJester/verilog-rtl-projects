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

    initial begin
        aclk = 1'b0;
        forever #5 aclk = ~aclk;
    end

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
         * Test 1: AXI write address channel.
         */
        $display("");
        $display("TEST 1: Send write address");
        $display("Expected: AWREADY accepts address 0x00000000");

        @(negedge aclk);

        s_axi_awaddr  = 32'h00000000;
        s_axi_awvalid = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_awvalid = 1'b0;

        if (s_axi_awready) begin
            $display("PASS: write address accepted");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: write address was not accepted");
            fail_count = fail_count + 1;
        end

        /*
         * Test 2: AXI write data channel.
         */
        $display("");
        $display("TEST 2: Send write data");
        $display("Expected: CONTROL receives DEADBEEF");

        @(negedge aclk);

        s_axi_wdata  = 32'hDEADBEEF;
        s_axi_wstrb  = 4'b1111;
        s_axi_wvalid = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_wvalid = 1'b0;

        if (s_axi_wready) begin
            $display("PASS: write data accepted");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: write data was not accepted");
            fail_count = fail_count + 1;
        end

        /*
         * Test 3: Write response.
         */
        $display("");
        $display("TEST 3: Verify write response");
        $display("Expected: BVALID with OKAY response");

        @(posedge aclk);
        #1;

        if (s_axi_bvalid && (s_axi_bresp == 2'b00)) begin
            $display("PASS: write response is OKAY");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: BVALID=%b BRESP=%b",
                s_axi_bvalid,
                s_axi_bresp
            );
            fail_count = fail_count + 1;
        end

        /*
         * Test 4: Complete the response.
         */
        $display("");
        $display("TEST 4: Complete write response");
        $display("Expected: BVALID clears after BREADY");

        @(negedge aclk);
        s_axi_bready = 1'b1;

        @(posedge aclk);
        #1;

        s_axi_bready = 1'b0;

        if (!s_axi_bvalid) begin
            $display("PASS: write response completed");
            pass_count = pass_count + 1;
        end
        else begin
            $display("FAIL: BVALID did not clear");
            fail_count = fail_count + 1;
        end

        /*
         * Test 5: Verify register contents.
         */
        $display("");
        $display("TEST 5: Verify CONTROL register");
        $display("Expected: DEADBEEF");

        if (dut.control_reg == 32'hDEADBEEF) begin
            $display("PASS: CONTROL register = DEADBEEF");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: CONTROL register = %h",
                dut.control_reg
            );
            fail_count = fail_count + 1;
        end

        /*
         * Summary.
         */
        $display("");
        $display("================================================");
        $display("PROJECT 38 STEP 2 VERIFICATION SUMMARY");
        $display("================================================");
        $display("PASS COUNT = %0d", pass_count);
        $display("FAIL COUNT = %0d", fail_count);

        if (fail_count == 0)
            $display("PROJECT 38 STEP 2 VERIFICATION: PASS");
        else
            $display("PROJECT 38 STEP 2 VERIFICATION: FAIL");

        $display("================================================");

        $finish;

    end

    initial begin
        $dumpfile("waves/axi4lite_reg_bank.vcd");
        $dumpvars(0, tb_axi4lite_reg_bank);
    end

endmodule
