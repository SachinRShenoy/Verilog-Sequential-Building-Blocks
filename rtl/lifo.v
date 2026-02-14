`timescale 1ns/1ps

module lifo #(parameter N = 32,
				  parameter depth = 3)
				 (input wire clk,
				  input wire reset,
				  
				  input wire wr_en,
				  input wire rd_en,
				  
				  input [N-1:0] din,
				  output reg [N-1:0] dout,
				  
				  output wire full,
				  output wire empty);
		
		localparam DEPTH = 2**depth;
		
		reg [depth:0] top;
		reg [N-1:0] mem [0:DEPTH-1];
		
		assign full = (top == DEPTH);
		assign empty = (top == 0);
		
		always @(posedge clk or posedge reset)
		begin
			if(reset)
			begin
				dout <= 0;
				top <= 0;
			end
			
			else
			begin
				case ({(wr_en && !full),(rd_en && !empty)})
					2'b01:begin
							dout <= mem[top-1];
							top <= top - 1'b1;
							end
					2'b10:begin
							mem[top] <= din;
							top <= top + 1'b1;
							end
					2'b11:begin
							dout <= mem[top-1];
                      		mem[top-1] <= din;
							top <= top;
							end
					default : top <= top;
				endcase
			end
		end
		
		
endmodule				  