module Full_Adder(cin, A, B, cout, out);
	input reg cin, A, B;
	output reg out, cout;
		always @* {cout, out} = cin + A + B ;
endmodule