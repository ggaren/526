`timescale 1ns/100ps
module RISCY_TB();
	reg CLK, RST;
	wire [7:0] IO;
	reg [7:0] Data_In;
	integer i;
	
	RISCY UUT(CLK, RST, IO);
	
	initial CLK = 1'b0;
	
	always #10 CLK = !CLK;
	
	assign IO = UUT.PORT_RD ? Data_In: 8'bz;
	
	initial begin
		$vcdpluson;
		$readmemb("ROM_DATA.txt", UUT.ROM32.memory);
	end
	
	initial begin
		RST = 1'b0; Data_In = 8'h55;
		#50 RST = 1'b1;
		#20000
		/*$display("\t RAM Address || Contents");
		for(i=0; i<32; i=i+1) begin
			#20 $display("\t   %2h    |    %2h    ", i, UUT.ROM32.memory[i]);
		end*/
		$finish;
	end
endmodule