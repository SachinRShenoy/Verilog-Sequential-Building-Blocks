`timescale 1ns/1ps

module piso #(parameter N = 32)
				(input wire [N-1:0] din,
				input wire load,
				input wire en,
				input wire clk,
				input wire reset,
				output dout);
				
	reg [N-1:0] shift_reg;
	
	assign dout = shift_reg[N-1];
	
	always @(posedge clk)
	begin
		if(reset)
			shift_reg <= {N{0}};
		else if(load)
			shift_reg <= din;
		else if(en)
			shift_reg <= {1'b0, shift_reg[`N-1:1]};
	end
	
endmodule