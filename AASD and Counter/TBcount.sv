

`timescale  1 ns / 10 ps
`define period 10

module TBcount();
    reg Clock, Enable, Reset,Load; // inputs
    reg [5:0]Data;                 // inputs
    wire [5:0]Count;               // outputs

    TLcount UUT(Count,Data,Clock,Reset,Enable,Load);      // UUT = unit under test  

    always #(`period* 0.5) Clock=~Clock; // sets CLK to 50% duty cycle

    initial begin
     $vcdpluson;
     $monitor("%d ns  Data=%d  Enable=%b  Load =%b  Reset=%b   Count=%d",$time,Data,Enable,Load,Reset,Count);
     Clock=0; // setting the clock
    end

    initial begin
	Enable=0; Reset=1; Load=0; Data=6'b010101; // starting vector

	#(`period* 0.25) Reset=0; // checking if AASD works properly, demonstrating asynchronous reset
	#(`period* 1.75) Reset=1; // Asserting Reset asychronously 
	#`period Enable=1; // 
	#(`period* 8) Load=1; Data=6'b111100; // loading 60d after count reaches 7d
	#`period Load=0;  // Setting Load to 0 so counter will begin to increment
	#(`period* 10) Load=1; Enable=1; Data=6'b101010; 
	#`period Reset=0; // testing if reset overrides load
	#`period Reset=1; Load=0; // incrementing continues, showing Enable works properly
	#(`period* 9) Reset=0; // testing if reset overrides increment
     	#(`period) Reset=1; Enable=0; Load=1; Data=6'd36; // checking if Load works while Enable is low
     #(`period* 4) $finish;

    end
endmodule

