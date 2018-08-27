/***********************************************************************
*** ECE526L Experiment #4 				  Garen Nikoyan, Spring 2018 ***
*** Behavioral Modeling of a Counter				          
************************************************************************
*** Filename: AASD.sv 	       Created by: Garen Nikoyan, 2/22/2018  ***
*** -Revision History                      							 ***
***    2/22/2018: First draft                                        ***
************************************************************************
*** This module models an AASD     									 ***
***   Asynchronous assert and synchronous deassert
***   to be used to prevent metastability issues with Reset lines    ***
***                                                                  ***
***      									                         ***
************************************************************************/

`timescale 1ns/100ps
module AASD(AASD_RST,CLOCK,RESET);
	output reg AASD_RST;
	input CLOCK,RESET;
	reg Out1; //this is the wire for the output of the first FF

always @(posedge CLOCK or negedge RESET) //allows 4 synchronous/asynchronous
	if(!RESET)begin//asynchronous reset
		Out1 <= 1'b0;
		AASD_RST <= 1'b0;
	end
	else begin
		Out1 <= 1'b1;
		AASD_RST <= Out1;
	end
endmodule
