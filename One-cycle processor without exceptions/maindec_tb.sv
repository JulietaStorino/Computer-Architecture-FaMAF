module maindec_tb();
	 logic [10:0]Op;
	 logic Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch;
	 logic [1:0] ALUOp;
	 
	 logic [8:0] recived;
	 logic [3:0] errors = 4'b0000, index = 4'b0000;
	 logic [19:0] input_output [0:14] = '{20'b11111000010_011110000,
														20'b11111000000_110001000,
														20'b10110100000_100000101,
														20'b10110100001_100000101,
														20'b10110100010_100000101,
														20'b10110100011_100000101,
														20'b10110100100_100000101,
														20'b10110100101_100000101,
														20'b10110100110_100000101,
														20'b10110100111_100000101,
														20'b10001011000_000100010,
														20'b11001011000_000100010,
														20'b10001010000_000100010,
														20'b10101010000_000100010,
														20'b11111111111_000000000};
	 
	maindec dut(Op, Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp);
	
	always begin
		if (index !== 14) begin
			Op = input_output[index][19:9];
			#5ns;
			recived = {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp};
			if(recived !== input_output[index][8:0])
				begin
					$display("Error: input %d, %d (recived) !== %d (expected)", index, recived, input_output[index][8:0]);
					errors++;
				end				
			index++;
			#5ns;
		end
		else begin
			$display("15 tests completed with %d errors", errors);
			$stop;
		end
	end
endmodule
		