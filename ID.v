`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:04:15 11/23/2016 
// Design Name: 
// Module Name:    ID 
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
module ID(
    input Clk,
    input Rst,
    input [31:0] PC_in,
    input [31:0] instr_in,

    input [31:0] Rd1F,
    input [31:0] Rd2F,
    input Rd1FSel,
    input Rd2FSel,

    input [31:0] RegWData,
	 input RegWrite,
	 input [4:0] RegWAddr,

    input Stall,
	 input ExcStall,
	 
	 input [31:0] CPRData,
	 output CPWrite,
	 output ERet,
	 output SWInt,

    output [31:0] nPCAlt,
	 output nPCSel,

    output [31:0] Rd1,
    output [31:0] Rd2,
    output [31:0] imm,

	 output [31:0] PC,
    output [31:0] instr
    );

	StageReg IF_ID(
		.Clk(Clk),
		.Rst(Rst),
		.Stall(Stall),
		.StallClr(ExcStall),
		.PC_in(PC_in),
		.instr_in(instr_in),
		.PC(PC),
		.instr(instr)
	);

	wire [5:0] func = instr[5:0];
	wire [4:0] shamt = instr[10:6];
	wire [4:0] rd = instr[15:11];
	wire [4:0] rt = instr[20:16];
	wire [4:0] rs = instr[25:21];
	wire [5:0] op = instr[31:26];

	wire [3:0] Branch;
	wire [1:0] ExtOp;
	wire [3:0] AluOp;
	Ctrl Ctrl(
		.instr(instr),
		.Branch(Branch),
		.ExtOp(ExtOp),
		.AluOp(AluOp),
		.Jump(Jump),
		.JumpSrc(JumpSrc),
		.Link(Link),
		.LinkSrc(LinkSrc),
		.ERet(ERet),
		.CPWrite(CPWrite),
		.Rd2AltCP(Rd2AltCP),
		.SWInt(SWInt)
	);

	wire [31:0] RData1, RData2;
	grf grf(
		.Clk(Clk),
		.Rst(Rst),
		.RS1(rs),
		.RS2(rt),
		.WAddr(RegWAddr),
		.RegWrite(RegWrite),
		.WData(RegWData),
		.RData1(RData1),
		.RData2(RData2)
	);
	
	assign Rd1 = Rd1FSel? Rd1F : RData1;
	assign Rd2 = Rd2AltCP? CPRData : (Rd2FSel? Rd2F : RData2);

	ImmExt ImmExt(
		.instr(instr),
		.ExtOp(ExtOp),
		.imm32(imm)
	);
	
	nPC_Ctrl nPC_Ctrl(
		.Rd1(Rd1),
		.Rd2(Rd2),
		.imm(imm),
		.target(Rd1),
		.PC(PC),
		.Jump(Jump),
		.JumpSrc(JumpSrc),
		.Branch(Branch),
		.nPCAlt(nPCAlt),
		.nPCSel(nPCSel)
	);

endmodule
