`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:07:48 12/14/2016 
// Design Name: 
// Module Name:    MD 
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
module MD(
    input Clk,
    input Rst,
    input [3:0] MDOp,
    input MDStart,
    input signed [31:0] A,
    input signed [31:0] B,
	 output [31:0] Out,
	 output MDBusy
    );
	integer cnt;
	reg signed [31:0] Hi, Lo;
	assign Out = MDOp == 9 ? Hi : (MDOp == 10 ? Lo : 32'bx);
	assign MDBusy = cnt > 0;
	initial begin
		Hi = 0;
		Lo = 0;
		cnt = 0;
	end
	always @(posedge Clk) begin
		if (Rst) begin
			Hi <= 0;
			Lo <= 0;
			cnt <= 0;
		end
		else if (MDOp == 7) begin
			Hi <= A;
			//$display("$33 <= %h", A);
		end
		else if (MDOp == 8) begin
			Lo <= A;
			//$display("$34 <= %h", A);
		end
		else if (MDStart && !(MDOp >= 14 && B == 0)) begin
			if (MDOp < 7)
				cnt <= 5;
			else if (MDOp >= 14)
				cnt <= 10;
			else ;
			case (MDOp)
				1: {Hi,Lo} <= A * B;
				2: {Hi,Lo} <= $unsigned({0,A}) * $unsigned({0,B});
				3: {Hi,Lo} <= {Hi,Lo} + A * B;
				4: {Hi,Lo} <= $unsigned({Hi,Lo}) + $unsigned({0,A}) * $unsigned({0,B});
				5: {Hi,Lo} <= {Hi,Lo} - A * B;
				6: {Hi,Lo} <= $unsigned({Hi,Lo}) - $unsigned({0,A}) * $unsigned({0,B});
				14: if (B != 0)
					begin
						Hi <= A % B;
						Lo <= A / B;
					end
				15: if (B != 0)
					begin
						Hi <= $unsigned(A) % $unsigned(B);
						Lo <= $unsigned(A) / $unsigned(B);
					end
				default: ;
			endcase
/*			if (MDOp != 9 && MDOp != 10) begin
				if (MDOp != 8)
					$display("$33 <= %h", Hi);
				if (MDOp != 7)
					$display("$34 <= %h", Lo);
			end
*/
		end
		else if (cnt > 0)
			cnt <= cnt - 1;
		else ;
	end	

endmodule
