`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:33:25 11/23/2016 
// Design Name: 
// Module Name:    EX 
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

module EX(
    input Clk,
    input Rst,
    input [31:0] PC_in,
    input [31:0] instr_in,

    input [31:0] Rd1,
    input [31:0] Rd2,
    input [31:0] imm_in,
    input [31:0] AF,
    input [31:0] BF,
    input [31:0] DataF,
    input AFSel,
    input BFSel,
    input DataFSel,

    input Stall,

	 output MDBusy,
	 output [31:0] Rd1E,
    output [31:0] Res,
    output [31:0] Data,

	 output [31:0] PC,
    output [31:0] instr
    );
	
	wire [31:0] RegA, RegB, imm;
	StageReg ID_EX(
		.Clk(Clk),
		.Rst(Rst),
		.StallClr(Stall),
		.PC_in(PC_in),
		.instr_in(instr_in),
		.Din1(Rd1),
		.Din2(Rd2),
		.Din3(imm_in),
		.D1(RegA),
		.D2(RegB),
		.D3(imm),
		.PC(PC),
		.instr(instr)
	);
	assign Rd1E = RegA;

	wire [3:0] AluOp, MDOp;
	Ctrl Ctrl(
		.instr(instr),
		.AluSrcA(AluSrcA),
		.AluSrcB(AluSrcB),
		.AluOp(AluOp),
		.Unsigned(Unsigned),
		.MDOp(MDOp),
		.MDStart(MDStart),
		.MDOutSel(MDOutSel),
		.Rd2AltCP(Rd2AltCP)
	);
	
	wire [31:0] AluA, AluB, AluRes;
	assign AluA = AluSrcA ? imm : (AFSel? AF: RegA);
	assign AluB = AluSrcB ? imm : (BFSel && !Rd2AltCP ? BF: RegB);

	alu alu(
		.A(AluA),
		.B(AluB),
		.Unsigned(Unsigned),
		.AluOp(AluOp),
		.Res(AluRes)
	);
	
	assign Data = DataFSel ? DataF : RegB;
	
	wire [31:0] MDOut;
	wire MDBusy_;
	MD MD(
		.Clk(Clk),
		.Rst(Rst),
		.MDOp(MDOp),
		.MDStart(MDStart),
		.A(AluA),
		.B(AluB),
		.Out(MDOut),
		.MDBusy(MDBusy_)
	);
	assign MDBusy = MDBusy_ || (MDStart && !(MDOp >= 7 && MDOp <= 10));
	assign Res = MDOutSel ? MDOut : AluRes;

endmodule
