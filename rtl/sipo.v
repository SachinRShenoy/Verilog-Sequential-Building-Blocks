`timescale 1ns/1ps

module sipo #(parameter N = 32)
				(input wire din,
				input wire clk,
				input wire en,
				input wire reset,
				output [N-1:0] dout);
				
	reg [N-1:0] shift_reg;
	
	assign dout = shift_reg;
	
	always @(posedge clk)
	begin
		if(reset)
			shift_reg <= {N{0}};
		else if(en)
			shift_reg <= {shift_reg[N-2:0],din};
	end
	
endmodule