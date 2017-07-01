`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:17:23 12/20/2016 
// Design Name: 
// Module Name:    timer 
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

module timer(
    input Clk,
    input Rst,
    input [3:2] Addr,
    input WEn,
    input [31:0] WData,
    output [31:0] RData,
    output reg IRQ
    );
	reg [31:0] mem[2:0];
	assign RData = Addr == 0? {7'h0000000, mem[0][3:0]} : mem[Addr];
	reg [2:0] S;
	parameter idle = 0, load = 1, cnt = 2, irq = 3;
	initial  begin
		mem[0] = 0;
		mem[1] = 0;
		mem[2] = 0;
		S = idle;
		IRQ = 0;
	end
	always @(posedge Clk) begin
		if (Rst) begin
			mem[0] <= 0;
			mem[1] <= 0;
			mem[2] <= 0;
			S <= idle;
			IRQ <= 0;
		end
		else begin
			if (WEn && Addr != 2)
				mem[Addr] <= WData;
			case (S)
				idle: begin
					if (mem[0][0] != 0)
						S <= load;
				end
				load: begin
					IRQ <= 0;
					if (mem[0][0] == 0)
						S <= idle;
					else begin
						mem[2] <= mem[1];
						S <= cnt;
					end
				end
				cnt: begin
					IRQ <= 0;
					if (mem[0][0] == 0)
						S <= idle;
					else begin
						if (mem[2] == 1)
							S <= irq;
						mem[2] <= mem[2] - 1;
					end
				end
				irq: begin
					IRQ <= mem[0][3];
					if (mem[0][0] == 0)
						S <= idle;
					else begin
						if (mem[0][2:1] == 0) begin
							mem[0][0] <= 0;
							S <= idle;
						end
						else S <= load;
					end
				end
			endcase
		end
	end

endmodule
