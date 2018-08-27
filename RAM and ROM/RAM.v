/***********************************************************************
*** ECE526L Experiment #7 				  Garen Nikoyan, Spring 2018  
***  Register File Models	                  
************************************************************************
*** Filename: RAM.v	    Created by: Garen Nikoyan, 3/29/2018  ***
*** -Revision History                      							    
***    3/29/2018: First draft                                  
************************************************************************
*** This module models memory with an 8-bit data bus and 5-bit address bus
***   This module uses an active high output enable signal, active low chip
***   select signal, and a write strobe signal. If chip select is high,
***   or output enable is low, data bus goes to Z
************************************************************************/

`timescale 1ns/100ps
module RAM(DATA, ADDR, OE, CS, WS);
  inout [7:0] DATA;
  input [4:0] ADDR; 
  input OE, CS, WS;
  reg [7:0] memory [0:31];
  
  // if OE=1 and CS=0, DATA=memory at ADDR; if not, DATA=z
  // assign is used because of inout type
  assign DATA = (OE && !CS) ? memory[ADDR] : 8'bz;

  always@(posedge WS) begin
    if (!OE && !CS)
      memory[ADDR] <= DATA;
	else
	  memory[ADDR] <= memory[ADDR];	// to prevent latches in hardware
  end

endmodule