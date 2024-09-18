module flopr_32_tb();
	logic 		 clk, reset;
	logic [31:0] d, q;
	logic [31:0] qexpected = '0;
	logic [3:0] vectornum, errors;
	logic [31:0] testvectors [0:9] = '{ 32'h2A3BCD4E,
													 32'h5E7F8A9B,
													 32'hA1B2C3D4,
													 32'h9ABCDEF0,
													 32'hFEDCBA98,
													 32'h12345678,
													 32'hCAFEBABE,
													 32'hBADC0FFE,
													 32'h00000000,
													 32'hFFFFFFFF};
	
	//Instancia del Device Under Test
	flopr #(32) dut (clk, reset, d, q);

	//Generacion del clock con periodo de 10ns
	always
		begin
			clk = 1; #5ns; clk = 0; #5ns;
		end
	
	//Generacion señal de reset en 1 por 50ns (5 periodos)
	initial 	
		begin     
			vectornum = 0; errors = 0;
			reset = 1; #50ns; reset = 0;		
		end

	//Aplicacion de los vectores de tests en los flancos negativos de clock
	always @(negedge clk)
		begin
			d = testvectors[vectornum]; #10ns;
		end

	//Chequeo de resultado en los flancos positivos
	always @(posedge clk)
		begin
			if (~reset) begin
				if (q !== qexpected) begin  
					$display("Error: input = %h", d);
					$display("  outputs = %h (%h expected)",q,qexpected);
					errors = errors + 1;
				end
				qexpected = testvectors[vectornum];
			end
			vectornum = vectornum + 1;
			if (vectornum === 10) begin 
				$display("%d tests completed with %d errors", 
						 vectornum, errors);
				$stop;
			end
		end
	
endmodule
