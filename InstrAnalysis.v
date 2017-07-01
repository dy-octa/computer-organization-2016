`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:21:19 12/06/2016 
// Design Name: 
// Module Name:    InstrAnalysis 
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
module InstrAnalysis(
    input [31:0] instr,
    output movC,
    output alr,
    output al,
    output cal_rd,
    output cal_rt,
    output load,
	 output readRs,
	 output readRt,
	 output needRsD,
	 output needRtD,
	 output useMD
    );
	`include "params.v"
	wire [5:0] func = instr[5:0];
	wire [4:0] rd = instr[15:11];
	wire [4:0] rt = instr[20:16];
	wire [4:0] rs = instr[25:21];
	wire [5:0] op = instr[31:26];
	wire [15:0] imm16 = instr[15:0];
	wire [25:0] imm26 = instr[25:0];

	wire cal_i = op == addi || op == addiu || op == lui || op == slti || op == sltiu
	|| op == ori || op == andi || op == xori;
	
	assign useMD = (op == R && (func == mflo || func == mfhi || func == mtlo || func == mthi
	|| func == mult || func == multu || func == div || func == divu))
	|| (op == SP2 && (func == madd || func == msub || func == maddu || func == msubu || func == mul));

	
	assign movC = op == R && (func == movn || func == movz);
	assign alr = op == R && func == jalr;
	assign al = op == jal || (op == REGIMM && (rt == bal || rt == bgezal || rt == bltzal));
	assign cal_rd = (op == R && (!al && !alr && !movC && instr != 0 && (!useMD || func == mfhi || func == mflo))) 
	|| (op == SP2 && (func == clo || func == clz))
	|| (op == SP3 && (func == bshfl));
	assign cal_rt = (op == SP3 && (func == ins || func == ext)) || cal_i || (op == COP0 && rs == mfc0);
	assign load = op == lw || op == lh || op == lb || op == lhu || op == lbu;

	assign needRsD = movC || op == bgtz || op == blez || op == beq || op == bne
	|| (op == REGIMM && (rt == bgez || rt == bltz || rt == bgezal || rt == bltzal))
	|| (op == R && (func == jr || func == jalr));
	assign needRtD = movC || op == beq || op == bne || (op == COP0 && rs == mtc0);

	wire noReg = op == j || op == jal || op == lui 
	|| (op == R && (func == mfhi || func == mflo));

	wire singRs = op == bgtz || op == blez 
	|| (op == R && (func == jr || func == jalr || func == mthi || func == mtlo))
	|| (op == SP2 && (func == clo || func == clz))
	|| (op == SP3 && (func == ext))
	|| cal_i
	|| (load && op != lwl && op != lwr)
	|| (op == REGIMM && (rt == bgez || rt == bltz || rt == bgezal || rt == bltzal));
	
	wire singRt = (op == SP3 && func == bshfl)
	|| (op == R && (func == sll || func == sra || func == srl))
	|| (op == COP0 && rs == mtc0);
	

	assign readRs = !singRt && !noReg;
	assign readRt = !singRs && !noReg;

endmodule
