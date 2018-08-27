/***********************************************************************
*** ECE526L Experiment #3 				  Garen Nikoyan, Spring 2018 ***
*** Hierarchical Modeling				                             ***
************************************************************************
*** Filename: SR_Latch2.v 	   Created by: Garen Nikoyan, 2/15/2018  ***
*** -Revision History                      							 ***
***    2/15/2018: First draft                                        ***
************************************************************************
*** This module models a SR Latch using primitive gates              ***
*** The gates of the flip flop have different input delays,          ***
*** as well as fanout delays:   		                             ***
*** FO1 = 0.5ns; FO2 = 0.8ns; FO3 = 1.0ns; Primary Output = 4ns      ***
*** 1 input gates = IN1 = 1ns                                        ***
*** 2 input gates = IN2 = 2ns                                        ***
*** 3 input gates = IN3 = 3ns                            		     ***
***                                                                  ***
***      									                         ***
************************************************************************/

`timescale 1 ns / 100 ps

module SR_Latch2(Q, Qnot, s0, s1, r0, r1);
	// using parameter allows us to easily change these time delays when we call the module
	parameter 	NAND1_IN = 3, 	// 3 ns delay for 3 input gate
			NAND1_FO = 0.5,	// 0.5 ns delay, for fanout 1 delay 
			NAND2_IN = 3,
			NAND2_FO = 0.5;
				
	output Q, Qnot;
	input s0, s1, r0, r1;
	
	wire s0,s1,r0,r1;
	wire Q, Qnot;
	
	nand #(NAND1_IN + NAND1_FO) NAND1(Q,s0,s1,Qnot);
	nand #(NAND2_IN + NAND2_FO) NAND2(Qnot,r1,r0,Q);
	
endmodule 
