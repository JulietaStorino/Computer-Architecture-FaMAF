module execute_tb();

	logic [63:0] PC_E, signImm_E, readData1_E, readData2_E, PCBranch_E, aluResult_E, writeData_E;
	logic [3:0] AluControl;
	logic zero_E, AluSrc;
	
	logic [192:0] received;
	logic [3:0] errors = 4'b0000;
	logic [453:0] input_output [0:10] = '{ {1'b0, 4'b0000, 64'h00, 64'h00, 64'h00, 64'h04, 64'h000, 64'h000, 64'h04, 1'b1},
														{1'b1, 4'b0000, 64'h04, 64'h04, 64'h04, 64'h08, 64'h014, 64'h004, 64'h08, 1'b0},
														{1'b0, 4'b0001, 64'h08, 64'h08, 64'h08, 64'h0C, 64'h028, 64'h00C, 64'h0C, 1'b0},
														{1'b1, 4'b0001, 64'h0C, 64'h0C, 64'h0C, 64'h00, 64'h03C, 64'h00C, 64'h00, 1'b0},
														{1'b0, 4'b0010, 64'h10, 64'h10, 64'h10, 64'h14, 64'h050, 64'h024, 64'h14, 1'b0},
														{1'b1, 4'b0010, 64'h58, 64'h58, 64'h58, 64'h50, 64'h1B8, 64'h0B0, 64'h50, 1'b0},
														{1'b0, 4'b0110, 64'h5C, 64'h5C, 64'h5C, 64'h54, 64'h1CC, 64'h008, 64'h54, 1'b0},
														{1'b1, 4'b0110, 64'h60, 64'h60, 64'h60, 64'h60, 64'h1E0, 64'h000, 64'h60, 1'b1},
														{1'b0, 4'b0111, 64'h64, 64'h64, 64'h64, 64'h6C, 64'h1F4, 64'h06C, 64'h6C, 1'b0},
														{1'b1, 4'b0111, 64'h68, 64'h68, 64'h68, 64'h60, 64'h208, 64'h068, 64'h60, 1'b0},
														{1'b0, 4'b0111, 64'h6C, 64'h6C, 64'h6C, 64'h6C, 64'h21C, 64'h06C, 64'h6C, 1'b0}};

	execute dut(AluSrc, AluControl, PC_E, signImm_E, readData1_E, readData2_E, PCBranch_E, aluResult_E, writeData_E, zero_E);
	
	initial begin
		for (int unsigned i = 4'b0; i < 11; i++) begin
			AluSrc = input_output[i][453];
			AluControl = input_output[i][452:449];
			PC_E = input_output[i][448:385];
			signImm_E = input_output[i][384:321];
			readData1_E = input_output[i][320:257];
			readData2_E = input_output[i][256:193];
			#5ns;
			
			received = {PCBranch_E, aluResult_E, writeData_E, zero_E};
			if(received !== input_output[i][192:0]) begin
				$display("Error: %d (recived) !== %d (expected) (Test: %d, %h, %h, %h, %b)", received, input_output[i][192:0], i, PCBranch_E, aluResult_E, writeData_E, zero_E);
				errors++;
			end
			#5ns;
		end
		$display("11 tests completed with %d errors", errors);
		$stop;
	end
	
endmodule
