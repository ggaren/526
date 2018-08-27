/***********************************************************************
*** ECE526L Experiment #3 				  Garen Nikoyan, Spring 2018 ***
*** Hierarchical Modeling				                             ***
************************************************************************
*** Filename: dff.v 	       Created by: Garen Nikoyan, 2/15/2018  ***
*** -Revision History                      							 ***
***    2/15/2018: First draft                                        ***
************************************************************************
*** This module models a D flip-flop using primitive gates, and a    ***
***  SR_Latch2.v module                                              ***
*** The gates of the flip flop have different input delays,          ***  
*** as well as fanout delays:   		                             ***
*** FO1 = 0.5ns; FO2 = 0.8ns; FO3 = 1.0ns; Primary Output = 4ns      ***
*** 1 input gates = IN1 = 1ns                                        ***
*** 2 input gates = IN2 = 2ns                                        ***
*** 3 input gates = IN3 = 3ns                            		     ***
***                                                                  ***
************************************************************************/

`timescale 1 ns / 100 ps
`define InverterIN 1 		// Inverters can only have 1 input
`define InverterOUT 0.5		// Fanout in this module is 1, no need to use parameter here
module dff(q, qbar, clock, data, clear);	

	output q, qbar;
	input clock, data, clear;

	not #(`InverterIN+ `InverterOUT) CLR1(cbar,clear);
	not #(`InverterIN+ `InverterOUT) CLR2(clr,cbar);
	not #(`InverterIN+ `InverterOUT) CLK1(clkbar,clock);
	not #(`InverterIN+ `InverterOUT) CLK2(clk,clkbar);
	not #(`InverterIN+ `InverterOUT) D1(dbar,data);
	not #(`InverterIN+ `InverterOUT) D2(d,dbar);
	
	SR_Latch2 #(2, 0.5, 3, 1.0) SR1(sbar,s,rbar,1'b1,clr,clk);
	SR_Latch2 #(3, 0.8, 3, 0.8) SR2(r,rbar,s,clk,clr,d);
	SR_Latch2 #(2, 4.5, 3, 4.5) SR3(q,qbar,s,1'b1,clr,r);

endmodule
