`timescale 1ns/100ps
module ROM_TB();
  reg OE,CS,WS,OE2,CS2;
  reg [4:0] ADDRbus, ADDRbus2;
  wire [7:0] DATAbus, DATAbus2;
  reg [7:0] biport;
  reg [7:0] BuffRAM [0:31];
  integer i,j,k;
  
  RAM RAM_UUT(DATAbus, ADDRbus, OE, CS, WS);
  ROM ROM_UUT(DATAbus2, ADDRbus2, OE2, CS2);
  
  assign DATAbus = (!OE && !CS) ? biport:8'bz; 
  initial $monitor("ADDR2 =%h,  DATA2 =%h,  OE2 =%b,  CS2 =%b", ADDRbus2, DATAbus2, OE2, CS2);
  initial $readmemh("ROM_data.txt", ROM_UUT.memory);
  

  initial begin
  $vcdpluson;
  //$dumpfile("dump.vcd");	
  //$dumpvars;
    
// *** Read
  $display("\t\t READ");
  #10 CS2=0; OE2=1;
  for(i=0; i<32; i=i+1) #10 ADDRbus2 = i;
    
// *** Scramble
    $display("\nSCRAMBLING DATA OF ROM INTO BUFFER RAM");
    for (i=0; i<32; i=i+1) begin
      k=0;
      for(j=7; j>0; j=j-2) begin
        if( ROM_UUT.memory[i] != 0) begin
          BuffRAM[i][j] = ROM_UUT.memory[i][k];
          k = k+1;
        end
        else;
      end
      for(j=0; j<7; j=j+2) begin
        if(ROM_UUT.memory[i] != 0) begin
          BuffRAM[i][j] = ROM_UUT.memory[i][k];
          k = k+1;
        end
        else;
      end
    end
// *** Write to RAM
    $monitor("ADDR =%h,  DATA =%h,  OE =%b,  CS =%b,  WS =%b", ADDRbus, DATAbus, OE, CS, WS);
    $monitoroff;
    #10 CS=0; OE=0;
    $display("\n\t\t WRITE SCRAMBLED DATA TO RAM");
    $monitoron;
    for(i=0;i<32;i=i+1) begin
      #10 $monitoroff; WS=0; biport=BuffRAM[i]; ADDRbus=i;
      #10 $monitoron; WS=1;
    end
// *** Block Read
  #10 $monitoroff;
  #10 CS=0; OE=1;
    $display("\n\t\t BLOCK READ OF RAM");
   for(j=0;j<32;j=j+1) begin
     $strobe("\t\t RAM[%2d] = %d",j, RAM_UUT.memory[j]);
     #10 ADDRbus=j;
   end

   #20 $finish;
  end
endmodule


//   vcs -debug -full64 ROM.v RAM.v ROM_TB.v
