`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:51:07 11/11/2023 
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
	input Is_Branch,
	input D_Is_New,
	
	output D_Condition,
	output B_jump
    );
	
	assign B_jump = (RD1 == RD2) && (Is_Branch == 1) ? 1'b1 : 
					1'b0 ;
	//assign D_Condition = (D_Is_New==1)&&(RD1 .. RD2) ? 1'b1 : 1'b0;
	assign D_Condition = 1'b0;
endmodule
