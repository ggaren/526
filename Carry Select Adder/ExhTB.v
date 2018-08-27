/***********************************************************************
*** ECE526L Experiment #6 				  Garen Nikoyan, Spring 2018  
***  Carry Select Adder		                  
************************************************************************
*** Filename: ExhTB.v	    Created by: Garen Nikoyan, 3/8/2018  ***
*** -Revision History                      							    
***    3/1/2018: First draft 
***    3/27/2018: Corrected error checking, forced error, and `ifdef                                 
************************************************************************
*** This module exhaustively tests a 6-bit Carry Select Adder		  ***
***   It will force an error if "`define no_force" is commented out	
***   It has built in error checking which will display a message and stop
***       simulation if an error is found  				     
************************************************************************/

`timescale 1 ns / 1 ns

//`define no_force  // if commented out, runs code with forced error

module ExhTB();
  reg [5:0] A, B;
  wire [5:0] sum, outb;
  wire c6, coutb;
  reg  c0;
  integer i, j;
    Carry_Sel_Adder UUT(c6, sum, A, B, c0);
    BehavAdder(c0, A, B, coutb, outb);
    initial
    $monitorb ("A = %d  B = %d  Carryin = %b    Sum = %d  Carryout = %b    |||    SumBehav = %d  CarryoutBehav = %b", A, B, c0, sum, c6, outb, coutb);
    initial begin
    $vcdpluson;
// Testing with Carryin = 0
    c0 = 0; A = 0; B = 0;
    for(i=0; i<64; i=i+1) begin 
      for(j=0; j<64; j=j+1) begin
        #10 B = B + 1'b1;
        // Turning monitor off after first dozen results
        if(A==0 && B==12) $monitoroff;
        else;
        // If statement to check for errors in either sum or carryout, stops simulation and displays a message if error is found
        if (sum!=outb | c6!=coutb) begin
          $display ("ERROR \n A = %d  B = %d  Carryin = %b    Sum = %d Carryout = %b  SumBehav = %d  CarryoutBehav = %b", A, B, c0, sum, c6, outb, coutb);
          $stop;
        end
        else;
      end
	#10 A = A + 1'b1; 	
	end
	
// Testing with Carryin = 1
    c0 = 1'b1; A = 0; B = 0;
    for(i=0; i<64; i=i+1) begin 
      for(j=0; j<64; j=j+1) begin
        #10 B = B + 1'b1;
        // Turning Monitor back on for last dozen results
        if(A==63 && B==52) $monitoron;
        else;
        // If statement to check for errors in either sum or carryout, stops simulation and displays a message if error is found
        if (sum!=outb | c6!=coutb) begin
          $display ("ERROR \n A = %d  B = %d  Carryin = %b    Sum = %d Carryout = %b  SumBehav = %d  CarryoutBehav = %b", A, B, c0, sum, c6, outb, coutb);
        #80 $finish;
        end
        else;
// if no_force is defined, forced error is not applied
// if no_force is not defined, sum is forced to a value that causes an error when test is 75% complete
    `ifdef no_force
    `else begin
      if(A==47 && B==19) $monitoron;
      else;
      if(A==47 && B==31) force outb=10;
      else;
           end
    `endif  
        
      end
	#10 A = A + 1'b1; 	
    end
    $display("Exhaustive test was successful with no errors.");  
    #10 $finish;  
    end
endmodule
