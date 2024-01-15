`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:48:31 11/11/2023 
// Design Name: 
// Module Name:    E_ALU 
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
`define Alu_add 4'd0
`define Alu_sub 4'd1
`define Alu_or  4'd2
`define Alu_lui 4'd3
module E_ALU(
    input [31:0] SrcA,
    input [31:0] SrcB,
    input [4:0] Shamt,
	input [3:0] ALU_Ctr,
	
    output [31:0] ALU_Result
    );

    wire [31:0] f_add = $signed(SrcA)+$signed(SrcB);
    wire [31:0] f_sub = $signed(SrcA)-$signed(SrcB);
    wire [31:0] f_or  = SrcA | SrcB;
    wire [31:0] f_lui = SrcB << 16;
	
    assign ALU_Result = (ALU_Ctr == `Alu_add) ? (f_add):
                        (ALU_Ctr == `Alu_sub) ? (f_sub):
                        (ALU_Ctr == `Alu_or ) ? (f_or ):
                        (ALU_Ctr == `Alu_lui) ? (f_lui): 0;

endmodule