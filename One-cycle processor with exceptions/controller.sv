// CONTROLLER

module controller(input logic reset, ExtIRQ, ExcAck,
						input logic [10:0] instr,
						output logic [3:0] AluControl, EStatus,
						output logic [2:0] AluSrc,
						output logic reg2loc, regWrite, Branch,
											memtoReg, memRead, memWrite, ExtIAck, ERet, Exc);
											
	logic [1:0] AluOp_s;
											
	maindec 	decPpal 	(.reset(reset),
							.ExtIRQ(ExtIRQ),
							.Op(instr), 
							.Reg2Loc(reg2loc), 
							.ALUSrc(AluSrc), 
							.MemtoReg(memtoReg), 
							.RegWrite(regWrite), 
							.MemRead(memRead), 
							.MemWrite(memWrite), 
							.Branch(Branch),
							.ERet(ERet),
							.Exc(Exc),
							.ALUOp(AluOp_s),
							.Status(EStatus));	
						
	aludec 	decAlu 	(.funct(instr), 
							.aluop(AluOp_s), 
							.alucontrol(AluControl));
	always_comb
	
		ExtIAck = ExcAck & ExtIRQ;
	
endmodule
