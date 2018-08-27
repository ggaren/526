/***********************************************************************
*** ECE526L Experiment #2 				  Garen Nikoyan, Spring 2018 ***
*** Structural Modeling of a JK Flip-Flop                            ***
************************************************************************
*** Filename: TB_JKFF.v 		Created by: Garen Nikoyan, 2/7/2018  ***
*** -Revision History                      							 ***
***    2/7/2018: First draft                                         ***
***    2/8/2018: Editted time delays                                 ***
************************************************************************
*** This testbench tests a JK Flip-Flop module                       ***
***      									                         ***
************************************************************************/
`timescale  1 ns / 100 ps
`define period 50  // 50ns for 50% duty cycle, 180ns for 10% duty cycle

module TB_JKFF();
    reg SD_N, CP, J, K_N, RD_N; // inputs
    wire Q, Q_N;                // outputs

    JKFF UUT(Q, Q_N, SD_N, CP, J, K_N, RD_N);      // UUT = unit under test

    always #(`period*0.5) CP=~CP; // sets CP to 50% duty cycle, toggles CP every 25ns

/*  always begin // used to set the duty cycle to 10%
      CP=1; //CP set to 1 and then changes at each clock pulse
      # ( `period*0.1 );
	  CP=0; //CP set to 0 for the 90% of the logic low at each clock pulse
      # (`period*0.9);
    end
*/

    initial begin // used initial begin because multiple $ statements are used
      $write ("This shows the given inputs");        // good for writing text, but no built-in new line
      $display (" that will be a part of all tests in this lab.");   // good for writing text, built-in new line
      $monitor ("%d ns  J = %b, K_N= %b, SD_N = %b, CP = %b, RD_N = %b   Q = %b  Q_N = %b",$time,J,K_N,SD_N,CP,RD_N,Q,Q_N);
    end

    initial begin
     //$vcdpluson;
      $dumpfile("dump.vcd");
      $dumpvars;
     // Asynchronous Tests
     $display("Async Set Test");
     J=1 ; K_N=1 ; SD_N=0 ; CP=1 ; RD_N=1;
     #28 $display("Q = %b  Q_N = %b", Q, Q_N);  // 28ns delay because longest propogation delay in circuit is 27.5ns

     #(`period/2) $display("Async Reset Test");
     J=1 ; K_N=1 ; SD_N=1 ; RD_N=0;
     #28 $display("Q = %b  Q_N = %b", Q, Q_N);

     //period is (`period/2) for Async Reset
     #`period $display("Indeterminate Test");
     J=1 ; K_N=1 ; SD_N=0 ; RD_N=0;
	 #28 $display("Q = %b  Q_N = %b", Q, Q_N);

     // Asynchronous Tests
     #`period $display("Load 0 Test");
     J=0 ; K_N=0 ; SD_N=1 ; RD_N=1;
     #28 $display("Q = %b  Q_N = %b", Q, Q_N);

     #`period $display("Load 1 Test");
     J=1 ; K_N=1 ; SD_N=1  ; RD_N=1;
      $strobe("q = %b  q_n = %b", Q, Q_N);
     #29 $display("Q = %b  Q_N = %b", Q, Q_N);

     #`period $display("Hold");
     J=0; K_N=1; SD_N=1; RD_N=1;
     #28 $display("Q = %b  Q_N = %b", Q, Q_N);

     #`period $display("Toggle");
     J=1; K_N=0; SD_N=1; RD_N=1;
 	 #28 $display("Q = %b  Q_N = %b", Q, Q_N);

     #`period $display("Hold");
     J=1; K_N=1; SD_N=1; RD_N=1;
     #28 $display("Q = %b  Q_N = %b", Q, Q_N);

     #100 $finish;

    end
endmodule
