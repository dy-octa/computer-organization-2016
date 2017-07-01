`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:24:39 11/24/2016 
// Design Name: 
// Module Name:    Forward 
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
module Hazard(
    input [31:0] instrD,
    input [31:0] instrE,
    input [31:0] instrM,
	 input [31:0] instrW,
	 input [31:0] D_E_Rd1,
	 input [31:0] D_E_PC,
	 input E_MDBusy,
	 input [31:0] E_M_Res,
	 input [31:0] M_W_Res,
	 input [31:0] M_W_Data,
	 input [31:0] E_M_PC,
	 input [31:0] M_W_PC,
    output reg [31:0] Rd1F,
    output reg [31:0] Rd2F,
    output reg Rd1FSel,
    output reg Rd2FSel,
    output reg [31:0] AF,
    output reg [31:0] BF,
    output reg [31:0] DataF_E,
    output reg AFSel,
    output reg BFSel,
    output reg DataF_ESel,
    output reg [31:0] DataF_M,
    output reg DataF_MSel,
	 output reg Stall
    );
	InstrAnalysis InstrD(
		.instr(instrD),
		.readRs(readRsD),
		.readRt(readRtD),
		.needRsD(needRsD),
		.needRtD(needRtD),
		.useMD(D_useMD)
	);
	InstrAnalysis InstrE(
		.instr(instrE),
		.movC(E_movC),
		.alr(E_alr),
		.al(E_al),
		.cal_rd(E_cal_rd),
		.cal_rt(E_cal_rt),
		.load(E_load),
		.useMD(E_useMD)
	);
	
	InstrAnalysis InstrM(
		.instr(instrM),
		.movC(M_movC),
		.alr(M_alr),
		.al(M_al),
		.cal_rd(M_cal_rd),
		.cal_rt(M_cal_rt),
		.load(M_load)
	);
	
	InstrAnalysis InstrW(
		.instr(instrW),
		.movC(W_movC),
		.alr(W_alr),
		.al(W_al),
		.cal_rd(W_cal_rd),
		.cal_rt(W_cal_rt),
		.load(W_load)
	);


	wire [4:0] rdD = instrD[15:11];
	wire [4:0] rtD = instrD[20:16];
	wire [4:0] rsD = instrD[25:21];
	wire [5:0] opD = instrD[31:26];
	wire [5:0] funcD = instrD[5:0];
	
	wire [4:0] rdE = instrE[15:11];
	wire [4:0] rtE = instrE[20:16];
	wire [4:0] rsE = instrE[25:21];
	wire [5:0] opE = instrE[31:26];
	wire [5:0] funcE = instrE[5:0];
	
	wire [4:0] rdM = instrM[15:11];
	wire [4:0] rtM = instrM[20:16];
	wire [4:0] rsM = instrM[25:21];
	wire [5:0] opM = instrM[31:26];
	wire [5:0] funcM = instrM[5:0];

	wire [4:0] rdW = instrW[15:11];
	wire [4:0] rtW = instrW[20:16];
	wire [4:0] rsW = instrW[25:21];
	wire [5:0] opW = instrW[31:26];
	wire [5:0] funcW = instrW[5:0];

	reg [31:0] E_F, M_F, W_F;
	reg [4:0] E_Addr, M_Addr, W_Addr;
	reg E_toWrite, M_toWrite, W_toWrite;
	reg E_Unready, M_Unready;

/*	initial begin
		Rd1FSel = 0; Rd2FSel = 0; AFSel = 0; BFSel = 0;
		DataF_ESel = 0; DataF_MSel = 0; StallD = 0; StallE = 0;
		E_toWrite = 0; M_toWrite = 0; W_toWrite = 0;
		E_Unready = 0; M_Unready = 0;
		E_F = x; M_F = x; W_F = x;
		E_Addr = x; M_Addr = x; W_Addr = x;
	end
*/
	always @(*) begin
		Rd1FSel = 0; Rd2FSel = 0; AFSel = 0; BFSel = 0;
		DataF_ESel = 0; DataF_MSel = 0; Stall = 0;
		E_toWrite = 0; M_toWrite = 0; W_toWrite = 0;
		E_Unready = 0; M_Unready = 0;
		E_F = 0; M_F = 0; W_F = 0;
		E_Addr = 0; M_Addr = 0; W_Addr = 0;
		Rd1F = 0; Rd2F = 0;
		AF = 0; BF = 0; DataF_E = 0;
		DataF_M = 0;
		
		if (E_movC) begin
			E_F = D_E_Rd1;
			E_Addr = rdE;
			E_toWrite = 1;
		end
		else if (E_alr) begin
			E_F = D_E_PC+8;
			E_Addr = rdE;
			E_toWrite = 1;
		end
		else if (E_al) begin
			E_F = D_E_PC+8;
			E_Addr = 31;
			E_toWrite = 1;
		end
		else if (E_cal_rd || E_cal_rt || E_load) begin
			E_Unready = 1; E_toWrite = 1;
			if (E_cal_rd)
				E_Addr = rdE;
			else E_Addr = rtE;
		end
		else ;
		
		if (M_movC || M_cal_rd) begin
			M_F = E_M_Res;
			M_Addr = rdM;
			M_toWrite = 1;
		end
		else if (M_cal_rt) begin
			M_F = E_M_Res;
			M_Addr = rtM;
			M_toWrite = 1;
		end
		else if (M_alr) begin
			M_F = E_M_PC+8;
			M_Addr = rdM;
			M_toWrite = 1;
		end
		else if (M_al) begin
			M_F = E_M_PC+8;
			M_Addr = 31;
			M_toWrite = 1;
		end
		else if (M_load) begin
			M_Unready = 1; M_toWrite = 1;
			M_Addr = rtM;
		end
		else ;
		
		if (W_movC || W_cal_rd) begin
			W_F = M_W_Res;
			W_Addr = rdW;
			W_toWrite = 1;
		end
		else if (W_cal_rt) begin
			W_F = M_W_Res;
			W_Addr = rtW;
			W_toWrite = 1;
		end
		else if (W_alr) begin
			W_F = M_W_PC+8;
			W_Addr = rdW;
			W_toWrite = 1;
		end
		else if (W_al) begin
			W_F = M_W_PC+8;
			W_Addr = 31;
			W_toWrite = 1;
		end
		else if (W_load) begin
			W_F = M_W_Data;
			W_Addr = rtW;
			W_toWrite = 1;
		end
		else ;
// Providers
		if (readRsD && rsD != 0)
			if (E_toWrite && rsD == E_Addr) begin
				if ((needRsD || E_load) && E_Unready)
					Stall = 1;
				else if (!E_Unready) begin
					Rd1F = E_F;
					Rd1FSel = 1;
				end
				else ;
			end
			else if (M_toWrite && rsD == M_Addr) begin
				if (M_Unready)
					if (needRsD)
						Stall = 1;
					else ;
				else begin
					Rd1F = M_F;
					Rd1FSel = 1;
				end
			end
			else ;
		else ;
		
		
		if (readRtD && rtD != 0)
			if (E_toWrite && rtD == E_Addr) begin
				if ((needRtD || E_load) && E_Unready)
					Stall = 1;
				else if (!E_Unready) begin
					Rd2F = E_F;
					Rd2FSel = 1;
				end
			end
			else if (M_toWrite && rtD == M_Addr) begin
				if (M_Unready)
					if (needRtD)
						Stall = 1;
					else ;
				else begin
					Rd2F = M_F;
					Rd2FSel = 1;
				end
			end
			else ;
		else ;
		
		if (D_useMD && E_MDBusy)
			Stall = 1;
		else ;
		
		if (rsE != 0)
			if (M_toWrite && rsE == M_Addr) begin
				AF = M_F;
				AFSel = 1;
			end
			else if (W_toWrite && rsE == W_Addr) begin
				AF = W_F;
				AFSel = 1;
			end
			else ;
		else ;
		
		if (rtE != 0)
			if (M_toWrite && rtE == M_Addr) begin
				BF = M_F; DataF_E = M_F;
				BFSel = 1; DataF_ESel = 1;
			end
			else if (W_toWrite && rtE == W_Addr) begin
				BF = W_F; DataF_E = W_F;
				BFSel = 1; DataF_ESel = 1;
			end
			else ;
		else ;
//Receivers		
		
	end

endmodule
