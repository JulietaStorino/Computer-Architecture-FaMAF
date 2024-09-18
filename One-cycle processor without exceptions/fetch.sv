module fetch
			#(parameter N=64)
			(input logic PCSrc_F, clk, reset,
			input logic [N-1:0] PCBranch_F,
			output logic [N-1:0] imem_addr_F);
	
	logic [N-1:0] adder_out, mux2_out;

	mux2 #(N) MUX(adder_out, PCBranch_F, PCSrc_F, mux2_out);
	flopr #(N) PC(clk, reset, mux2_out, imem_addr_F);
	adder #(N) ADD(imem_addr_F, N'('h4), adder_out);

endmodule
