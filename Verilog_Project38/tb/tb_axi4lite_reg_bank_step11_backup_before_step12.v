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
         * Perform several writes one after another.
         */

        $display("");
        $display("TEST 1: Back-to-back register writes");
        $display("Expected: all written values are retained");

        write_register(
            32'h00000000,
            32'h11111111,
            4'b1111
        );

        write_register(
            32'h00000008,
            32'h22222222,
            4'b1111
        );

        write_register(
            32'h0000000C,
            32'h33333333,
            4'b1111
        );

        read_register(32'h00000000);

        if (s_axi_rdata == 32'h11111111) begin
            $display("PASS: CONTROL = 11111111");
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


        read_register(32'h00000008);

        if (s_axi_rdata == 32'h22222222) begin
            $display("PASS: DATA = 22222222");
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

        if (s_axi_rdata == 32'h33333333) begin
            $display("PASS: CONFIG = 33333333");
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
         * TEST 2
         *
         * Perform consecutive writes to the same register.
         */

        $display("");
        $display("TEST 2: Consecutive writes to CONTROL");
        $display("Expected: latest value is retained");

        write_register(
            32'h00000000,
            32'hAAAAAAAA,
            4'b1111
        );

        write_register(
            32'h00000000,
            32'hBBBBBBBB,
            4'b1111
        );

        read_register(32'h00000000);

        if (s_axi_rdata == 32'hBBBBBBBB) begin
            $display("PASS: latest CONTROL value retained");
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
         * TEST 3
         *
         * Check a partial write after several transactions.
         */

        $display("");
        $display("TEST 3: Partial write after consecutive transactions");
        $display("Expected: CONTROL = BBBBBB55");

        write_register(
            32'h00000000,
            32'h00000055,
            4'b0001
        );

        read_register(32'h00000000);

        if (s_axi_rdata == 32'hBBBBBB55) begin
            $display("PASS: partial CONTROL write worked");
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
         * TEST 4
         *
         * Make sure the other registers were not affected.
         */

        $display("");
        $display("TEST 4: Register independence");
        $display("Expected: DATA = 22222222, CONFIG = 33333333");

        read_register(32'h00000008);

        if (s_axi_rdata == 32'h22222222) begin
            $display("PASS: DATA retained its value");
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

        if (s_axi_rdata == 32'h33333333) begin
            $display("PASS: CONFIG retained its value");
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
         * TEST 5
         *
         * Finish with another complete write/read transaction.
         */

        $display("");
        $display("TEST 5: Final write and read");
        $display("Expected: DATA = DEADBEEF");

        write_register(
            32'h00000008,
            32'hDEADBEEF,
            4'b1111
        );

        read_register(32'h00000008);

        if (s_axi_rdata == 32'hDEADBEEF) begin
            $display("PASS: final DATA transaction completed");
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
         * Summary.
         */

        $display("");
        $display("================================================");
        $display("PROJECT 38 STEP 11 VERIFICATION SUMMARY");
        $display("================================================");
        $display("PASS COUNT = %0d", pass_count);
        $display("FAIL COUNT = %0d", fail_count);

        if (fail_count == 0) begin
            $display("PROJECT 38 STEP 11 VERIFICATION: PASS");
        end
        else begin
            $display("PROJECT 38 STEP 11 VERIFICATION: FAIL");
        end

        $display("================================================");

        $finish;

    end
    initial begin
        $dumpfile("waves/axi4lite_reg_bank.vcd");
        $dumpvars(0, tb_axi4lite_reg_bank);
    end

endmodule
