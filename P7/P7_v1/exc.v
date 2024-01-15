`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:02:18 12/04/2023 
// Design Name: 
// Module Name:    exc 
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
module Exc(
	input [31:0] Instr,//M_
	input D_Syscall,
	input D_RI,
	input E_Overflow,
	input M_Overflow,
	input E_Ov_sel,
	input [31:0] M_MemAddr,
	
	input D_Is_New,
	input E_Is_New,
	input M_Is_New,
	
	input [4:0] D_ExcCode_tmp,
	input [4:0] E_ExcCode_tmp,
	input [4:0] M_ExcCode_tmp,
	output [4:0] D_ExcCode,
	output [4:0] E_ExcCode,
	output [4:0] M_ExcCode
    );
	wire [5:0] Op = Instr[31:26];
    wire [5:0] Funct = Instr[5:0];

	wire add = (Op == 6'b000000 && Funct == 6'b100000);
	wire sub = (Op == 6'b000000 && Funct == 6'b100010);
	wire addi= (Op == 6'b001000);
	
	wire lw  = (Op == 6'b100011);
	wire lh  = (Op == 6'b100001);
	wire lb  = (Op == 6'b100000);
	wire load = lw|lh|lb;
	wire sw  = (Op == 6'b101011);
	wire sh  = (Op == 6'b101001);
	wire sb  = (Op == 6'b101000);
	wire store = sw|sh|sb;
	
	wire Addr_Error = 	~((M_MemAddr >= 32'h0000 && M_MemAddr <= 32'h2fff)
						||(M_MemAddr >= 32'h7f00 && M_MemAddr <= 32'h7f0b)
						||(M_MemAddr >= 32'h7f10 && M_MemAddr <= 32'h7f1b)
						||(M_MemAddr >= 32'h7f20 && M_MemAddr <= 32'h7f23));
	
	//取指异常,取数异常
	wire AdEL = (lw && (M_MemAddr[1:0] != 2'b0)) ? 1'b1 :		//取数地址未与 4 字节对齐。
				(lh && (M_MemAddr[0]   != 1'b0)) ? 1'b1 :		//取数地址未与 2 字节对齐。
				((lh|lb) && (M_MemAddr >= 32'h7f00 && M_MemAddr <= 32'h7f1b)) ? 1'b1 ://取 Timer 寄存器的值。
				(load && M_Overflow) ? 1'b1 :					//计算地址时加法溢出。
				(load && Addr_Error) ? 1'b1 : 1'b0;				//取数地址超出 DM、Timer0、Timer1、中断发生器的范围。
	
	//存数异常
	wire AdES = (sw && (M_MemAddr[1:0] != 2'b0)) ? 1'b1 :		//存数地址未 4 字节对齐。
				(sh && (M_MemAddr[0]   != 1'b0)) ? 1'b1 :		//存数地址未与 2 字节对齐。
				((sh|sb) && (M_MemAddr >= 32'h7f00 && M_MemAddr <= 32'h7f1b)) ? 1'b1 ://存 Timer 寄存器的值。
				(store && M_Overflow) ? 1'b1 :					//计算地址时加法溢出。
				(store && ((M_MemAddr == 32'h7f08) || (M_MemAddr == 32'h7f18))) ? 1'b1 :	//向计时器的 Count 寄存器存值。
				(store && Addr_Error) ? 1'b1 : 1'b0;			//存数地址超出 DM、Timer0、Timer1、中断发生器的范围。	
	
	wire Ov = ((E_Ov_sel) && E_Overflow );				//溢出异常
	

	assign D_ExcCode =  D_ExcCode_tmp ? D_ExcCode_tmp :
						(D_Syscall) ? 5'd8 : 
						(D_RI) 		? 5'd10 :5'd0 ;
						
	assign E_ExcCode = 	E_ExcCode_tmp ? E_ExcCode_tmp :
						(Ov)   	? 5'd12 : 5'd0 ;
						
	assign M_ExcCode =	M_ExcCode_tmp ? M_ExcCode_tmp :
						(AdEL) 	? 5'd4 :
						(AdES) 	? 5'd5 : 5'd0 ;
endmodule
