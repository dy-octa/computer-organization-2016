`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:52:45 12/14/2016 
// Design Name: 
// Module Name:    MemExt 
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
module MemExt(
    input [31:0] MemRData,
    input [3:0] MemMask,
    input [1:0] MemExtPos,
	 input [1:0] subAddr,
    output reg [31:0] MemData
    );
	wire [3:0] mask;
	assign mask = MemMask << subAddr;
	always @(*) begin
		MemData = 0;
		if (mask[3])
			MemData[31:24] = MemRData[31:24];
		if (mask[2])
			MemData[23:16] = MemRData[23:16];
		if (mask[1])
			MemData[15:8] = MemRData[15:8];
		if (mask[0])
			MemData[7:0] = MemRData[7:0];
		MemData = MemData >> ( {32'b0,subAddr} << 3);
		case (MemExtPos)
			3: ;
			2: MemData[31:24] = {8{MemData[23]}};
			1: MemData[31:16] = {16{MemData[15]}};
			0: MemData[31:8] = {24{MemData[7]}};
		endcase
	end
	

endmodule
