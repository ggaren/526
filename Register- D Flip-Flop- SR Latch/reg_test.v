/***********************************************************************
*** ECE526L Experiment #3 				  Garen Nikoyan, Spring 2018 ***
*** Hierarchical Modeling				            ***
************************************************************************
*** Filename: reg_test.v 	       Created by: Garen Nikoyan, 2/15/2018  ***
*** -Revision History                      			     ***
***    2/15/2018: First draft                                        ***
************************************************************************
*** This module tests a register module, by testing if RST works properly,
*** and if ENA works properly
***  		                                                     ***                      
************************************************************************/

`timescale  1 ns / 100 ps
`define period 20  

module reg_test();
    reg CLK, ENA, RST; // inputs
    reg [7:0]DATA;     // inputs
    wire [7:0]R;       // outputs

    register UUT(R, CLK, DATA, ENA, RST);      // UUT = unit under test  

    always #(`period*0.5) CLK=~CLK; // sets CLK to 50% duty cycle

    initial begin
     $vcdpluson;
     $monitor("%d ns  DATA=%h  ENA=%b  RST=%b  R=%h",$time,DATA,ENA,RST,R);
     CLK=0; // setting the clock
    end

    initial begin
	ENA=0; RST=1; DATA=8'hAA; // starting vector, DATA Line is 10101010

	#(`period*2) ENA=1; // checking if register holds DATA values when ENA asserted
	#(`period*2) ENA=0; // deasserting ENA
	#`period DATA=8'h55; // changing DATA to 01010101 to see if R changes while ENA is off
	#(`period*2) RST=0; // checking if registers reset when RST is 0
     
     #`period $finish;

    end
endmodule
