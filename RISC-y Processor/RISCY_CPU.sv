`timescale 1ns/100ps
`default_nettype none
package cycle_package;
   typedef enum [1:0] {FETCH = 0, DECODE = 1, EXECUTE = 2, UPDATE = 3} CYCLE;
endpackage


// ********** Top Level CPU
module RISCY(CLK,RST,IO);
	import cycle_package::*;
	input CLK, RST;
	inout [7:0] IO;

	wire IR_EN, A_EN, B_EN, PDR_EN, PORT_EN, PORT_RD, PC_EN, LOAD_EN, ALU_EN, ALU_OE, RAM_OE, RDR_EN, RAM_CS;
	
	CYCLE PHASE;
	wire PORT_DIR_OUT, AASD_RST;
	wire [3:0] OPCODE;
	wire [11:0] RESERVED;
	wire [6:0] ADDR;
	wire [4:0] PROG_ADDR;
	wire [7:0] DATA, ROM_DATA, RAM_DATA, PORT_DATA_OUT, A_OUT, B_OUT;
	wire [7:0] BiDi_Data;
	wire [31:0] ROM_OUT;
	wire I_FLAG, OF, SF, ZF, CF;
	
	// Memory Subsystem
	RAM	RAM8(.DATA(BiDi_Data), .ADDR(ROM_DATA[4:0]), .OE(RAM_OE), .CS(RAM_CS), .WS(CLK));
	SCALE_REG #(8) REG8(.REG_OUT(RAM_DATA), .DATA_IN(BiDi_Data), .EN(RDR_EN), .CLOCK(CLK));
	
	ROM	ROM32(.DATA(ROM_OUT), .ADDR(PROG_ADDR), .OE(1'b1), .CS(1'b0));
	ProgCount #(5) PrgCnt(.Count(PROG_ADDR), .CLOCK(CLK), .RESET(AASD_RST), .Enable(PC_EN), .Load(LOAD_EN), .Data(ADDR[4:0])); 
	SCALE_REG #(32) REG32(.REG_OUT({OPCODE,I_FLAG, ADDR, RESERVED, ROM_DATA}), .DATA_IN(ROM_OUT), .EN(IR_EN), .CLOCK(CLK));
	

	// IO Subsystem
	PORT_DIR_REG PDR(.REG_OUT(PORT_DIR_OUT), .DATA_IN(DATA[0]), .PDR_EN(PDR_EN),.CLOCK(CLK), .RESET(AASD_RST));
	SCALE_REG #(8) IOREG(.REG_OUT(PORT_DATA_OUT), .DATA_IN(DATA), .EN(PORT_EN), .CLOCK(CLK));
	Tri_State_Buffer	Port_Data(.OUT(IO), .A(PORT_DATA_OUT), .SEL(PORT_DIR_OUT));
	Tri_State_Buffer	Port_Read(.OUT(BiDi_Data), .A(IO), .SEL(PORT_RD));

	
	// ALU Subsystem
	SCALE_REG #(8) A_Reg(.REG_OUT(A_OUT), .DATA_IN(DATA), .EN(A_EN), .CLOCK(CLK));
	SCALE_REG #(8) B_Reg(.REG_OUT(B_OUT), .DATA_IN(DATA), .EN(B_EN), .CLOCK(CLK));
	ALU #(8) ALU0(.CLK(CLK), .EN(ALU_EN), .OE(ALU_OE), .OPCODE(OPCODE), .A(A_OUT), .B(B_OUT), .ALU_OUT(BiDi_Data), .CF(CF), .OF(OF), .SF(SF), .ZF(ZF));	
	
	
	// Memory to Data Bus Subsysten
	scale_mux #(8) MUX(.A(ROM_DATA), .B(RAM_DATA), .SEL(RAM_OE), .OUT(DATA));

	
	// Sequence Controller Subsystem
	AASD AASD0(.AASD_RST(AASD_RST), .CLOCK(CLK), .RESET(RST));
	phaser Phsr(.CLOCK(CLK), .RESET(AASD_RST), .EN(1'b0), .PHASE(PHASE));
	sequence_controller SeqCtrl(.ADDR(ADDR), .OPCODE(OPCODE), .PHASE(PHASE), .I_FLAG(I_FLAG), .ZF(ZF), .NF(SF), .OF(OF), .CF(CF), .IR_EN(IR_EN), .A_EN(A_EN), .B_EN(B_EN), .PDR_EN(PDR_EN), .PORT_EN(PORT_EN), .PORT_RD(PORT_RD), .PC_EN(PC_EN), .PC_LOAD(LOAD_EN), .ALU_EN(ALU_EN), .ALU_OE(ALU_OE), .RAM_OE(RAM_OE), .RDR_EN(RDR_EN), .RAM_CS(RAM_CS));
	
endmodule


// ********** Sequence Controller
module sequence_controller(ADDR,OPCODE,PHASE,I_FLAG,ZF,NF,OF,CF,IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN,PC_LOAD,ALU_EN,ALU_OE,RAM_OE,RDR_EN,RAM_CS);
    import cycle_package::*;
	input [6:0] ADDR;
	input [3:0] OPCODE;
	input CYCLE PHASE;
	input I_FLAG,ZF,NF,OF,CF;
	output reg IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN,PC_LOAD,ALU_EN,ALU_OE,RAM_OE,RDR_EN,RAM_CS;
	reg branches;
// Instruction set 	
  localparam	LOAD = 0,
		  		STORE = 1,
		  		ADD = 2,
		  		SUB = 3,
		  		AND = 4,
		  		OR = 5,
		  		XOR = 6,
		  		NOT = 7,
		  		B = 8,	
		  		BZ = 9,	
		  		BN = 10,	
		  		BV = 11,	
		  		BC = 12;	

always @(PHASE,I_FLAG,ZF,NF,OF,CF,ADDR,OPCODE)
	case (PHASE)
// FETCH
	FETCH:
	begin
	IR_EN=1'b1; 
	PC_EN=1'b0;
	end
// DECODE
	DECODE:
	begin
		case (OPCODE)
		LOAD:
		begin
		RAM_OE <= 1'b1;
		RAM_CS <= 1'b1;
		RDR_EN <= 1'b1;
		end

		STORE:
		begin
		if(ADDR==67) PORT_RD <= 1'b1;
		else ALU_OE <= 1'b1;
		end

		ADD:
		begin
		A_EN = 1'b1;
		B_EN = 1'b1;
		end

		SUB:
		begin
		A_EN = 1'b1;
		B_EN = 1'b1;
		end

		AND:
		begin
		A_EN = 1'b1;
		B_EN = 1'b1;
		end

		OR:
		begin
		A_EN = 1'b1;
		B_EN = 1'b1;
		end

		XOR:
		begin
		A_EN = 1'b1;
		B_EN = 1'b1;
		end

		NOT:
		begin
		A_EN = 1'b1;
		B_EN = 1'b1;
		end

/*		B:
		begin
		branches <= 1'b1;
		end

		BZ:
		begin
		if (ZF) branches <= 1'b1;
		else branches <= 1'b0;
		end

		BN:
		begin
		if (NF) branches <= 1'b1;
		else branches <= 1'b0;
		end

		BV:
		begin
		if (OF) branches <= 1'b1;
		else branches <= 1'b0;
		end

		BC:
		begin
		if (CF) branches <= 1'b1;
		else branches <= 1'b0; 
		end   */
		endcase
	end 
// EXECUTE
	EXECUTE:
	begin 
		case (OPCODE) 
		LOAD:
		begin
			case (ADDR)
			64: A_EN = 1'b1;    
			65: B_EN =1'b1;     
			66: PDR_EN <=1'b1;   
			67: PORT_EN <=1'b1;  
			endcase
		end
		
		STORE:
		begin
		RAM_CS <= 1'b0;
		end
		
		ADD:
		begin
		ALU_EN <=1'b1; 
		end

		SUB:
		begin
		ALU_EN <=1'b1;
		end

		AND:
		begin
		ALU_EN <=1'b1;
		end

		OR:
		begin
		ALU_EN <=1'b1;
		end

		XOR:
		begin
		ALU_EN <=1'b1;
		end

		NOT:
		begin
		ALU_EN <=1'b1;
		end

	endcase
    end
/*// BRANCH CHECKING
  if (branches)
	 begin
	 PC_LOAD <=1'b1;
	 branches <=1'b0;
	 end
	 else
	 begin
	 PC_LOAD <=1'b0;
  end
*/
	//end
// UPDATE
	UPDATE: begin
	case(OPCODE)
		B: PC_LOAD=1'b1;
		BZ: PC_LOAD=ZF;
		BN: PC_LOAD=NF;
		BV: PC_LOAD=OF;
		BC: PC_LOAD=CF;
		default: PC_LOAD=1'b0;
	endcase
	IR_EN <= 1'b0;
	A_EN = 1'b0;
	B_EN = 1'b0;
	PDR_EN <= 1'b0;
	PORT_EN <= 1'b0;
	PORT_RD <= 1'b0;
	ALU_EN <= 1'b0;
	ALU_OE <= 1'b0;
	RAM_OE <= 1'b0;
	RDR_EN <= 1'b0;
	PC_EN=1'b1; 
	PC_LOAD=1'b0; 
	RAM_CS <= 1'b1; 
	end
// DEFAULT
    default: begin
      	IR_EN <= 1'b0;
		A_EN = 1'b0;
		B_EN = 1'b0;
		PDR_EN <= 1'b0;
		PORT_EN <= 1'b0;
		PORT_RD <= 1'b0;
		ALU_EN <= 1'b0;
		ALU_OE <= 1'b0;
		RAM_OE <= 1'b0;
		RDR_EN <= 1'b0;
		PC_EN=1'b0; 
		PC_LOAD=1'b0; 
		RAM_CS <= 1'b1;
    end
	endcase
endmodule


// ********** Phase Generator
module phaser(CLOCK, RESET, EN, PHASE);
  import cycle_package::*;
  input CLOCK, RESET, EN;
  output CYCLE PHASE;
  
  always @(posedge CLOCK, negedge RESET) begin
    if(!RESET)
      PHASE <= PHASE.first();
    else if(!EN)
      PHASE <= PHASE.next();
    else
      PHASE <= PHASE;
  end
endmodule


// ********** RAM
module RAM(DATA, ADDR, OE, CS, WS);
  inout [7:0] DATA;
  input [4:0] ADDR; 
  input OE, CS, WS;
  reg [7:0] memory [0:31];
  
  // if OE=1 and CS=0, DATA=memory at ADDR; if not, DATA=z
  // assign is used because of inout type
  assign DATA = (OE && !CS) ? memory[ADDR] : 8'bz;
  always@(posedge WS) begin
    if (!OE && !CS)
      memory[ADDR] <= DATA;
	else
	  memory[ADDR] <= memory[ADDR];	// to prevent latches in hardware
  end
endmodule


// ********** ROM
module ROM(DATA, ADDR, OE, CS);
  output reg [31:0] DATA;
  input wire [4:0] ADDR; 
  input OE, CS;
  reg [31:0] memory [0:31];
  
  // if OE=1 and CS=0, DATA=memory at ADDR; if not, DATA=z
  always@* DATA = (OE && !CS) ? memory[ADDR] : 32'bz;

endmodule


// ********** SCALABLE REGISTER
module SCALE_REG(REG_OUT,DATA_IN,EN,CLOCK);
	parameter RegSize = 1;
	output reg [ RegSize - 1 : 0] REG_OUT;
	input reg [ RegSize - 1 : 0] DATA_IN;
	input CLOCK,EN;
  always @ (posedge CLOCK) begin
	if(EN)
		REG_OUT <= DATA_IN;
	else
		REG_OUT <= REG_OUT;
  end
endmodule


// ********** PORT DIRECTION REGISTER (ONE BIT)
module PORT_DIR_REG(REG_OUT,DATA_IN,PDR_EN,CLOCK,RESET);
	output reg REG_OUT;
	input reg DATA_IN;     // DATA[0]
	input CLOCK,RESET,PDR_EN;
  always @ (posedge CLOCK or negedge RESET) begin
	if(PDR_EN)
		REG_OUT <= DATA_IN;
	else if (!RESET)
		REG_OUT <= 0;
	else
		REG_OUT <= REG_OUT;
  end
endmodule



// ********** AASD
module AASD(AASD_RST,CLOCK,RESET);
	output reg AASD_RST;
	input CLOCK,RESET;
	reg Out1; //this is the wire for the output of the first FF
always @ (posedge CLOCK or negedge RESET) //allows 4 synchronous/asynchronous
	if(!RESET)begin//asynchronous reset
		Out1 <= 1'b0;
		AASD_RST <= 1'b0;
	end
	else begin
		Out1 <= 1'b1;
		AASD_RST <= Out1;
	end
endmodule


/* OBSOLETE
// ********** IO PORT
module IO_PORT(DATA_BUS, PDR_EN, PORT_EN, PORT_RD, CLOCK, RESET, IO, PORT_READ_DATA);
	input [7:0] DATA_BUS;
	input PDR_EN,PORT_EN,PORT_RD,CLOCK,RESET;
	inout [7:0] IO;
	wire PDiR; //output wire for Port direction register
	wire [7:0] PDaR; //output wire for Port data register
	output [7:0] PORT_READ_DATA;
	
	PORT_DIR_REG Port_Direction_Register(PDiR,DATA_BUS[0],PDR_EN,CLOCK,RESET); 	// REG_OUT,DATA_IN,PDR_EN,CLOCK,RESET	
	SCALE_REG #(8) Port_Data_Register(PDaR,DATA_BUS,PORT_EN,CLOCK);				// REG_OUT,DATA_IN,EN,CLOCK
	
	assign IO = PDiR ? PDaR : 8'bz; //first tri state buffer
	assign PORT_READ_DATA = PORT_RD ? IO : 8'bz; //second tri state buffer
endmodule 
*/


// ********** Tri State Buffer
module Tri_State_Buffer(OUT, A, SEL);
	input [7:0] A;
	input 		SEL;
	inout [7:0] OUT;
	
	assign OUT = SEL ? A : 8'bz; //first tri state buffer
endmodule 


// ********** Program Counter
module ProgCount(Count, CLOCK, RESET, Enable, Load, Data); 
	parameter PCSize = 1;
	output reg [PCSize-1:0] Count; 
	input  [PCSize-1:0] Data; 
	input  CLOCK, Enable, RESET, Load; 
	
	always @ (posedge CLOCK or negedge RESET)
		if(!RESET)
			Count <= 0;
		else if(Enable)
			begin
				if(Load)
					Count <= Data;
				else
					Count <= Count+ 1;
	end
endmodule


// ********** ALU
module ALU(CLK, EN, OE, OPCODE, A, B, ALU_OUT, CF, OF, SF, ZF);
  parameter WIDTH = 8;
  output reg [ WIDTH-1 : 0] ALU_OUT;
  output reg CF, OF, SF, ZF;
  input [3:0] OPCODE;
  input [ WIDTH-1 : 0] A, B;
  input reg CLK, EN, OE;
  reg [ WIDTH-1 : 0] temp;
  localparam ADDalu = 4'b0010,
             SUBalu = 4'b0011,
             ANDalu = 4'b0100,
             ORalu  = 4'b0101,
             XORalu = 4'b0110,
             NOTalu = 4'b0111;
always @(OE, temp) ALU_OUT = (OE) ? temp : 8'bz;
always @(posedge CLK) begin
  if(EN) begin
    case (OPCODE)
      ADDalu: begin
       temp = A + B;
        // Carry Flag
        if (A+B> 2**WIDTH -1) CF=1;
        else CF=0;
        // Signed Flag
        if (temp[WIDTH-1]==1) SF=1;
        else SF=0;
        // Zero Flag
        if(temp==0) ZF=1;
        else ZF=0;
        // Overflow Flag
        if(A>0 && B>0 && temp<0) OF=1;
        else if (A<0 && B<0 && temp>0) OF=1;
        else OF=0;
      end
      SUBalu: begin
       temp = A - B;
        // Carry Flag
        if (A<B) CF=1;
        else CF=0;
        // Signed Flag
        if (temp[WIDTH-1]==1) SF=1;
        else SF=0;
        // Zero Flag
        if(temp==0) ZF=1;
        else ZF=0;
        // Overflow Flag
        if(A>0 && B>0 && temp<0) OF=1;
        else if (A<0 && B<0 && temp>0) OF=1;
        else OF=0;
      end
      ANDalu: begin
       temp = A&B;
        // Signed Flag
        if(temp[WIDTH-1]==1) SF=1;
        else SF=0;
        // Zero Flag
        if(temp==0) ZF=1;
        else ZF=0;
      end
      ORalu: begin
       temp = A|B;
        // Signed Flag
        if(temp[WIDTH-1]==1) SF=1;
        else SF=0;
        // Zero Flag
        if(temp==0) ZF=1;
        else ZF=0;
      end
      XORalu: begin
       temp = A^B;
        // Signed Flag
        if(temp[WIDTH-1]==1) SF=1;
        else SF=0;
        // Zero Flag
        if(temp==0) ZF=1;
        else ZF=0;
      end
      NOTalu: begin
       temp = ~A;
        // Signed Flag
        if(temp[WIDTH-1]==1) SF=1;
        else SF=0;
        // Zero Flag
        if(temp==0) ZF=1;
        else ZF=0;
      end
      default: temp = 1'bx;
    endcase
  end
end
endmodule


// ********** Multiplexer
module scale_mux(A, B, SEL, OUT);
  parameter Size = 1;
  output reg [Size-1:0] OUT;
  input [Size-1:0] A, B;
  input SEL;
  
  always @(SEL, A, B)
    	OUT = SEL ? B : A; // if SEL=1, OUT=B,   if SEL=0, OUT=A
  		// if SEL=x, then A=B causes OUT=A=B, and A!=B, OUT=x
endmodule