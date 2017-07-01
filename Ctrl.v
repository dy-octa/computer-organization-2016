`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:48:45 11/15/2016 
// Design Name: 
// Module Name:    Ctrl 
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
module Ctrl(
    input [31:0] instr,
    output reg RegDst,
    output reg AluSrcA,
	 output reg AluSrcB,
    output reg [3:0] Branch,
    output reg MemtoReg,
    output reg [1:0] ExtOp,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
	 output reg [3:0] MemMask,
	 output reg [1:0] MemExtPos,
    output reg [3:0] AluOp,
    output reg Jump,
	 output reg JumpSrc,
	 output reg Link,
	 output reg LinkSrc,
	 output reg Unsigned,
	 output reg [3:0] MDOp,
	 output reg MDStart,
	 output reg MDOutSel,
	 output reg ERet,
	 output reg CPWrite,
	 output reg Rd2AltCP,
	 output reg SWInt
    );
	`include "params.v"
	wire [5:0] func = instr[5:0];
	wire [4:0] shamt = instr[10:6];
	wire [4:0] rd = instr[15:11];
	wire [4:0] rt = instr[20:16];
	wire [4:0] rs = instr[25:21];
	wire [5:0] op = instr[31:26];
	wire [15:0] imm16 = instr[15:0];
	wire [25:0] imm26 = instr[25:0];
	

	always @(*) begin
		RegDst = 0; AluSrcA = 0; AluSrcB = 0; Branch = 0; MemtoReg = 0; ExtOp = 0;
		RegWrite = 0; MemRead = 0; MemWrite = 0; MemMask = 0; MemExtPos = 0; AluOp = 0;
		Jump = 0; JumpSrc = 0; Link = 0; Unsigned = 0; 
		MDOp = 0; MDStart = 0; MDOutSel = 0;
		ERet = 0; CPWrite = 0; Rd2AltCP = 0; SWInt = 0;
		case (op)
			R: begin
				case (func)
					add: begin 
						RegDst = 1;
						RegWrite = 1;
						AluOp = 0;
						Unsigned = 0;
					end
					addu: begin 
						RegDst = 1;
						RegWrite = 1;
						AluOp = 0;
						Unsigned = 1;
					end
					sub: begin
						RegDst = 1;
						RegWrite = 1;
						AluOp = 1;
						Unsigned = 0;
					end
					subu: begin
						RegDst = 1;
						RegWrite = 1;
						AluOp = 1;
						Unsigned = 1;
					end
					jr: begin
						Jump = 1;
						JumpSrc = 1;
					end
					jalr: begin
						RegWrite = 1;
						Jump = 1;
						JumpSrc = 1;
						Link = 1;
						LinkSrc = 1;
					end
					sll: 
						if (instr != 0) begin
							RegDst = 1;
							AluSrcA = 1;
							ExtOp = 2;
							RegWrite = 1;
							AluOp = 15;
						end
					srl/*|rotr*/: begin
						RegDst = 1;
						AluSrcA = 1;
						ExtOp = 2;
						RegWrite = 1;
						if (rs == 0)
							AluOp = 13;
						else AluOp = 4;
					end
					sra: begin
						RegDst = 1;
						AluSrcA = 1;
						ExtOp = 2;
						RegWrite = 1;
						AluOp = 12;
					end
					sllv: begin
						RegDst = 1;
						RegWrite = 1;
						AluOp = 15;
					end
					srlv/*|rotrv*/: begin
						RegDst = 1;
						RegWrite = 1;
						if (shamt == 0)
							AluOp = 13;
						else AluOp = 4;
					end
					srav: begin
						RegDst = 1;
						RegWrite = 1;
						AluOp = 12;
					end					
					and_: begin 
						RegDst = 1;
						RegWrite = 1;
						AluOp = 6;
					end
					or_: begin 
						RegDst = 1;
						RegWrite = 1;
						AluOp = 7;
					end
					xor_: begin 
						RegDst = 1;
						RegWrite = 1;
						AluOp = 9;
					end
					nor_: begin 
						RegDst = 1;
						RegWrite = 1;
						AluOp = 8;
					end
					slt: begin 
						RegDst = 1;
						RegWrite = 1;
						AluOp = 10;
						Unsigned = 0;
					end
					sltu: begin 
						RegDst = 1;
						RegWrite = 1;
						AluOp = 10;
						Unsigned = 1;
					end
					mult: begin
						MDStart = 1;
						MDOp = 1;
					end
					multu: begin
						MDStart = 1;
						MDOp = 2;
					end
					mthi: begin
						MDStart = 1;
						MDOp = 7;
					end
					mtlo: begin
						MDStart = 1;
						MDOp = 8;
					end
					mfhi: begin
						RegDst = 1;
						RegWrite = 1;
						MDStart = 1;
						MDOp = 9;
						MDOutSel = 1;
					end
					mflo: begin
						RegDst = 1;
						RegWrite = 1;
						MDStart = 1;
						MDOp = 10;
						MDOutSel = 1;
					end
					
					div: begin
						MDStart = 1;
						MDOp = 14;
					end
					divu: begin
						MDStart = 1;
						MDOp = 15;
					end
					
					break_: begin
						SWInt = 1;
					end
					default: ;
				endcase
			end
			
			SP2: begin
				case (func)
					madd: begin
						MDStart = 1;
						MDOp = 3;
					end
					maddu: begin
						MDStart = 1;
						MDOp = 4;
					end
					msub: begin
						MDStart = 1;
						MDOp = 5;
					end
					msubu: begin
						MDStart = 1;
						MDOp = 6;
					end
					default: ;
				endcase
			end
			
			COP0: begin
				if (rs == mfc0) begin
					RegWrite = 1;
					AluOp = 2;
					Rd2AltCP = 1;
				end
				else if (rs == mtc0) begin
					CPWrite = 1;
				end
				else if (func == eret) begin
					ERet = 1;
				end
			end

			ori: begin
				AluSrcB = 1;
				RegWrite = 1;
				AluOp = 7;
			end
			xori: begin
				AluSrcB = 1;
				RegWrite = 1;
				AluOp = 9;
			end
			andi: begin
				AluSrcB = 1;
				RegWrite = 1;
				AluOp = 6;
			end
			addi: begin
				AluSrcB = 1;
				ExtOp = 1;
				RegWrite = 1;
				AluOp = 0;
				Unsigned = 0;
			end
			addiu: begin
				AluSrcB = 1;
				ExtOp = 1;
				RegWrite = 1;
				AluOp = 0;
				Unsigned = 1;
			end
			slti: begin
				AluSrcB = 1;
				ExtOp = 1;
				RegWrite = 1;
				AluOp = 10;
				Unsigned = 0;
			end
			sltiu: begin
				AluSrcB = 1;
				ExtOp = 1;
				RegWrite = 1;
				AluOp = 10;
				Unsigned = 1;
			end
			lw: begin
				AluSrcB = 1;
				MemtoReg = 1;
				MemMask = 'b1111;
				MemExtPos = 3;
				ExtOp = 1;
				RegWrite = 1;
				MemRead = 1;
				AluOp = 0;
			end
			lh: begin
				AluSrcB = 1;
				MemtoReg = 1;
				MemMask = 'b0011;
				MemExtPos = 1;
				ExtOp = 1;
				RegWrite = 1;
				MemRead = 1;
				AluOp = 0;
			end
			lb: begin
				AluSrcB = 1;
				MemtoReg = 1;
				MemMask = 'b0001;
				MemExtPos = 0;
				ExtOp = 1;
				RegWrite = 1;
				MemRead = 1;
				AluOp = 0;
			end
			lhu: begin
				AluSrcB = 1;
				MemtoReg = 1;
				MemMask = 'b0011;
				MemExtPos = 3;
				ExtOp = 1;
				RegWrite = 1;
				MemRead = 1;
				AluOp = 0;
			end
			lbu: begin
				AluSrcB = 1;
				MemtoReg = 1;
				MemMask = 'b0001;
				MemExtPos = 3;
				ExtOp = 1;
				RegWrite = 1;
				MemRead = 1;
				AluOp = 0;
			end
			sw: begin
				AluSrcB = 1;
				ExtOp = 1;
				MemWrite = 1;
				MemMask = 'b1111;
				AluOp = 0;
			end
			sh: begin
				AluSrcB = 1;
				ExtOp = 1;
				MemWrite = 1;
				MemMask = 'b0011;
				AluOp = 0;
			end
			sb: begin
				AluSrcB = 1;
				ExtOp = 1;
				MemWrite = 1;
				MemMask = 'b0001;
				AluOp = 0;
			end
			beq: begin
				Branch = 'b0010;
				ExtOp = 1;
			end
			bne: begin
				Branch = 'b0101;
				ExtOp = 1;
			end
			lui: begin
				AluSrcB = 1;
				ExtOp = 0;
				RegWrite = 1;
				AluOp = 5;
			end
			j: begin
				ExtOp = 3;
				Jump = 1;
				JumpSrc = 0;
			end
			jal: begin
				ExtOp = 3;
				RegWrite = 1;
				Jump = 1;
				JumpSrc = 0;
				Link = 1;
				LinkSrc = 0;
			end
			bgtz: begin
				ExtOp = 1;
				Branch = 'b1100;
			end
			blez: begin
				ExtOp = 1;
				Branch = 'b1011;
			end
			REGIMM: begin
				ExtOp = 1;
				if (rt == bgez)
					Branch = 'b1110;
				else if (rt == bltz)
					Branch = 'b1001;
			end
			default: ;
		endcase
	end
			

endmodule
