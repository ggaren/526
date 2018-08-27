/***********************************************************************
*** ECE526L Experiment #8 				  Garen Nikoyan, Spring 2018  
***  Arithmetic-Logic Unit Modeling
************************************************************************
*** Filename: ALU.sv	    Created by: Garen Nikoyan, 4/5/2018  ***
*** -Revision History
***    4/5/2018: First draft                                  
************************************************************************
*** This module models an ALU
***   It can add, subtract, AND, OR, XOR and NOT. It has a carry flag,
***   overflow flag, signed flag, and zero flag.
***   EN needs to be high to enable the ALU, and OE needs to be high 
************************************************************************/
`timescale 1ns/100ps
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
