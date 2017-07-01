`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:11:41 11/23/2016 
// Design Name: 
// Module Name:    StageReg 
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
module StageReg(
    input Clk,
    input Rst,
	 input StallClr,
    input Stall,
    input [31:0] PC_in,
    input [31:0] instr_in,
    input [31:0] Din1,
    input [31:0] Din2,
    input [31:0] Din3,
    output reg [31:0] PC,
    output reg [31:0] instr,
    output reg [31:0] D1,
    output reg [31:0] D2,
    output reg [31:0] D3
    );
	initial begin
		PC <= 'h0000_0000;
		instr <= 0;
		D1 <= 0;
		D2 <= 0;
		D3 <= 0;
	end
	always @(posedge Clk) begin
		if (Rst) begin
			PC <= 'h0000_0000;
			instr <= 0;
			D1 <= 0;
			D2 <= 0;
			D3 <= 0;
		end
		else if (StallClr === 1) begin
			PC <= PC_in;
			instr <= 0;
			D1 <= 0;
			D2 <= 0;
			D3 <= 0;
		end
		else if (Stall !== 1) begin
			PC <= PC_in;
			instr <= instr_in;
			D1 <= Din1;
			D2 <= Din2;
			D3 <= Din3;
		end
	end

endmodule
