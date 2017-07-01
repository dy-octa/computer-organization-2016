`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:46:12 11/15/2016 
// Design Name: 
// Module Name:    alu 
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
module alu(
    input signed [31:0] A,
    input signed [31:0] B,
	 input Unsigned,
    input [3:0] AluOp,
    output reg [31:0] Res,
    output gtz,
    output zero,
    output ltz
    );
	integer i;

	always@(*) begin
		case (AluOp)
			0: Res = A + B;
			1: Res = A - B;
			2: Res = B;
			4: Res = {B,B}>>A;
			5: Res = B << 16;
			6: Res = A & B;
			7: Res = A | B;
			8: Res = ~ (A | B);
			9: Res = A ^ B;
			10:
				if (Unsigned)
					Res = $unsigned(A)<$unsigned(B);
				else Res = A < B;
			11: Res = A;
			12: Res = (B >>> A[4:0]);
			13: Res = (B >> A[4:0]);
			14: Res = (B <<< A[4:0]);
			15: Res = (B << A[4:0]);
			default: Res = {32{1'bx}};
		endcase
	end
	assign gtz = $signed(Res) > 0;
	assign zero = $signed(Res) == 0;
	assign ltz = $signed(Res) < 0;
endmodule
