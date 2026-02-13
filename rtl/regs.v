`timescale 1ns/1ps

module regs #(parameter N = 32)
				(input clk,
				 input reset,
				 input [N-1:0]din,
				 output reg [N-1:0] q);
	always @(posedge clk)
		begin	
			if(reset)
				q <= {N{1'b0}};
			else
				q <= din;
		end
endmodule