`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:15:10 11/16/2016 
// Design Name: 
// Module Name:    datapath 
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
module mips(
    input clk,
    input reset,
	 input [31:0] PrRData,
	 input [7:2] HWInt,
	 output [31:0] PrAddr,
	 output [31:0] PrWData,
	 output [3:0] PrMask,
	 output PrWrite
    );
	wire Clk = clk;
	wire Rst = reset;
/*	reg Clk , Rst;
	always #10 Clk = ~Clk;
	initial begin 
		Clk = 0;
		Rst = 0;
	end
*/
//	always @(posedge Clk) 
//		$display("@%h",PC_F);
	
	wire [31:0] nPCAlt, CPRData;
	wire [6:2] ExcCode;
	cp0 cp0(
		.Addr(instrD[15:11]),
		.WData(Rd2),
		.PC_F(PC_F),
		.nPCAlt_in(nPCAltD),
		.nPCSel_in(nPCSelD),
		.ExcCode(ExcCode),
		.HWInt(HWInt),
		.CPWrite(CPWrite),
		.ERet(ERet),
		.Clk(Clk),
		.Rst(Rst),
		.nPCAlt(nPCAlt),
		.nPCSel(nPCSel),
		.RData(CPRData),
		.ExcStall(ExcStall)
	);
		
		
	wire [31:0] PC_F, instrF;
	wire _in_kernel = PC_F >= 'h4180;
	IF IF(
		.Clk(Clk),
		.Rst(Rst),
		.nPCAlt(nPCAlt),
		.nPCSel(nPCSel),
		.Stall(Stall && !ExcStall),

		.PC(PC_F),
		.instr(instrF)
	);

	wire [31:0] nPCAltD, Rd1, Rd2, imm, PC_D, instrD;
	ID ID(
		.Clk(Clk),
		.Rst(Rst),
		.PC_in(PC_F),
		.instr_in(instrF),
		.Rd1F(Rd1F),
		.Rd2F(Rd2F),
		.Rd1FSel(Rd1FSel),
		.Rd2FSel(Rd2FSel),
		.RegWData(RegWData),
		.RegWrite(RegWrite),
		.RegWAddr(RegWAddr),
		.Stall(Stall),

		.ExcStall(ExcStall),
		.CPRData(CPRData),
		.CPWrite(CPWrite),
		.ERet(ERet),
		.SWInt(SWInt),

		.nPCAlt(nPCAltD),
		.nPCSel(nPCSelD),
		
		.Rd1(Rd1),
		.Rd2(Rd2),
		.imm(imm),
		.PC(PC_D),
		.instr(instrD)
	);
	assign ExcCode = SWInt ? 'b1001 : 0;

	wire [31:0] ResE, Data, PC_E, instrE, Rd1E;
	EX EX(
		.Clk(Clk),
		.Rst(Rst),
		.PC_in(PC_D),
		.instr_in(instrD),
		.Rd1(Rd1),
		.Rd2(Rd2),
		.imm_in(imm),
		.AF(AF),
		.BF(BF),
		.DataF(DataF_E),
		.AFSel(AFSel),
		.BFSel(BFSel),
		.DataFSel(DataF_ESel),
		.Stall(Stall),
		
		.Rd1E(Rd1E),
		.Res(ResE),
		.Data(Data),
		.MDBusy(MDBusy),
		.PC(PC_E),
		.instr(instrE)
	);
	
	wire [31:0] RegWData;
	wire [4:0] RegWAddr;
	wire [31:0] ResM, MemRData, PC_M, instrM, ResW, DataW, PC_W, instrW;
	MEM MEM(
		.Clk(Clk),
		.Rst(Rst),
		.PC_in(PC_E),
		.instr_in(instrE),
		.Res_in(ResE),
		.Data_in(Data),
		.DataF(DataF_M),
		.DataFSel(DataF_MSel),
		.PrRData(PrRData),
		
		
		.PrAddr(PrAddr),
		.PrWData(PrWData),
		.PrMask(PrMask),
		.PrWrite(PrWrite),
		
		.Res(ResM),
		.MemRData(MemRData),
		.PC(PC_M),
		.instr(instrM)
	);
	
	wire [31:0] Rd1F, Rd2F, AF, BF, DataF_E, DataF_M;
	WB WB(
		.Clk(Clk),
		.Rst(Rst),
		.PC_in(PC_M),
		.instr_in(instrM),
		.Res_in(ResM),
		.MemRData_in(MemRData),
		
		.RegWData(RegWData),
		.RegWrite(RegWrite),
		.RegWAddr(RegWAddr),
		
		.ResW(ResW),
		.DataW(DataW),
		.PC(PC_W),
		.instr(instrW)
	);

	Hazard Hazard(
		.instrD(instrD),
		.instrE(instrE),
		.instrM(instrM),
		.instrW(instrW),
		
		.D_E_Rd1(Rd1E),
		.E_M_Res(ResM),
		.E_MDBusy(MDBusy),
		.M_W_Res(ResW),
		.M_W_Data(DataW),
		.D_E_PC(PC_E),
		.E_M_PC(PC_M),
		.M_W_PC(PC_W),

		.Rd1F(Rd1F),
		.Rd2F(Rd2F),
		.Rd1FSel(Rd1FSel),
		.Rd2FSel(Rd2FSel),
		.AF(AF),
		.BF(BF),
		.DataF_E(DataF_E),
		.AFSel(AFSel),
		.BFSel(BFSel),
		.DataF_ESel(DataF_ESel),
		.DataF_M(DataF_M),
		.DataF_MSel(DataF_MSel),
		.Stall(Stall)
	);

endmodule
