`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:55:59 11/23/2016 
// Design Name: 
// Module Name:    nPC_Ctrl 
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
module nPC_Ctrl(
    input signed [31:0] Rd1,
    input signed [31:0] Rd2,
    input [31:0] imm,
	 input [31:0] target,
    input [31:0] PC,
    input Jump,
	 input JumpSrc,
    input [3:0] Branch,
    output reg [31:0] nPCAlt,
	 output reg nPCSel
    );
	wire signed [31:0] Res = Branch[3] ? Rd1 : Rd1 - Rd2;
	wire gtz = Res > 0;
	wire zero = Res == 0;
	wire ltz = Res < 0;
	always @(*) begin
		nPCSel = 0;
		nPCAlt = 0;
		if (Jump) begin
			nPCAlt = PC + 4;
			nPCSel = 1;
			if (JumpSrc)
				nPCAlt = target;
			else nPCAlt = {nPCAlt[31:28], imm[25:0], 2'b00};
		end
		else if ((Branch[2]&gtz) | (Branch[1]&zero) | (Branch[0]&ltz)) begin
			nPCSel = 1;
			nPCAlt = PC + 4 + (imm <<< 2);
		end
		else ;
	end
endmodule
