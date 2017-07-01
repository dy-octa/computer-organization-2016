`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:13:38 11/24/2016 
// Design Name: 
// Module Name:    WB 
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
module WB(
    input Clk,
    input Rst,
	 input [31:0] PC_in,
    input [31:0] instr_in,

    input [31:0] Res_in,
    input [31:0] MemRData_in,
	
    output reg [31:0] RegWData,
    output RegWrite,
    output reg [4:0] RegWAddr,
	 
	 output [31:0] ResW,
	 output [31:0] DataW,

	 output [31:0] PC,
	 output [31:0] instr
    );

	wire [31:0] Res, MemRData, MemData;
	StageReg EX_MEM(
		.Clk(Clk),
		.Rst(Rst),
		.PC_in(PC_in),
		.instr_in(instr_in),
		.Din1(Res_in),
		.Din2(MemRData_in),
		.D1(Res),
		.D2(MemRData),
		.PC(PC),
		.instr(instr)
	);
	
	assign ResW = Res;
	assign DataW = MemData;

	wire [3:0] MemMask;
	wire [1:0] MemExtPos;
	Ctrl Ctrl(
		.instr(instr),
		.RegDst(RegDst),
		.MemtoReg(MemtoReg),
		.MemMask(MemMask),
		.MemExtPos(MemExtPos),
		.RegWrite(RegWrite),
		.Link(Link),
		.LinkSrc(LinkSrc)
	);
	
	wire [4:0] rd = instr[15:11];
	wire [4:0] rt = instr[20:16];
	
	always @(*) begin
		RegWData = 0;
		RegWAddr = 0;
		if (Link) begin
			RegWData = PC + 8;
			if (LinkSrc)
				RegWAddr = rd;
			else RegWAddr = 31;
		end
		else begin
			if (RegDst)
				RegWAddr = rd;
			else RegWAddr = rt;
			if (MemtoReg)
				RegWData = MemData;
			else RegWData = Res;
		end
	end

	MemExt MemExt(
		.MemRData(MemRData),
		.MemMask(MemMask),
		.MemExtPos(MemExtPos),
		.subAddr(Res[1:0]),
		.MemData(MemData)
	);
	
	
	assign RegData = MemtoReg ? MemData : Res;

endmodule
