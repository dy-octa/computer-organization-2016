`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:08:28 12/20/2016 
// Design Name: 
// Module Name:    Bridge 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Bridge(
    input [31:0] PrAddr,
    input [31:0] PrWData,
    input [3:0] PrMask,
    input PrWrite,
    output [7:2] HWInt,
    output [31:0] PrRData,
    input Clk,
    input Rst
    );
	reg T0Write, T1Write;
	reg [3:0] TAddr;
	wire AccessT0 = PrAddr >= 'h0000_7f00 && PrAddr <= 'h0000_7f0b;
	wire AccessT1 = PrAddr >= 'h0000_7f10 && PrAddr <= 'h0000_7f1b;
	wire [31:0] T0RData, T1RData;
	assign PrRData = AccessT0 ? T0RData : (AccessT1 ? T1RData : 0);

	always @(*) begin
		if (AccessT0 && PrWrite) begin
			T0Write = 1;
			T1Write = 0;
			TAddr = PrAddr - 'h0000_7f00;
		end else 
		if (AccessT1 && PrWrite) begin
			T0Write = 0;
			T1Write = 1;
			TAddr = PrAddr - 'h0000_7f10;
		end
		else begin
			T0Write = 0;
			T1Write = 0;
			TAddr = 0;
		end
	end
	
	timer timer0(
		.Clk(Clk),
		.Rst(Rst),
		.Addr(TAddr[3:2]),
		.WEn(T0Write),
		.WData(PrWData),
		.RData(T0RData),
		.IRQ(T0IRQ)
	);

	timer timer1(
		.Clk(Clk),
		.Rst(Rst),
		.Addr(TAddr[3:2]),
		.WEn(T1Write),
		.WData(PrWData),
		.RData(T1RData),
		.IRQ(T1IRQ)
	);
	assign HWInt[7:4] = 0;
	assign HWInt[2] = T0IRQ;
	assign HWInt[3] = T1IRQ;
	
		

endmodule
