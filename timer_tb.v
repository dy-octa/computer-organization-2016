`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:22:19 12/21/2016
// Design Name:   timer
// Module Name:   D:/ise/p7/timer_tb.v
// Project Name:  p7
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: timer
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module timer_tb;

	// Inputs
	reg Clk;
	reg Rst;
	reg [3:2] Addr;
	reg WEn;
	reg [31:0] WData;

	// Outputs
	wire [31:0] RData;
	wire IRQ;

	// Instantiate the Unit Under Test (UUT)
	timer uut (
		.Clk(Clk), 
		.Rst(Rst), 
		.Addr(Addr), 
		.WEn(WEn), 
		.WData(WData), 
		.RData(RData), 
		.IRQ(IRQ)
	);
	always #10 Clk = ~Clk;
	initial begin
		// Initialize Inputs
		Clk = 0;
		Rst = 0;
		Addr = 0;
		WEn = 0;
		WData = 0;

		// Wait 100 ns for global reset to finish
		#100;
      Addr = 1;
		WData = 10;
		WEn = 1;
		
		#20;
		Addr = 0;
		WData = {0,'b1001};
		WEn = 1;
		#20;
		Addr = 2;
		#300;
		Addr = 0;
		WData[0] = 1;
		#50;
		WEn = 0;
		Addr = 2;
		// Add stimulus here

	end
      
endmodule

