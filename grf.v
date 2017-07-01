`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:32:51 11/15/2016 
// Design Name: 
// Module Name:    grf 
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
module grf(
    input Clk,
    input Rst,
    input [4:0] RS1,
    input [4:0] RS2,
    input [4:0] WAddr,
    input RegWrite,
    input [31:0] WData,
    output [31:0] RData1,
    output [31:0] RData2
    );
	reg [31:0] _reg[31:0];
	integer i;
	initial begin 
		for (i=0;i<32;i=i+1)
				_reg[i] = 0;
	end
	always @(posedge Clk) begin
		if (Rst) begin
			for (i=0;i<32;i=i+1)
				_reg[i] <= 0;
		end else
			if (RegWrite) begin
					$display("$%d <= %h", WAddr, WData);
					_reg[WAddr] <= WData;
				end
		
/*		$display("GRF:\n");
		for (i=1;i<32;i=i+1)
			if (_reg[i]!=0)
				$display("%d: %d\n",i,_reg[i]);
*/
	end
	assign RData1 = RS1 == 0? 0 : ( RegWrite && RS1 == WAddr ? WData : _reg[RS1]);
	assign RData2 = RS2 == 0? 0 : ( RegWrite && RS2 == WAddr ? WData : _reg[RS2]);
	

endmodule
