`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:24:29 12/21/2016 
// Design Name: 
// Module Name:    cp0 
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
module cp0(
    input [4:0] Addr,
    input [31:0] WData,
    input [31:0] PC_F,
	 input [31:0] nPCAlt_in,
	 input nPCSel_in,
    input [6:2] ExcCode,
    input [7:2] HWInt,
    input CPWrite,
    input ERet,
	 input Clk,
	 input Rst,
    output reg [31:0] nPCAlt,
    output reg nPCSel,
    output reg [31:0] RData,
	 output reg ExcStall
    );
	parameter EXL = 1, BD = 31, IE = 0;
	wire Exc = ((|(HWInt & sr[15:10])) | (|ExcCode)) && !sr[EXL] && sr[IE];
	reg [31:0] sr, cause, epc, PrID;

	initial begin
		sr = 0;
		cause = 0;
		epc = 0;
		PrID = 0;
	end
	
	always @(*) begin
		case (Addr)
			12: RData = sr;
			13: RData = cause;
			14: RData = epc;
			15: RData = PrID;
			default: RData = 0;
		endcase
	end

	always @(*) begin
		nPCAlt = nPCAlt_in;
		nPCSel = nPCSel_in;
		ExcStall = 0;
		if (Exc) begin
			nPCAlt = 'h0000_4180;
			nPCSel = 1;
			ExcStall = 1;
		end
		else if (ERet) begin
			nPCAlt = epc;
			nPCSel = 1;
			ExcStall = 1;
		end
	end

	always @(posedge Clk) begin
		if (Rst) begin
			sr <= 0;
			cause <= 0;
			epc <= 0;
		end
		else if (Exc) begin
			//$display("PC_F = %h nPCSel_in = %h",PC_F, nPCSel_in);
			if (nPCSel_in) begin
				cause[BD] <= 1;
				epc <= PC_F - 4;
			end
			else begin
				cause[BD] <= 0;
				epc <= PC_F;
			end
			sr[EXL] <= 1;
			cause[15:10] <= HWInt;
			cause[6:2] <= ExcCode;
			//$display("cause == %h @ INT",cause);
		end
		else if (ERet) begin
			sr[EXL] <= 0;
		end
		else if (CPWrite) begin
			case (Addr)
				12: begin 
					sr <= WData;
					//$display("sr <= %h",WData);
				end
				14: epc <= WData;
			endcase
		end
	end

endmodule
