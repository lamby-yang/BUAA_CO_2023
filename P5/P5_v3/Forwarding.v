`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:19:42 11/11/2023 
// Design Name: 
// Module Name:    Forwarding 
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
/*********************所有模块的输入端口都是Forwarding后的数据, 流水线寄存器的输入端口是Choose后的数据**************************/
module Forwarding(//转发模块//完工
//接收转发的地址
	input [4:0] D_A1,//b指令
	input [4:0] D_A2,
	input [4:0] E_A1,//SrcA B的地址
	input [4:0] E_A2,
	input [4:0] M_A2,//sw 要存数据的寄存器地址，W->M
	input D_A1use,
    input D_A2use,
    input E_A1use,
    input E_A2use,
    input M_A2use,
//转发数据的地址
	input [4:0] W_A3,//lw 取出数据，放到的寄存器地址
	input [4:0] M_A3,//ALUresult 的地址
	//input [4:0] E_A3,//jal 指令的地址?$31?
	//最后采用了，在Choose模块把jal? RD1改成D_PC+4? RD2改成0, A3改成31 的写?
	//input [4:0] D_A3,
//这一级的A3地址是否有效（是否要写入A3?
	input W_RegWrite,
	input M_RegWrite,
	
//接受转发之前的数?
	input [31:0] D_RD1,
	input [31:0] D_RD2,
	input [31:0] E_RD1,
	input [31:0] E_RD2,
	input [31:0] M_WriteData,//M_A2
//转发出去的数
	input [31:0] M_ALU_Result,//M_A3
	input [31:0] W_RegData,//W_A3
	
//接受转发后的输出
	output [31:0] D_RD1_FW,//FW=Forwarding
	output [31:0] D_RD2_FW,
	output [31:0] E_RD1_FW,
	output [31:0] E_RD2_FW,
	output [31:0] M_WriteData_FW
    ); 
	
	assign D_RD1_FW = 	(D_A1use == 1'b0) ? D_RD1 :
						(D_A1 == 5'b0) ? 32'h0000_0000 :
						(D_A1 == M_A3)&&(M_RegWrite) ? M_ALU_Result ://先转发M级的，数据新，才是对的
						(D_A1 == W_A3)&&(W_RegWrite)? W_RegData : D_RD1 ;
	
	assign D_RD2_FW = 	(D_A2use == 1'b0) ? D_RD2 :
						(D_A2 == 5'b0) ? 32'h0000_0000 :
						(D_A2 == M_A3)&&(M_RegWrite) ? M_ALU_Result :
						(D_A2 == W_A3)&&(W_RegWrite) ? W_RegData : D_RD2 ;
					
	assign E_RD1_FW = 	(E_A1use == 1'b0) ? E_RD1 :
						(E_A1 == 5'b0) ? 32'h0000_0000 :
						(E_A1 == M_A3)&&(M_RegWrite) ? M_ALU_Result :
						(E_A1 == W_A3)&&(W_RegWrite) ? W_RegData : E_RD1 ;
						
	assign E_RD2_FW = 	(E_A2use == 1'b0) ? E_RD2 :
						(E_A2 == 5'b0) ? 32'h0000_0000 :
						(E_A2 == M_A3)&&(M_RegWrite) ? M_ALU_Result : 
						(E_A2 == W_A3)&&(W_RegWrite) ? W_RegData :E_RD2 ;
						
	assign M_WriteData_FW = (M_A2use == 1'b0) ? M_WriteData :
							(M_A2 == 5'b0) ? 32'h0000_0000 :
							(M_A2 == W_A3)&&(W_RegWrite) ? W_RegData : M_WriteData ;
							 
endmodule
