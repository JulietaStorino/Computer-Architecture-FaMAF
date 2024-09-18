module signext (input logic [31:0] a,
					output logic [63:0] y);
					
	always_comb
		casez(a[31:21])
			//LDUR y STUR
			11'b1111_1000_0?0: y = {{55{a[20]}}, a[20:12]};
			
			//CBZ
			11'b1011_0100_???: y = {{45{a[23]}}, a[23:5]};
			
			//otherwise
			default: y = '0;
		endcase
endmodule
			