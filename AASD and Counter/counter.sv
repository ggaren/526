/***********************************************************************
*** ECE526L Experiment #4 				  Garen Nikoyan, Spring 2018 ***
*** Behavioral Modeling of a Counter				                 ***
************************************************************************
*** Filename: counter.sv 	   Created by: Garen Nikoyan, 2/22/2018  ***
*** -Revision History                      							 ***
***    2/22/2018: First draft                                        ***
************************************************************************
*** This module models an counter     				     ***
***   Asynchronous, active low Reset: sets Count to 0
***	  Synchronous active high Enable: Count is incremented, 
***      or loaded with new data if Load is high
***   Synchronous, active high Load: value on data pins is loaded 
***      into counter after posedge of clock if Enable is high 
***   If Load is low, Enable is high, and Reset is high, counter 
***      advances on posedge of clock                                ***
***      							     ***
************************************************************************/
`timescale 1 ns / 100 ps

module counter(Count, Clock, Reset, Enable, Load, Data); 
	output reg [5:0] Count; 
	input  [5:0] Data; 
	input  Clock, Enable, Reset, Load; 
	
	always @(posedge Clock or negedge Reset)
		if(!Reset)
			Count <= 6'b000000;
		else if(Enable)
			begin
				if(Load)
					Count <= Data;
				else
					Count <= Count+ 1;
	end

endmodule 
