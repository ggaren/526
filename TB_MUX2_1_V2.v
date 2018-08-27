/***********************************************************************
*** ECE526L Experiment #1 					      Garen Nikoyan, Spring 2018 ***
*** Familiarization with Linux and the Synopsys VCS Simulator        ***
************************************************************************
*** Filename: TB_MUX2_1_V2.v 	  Created by: Garen Nikoyan, 1/31/2018 ***
*** -Revision History                                  							 ***
***    1/31/2018: Added code                                         ***
************************************************************************
*** This module exhaustively tests a 2:1 Multiplexer module		   	   ***
***      										                                         ***
************************************************************************/
`timescale 1 ns / 1 ns
module TB_MUX2_1();
    reg A, B, SEL;
    wire OUT;

    MUX2_1 UUT(OUT, A, B, SEL);       // UUT = unit under test

    initial
        $monitorb ("%d out = %b a = %b b = %b sel = %b", $time, OUT, A, B, SEL); // sets which signals will be displayed

    initial begin
      //$vcdpluson;				// for Synopsys
      $dumpfile("dump.vcd");	// for EDAPlayground/Icarus 
      $dumpvars;				// for EDAPlayground/Icarus
// Tests with SEL = 0
      $display("\t\t Tests with SEL = 0");
    // B = 0
      $display("\t Tests with B = 0, varying A");
    A = 0; B = 0; SEL = 0;
    #10 A = 1; B = 0; SEL = 0;
    #10 A = 1'bx; B = 0; SEL = 0;
    #10 A = 1'bz; B = 0; SEL = 0;
    // B = 1
      $display("\t Tests with B = 1, varying A");
    #10 A = 0; B = 1; SEL = 0;
    #10 A = 1; B = 1; SEL = 0;
    #10 A = 1'bx; B = 1; SEL = 0;
    #10 A = 1'bz; B = 1; SEL = 0;
    // B = 1'bx
      $display("\t Tests with B = 1'bx, varying A");
    #10 A = 0; B = 1'bx; SEL = 0;
    #10 A = 1; B = 1'bx; SEL = 0;
    #10 A = 1'bx; B = 1'bx; SEL = 0;
    #10 A = 1'bz; B = 1'bx; SEL = 0;
    // B = 1'bz
      $display("\t Tests with B = 1'bz, varying A");
    #10 A = 0; B = 1'bz; SEL = 0;
    #10 A = 1; B = 1'bz; SEL = 0;
    #10 A = 1'bx; B = 1'bz; SEL = 0;
    #10 A = 1'bz; B = 1'bz; SEL = 0;

// Tests with SEL = 1
      $display("\n\t\t Tests with SEL = 1");
    // B = 0
      $display ("\t Tests with B = 0, varying A");
    #10 A = 0; B = 0; SEL = 1;
    #10 A = 1; B = 0; SEL = 1;
    #10 A = 1'bx; B = 0; SEL = 1;
    #10 A = 1'bz; B = 0; SEL = 1;
    // B = 1
      $display("\t Tests with B = 1, varying A");
    #10 A = 0; B = 1; SEL = 1;
    #10 A = 1; B = 1; SEL = 1;
    #10 A = 1'bx; B = 1; SEL = 1;
    #10 A = 1'bz; B = 1; SEL = 1;
    // B = 1'bx
      $display("\t Tests with B = 1'bx, varying A");
    #10 A = 0; B = 1'bx; SEL = 1;
    #10 A = 1; B = 1'bx; SEL = 1;
    #10 A = 1'bx; B = 1'bx; SEL = 1;
    #10 A = 1'bz; B = 1'bx; SEL = 1;
    // B = 1'bz
      $display("\t Tests with B = 1'bz, varying A");
    #10 A = 0; B = 1'bz; SEL = 1;
    #10 A = 1; B = 1'bz; SEL = 1;
    #10 A = 1'bx; B = 1'bz; SEL = 1;
    #10 A = 1'bz; B = 1'bz; SEL = 1;

// Tests with SEL = 1'bx (x = unknown logic value)
      $display("\n\t\t Tests with SEL = 1'bx");
    // B = 0
      $display("\t Tests with B = 0, varying A");
    #10 A = 0; B = 0; SEL = 1'bx;
    #10 A = 1; B = 0; SEL = 1'bx;
    #10 A = 1'bx; B = 0; SEL = 1'bx;
    #10 A = 1'bz; B = 0; SEL = 1'bx;
    // B = 1
      $display("\t Tests with B = 1, varying A");
    #10 A = 0; B = 1; SEL = 1'bx;
    #10 A = 1; B = 1; SEL = 1'bx;
    #10 A = 1'bx; B = 1; SEL = 1'bx;
    #10 A = 1'bz; B = 1; SEL = 1'bx;
    // B = 1'bx
      $display("\t Tests with B = 1'bx, varying A");
    #10 A = 0; B = 1'bx; SEL = 1'bx;
    #10 A = 1; B = 1'bx; SEL = 1'bx;
    #10 A = 1'bx; B = 1'bx; SEL = 1'bx;
    #10 A = 1'bz; B = 1'bx; SEL = 1'bx;
    // B = 1'bz
      $display("\t Tests with B = 1'bz, varying A");
    #10 A = 0; B = 1'bz; SEL = 1'bx;
    #10 A = 1; B = 1'bz; SEL = 1'bx;
    #10 A = 1'bx; B = 1'bz; SEL = 1'bx;
    #10 A = 1'bz; B = 1'bz; SEL = 1'bx;

// Tests with SEL = 1'bz (z = high impedance, floating logic value)
      $display("\n\t\t Tests with SEL = 1'bz");
    // B = 0
      $display("\t Tests with B = 0, varying A");
    #10 A = 0; B = 0; SEL = 1'bz;
    #10 A = 1; B = 0; SEL = 1'bz;
    #10 A = 1'bx; B = 0; SEL = 1'bz;
    #10 A = 1'bz; B = 0; SEL = 1'bz;
    // B = 1
      $display("\t Tests with B = 1, varying A");
    #10 A = 0; B = 1; SEL = 1'bz;
    #10 A = 1; B = 1; SEL = 1'bz;
    #10 A = 1'bx; B = 1; SEL = 1'bz;
    #10 A = 1'bz; B = 1; SEL = 1'bz;
    // B = 1'bx
      $display("\t Tests with B = 1'bx, varying A");
    #10 A = 0; B = 1'bx; SEL = 1'bz;
    #10 A = 1; B = 1'bx; SEL = 1'bz;
    #10 A = 1'bx; B = 1'bx; SEL = 1'bz;
    #10 A = 1'bz; B = 1'bx; SEL = 1'bz;
    // B = 1'bz
      $display("\t Tests with B = 1'bz, varying A");
    #10 A = 0; B = 1'bz; SEL = 1'bz;
    #10 A = 1; B = 1'bz; SEL = 1'bz;
    #10 A = 1'bx; B = 1'bz; SEL = 1'bz;
    #10 A = 1'bz; B = 1'bz; SEL = 1'bz;

    #20 $finish;

    end

endmodule
