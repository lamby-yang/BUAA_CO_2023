`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:09:39 11/24/2023 
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
    input D_Jump_addr,
    input D_Jump_reg,
	input [31:0] SignImm,
    input [31:0] RD1,
	input [31:0] RD2,
	input [25:0] Instr_Index,
    input [31:0] F_PC,
	input [31:0] D_PC,
	input D_Is_New,
	input D_Condition,
	
    output [31:0] Npc
    );
	
	wire [31:0] D_PC4 = D_PC + 4;
	//wire [31:0] addr_new = {temp[31:2],2'b0}; 
    wire [31:0] instr_index_out = {D_PC4[31:28],Instr_Index[25:0],2'b0}; //jal
    wire [31:0] sign_out = D_PC + 4 + (SignImm << 2); //beq  // D_PC+8 = F_PC+4
    assign Npc = //(D_Is_New&D_Condition == 1) ? RD1  :
				 (D_Jump_addr == 1) ? instr_index_out :
                 (D_Jump_reg  == 1) ? RD1  :
                 (B_jump  == 1) ? sign_out :
                 (F_PC + 4);

endmodule
