/***********************************************************************
*** ECE526L Experiment #2 				  Garen Nikoyan, Spring 2018 ***
*** Structural Modeling of a JK Flip-Flop                            ***
************************************************************************
*** Filename: JKFF.v 		    Created by: Garen Nikoyan, 2/7/2018  ***
*** -Revision History                      							 ***
***    2/7/2018: First draft                                         ***
***    2/8/2018: Corrected time delays
************************************************************************
*** This module models a JK Flip-Flop                                ***
*** The gates of the flip flop have different input delays,          ***
*** as well as fanout delays:   		                             ***
*** FO1 = 1ns; FO2 = 1.5ns; FO3 = 2ns; Primary Output = 4ns          ***
*** 2 input gates = time_delay_1 = 2ns                               ***
*** 3 input gates = time_delay_2 = 3ns                               ***
*** 4 input gates = time_delay_3 = 4ns                               ***
***                                                                  ***
***     The following results are expected from the JKFF		     ***
*** J  K  SD  CP  RD  Q    QN 	   MODE								 ***
*** x  x  0   x   1   1    0     Async Set							 ***
*** x  x  1   x   0   0    1 	 Async Reset						 ***
*** x  x  0   x   0   1-?  1-?   Indeterminate						 ***
*** 0  0  1   p   1   0    1     Load 0 SYNC (reset) 				 ***
*** 1  1  1   p   1   1    0	 Load 1 SYNC (SET) 				     ***
*** 0  1  1   p   1   q    qb    Hold SYNC 							 ***
*** 1  0  1   p   1   qb   q     Toggle SYNC 						 ***
***      									                         ***
************************************************************************/

`timescale 1 ns / 100 ps      //100ps because precision of less than 1ns is needed
`define FO1 0.5         //0.5ns
`define FO2 1.5         //1.5ns
`define FO3 2           //2ns
`define PO  4           //4ns
`define time_delay_1 1  //1ns, 2 input gate delay
`define time_delay_2 2  //2ns, 3 input gate delay
`define time_delay_3 3  //3ns, 4 input gat delay

module JKFF(Q, Q_N, SD_N, CP, J, K_N, RD_N);
    // Port Declarations
    input SD_N, CP, J, K_N, RD_N;
    output Q, Q_N;
    // Internal variable declarations
    wire a1, a2, nr, n1, n2, n3, Q, Q_N;
    // The netlist
    and #(`time_delay_3+ `FO1) AND1(a1, J, Q_N, RD_N, n3);
    and #(`time_delay_3+ `FO1) AND2(a2, Q, K_N, RD_N, n3);

    nand #(`time_delay_2+ `FO1) NAND1(n1, nr, SD_N, n2);
    nor #(`time_delay_1+ `FO2) NOR2(nr, a1, a2);

    nand #(`time_delay_2+ `FO3) NAND2(n2, n1, CP, RD_N);
    nand #(`time_delay_2+ `FO2) NAND3(n3, n2, CP, nr);

    nand #(`time_delay_2+ `PO+ `FO3) NAND4(Q, SD_N, n2, Q_N);
    nand #(`time_delay_2+ `PO+ `FO3) NAND5(Q_N, Q, n3, RD_N);

endmodule
