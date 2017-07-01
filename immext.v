`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:47:32 11/15/2016 
// Design Name: 
// Module Name:    ext16 
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
module ImmExt(
    input [31:0] instr,
    input [1:0] ExtOp,
    output reg [31:0] imm32
    );
	wire [15:0] imm16 = instr[15:0];
	wire signed [15:0] sig_imm = imm16;
	wire [4:0] shamt = instr[10:6];
	wire [25:0] target = instr[25:0];
	always @(*) begin
		case (ExtOp)
			0: imm32 = imm16;
			1: imm32 = sig_imm;
			2: imm32 = shamt;
			3: imm32 = target;
			default: ;
		endcase
	end
endmodule
