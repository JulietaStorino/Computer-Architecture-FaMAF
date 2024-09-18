module regfile_tb();
	logic clk, we3 = 0;
	logic [1:0] test = 2'b0; // 0 = read registers, 1 = write registers, 2 = XZR writing
	logic [4:0] ra1 = 4'b0, ra2 = 4'b0, wa3 = 4'b0;
	logic [6:0] errors = 6'b0;
	logic [31:0] vectornum = 34'b0;
	logic [63:0] wd3 = 64'b0, rd1, rd2;
	
	regfile dut(clk, we3, ra1, ra2, wa3, wd3, rd1, rd2);
	
	always begin
		clk = 1; #5ns; clk = 0; #5ns;
	end

	always begin
		if (test == 0) begin // POSEDGE
				ra1 = vectornum; ra2 = vectornum;
			end
		else if (test == 1) begin
				we3 = 1;
				ra1 = vectornum;
				ra2 = vectornum;
				wa3 = vectornum;
				wd3 = $random;
			end
		else if (test == 2) begin 
				we3 = ~we3;
				ra1 = 5'b11111;
				ra2 = 5'b11111;
				wa3 = 5'b11111;
			end
		#5ns;
		
		if (test == 0 && (rd1 !== vectornum || rd2 !== vectornum)) begin// NEGEDGE
				$display("READ ERROR: Needs to be %d == %d == %d (register %d)", vectornum, rd1, rd2, vectornum);
				errors++;
			end
		else if (test == 1 && (rd1 !== wd3 || rd2 !== wd3)) begin
				$display("WRITE ERROR: Needs to be %d == %d == %d (register %d)", wd3, rd1, rd2, vectornum);
				errors++;
			end
		else if (test == 2 && (rd1 !== 64'h0 || rd2 !== 64'h0)) begin
				$display("WRITE ERROR: Register XZR = %d (rd1), Register XZR = %d (rd2)", rd1, rd2);
				errors++;
			end
		if (test == 2 && vectornum == 1) begin
				$display("64 tests completed with %d errors", errors);
				$stop;
			end
		if (vectornum == 30)
			begin
				test++;
				vectornum = 0;
			end
		else vectornum++;
		#5ns;
	end
endmodule
