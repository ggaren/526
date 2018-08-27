
`timescale 1ns/100ps
//`define SignedINTs  // if not commented out, signed inputs are used

module ALU_TB();
  parameter WIDTH = 8;
  reg CF, OF, SF, ZF;
  reg [3:0] OPCODE;
  reg CLK, EN, OE;
  
  `ifdef SignedINTs begin
    reg signed [ WIDTH-1 : 0] ALU_OUT;
    reg signed [ WIDTH-1 : 0] A, B;
  end
  
  `else begin
    reg [ WIDTH-1 : 0] ALU_OUT;
    reg [ WIDTH-1 : 0] A, B;  
  end
  `endif
  
  ALU UUT(CLK, EN, OE, OPCODE, A, B, ALU_OUT, CF, OF, SF, ZF);
  
  initial begin
    CLK=1'b0;
    forever #20 CLK=~CLK;
  end
  
  initial $monitor("OPCODE = %b  A =%4d  B =%4d  EN =%b  OE =%b \n\t\tALU_OUT =%4d  CF =%b  OF =%b  SF =%b  ZF =%b", OPCODE, A, B, EN, OE, ALU_OUT, CF, OF, SF, ZF);
  
  initial begin
    $vcdpluson;
  
  $display("\n\t\t\t Testing ADD");
  $monitoroff; OE=1; EN=1; OPCODE = 4'b0010; #10 $monitoron;
  #20 $display("ADD"); A=8'd6; B=8'd5;
  #40 $display("ADD, Zero flag"); A=8'd0; B=8'd0;
  #40 $display("ADD, Overflow and Carry flags"); A=8'd150; B=8'd106;
  #40 $display("ADD, Signed flag"); A=8'd128; B=8'd1;
  
  #60 $display("\n\t\t\t Testing SUB");
  $monitoroff; OE=1; EN=1; OPCODE = 4'b0011; $monitoron;
  #40 $display("SUB"); A=8'd60; B=8'd43;
  #40 $display("SUB, Zero flag"); A=8'd20; B=8'd20;
  #40 $display("SUB, Overflow flag"); A=8'd128; B=-8'd1;
  #40 $display("SUB, Signed and Carry flags"); A=8'd50; B=8'd100;

  #60 $display("\n\t\t\t Testing AND");
  $monitoroff; OE=1; EN=1; OPCODE = 4'b0100; $monitoron;
  #60 $display("AND"); A=8'd10; B=8'd10;
  #40 $display("AND, Zero flag"); A=8'd20; B=8'd10;
  #40 $display("AND, Signed flags"); A=8'd128; B=8'd128;

  #60 $display("\n\t\t\t Testing OR");
  $monitoroff; OE=1; EN=1; OPCODE = 4'b0101; $monitoron;
  #60 $display("OR"); A=8'd20; B=8'd10;
  #40 $display("OR, Zero flag"); A=8'd0; B=8'd0;
  #40 $display("OR, Signed flags"); A=8'd10; B=-8'd5;

  #60 $display("\n\t\t\t Testing XOR");
  $monitoroff; OE=1; EN=1; OPCODE = 4'b0110; $monitoron;
  #60 $display("XOR"); A=8'd37; B=8'd90;
  #40 $display("XOR, Zero flag"); A=8'd255; B=8'd255;
  #40 $display("XOR, Signed flags"); A=8'd128; B=8'd0;

  #60 $display("\n\t\t\t Testing NOT");
  $monitoroff; OE=1; EN=1; OPCODE = 4'b0111; $monitoron;
  #60 $display("NOT"); A=8'd37;
  #40 $display("NOT, Zero flag"); A=8'd255;
  #40 $display("NOT, Signed flags"); A=8'd127;

  #40 $finish;
  end
endmodule
// vcs -debug -full64 -sverilog ALU.sv ALU_TB.sv