`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:05:50 11/16/2016
// Design Name:   mips
// Module Name:   D:/ise/p4/mips_tb.v
// Project Name:  p5
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mips
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mips_tb;

	// Inputs
	reg Clk;
	reg Rst;
	
	wire [31:0] PrRData, PrAddr, PrWData;
	wire [7:2] HWInt;
	wire [3:0] PrMask;
	wire PrWrite;

	// Instantiate the Unit Under Test (UUT)
	mips uut (
		.clk(Clk), 
		.reset(Rst),
		.PrRData(PrRData),
		.HWInt(HWInt),
		.PrAddr(PrAddr),
		.PrWData(PrWData),
		.PrMask(PrMask),
		.PrWrite(PrWrite)
	);
	Bridge Bridge(
		.PrAddr(PrAddr),
		.PrWData(PrWData),
		.PrMask(PrMask),
		.PrWrite(PrWrite),
		.HWInt(HWInt),
		.PrRData(PrRData),
		.Clk(Clk), 
		.Rst(Rst)
	);
	always #1 Clk=~Clk;
	initial begin
		// Initialize Inputs
		Clk = 0;
		Rst = 0;
//      #195;
//		Rst = 1;
//		#30;
//		Rst = 0;
		// Add stimulus here

	end
      
endmodule

