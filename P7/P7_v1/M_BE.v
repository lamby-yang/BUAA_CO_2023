`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:11:31 11/27/2023 
// Design Name: 
// Module Name:    M_BE 
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
`define BE_w 2'b00 
`define BE_h 2'b01 
`define BE_b 2'b10 
module M_BE(
	input [1:0] M_width,
    input M_Mem_Write,
    input [31:0] Addr,//ALU_Result
    input [31:0] Write_Data,
	input M_Is_New,
	input [31:0] m_data_rdata,
	
	output [31:0] M_Read_Data,
    output [31:0] m_data_wdata,
    output [3:0] m_data_byteen
    );
	
	assign m_data_byteen = 	(M_Mem_Write == 1 && M_width == `BE_w) ?  	4'b1111 :
							(M_Mem_Write == 1 && M_width == `BE_h) ?  	(Addr[1:0]==2'b00 ? 4'b0011:
																		 Addr[1:0]==2'b10 ? 4'b1100: 4'b0000):
							(M_Mem_Write == 1 && M_width == `BE_b) ?  	(Addr[1:0]==2'b00 ? 4'b0001:
																		 Addr[1:0]==2'b01 ? 4'b0010:
																		 Addr[1:0]==2'b10 ? 4'b0100:
																		 Addr[1:0]==2'b11 ? 4'b1000: 4'b0000): 4'b0000;
	assign m_data_wdata =	(M_Mem_Write == 1 && M_width == `BE_w) ?  	Write_Data :
							(M_Mem_Write == 1 && M_width == `BE_h) ?  	(Addr[1:0]==2'b00 ? {16'b0, Write_Data[15:0]}:
																		 Addr[1:0]==2'b10 ? {Write_Data[15:0], 16'b0}:	Write_Data):
							(M_Mem_Write == 1 && M_width == `BE_b) ?  	(Addr[1:0]==2'b00 ? {24'b0, Write_Data[7:0]		 }	:
																		 Addr[1:0]==2'b01 ? {16'b0, Write_Data[7:0],8'b0 }  :
																		 Addr[1:0]==2'b10 ? {8'b0, 	Write_Data[7:0],16'b0} 	:
																		 Addr[1:0]==2'b11 ? {		Write_Data[7:0],24'b0}	: Write_Data): Write_Data;
	
	assign M_Read_Data =	(M_Mem_Write == 0 && M_width == `BE_w) ?  	m_data_rdata :
							(M_Mem_Write == 0 && M_width == `BE_h) ?  	(Addr[1:0]==2'b00 ? {{16{m_data_rdata[15]}}, m_data_rdata[15:0] }	:
																		 Addr[1:0]==2'b10 ? {{16{m_data_rdata[31]}}, m_data_rdata[31:16]}	:m_data_rdata):
							(M_Mem_Write == 0 && M_width == `BE_b) ?  	(Addr[1:0]==2'b00 ? {{24{m_data_rdata[7]}} , m_data_rdata[7:0]	}	:
																		 Addr[1:0]==2'b01 ? {{24{m_data_rdata[15]}}, m_data_rdata[15:8] }  	:
																		 Addr[1:0]==2'b10 ? {{24{m_data_rdata[23]}}, m_data_rdata[23:16]} 	:
																		 Addr[1:0]==2'b11 ? {{24{m_data_rdata[31]}}, m_data_rdata[31:24]}	: m_data_rdata): m_data_rdata;
	
endmodule
