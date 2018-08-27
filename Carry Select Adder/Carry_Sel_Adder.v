/*
		Full_Adder(cin, A, B, cout, out);
		mux(A, B, SEL, OUT);
		Twobitadder(cin, A, B, coT, coB, sum0, sum1);
*/
`timescale 1ns/1ns
module Carry_Sel_Adder(c6, sum, A, B, c0);
	input [5:0] A, B;
	input c0; 
	output [5:0] sum;
	output c6;
	
	Full_Adder FA0(c0, A[0], B[0], c1, sum[0]);
	Full_Adder FA1(c1, A[1], B[1], c2, sum[1]);
	
	Twobitadder TBA0(c2, A[3:2], B[3:2], co0, co1, sum[2], sum[3]);
	
	mux mux0(co1, co0, c2, c4);
	
	Twobitadder TBA1(c4, A[5:4], B[5:4], co2, co3, sum[4], sum[5]);
	
	mux mux1(co3, co2, c4, c6);
endmodule
