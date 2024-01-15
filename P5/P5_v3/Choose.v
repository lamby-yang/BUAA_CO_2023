`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:39:26 11/13/2023 
// Design Name: 
// Module Name:    Choose 
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
module Choose(
//选择模块RD2(jal),E_SrcB,M_RegData, 在即将使用到这个值的时候再做选择，避免和转发模块打架

//被选择的值

	input [31:0] E_PC,//E_PC+8//jal_sel
	input [31:0] E_ALUResult_in,
	input [31:0] E_RD2_in,//ALU_sel
	input [31:0] E_SignImm,
	input [31:0] M_ReadData,//WD3_sel
	input [31:0] M_ALUResult,
	
//选择控制信号 

	input D_Reg_Dst,
	input D_Jal_Sel,
	input E_Jal_Sel,
	input E_ALU_Sel,
    input M_Mem_To_Reg,
	input D_Condition,
	input E_Condition,
	
//选择后的值

	output D_Jal_Sel_out,
	output [31:0] E_ALUResult_out,
	output [31:0] E_RD2_out,
	output [31:0] M_RegData
    );

	assign E_RD2_out =  (E_ALU_Sel == 1) ? E_SignImm : E_RD2_in ;
	assign E_ALUResult_out = (E_Jal_Sel == 1) ? E_PC+8 : E_ALUResult_in ;
	assign M_RegData = 	(M_Mem_To_Reg == 1) ? M_ReadData : M_ALUResult ;
	
	//assign D_Jal_Sel_out = D_Jal_Sel | D_Condition | 1'b0 ;
	assign D_Jal_Sel_out = 1'b0 ;
endmodule
