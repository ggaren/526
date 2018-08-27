`timescale 1ns/100ps
`default_nettype none
module toplevel_tb();

	reg [6:0] ADDR;
	reg I_FLAG,ZF,NF,OF,CF,RST,CLK,EN;
	wire IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN,PC_LOAD,ALU_EN,ALU_OE,RAM_OE,RDR_EN,RAM_CS;
	enum reg[3:0] {LOAD, STORE, ADD, SUB, AND, OR, XOR, NOT, B, BZ, BN, BV, BC} OPCODE;

	toplevel UUT(ADDR,OPCODE,I_FLAG,ZF,NF,OF,CF,IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN,PC_LOAD,ALU_EN,ALU_OE,RAM_OE,RDR_EN,RAM_CS,CLK,RST,EN);


initial //makes the clock
begin
	CLK=1'b0;
forever #10 CLK=~CLK;
end

initial
begin
  $monitor("OUTPUTS: %d ns\tIR_EN=%d A_EN=%d B_EN=%d PDR_EN=%d PORT_EN=%d PORT_RD=%d PC_EN=%d PC_LOAD=%d ALU_EN=%d ALU_OE=%d RAM_OE=%d RDR_EN=%d RAM_CS=%d",$time,IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN,PC_LOAD,ALU_EN,ALU_OE,RAM_OE,RDR_EN,RAM_CS);
    $vcdpluson;
	//  $dumpfile("dump.vcd");
    //  $dumpvars;
end

initial begin
  $monitoroff;
	RST = 1'b0; ADDR = 64; CF = 0; OF = 0; NF = 0; ZF = 0; I_FLAG = 1; OPCODE = 0; EN=1'b0;  //initial states
	#10 RST = 1'b1; 
	#110 $monitoron;
	#70 ADDR = 65;
	#80 ADDR = 66;
	#80 ADDR = 67;
	#80 I_FLAG = 0; ADDR = 64;
	#80 OPCODE = 1; ADDR = 64;
	#80 OPCODE = 1; ADDR = 67;
	#80 OPCODE = 2;
	#80 OPCODE = 8; CF = 0; OF = 0; NF = 0; ZF = 0;
	#80 OPCODE = 9;
	#80 OPCODE = 10;
	#80 OPCODE = 11;
	#80 OPCODE = 12;
	$finish;
end
endmodule
