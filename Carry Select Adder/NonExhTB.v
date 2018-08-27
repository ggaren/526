`timescale 1 ns / 1 ns
// Carry_Sel_Adder.v Testbench
module NonExhTB();
  reg [5:0] A, B;
  wire [5:0] sum;
  wire c6;
  reg  c0;

    Carry_Sel_Adder UUT(c6, sum, A, B, c0);
    initial
      $monitorb ("sum = %d  A = %d  B = %d  carryout = %d  carryin = ", sum, A, B, c6, c0);

    initial begin
      $vcdpluson;

    c0 = 1'b1; A = 6'b100000; B = 6'b100000;
$displayb("Testing if carryout=1 properly with carry-in = 1");

    #10 A = 6'b101001; B = 6'b001100;
$displayb("Testing if carryout=0 properly with carry-in = 1");

    #10 A = 6'b100110; B = 6'b011000;
$displayb("Testing if all bits go to 1 with carry-in = 1");

    #10 A = 6'b101010; B = 6'b010101;
$displayb("Testing if all bits go to 0 with carry-in = 1");
	

    #10 c0 = 1'b0; A = 6'b010101; B = 6'b101010;
$displayb("Testing if carryout=0 properly with carry-in = 0");

    #10 A = 6'b100000; B = 6'b100000;
$displayb("Testing if carryout=1 properly with carry-in = 0");

    #10 A = 6'b100110; B = 6'b011001;
$displayb("Testing if all bits go to 1 with carry-in = 0");

    #10 A = 6'b010110; B = 6'b101010;
$displayb("Testing if all bits go to 0 with carry-in = 0");

    #20 $finish;

    end

endmodule 


// Full_Adder.v Testbench
/*module TB();
  reg A, B;
  wire out;
  wire cout;
  reg  cin;

    Full_Adder UUT(cin, A, B, cout, out);
    initial
      $monitorb ("out = %b  A = %b  B = %b  c6 = %b  c0 = ", out,A,B,cout,cin);

    initial begin
      $dumpfile("dump.vcd");	
      $dumpvars;

	cin = 1'b0;
    A = 1'b0; B = 1'b1;
      #10 A = 1'b1; B = 1'b1;
      #10 A = 1'b0; B = 1'b0;
      #10 A = 1'b1; B = 1'b0;
    //#10 A = 6'b010101; B = 6'b101010; 
    #20 $finish;

    end

endmodule
*/




/*// Twobitadder.v Testbench
module TB();
  reg [1:0] A, B;
  reg cin;
  wire coT, coB, sum0, sum1;

    Twobitadder UUT(cin, A, B, coT, coB, sum0, sum1);
    initial
      $monitorb ("cin = %b  A = %b  B = %b  coT = %b  coB = %b  sum0 = %b  sum1 = %b ", cin, A, B, coT, coB, sum0, sum1);

    initial begin
      $dumpfile("dump.vcd");	
      $dumpvars;

	cin = 1'b0;
    A = 2'b00; B = 2'b11;
    //  #10 A = 1'b1; B = 1'b1;
    //  #10 A = 1'b0; B = 1'b0;
    //  #10 A = 1'b1; B = 1'b0;
    //#10 A = 6'b010101; B = 6'b101010; 
    #20 $finish;

    end

endmodule
*/
