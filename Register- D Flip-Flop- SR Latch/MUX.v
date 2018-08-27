/***********************************************************************
*** ECE526L Experiment #3 				  Garen Nikoyan, Spring 2018 ***
*** Hierarchical Modeling				                             ***
************************************************************************
*** Filename: MUX.v 	       Created by: Garen Nikoyan, 2/15/2018  ***
*** -Revision History                      							 ***
***    2/15/2018: First draft, copied from Lab1, editted to include time delays
************************************************************************
*** This module models a 2:1 Multiplexer		   
*** The gates have different input delays,          ***
*** as well as fanout delays:   		                             ***
*** FO1 = 0.5ns; FO2 = 0.8ns; FO3 = 1.0ns; Primary Output = 4ns        ***
*** 1 input gates = IN1 = 1ns                                        ***
*** 2 input gates = IN2 = 2ns                                        ***
*** 3 input gates = IN3 = 3ns                            		     ***
***                                                                  ***
************************************************************************/

`timescale 1 ns / 100 ps

module MUX(OUT, A, B, SEL);
	
	parameter NOT1in = 1,	 // delays set according to # of inputs and fanout 
		  NOT1out = 0.5,
		  AND1in = 2,
		  AND1out = 0.8,
		  AND2in = 2,
		  AND2out = 0.8,
		  OR1in = 2,
		  OR1out = 0.5;
    // Port Declarations
    input A, B, SEL;
    output OUT;

    // Internal variable declarations
    wire A1, B1, SEL_N;

    // The netlist
    not #(NOT1in+NOT1out) NOT1(SEL_N, SEL);
    and #(AND1in+AND1out) AND1(A1, A, SEL_N);
    and #(AND2in+AND2out) AND2(B1, B, SEL);
    or #(OR1in+OR1out) OR1(OUT, A1, B1);
endmodule
