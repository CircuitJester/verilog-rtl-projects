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
         * Test 1
         */
        $display("");
        $display("TEST 1: Write CONTROL register");
        $display("Expected: CONTROL = DEADBEEF");

        write_register(
            32'h00000000,
            32'hDEADBEEF,
            4'b1111
        );

        if (dut.control_reg == 32'hDEADBEEF) begin
            $display("PASS: CONTROL register updated");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: CONTROL = %h",
                dut.control_reg
            );
            fail_count = fail_count + 1;
        end

        /*
         * Test 2
         */
        $display("");
        $display("TEST 2: Write DATA register");
        $display("Expected: DATA = 12345678");

        write_register(
            32'h00000008,
            32'h12345678,
            4'b1111
        );

        if (dut.data_reg == 32'h12345678) begin
            $display("PASS: DATA register updated");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: DATA = %h",
                dut.data_reg
            );
            fail_count = fail_count + 1;
        end

        /*
         * Test 3
         */
        $display("");
        $display("TEST 3: Write CONFIG register");
        $display("Expected: CONFIG = A5A5A5A5");

        write_register(
            32'h0000000C,
            32'hA5A5A5A5,
            4'b1111
        );

        if (dut.config_reg == 32'hA5A5A5A5) begin
            $display("PASS: CONFIG register updated");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: CONFIG = %h",
                dut.config_reg
            );
            fail_count = fail_count + 1;
        end

        /*
         * Test 4
         */
        $display("");
        $display("TEST 4: Partial byte write");
        $display("Expected: CONTROL becomes DEADBEAA");

        write_register(
            32'h00000000,
            32'h000000AA,
            4'b0001
        );

        if (dut.control_reg == 32'hDEADBEAA) begin
            $display("PASS: byte strobe updated only byte 0");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: CONTROL = %h",
                dut.control_reg
            );
            fail_count = fail_count + 1;
        end

        /*
         * Test 5
         */
        $display("");
        $display("TEST 5: Verify write responses");
        $display("Expected: OKAY response");

        if (s_axi_bresp == 2'b00) begin
            $display("PASS: AXI write response is OKAY");
            pass_count = pass_count + 1;
        end
        else begin
            $display(
                "FAIL: BRESP = %b",
                s_axi_bresp
            );
            fail_count = fail_count + 1;
        end

        /*
         * Summary
         */
        $display("");
        $display("================================================");
        $display("PROJECT 38 STEP 3 VERIFICATION SUMMARY");
        $display("================================================");
        $display("PASS COUNT = %0d", pass_count);
        $display("FAIL COUNT = %0d", fail_count);

        if (fail_count == 0)
            $display("PROJECT 38 STEP 3 VERIFICATION: PASS");
        else
            $display("PROJECT 38 STEP 3 VERIFICATION: FAIL");

        $display("================================================");

        $finish;

    end

    initial begin
        $dumpfile("waves/axi4lite_reg_bank.vcd");
        $dumpvars(0, tb_axi4lite_reg_bank);
    end

endmodule
