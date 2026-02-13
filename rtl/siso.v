`timescale 1ns/1ps

module siso #(parameter N = 32)
				(input wire din,
				input wire clk,
				input wire en,
				input wire reset,
				output dout);
				
	reg [N-1:0] shift_reg;
	
	assign dout = shift_reg[N-1];
	
	always @(posedge clk)
	begin
		if(reset)
			shift_reg <= {N{1'b0}};
		else if(en)
			shift_reg <= {shift_reg[N-2:0],din};
	end
	
endmodule