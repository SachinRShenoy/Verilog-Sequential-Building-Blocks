`timescale 1ns/1ps

module tb_fifo;

    // Parameters matching the DUT (Device Under Test)
    parameter N = 32;
    parameter depth = 3;
    localparam ACTUAL_DEPTH = 1 << depth; // 2^3 = 8

    // Testbench signals
    reg clk;
    reg reset;
    reg wr_en;
    reg rd_en;
    reg [N-1:0] din;
    
    wire [N-1:0] dout;
    wire full;
    wire empty;

    integer i;

    // Instantiate the DUT
    fifo #(
        .N(N),
        .depth(depth)
    ) uut (
        .clk(clk),
        .reset(reset),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    // Clock Generation (10ns period -> 100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus process
    initial begin
        // Optional: Dump waves for GTKWave
        $dumpfile("fifo_waves.vcd");
        $dumpvars(0, tb_fifo);

        // 1. Initialize Inputs
        reset = 0;
        wr_en = 0;
        rd_en = 0;
        din = 0;

        // 2. Apply Active-High Reset
        $display("--- Applying Reset ---");
        #15 reset = 1;
        #10 reset = 0;
        #10;

        // 3. Test: Fill the FIFO completely
        $display("--- Test 1: Fill the FIFO ---");
        for (i = 0; i < ACTUAL_DEPTH; i = i + 1) begin
            @(posedge clk);
            wr_en = 1;
            din = (i + 1) * 1111; // Write dummy data (1111, 2222, 3333...)
        end
        @(posedge clk);
        wr_en = 0;
        #10;

        // 4. Test: Overflow attempt (Write when full)
        $display("--- Test 2: Attempt to write to FULL FIFO ---");
        @(posedge clk);
        wr_en = 1;
        din = 32'hDEADBEEF; // This should be ignored by the FIFO
        @(posedge clk);
        wr_en = 0;
        #20;

        // 5. Test: Empty the FIFO completely
        $display("--- Test 3: Empty the FIFO ---");
        for (i = 0; i < ACTUAL_DEPTH; i = i + 1) begin
            @(posedge clk);
            rd_en = 1;
        end
        @(posedge clk);
        rd_en = 0;
        #10;

        // 6. Test: Underflow attempt (Read when empty)
        $display("--- Test 4: Attempt to read from EMPTY FIFO ---");
        @(posedge clk);
        rd_en = 1; // This should not increment the read pointer
        @(posedge clk);
        rd_en = 0;
        #20;

        // 7. Test: Simultaneous Read and Write
        $display("--- Test 5: Simultaneous Read and Write ---");
        // Pre-fill with one item first so we have something to read
        @(posedge clk);
        wr_en = 1; din = 32'hAAAA_AAAA;
        @(posedge clk);
        
        // Write a new item while reading the old one
        wr_en = 1; din = 32'hBBBB_BBBB;
        rd_en = 1;
        @(posedge clk);
        
        // Stop reading and writing
        wr_en = 0; rd_en = 0;
        #20;

        $display("--- Simulation Complete ---");
        $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time=%0t | reset=%b | wr=%b rd=%b | din=%0d | dout=%0d | empty=%b full=%b", 
                 $time, reset, wr_en, rd_en, din, dout, empty, full);
    end

endmodule