`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:59:49 11/03/2023 
// Design Name: 
// Module Name:    npc 
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
module npc(
    input Zero,
    input Branch,
    input Jr_Sel,
    input Jal_Sel,
	input [31:0] SignImm,
    input [31:0] RD1,
	input [25:0] Instr_Index,
    input [31:0] PC,

    output [31:0] Npc
    );

    wire [31:0] instr_index_out = {PC[31:28],Instr_Index[25:0],2'b0};
    wire [31:0] sign_out = PC + 4 + (SignImm << 2);
    assign Npc = (Jal_Sel == 1) ? instr_index_out :
                 (Jr_Sel  == 1) ? RD1  :
                 ((Zero & Branch) == 1) ? sign_out :
                 (PC + 4);

endmodule

