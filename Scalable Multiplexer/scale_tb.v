`timescale 1ns/1ns
module scale_tb();
//using parameter SIZES of 1,2,5,8

reg [7:0]A8,B8;
reg [4:0]A5,B5;
reg [1:0]A2,B2;
reg A1,B1;
reg SEL;

wire [7:0] OUT8;
wire [4:0] OUT5;
wire [1:0] OUT2;
wire OUT1;

// Using module instance parameter value
	scale_mux #(8) MUX8(A8,B8,SEL,OUT8);
// Using named parameter passing
  scale_mux #(.Size(5)) MUX5(A5,B5,SEL,OUT5);

// Using defparam
  defparam MUX2.Size=2;
  scale_mux MUX2(A2,B2,SEL,OUT2);
// Instantiating MUX with regular Size of 1
  scale_mux MUX1(A1,B1,SEL,OUT1);

initial begin
  $vcdpluson;
  $monitor("%d ns, OUT8=%b, OUT5=%b, OUT2=%b, OUT1=%b \n\t\t A8=%b ,B8=%b, SEL=%b",$time,OUT8,OUT5,OUT2,OUT1,A8,B8,SEL);
end

always @* begin   // making 5,2, and 1 
  A5=A8[4:0];
  B5=B8[4:0];

  A2=A8[1:0];
  B2=B8[1:0];

  A1=A8[0];
  B1=B8[0];
end

initial begin
  // SEL=1, so OUT=B
  $display("\nTest 1: SEL=1, A=!B, OUT=B"); A8=8'b01010101; B8=8'b10101010; SEL=1'b1;
  // SEL=0, so OUT=A, A and B stay the same 
  #10 $display("\nTest 2: SEL=0, OUT=A");SEL=1'b0;
// SEL=x, so if A=B, OUT=A=B, if A!=B, OUT=x
  // SEL=x, some common and some different bits between A and B
  #10 $display("\nTest 3: SEL=x, A[7:4]=B[7:4], OUT[7:4]=A[7:4], OUT[3:0]=x"); A8=8'b10101010; B8=8'b10100101; SEL=1'bx;
  // SEL=x, A=!B OUT=x
  #10 $display("Test 4: SEL=x, A!=B, OUT=x"); A8=8'b11111111; B8=8'b00000000; SEL=1'bx;
  // SEL=x, A=B, OUT=1
  #10 $display("\nTest 5: SEL=x, A=B=1, OUT=A=0"); A8=8'b11111111; B8=8'b11111111; SEL=1'bx;
  // SEL=x, A=B=0, OUT=0
  #10 $display("\nTest 6: SEL=x, A=B=0, OUT=A=0"); A8=8'b00000000; B8=8'b00000000; SEL=1'bx;
#10 $finish;
end
endmodule
