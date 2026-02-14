`timescale 1ns/1ps

module fifo #(
    parameter N = 32,
    parameter depth = 3 // log2 of actual depth
)(
    input wire clk,
    input wire reset,
    
    input wire wr_en,
    input wire rd_en,
    
    input [N-1:0] din,
    output reg [N-1:0] dout, 
    
    output wire full,
    output wire empty
);
    
    reg [depth-1:0] wr_ptr, rd_ptr;
    localparam DEPTH = 2**depth;
    reg [N-1:0] mem [0:(DEPTH)-1];
    
    reg [depth:0] count;
    
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            count <= 0;
            wr_ptr <= 0;
            rd_ptr <= 0;
            dout <= 0;
        end
        else begin
        
            // Write 
            if (wr_en && !full) begin
                mem[wr_ptr] <= din;
                wr_ptr <= wr_ptr + 1'b1;
            end
            
            // Read 
            if (rd_en && !empty) begin
                dout <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1'b1;
            end
          
            // Count Logic 
            case({(rd_en && !empty), (wr_en && !full)})
                2'b10: count <= count - 1'b1; // Read only
                2'b01: count <= count + 1'b1; // Write only
                default: count <= count;      // Both or neither
            endcase
        end    
    end
    
    assign full = (count == DEPTH);
    assign empty = (count == 1'b0);

endmodule