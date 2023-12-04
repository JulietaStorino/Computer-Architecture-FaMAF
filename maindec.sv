module maindec(input logic [10:0] Op,
					output logic Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch,
					output logic [1:0] ALUOp);
	always_comb
		casez(Op)
		11'b1?00_1011_000, 11'b10?0_1010_000: // R-format (ADD, SUB, AND y ORR) 
			begin
				Reg2Loc = 0;
				ALUSrc = 0;
				MemtoReg = 0;
				RegWrite = 1;
				MemRead = 0;
				MemWrite = 0;
				Branch = 0;
				ALUOp = 2'b10;
			end
			
		11'b1111_1000_000: // STUR
			begin
				Reg2Loc = 1;
				ALUSrc = 1;
				MemtoReg = 0;
				RegWrite = 0;
				MemRead = 0;
				MemWrite = 1;
				Branch = 0;
				ALUOp = 2'b00;
			end
		
		11'b101_1010_0???: // CBZ
			begin
				Reg2Loc = 1;
				ALUSrc = 0;
				MemtoReg = 0;
				RegWrite = 0;
				MemRead = 0;
				MemWrite = 0;
				Branch = 1;
				ALUOp = 2'b01;
			end
		
		11'b1111_1000_010: // LDUR
			begin
				Reg2Loc = 0;
				ALUSrc = 1;
				MemtoReg = 1;
				RegWrite = 1;
				MemRead = 1;
				MemWrite = 0;
				Branch = 0;
				ALUOp = 2'b00;
			end
		
		default:
			begin
				Reg2Loc = 0;
				ALUSrc = 0;
				MemtoReg = 0;
				RegWrite = 0;
				MemRead = 0;
				MemWrite = 0;
				Branch = 0;
				ALUOp = 2'b00;
			end
		endcase
	endmodule
				