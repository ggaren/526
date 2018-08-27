module BehavAdder(cin, A, B, coutb, outb);
  reg [6:0] temp;
	input cin;
	input [5:0] A, B;
    output reg coutb;
	output reg [5:0] outb;
    
  always @(cin, A, B)  begin
     temp = cin + A + B ;
     coutb = temp[6];
     outb =