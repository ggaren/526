`timescale 1ns/100ps
module ROM(DATA, ADDR, OE, CS);
  output reg [7:0] DATA;
  input wire [4:0] ADDR; 
  input OE, CS;
  reg [7:0] memory [0:31];
  
  // if OE=1 and CS=0, DATA=memory at ADDR; if not, DATA=z
  always@* DATA = (OE && !CS) ? memory[ADDR] : 8'bz;

endmodule
