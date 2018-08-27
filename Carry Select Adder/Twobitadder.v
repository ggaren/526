/*
		Full_Adder(cin, A, B, c0, out);
		mux(A, B, SEL, OUT);
*/
`timescale 1ns/1ns
module Twobitadder(cin, A, B, coT, coB, sum0, sum1);
	input [1:0] A, B;
	input cin; 
	output sum0, sum1;
	output coT, coB;
	
	Full_Adder FA0(1'b1, A[0], B[0], co1, S0);
	Full_Adder FA1(co1, A[1], B[1], coT, S1);
	
	Full_Adder FA2(1'b0, A[0], B[0], co2, S2);
	Full_Adder FA3(co2, A[1], B[1], coB, S3);
	
	mux mux0(S2, S0, cin, sum0);
	mux mux1(S3, S1, cin, sum1);	

endmodule
