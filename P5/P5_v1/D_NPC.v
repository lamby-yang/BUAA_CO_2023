`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:49:48 11/11/2023 
// Design Name: 
// Module Name:    D_NPC 
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
module D_NPC(
    input B_jump,
    input Branch,
    input Jr_Sel,
    input Jal_Sel,
	input [31:0] SignImm,
    input [31:0] RD1,
	input [25:0] Instr_Index,
    input [31:0] F_PC,
	input [31:0] D_PC,

    output [31:0] Npc
    );

    wire [31:0] instr_index_out = {D_PC[31:28],Instr_Index[25:0],2'b0}; //jal
    wire [31:0] sign_out = D_PC + 4 + (SignImm << 2); //beq  // D_PC+8 = F_PC+4
    assign Npc = (Jal_Sel == 1) ? instr_index_out :
                 (Jr_Sel  == 1) ? RD1  :
                 ((B_jump & Branch) == 1) ? sign_out :
                 (F_PC + 4);

endmodule
