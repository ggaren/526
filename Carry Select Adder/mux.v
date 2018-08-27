/***********************************************************************
*** ECE526L Experiment #6 				  Garen Nikoyan, Spring 2018 ***
*** 1 bit Multiplexer				                                 ***
************************************************************************
*** Filename: scale_mux.v	    Created by: Garen Nikoyan, 3/15/2018 ***
*** -Revision History                      							 ***
***    3/15/2018: First draft: edited from scale_mux.v from Lab 5    ***
************************************************************************
***This module models a 1 bit, 2:1 mux for the Carry_Sel_Adder module***
***      									                         ***
************************************************************************/
`timescale 1ns/1ns
module mux(A, B, SEL, OUT);
  output reg OUT;
  input A, B;
  input SEL;
	always @*
    	OUT = SEL ? B : A; // if SEL=1, OUT=B,   if SEL=0, OUT=A
  		// if SEL=x, then A=B causes OUT=A=B, and A!=B, OUT=x
endmodule
