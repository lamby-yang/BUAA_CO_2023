`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:01:55 11/03/2023 
// Design Name: 
// Module Name:    srcb_sel 
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
module srcb_sel(
    input [31:0] RD2,
    input [31:0] SignImm,
    input ALU_Sel,
	 
    output [31:0] SrcB
    );

    assign SrcB = (ALU_Sel == 0)?RD2:SignImm;

endmodule
