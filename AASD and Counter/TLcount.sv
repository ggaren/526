/***********************************************************************
*** ECE526L Experiment #4 				  Garen Nikoyan, Spring 2018       ***
*** Behavioral Modeling of a Counter				                         ***
************************************************************************
*** Filename: TLcount.sv       Created by: Garen Nikoyan, 2/22/2018  ***
*** -Revision History                      							             ***
***    2/22/2018: First draft                                        ***
************************************************************************
*** This module instantiates an AASD and 6 bit counter into a top    ***
***     level module                                                 ***
***  Output of AASD is used as Reset line for the 6 bit counter      ***
***                                                                  ***
************************************************************************/
`timescale 1 ns / 100 ps
module TLcount(Count,Data,Clock,Reset,Enable,Load)
	output [5:0] Count;
	input  [5:0] Data;
	input Clock,Reset,Enable,Load;
	
	AASD aasd1(RST, Clock, Reset);
	counter counter1(Count, Clock, RST, Enable, Load, Data); 
	
endmodule
