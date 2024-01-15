`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:08:13 11/24/2023 
// Design Name: 
// Module Name:    D_CMP 
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
module D_CMP(
	input [31:0] RD1,
	input [31:0] RD2,
	input [1:0] D_Branch,
	input D_Is_New,
	
	output D_Condition,
	output B_jump
    );
	
	assign B_jump = (RD1 == RD2) && (D_Branch == 2'b01) ? 1'b1 : 
					(RD1 != RD2) && (D_Branch == 2'b10) ? 1'b1 : 1'b0 ;
	//assign D_Condition = (D_Is_New==1)&&(RD1 .. RD2) ? 1'b1 : 1'b0;
	assign D_Condition = 1'b0;
endmodule

