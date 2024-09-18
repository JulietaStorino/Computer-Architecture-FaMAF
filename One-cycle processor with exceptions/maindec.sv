module maindec(input logic reset, ExtIRQ,
					input logic [10:0] Op,
					output logic Reg2Loc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ERet, Exc,
					output logic [1:0] ALUOp, ALUSrc,
					output logic [3:0] Status);
					
	logic NotAnInstr;
	
	always_comb begin
		if (reset)
		{Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, ERet, Status, NotAnInstr, Exc} = 17'b0_00_00000_00_0_0000_00;
		else begin
			casez(Op)
				// R-format (ADD, SUB, AND y ORR)
				11'b1?00_1011_000, 11'b10?0_1010_000: {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, ERet, Status, NotAnInstr} = 16'b0_00_01000_10_0_0000_0;
				// STUR
				11'b1111_1000_000: {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, ERet, Status, NotAnInstr} = 16'b1_01_00010_00_0_0000_0;
				// CBZ
				11'b1011_0100_???: {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, ERet, Status, NotAnInstr} = 16'b1_00_00001_01_0_0000_0;
				// LDUR
				11'b1111_1000_010: {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, ERet, Status, NotAnInstr} = 16'b0_01_11100_00_0_0000_0;
				// ERET
				11'b1101_0110_100: {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, ERet, Status, NotAnInstr} = 16'b0_00_00001_01_1_0000_0;
				// MRS
				11'b1101_0101_001: {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, ERet, Status, NotAnInstr} = 16'b1_10_01000_01_0_0000_0; 
				// Invalid OpCode
				default: {Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, ERet, Status, NotAnInstr} = 16'b0_00_00000_10_0_0010_1;
			endcase
			Exc = ExtIRQ | NotAnInstr;
			if (ExtIRQ) begin
				casez(Op)
					11'b???????????: Status = 4'b0001;
				endcase
			end
		end
	end
endmodule
				