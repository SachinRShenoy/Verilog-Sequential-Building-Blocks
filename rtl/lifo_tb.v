`timescale 1ns/1ps

module lifo_tb;

    // 1. Declare Testbench Signals
    reg clk;
    reg reset;
    reg wr_en;
    reg rd_en;
    reg [31:0] din;
    
    wire [31:0] dout;
    wire full;
    wire empty;

    // 2. Instantiate the Unit Under Test (UUT)
    lifo #(.N(32), .depth(3)) uut (
        .clk(clk),
        .reset(reset),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    // 3. Clock Generation (100MHz)
    always #5 clk = ~clk;

    // 4. Stimulus Block - ALL procedural code must be inside this block
    initial begin
        // Waveform dumping for Icarus/Questa
        $dumpfile("dump.vcd");
        $dumpvars(0, lifo_tb);
        
        // --- INITIALIZATION ---
        clk = 0;
        reset = 1;
        wr_en = 0;
        rd_en = 0;
        din = 0;

        #20 reset = 0;
        #10;

        // --- TEST CASE 1: Push (Write) until Full ---
        $display("Pushing data to LIFO...");
        repeat (8) begin
            @(posedge clk);
            wr_en = 1;
            din = din + 32'h10; // Pushes: 10, 20, 30, 40, 50, 60, 70, 80
        end
        
        // Attempt to push to a Full Stack (Should be ignored)
        @(posedge clk);
        din = 32'hDEADBEEF; 
        
        @(posedge clk);
        wr_en = 0; // Stop pushing
        #20;

        // --- TEST CASE 2: Pop (Read) until Empty ---
        $display("Popping data from LIFO...");
        repeat (8) begin
            @(posedge clk);
            rd_en = 1;
        end
        
        // Attempt to pop from an Empty Stack (Should be ignored)
        @(posedge clk);
        rd_en = 0; // Stop popping
        #20;

        // --- TEST CASE 3: Simultaneous Push and Pop ---
        $display("Testing Simultaneous Push/Pop...");
        // First, push a single item so it's not empty
        @(posedge clk);
        wr_en = 1;
        din = 32'hAAAA;
        
        // Next clock: Pop AAAA, and Push BBBB simultaneously
        @(posedge clk);
        wr_en = 1;
        rd_en = 1;
        din = 32'hBBBB;
        
        // Next clock: Turn off write, just pop the new item to verify it saved
        @(posedge clk);
        wr_en = 0;
        rd_en = 1;
        
        // Turn everything off
        @(posedge clk);
        rd_en = 0;
        #20;

        $display("Simulation Complete.");
        $finish; // Use $stop to keep the waveform window open in Questa
    end

endmodule