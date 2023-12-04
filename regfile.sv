module regfile(input logic clk, we3,
					input logic [4:0] ra1, ra2, wa3,
					input logic [63:0] wd3,
					output logic [63:0] rd1, rd2);
					
	logic [63:0] registers [0:31] = '{
		64'h00, 64'h01, 64'h02, 64'h03, 64'h04, 64'h05, 64'h06, 64'h07, 64'h08, 64'h09,
		64'h0A, 64'h0B, 64'h0C, 64'h0D, 64'h0E, 64'h0F, 64'h10, 64'h11, 64'h12, 64'h13,
		64'h14, 64'h15, 64'h16, 64'h17, 64'h18, 64'h19, 64'h1A, 64'h1B, 64'h1C, 64'h1D,
		64'h1E, 64'h00};

	assign rd1 = (rd1 == '1) ? '0 : registers[ra1];
	assign rd2 = (rd2 == '1) ? '0 : registers[ra2];

	always_ff @(posedge clk)
		if (we3 == '1 && wa3 !=  '1) begin
			registers[wa3] <= wd3;
		end

endmodule

