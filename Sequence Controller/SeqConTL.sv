/***********************************************************************
*** ECE526L Experiment #9 				  Garen Nikoyan, Spring 2018  
***  Modeling a Sequence Controller
************************************************************************
*** Filename: toplevel.sv	    Created by: Garen Nikoyan, 4/26/2018  ***
*** -Revision History
***    4/26/2018: First draft
***    5/8/2018: Changed branching in sequence_controller 
***	   5/10/2018:  Needs proper testing, error in test vectors, branch flags                                 
************************************************************************
*** This module instantiates a sequence_controller, AASD, and phase_generator
***   It is meant to fit into a larger design, such as processor. 
***   This module will provide the proper enable lines for certian opcodes
*** throughout FETCH, DECODE, EXECUTE, and UPDATE cycles 
************************************************************************/
`timescale 1ns/100ps
`default_nettype none
package cycle_package;
typedef enum [1:0] {FETCH =0, DECODE = 1, EXECUTE = 2, UPDATE = 3} CYCLE;
endpackage

module toplevel(ADDR,OPCODE,I_FLAG,ZF,NF,OF,CF,IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN,PC_LOAD,ALU_EN,ALU_OE,RAM_OE,RDR_EN,RAM_CS,CLK,RST,EN);

import cycle_package::*; //imports package 
	input [6:0] ADDR;
	input [3:0] OPCODE;
	input I_FLAG,ZF,NF,OF,CF,RST,CLK,EN;
	output reg IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN,PC_LOAD,ALU_EN,ALU_OE,RAM_OE,RDR_EN,RAM_CS;

    CYCLE PHASE;
	wire AASD_RST;
	
  sequence_controller seq_cont(ADDR,OPCODE,PHASE,I_FLAG,ZF,NF,OF,CF,IR_EN,A_EN,B_EN,PDR_EN,PORT_EN,PORT_RD,PC_EN,PC_LOAD,ALU_EN,ALU_OE,RAM_OE,RDR_EN,RAM_CS);
	
  AASD aasd_seq(AASD_RST,CLK,RST);
	
  phaser phase_gen(CLK,AASD_RST,EN,PHASE);
endmodule


// ********** Sequence controller
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