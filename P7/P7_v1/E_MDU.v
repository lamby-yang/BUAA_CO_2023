`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:40:06 11/26/2023 
// Design Name: 
// Module Name:    E_MDU 
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
`define MDU_mult 4'b0001
`define MDU_multu 4'b0010
`define MDU_div  4'b0011
`define MDU_divu 4'b0100

`define MDU_mthi 4'b0111
`define MDU_mtlo 4'b1000
module E_MDU(
	input clk,
	input reset,
	input Req,
	
	input [31:0] A,
	input [31:0] B,
	input [3:0] MDU_Ctr,
	input start,
	input E_Is_New,
	
	output reg [31:0] HI,
	output reg [31:0] LO,
	output Busy
    );
	reg [31:0] tmp_HI;
	reg [31:0] tmp_LO;
	reg [3:0] cnt;
	
	always @(posedge clk) begin
		if(reset == 1 )begin
			tmp_HI = 0;
			tmp_LO = 0;
			cnt = 0;
			HI = 0;
			LO = 0;
		end
		else if(!Req)begin
			if(start == 1)begin
				case(MDU_Ctr)
					`MDU_mult : begin
						{tmp_HI,tmp_LO} <= $signed(A) * $signed(B);
						cnt <= 5;
					end
					`MDU_multu : begin
						{tmp_HI,tmp_LO} <= A * B;
						cnt <= 5;
					end
					`MDU_div : begin
						tmp_HI <= $signed(A) % $signed(B);
						tmp_LO <= $signed(A) / $signed(B);
						cnt <= 10;
					end
					`MDU_divu : begin
						tmp_HI <= A % B;
						tmp_LO <= A / B;
						cnt <= 10;
					end
				endcase
			end
			else if(MDU_Ctr == `MDU_mthi) begin
				HI <= A;
			end
			else if(MDU_Ctr == `MDU_mtlo) begin
				LO <= A;
			end
			else if(cnt != 0) begin
				cnt <= cnt - 1;
			end
		end
	end
	assign Busy = (cnt > 0) ? 1'b1 : 1'b0;
	always @(negedge Busy) begin
		HI <= tmp_HI;
		LO <= tmp_LO;
	end
endmodule
