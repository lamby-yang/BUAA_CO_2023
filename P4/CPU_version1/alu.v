`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:00:13 11/03/2023 
// Design Name: 
// Module Name:    alu 
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
module alu(
    input [31:0] SrcA,
    input [31:0] SrcB,
    input [4:0] Shamt,
	input [3:0] ALU_Ctr,
	 
	output Zero,
    output [31:0] ALU_Result
    );

    wire [31:0] f_add = $signed(SrcA)+$signed(SrcB);
    wire [31:0] f_sub = $signed(SrcA)-$signed(SrcB);
    wire [31:0] f_or  = SrcA | SrcB;
    wire [31:0] f_lui = SrcB << 16;
    assign ALU_Result = (ALU_Ctr == 0) ? (f_add):
                        (ALU_Ctr == 1) ? (f_sub):
                        (ALU_Ctr == 2) ? (f_or ):
                        (ALU_Ctr == 3) ? (f_lui):0;

    assign Zero = (ALU_Result==0) ? 1 : 0;
endmodule
