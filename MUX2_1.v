/***********************************************************************
*** ECE526L Experiment #1 				  Garen Nikoyan, Spring 2018 ***
*** Familiarization with Linux and the Synopsys VCS Simulator        ***
************************************************************************
*** Filename: MUX2_1.v 		   Created by: Garen Nikoyan, 1/31/2018  ***
*** -Revision History                      							 ***
***    1/31/2018: Copied from ECE526L Lab Manual                     ***
************************************************************************
*** This module models a 2:1 Multiplexer				             ***
***      									                         ***
************************************************************************/

`timescale 1 ns / 1 ns
module MUX2_1(OUT, A, B, SEL);
    // Port Declarations
    input A, B, SEL;
    output OUT;

    // Internal variable declarations
    wire A1, B1, SEL_N;

    // The netlist
    not (SEL_N, SEL);
    and (A1, A, SEL_N);
    and (B1, B, SEL);
    or (OUT, A1, B1);
endmodule
