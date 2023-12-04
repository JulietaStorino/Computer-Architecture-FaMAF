module signext_tb();
	logic [31:0] a;
	logic [63:0] y, yexpected;
	logic 		 clk, reset;
	logic [3:0] vectornum, errors;
	logic [31:0] atestvectors [7:0] = '{32'hF84A9F02,
													32'hF85A9F01,
													32'hF80A9F01,
													32'hF81A9F01,
													32'hB40A9F01,
													32'hB48A9F01,
													32'h550A9F01,
													32'h551A9F01};
	logic [63:0] expected [7:0] = '{64'h00000000000000A9,
												64'hFFFFFFFFFFFFFFA9,
												64'h00000000000000A9,
												64'hFFFFFFFFFFFFFFA9,
												64'h00000000000054F8,
												64'hFFFFFFFFFFFC54F8,
												64'h0000000000000000,
												64'h0000000000000000};

	//Instancia del Device Under Test
	signext dut (a, y);

	//Generacion del clock con periodo de 5ps
	always
		begin
			clk = 1; #5; clk = 0; #5;
		end
	
	//Generacion señal de reset en 1 por 27ps
	initial 	
		begin     
			vectornum = 0; errors = 0;
			reset = 1; #20; reset = 0;		
		end

	//Aplicacion de los vectores de tests en los flancos positivos de clock
	always @(posedge clk)
		if (~reset) begin
			a = atestvectors[vectornum];
			yexpected = expected[vectornum];
			#10;
		end

	//Chequeo de resultado en los flancos negativos de clock
	always @(negedge clk)
		if (~reset) begin
			if (y !== yexpected) begin  
				$display("Error: input = %h", a);
				$display("  outputs = %h (%h expected)", y, yexpected);
				errors = errors + 1;
			end
			
			vectornum = vectornum + 1;
				
			if (vectornum === 8) begin 
				$display("%d tests completed with %d errors", 
					 vectornum, errors);
				$stop;
			end
		
		end
	
endmodule
