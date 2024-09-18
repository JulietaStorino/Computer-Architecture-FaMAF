module execute #(parameter N = 64)
					(input logic AluSrc,
					 input logic [3:0] AluControl,
					 input logic [N-1:0] PC_E, signImm_E, readData1_E, readData2_E,
					 output logic [N-1:0] PCBranch_E, aluResult_E, writeData_E,
					 output logic zero_E);
	
	logic [N-1:0] ExtSignImm_E, selectedData_E;
	
	mux2 #(N) MUX(readData2_E, signImm_E, AluSrc, selectedData_E);
	alu #(N) ALU(readData1_E, selectedData_E, AluControl, aluResult_E, zero_E);
	sl2 #(N) SL2(signImm_E, ExtSignImm_E);
	adder #(N) ADD(ExtSignImm_E, PC_E, PCBranch_E);
	
	assign writeData_E = readData2_E;

endmodule
