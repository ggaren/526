/***********************************************************************
*** ECE526L Experiment #5 				  Garen Nikoyan, Spring 2018 ***
*** Scalable Multiplexer				                             ***
************************************************************************
*** Filename: scale_mux.v	    Created by: Garen Nikoyan, 3/1/2018  ***
*** -Revision History                      							 ***
***    3/1/2018: First draft                                         ***
************************************************************************
*** This module models a scalable multiplexer						 ***
***   The amount of the bits of the 2 inputs and output can be passed in 
***   through the parameter "Size"
***   if SEL=1, OUT=B, if SEL=0, OUT=A    
***   if SEL=x, and A=B, OUT=A, if SEL=x, and A!=B, OUT=x            ***
***      									                         ***
************************************************************************/
`timescale 1ns/1ns
module scale_mux(A, B, SEL, OUT);
  parameter Size = 1;
  output reg [Size-1:0] OUT;
  input [Size-1:0] A, B;
  input SEL;
  
  always @*
    	OUT = SEL ? B : A; // if SEL=1, OUT=B,   if SEL=0, OUT=A
  		// if SEL=x, then A=B causes OUT=A=B, and A!=B, OUT=x
endmodule
