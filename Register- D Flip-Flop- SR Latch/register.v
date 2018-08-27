/***********************************************************************
*** ECE526L Experiment #3 				  Garen Nikoyan, Spring 2018 ***
*** Hierarchical Modeling				                             ***
************************************************************************
*** Filename: register.v 	     Created by: Garen Nikoyan, 2/15/2018***
*** -Revision History                      							 ***
***    2/15/2018: First draft                                        ***
************************************************************************
*** This module models a register, using a multiplexer and Dflip-flop***
***  		                                                         ***
*** The gates of the flip flop have different input delays,          ***
*** as well as fanout delays:   		                             ***
*** FO1 = 0.5ns; FO2 = 0.8ns; FO3 = 1.0ns; Primary Output = 4ns      ***
*** 1 input gates = IN1 = 1ns                                        ***
*** 2 input gates = IN2 = 2ns                                        ***
*** 3 input gates = IN3 = 3ns                            		     ***
***                                                                  ***
***      									                         ***
***********************************************************************/
 
`timescale 1 ns / 100 ps
`define PO 4 // time delay for primary output, out of dff module, is 4 ns 
module register(R, CLK, DATA, ENA, RST); 
	output [7:0] R; 
	input  [7:0] DATA; 
	input  CLK, ENA, RST; 

	wire [7:0] MO;
	wire [7:0] RN;

    MUX mux0(MO[0],R[0],DATA[0],ENA); // MO[ ] gets passed to dff as the data coming in
    dff dff0(R[0],RN[0],CLK,MO[0],RST); // R[ ] is the primary output 

    MUX mux1(MO[1],R[1],DATA[1],ENA);
    dff dff1(R[1],RN[1],CLK,MO[1],RST);

    MUX mux2(MO[2],R[2],DATA[2],ENA);
    dff dff2(R[2],RN[2],CLK,MO[2],RST);

    MUX mux3(MO[3],R[3],DATA[3],ENA);
    dff dff3(R[3],RN[3],CLK,MO[3],RST);

    MUX mux4(MO[4],R[4],DATA[4],ENA);
    dff dff4(R[4],RN[4],CLK,MO[4],RST);

    MUX mux5(MO[5],R[5],DATA[5],ENA);
    dff dff5(R[5],RN[5],CLK,MO[5],RST);

    MUX mux6(MO[6],R[6],DATA[6],ENA);
    dff dff6(R[6],RN[6],CLK,MO[6],RST);

    MUX mux7(MO[7],R[7],DATA[7],ENA);
    dff dff7(R[7],RN[7],CLK,MO[7],RST);
endmodule 
