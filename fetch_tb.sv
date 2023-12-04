module fetch_tb();

	logic PCSrc_F = 0, clk, reset;
	logic [63:0] PCBranch_F, imem_addr_F;
	
	logic [2:0] errors = 3'b000;

	fetch dut(PCSrc_F, clk, reset, PCBranch_F, imem_addr_F);
	
	always begin
		clk = 1; #5ns; clk = 0; #5ns;
	end
	
	initial begin
		PCBranch_F = 64'h0123456789ABCDEF;
		reset = 1; #5ns; reset = 0;
		for (int unsigned i = 3'b000; i < 13; i+=4) begin
			if (imem_addr_F !== i) begin
				$display("Error: %d (recived) !== %d (expected)", imem_addr_F, i);
				errors++;
			end
			#10ns;
		end

		PCSrc_F = 1; #10ns;
			if(imem_addr_F !== PCBranch_F) begin
				$display("Error: %d (recived) !== %d (expected)", imem_addr_F, PCBranch_F);
				errors++;
			end
		$display("5 tests completed with %d errors", errors);
		$stop;
	end
	
endmodule	
			