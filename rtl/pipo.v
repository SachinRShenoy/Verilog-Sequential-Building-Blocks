`timescale 1ns/1ps

module pipo #(parameter N = 32)
				(input wire [N-1:0] din,
				input wire load,
				input wire clk,
				input wire reset,
				output [N-1:0] dout);
				
	reg [N-1:0] shift_reg;
	
	assign dout = shift_reg;
	
	always @(posedge clk) 
	begin
		if(reset)
			shift_reg <= {N{0}};
		else if(load)
			shift_reg <= din;
	end
	
endmodule