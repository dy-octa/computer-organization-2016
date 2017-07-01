`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:10:49 11/15/2016 
// Design Name: 
// Module Name:    pc 
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
module pc(
    input Clk,
    input Rst,
	 input Stall,
	 input [31:0] nPC,
    output reg [31:0] PC
    );
	initial PC <= 'h0000_3000; 
	always @(posedge Clk) begin
		if (Rst)
			PC <= 'h0000_3000;
		else if (!Stall)
			PC <= nPC;
//		$display("PC: %h\n",PC);
	end

endmodule
