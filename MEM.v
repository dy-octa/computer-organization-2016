`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:49:31 11/23/2016 
// Design Name: 
// Module Name:    MEM 
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
module MEM(
    input Clk,
    input Rst,
    input [31:0] PC_in,
    input [31:0] instr_in,

    input [31:0] Res_in,
    input [31:0] Data_in,
    input [31:0] DataF,
    input DataFSel,
	 input [31:0] PrRData,
	 
	 output [31:0] PrAddr,
	 output [31:0] PrWData,
	 output [3:0] PrMask,
	 output PrWrite,

    output [31:0] Res,
    output [31:0] MemRData,
	 
	 output [31:0] PC,
    output [31:0] instr
    );
	wire AccessPr = Res >= 'h7f00;
	assign PrAddr = Res;
	assign PrWData = MemWData;
	assign PrMask = MemMask;
	assign PrWrite = AccessPr && MemWrite_;
	wire MemWrite = !AccessPr && MemWrite_;
	assign MemRData = AccessPr ? PrRData : MemRDataOut;

	wire [31:0] Data;
	StageReg EX_MEM(
		.Clk(Clk),
		.Rst(Rst),
		.PC_in(PC_in),
		.instr_in(instr_in),
		.Din1(Res_in),
		.Din2(Data_in),
		.D1(Res),
		.D2(Data),
		.PC(PC),
		.instr(instr)
	);
	
	wire [3:0] MemMask;
	Ctrl Ctrl(
		.instr(instr),
		.MemRead(MemRead),
		.MemWrite(MemWrite_),
		.MemMask(MemMask)
	);
	
	wire [31:0] MemRDataOut;
	wire [31:0] MemWData = DataFSel ? DataF : Data;
	dm dm(
		.MemAddr(Res),
		.WData(MemWData),
		.RData(MemRDataOut),
		.MemMask(MemMask),
		.Clk(Clk),
		.Rst(Rst),
		.MemRead(MemRead),
		.MemWrite(MemWrite)
	);
	

endmodule
