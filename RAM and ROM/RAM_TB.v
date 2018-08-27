/***********************************************************************
*** ECE526L Experiment #7 				  Garen Nikoyan, Spring 2018
***  Register File Models
************************************************************************
*** Filename: RAM_TB.v	    Created by: Garen Nikoyan, 3/29/2018  ***
*** -Revision History
***    3/29/2018: First draft
************************************************************************
*** This module tests a RAM module		  ***
***   It will write and read from every memory location using sequential	
***   numbering that matches the address number. Then tests a block read
***   Verifies both enabled and disabled states, and tests high impedance
***   state. It will lastly write a walking ones pattern and then read it
************************************************************************/


`timescale 1ns/100ps

module RAM_TB();
  reg OE, CS, WS;
  reg [4:0] ADDRbus;
  wire [7:0] DATAbus;
  reg [7:0] DATAreg;
  integer i,j,k;
  
  // needs to be assign because it is an inout port in the module
  assign DATAbus = (!OE && !CS) ? DATAreg:8'bz; 
  
  RAM RAM1(DATAbus, ADDRbus, OE, CS, WS);

  initial begin
    $vcdpluson;
    //$dumpfile("dump.vcd");	
    //$dumpvars;
    $monitor(" ADDRbus =%d  CS =%b  OE =%b  WS =%b  DATAbus =%d  DATAreg =%d", ADDRbus, CS, OE, WS, DATAbus, DATAreg);
  end
// *** Test Write 
initial begin
    $monitoroff;
    #10 CS=0; OE=0;
    $display("\n\t\t TEST WRITE");
    $monitoron;
    for(i=0;i<32;i=i+1) begin
      #10 $monitoroff; WS=0; DATAreg=i; ADDRbus=i;
      #10 $monitoron; WS=1;
    end

// *** Individual Read
  #20 $display("\n\t\t INDIVIDUAL READ OF ADDR 12");
  #10 CS=0; OE=1; WS=0; ADDRbus=12;

// *** Block Read
  #10 $monitoroff;
  #10 CS=0; OE=1;
  $display("\n\t\t BLOCK READ");
   for(j=0;j<32;j=j+1) begin
     $strobe("\t\t RAM[%2d] = %d",j, RAM.memory[j]);
     #10 ADDRbus=j;
   end
  
// *** High Impedance State
  #10 CS=1; $monitoron;
  $display("\n\t\t HIGH IMPEDANCE TEST");
  
// *** Walking Ones
  $monitorb("ADDRbus =%d  CS =%b  OE =%b  WS =%b  DATAbus =%b  DATAreg =%b", ADDRbus, CS, OE, WS, DATAbus, DATAreg);
  #10 k=1; CS=0; OE=0;
  $display("\n\t\t WRITING WALKING ONES");
  for(i=0;i<8;i=i+1) begin
  #10 $monitoroff; WS=0;  ADDRbus=i; DATAreg=k;
  #10 $monitoron; WS=1; k=k*2;
    if(k==256) k=1;
    else;
  end
  
  #10 $monitoroff; OE=1; WS=0; CS=0;
  #10 $display("\n\t\t READING WALKING ONES");
  #10 $monitoron;
  for(i=0; i<8; i=i+1) #10 ADDRbus=i;

  
#100 $finish;
end
endmodule