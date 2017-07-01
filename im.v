`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:15:03 11/15/2016 
// Design Name: 
// Module Name:    im 
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
module im(
    input [31:0] PC,
    output [31:0] instr
    );
	reg [31:0] mem [2047:0];
	wire [31:0] PC_r = PC - 'h0000_3000;
	initial begin
		$readmemh("code.txt", mem, 0, 1119);
		$readmemh("exc.txt", mem, 1120, 2047);
	end
	assign instr = mem[PC_r[13:2]];

endmodule
