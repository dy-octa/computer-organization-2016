`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:52:07 11/23/2016 
// Design Name: 
// Module Name:    IF 
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
module IF(
	 input Clk,
	 input Rst,
    input [31:0] nPCAlt,
	 input nPCSel,
	 input Stall,
    output [31:0] PC,
    output [31:0] instr
    );
	wire [31:0] nPC, cur_PC;
	assign nPC = nPCSel? nPCAlt : cur_PC + 4;
	pc pc (
		.Clk(Clk),
		.Rst(Rst),
		.Stall(Stall),
		.nPC(nPC),
		.PC(cur_PC)
	);
	im im (
		.PC(cur_PC),
		.instr(instr)
		
	);
	assign PC = cur_PC;

endmodule
