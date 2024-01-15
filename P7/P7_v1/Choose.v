`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:08:01 11/24/2023 
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
`define DMU_mfhi 4'b0101
`define DMU_mflo 4'b0110
module Choose(//选择模块RD1.RD2(jal),E_SrcB,M_RegData, 在即将使用到这个值的时候再做选择，避免和转发模块打架

//被选择的值
	input [31:0] E_RD2_in,//ALU_sel
	input [31:0] E_SignImm,
	input [31:0] E_PC,//E_PC+8//jal_sel
	input [31:0] E_ALUResult_in,
	input [31:0] E_HI,
	input [31:0] E_LO,
	input [31:0] M_ReadData,//WD3_sel
	input [31:0] M_ALUResult,
	input [31:0] M_CP0Out,
	
//选择控制信号 
	input E_Jump_link,
	input [3:0] E_MDU_Ctr,
	input E_ALU_Sel,
    input M_Mem_To_Reg,
    input M_mfc0,
	
	input D_Condition,
	input E_Condition,
	
//选择后的值
	output [31:0] E_ALUResult_out,
	output [31:0] E_RD2_out,
	output [31:0] M_RegData
    );
	
	assign E_RD2_out =  (E_ALU_Sel == 1) ? E_SignImm : E_RD2_in ;
	assign E_ALUResult_out = (E_Jump_link == 1) ? E_PC+8 : 
							 (E_MDU_Ctr == `DMU_mfhi) ? E_HI :
							 (E_MDU_Ctr == `DMU_mflo) ? E_LO :
							 E_ALUResult_in ;
	assign M_RegData = 	(M_Mem_To_Reg == 1) ? M_ReadData :
						(M_mfc0 == 1)		? M_CP0Out : M_ALUResult ;
	
endmodule

