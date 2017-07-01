`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:38:39 11/15/2016 
// Design Name: 
// Module Name:    dm 
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
module dm(
    input [31:0] MemAddr,
    input [31:0] WData,
	 input [3:0] MemMask,
    input Clk,
    input Rst,
    input MemRead,
    input MemWrite,
    output [31:0] RData
    );
	integer i;
	reg [31:0] mem[2047:0];
	reg [31:0] toWrite, _WData;
	reg [3:0] mask;
	initial begin 
		for (i=0;i<2048;i=i+1) begin
				mem[i]=0;
		end
	end
	always @(*) begin
		mask = MemMask << MemAddr[1:0];
		toWrite = mem[MemAddr[12:2]];
		if (MemMask[3])
			_WData = WData;
		else if (MemMask[1])
			_WData = {2{WData[15:0]}};
		else _WData = {4{WData[7:0]}};
		if (mask[3])
			toWrite[31:24] = _WData[31:24];
		if (mask[2])
			toWrite[23:16] = _WData[23:16];
		if (mask[1])
			toWrite[15:8] = _WData[15:8];
		if (mask[0])
			toWrite[7:0] = _WData[7:0];
	end
	always @(posedge Clk) begin
		if (Rst) begin
			for (i=0;i<2048;i=i+1) begin
				mem[i] <= 0;
			end
		end else
			if (MemWrite) begin
					if (MemMask[3]) 
						$display("*%h <= %h", MemAddr, WData[31:0]);
					else if (MemMask[2]) 
						$display("*%h <= %h", MemAddr, WData[23:0]);
					else if (MemMask[1]) 
						$display("*%h <= %h", MemAddr, WData[15:0]);
					else if (MemMask[0]) 
						$display("*%h <= %h", MemAddr, WData[7:0]);

					mem[MemAddr[12:2]] <= toWrite;
				end

/*		$display("DM:\n");
		for (i=0;i<2048;i=i+1)
			if (mem[i]!=0)
				$display("%d: %d\n",i,mem[i]);
*/
	end
	assign RData = MemRead ? mem[MemAddr[12:2]] : {32{1'bx}};


endmodule
