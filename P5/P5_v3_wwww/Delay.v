`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:11:35 11/14/2023 
// Design Name: 
// Module Name:    Delay 
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
module Delay(//阻塞模块
	input [3:0] D_rs_Tuse,
	input [3:0] D_rt_Tuse,
	
	input [3:0] D_Tnew,
	input [3:0] E_Tnew,
	input [3:0] M_Tnew,
	
	input [4:0] D_A1,
	input [4:0] D_A2,
	input [4:0] E_A3,//
	input [4:0] M_A3,//
	//这一级的A3地址是否有效（是否要写入A3）
	input E_RegWrite,
	input M_RegWrite,
	
	input D_Is_New,
	input D_Condition,
	input E_Is_New,
	input M_Is_New,
	
	output Stall,
	output F_D_RegWE,
    output F_D_clear,
    output D_E_RegWE,
    output D_E_clear,
    output E_M_RegWE,
    output E_M_clear,
    output M_W_RegWE,
    output M_W_clear,
	output PC_RegWE
    );
	//此时在D级，要和E,M级的T_new比较，（W级都=0,不需要比较）
	wire Stall_E_A1 = 	(D_A1 == 0) ? 1'b0 :
						(E_Is_New==1)&&((D_A1 == 5'd27)||(D_A1 == 5'd26))&&(D_rs_Tuse < E_Tnew)&&(E_RegWrite == 1) ? 1'b1 :
						(D_A1 == E_A3)&&(D_rs_Tuse < E_Tnew)&&(E_RegWrite == 1) ? 1'b1: 1'b0;
	
	wire Stall_E_A2 = 	(D_A2 == 0) ? 1'b0 :
						(E_Is_New==1)&&((D_A2 == 5'd27)||(D_A2 == 5'd26))&&(D_rt_Tuse < E_Tnew)&&(E_RegWrite == 1) ? 1'b1 :
						(D_A2 == E_A3)&&(D_rt_Tuse < E_Tnew)&&(E_RegWrite == 1) ? 1'b1: 1'b0;
	
	wire Stall_M_A1 = 	(D_A1 == 0) ? 1'b0 :
						(M_Is_New==1)&&((D_A1 == 5'd27)||(D_A1 == 5'd26))&&(D_rs_Tuse < M_Tnew)&&(M_RegWrite == 1) ? 1'b1 :
						(D_A1 == M_A3)&&(D_rs_Tuse < M_Tnew)&&(M_RegWrite == 1) ? 1'b1: 1'b0;
		
	wire Stall_M_A2 = 	(D_A2 == 0) ? 1'b0 :
						(M_Is_New==1)&&((D_A2 == 5'd26)||(D_A2 == 5'd27))&&(D_rt_Tuse < M_Tnew)&&(M_RegWrite == 1) ? 1'b1 :
						(D_A2 == M_A3)&&(D_rt_Tuse < M_Tnew)&&(M_RegWrite == 1) ? 1'b1: 1'b0;
	
	assign Stall = Stall_E_A1 | Stall_E_A2 | Stall_M_A1 | Stall_M_A2 | 1'b0;
	
	assign PC_RegWE  = Stall==1 ? 1'b0:1'b1;//!Stall
    assign F_D_RegWE = Stall==1 ? 1'b0:1'b1;//!Stall
    assign D_E_RegWE = 1'b1;
    assign E_M_RegWE = 1'b1;
    assign M_W_RegWE = 1'b1;
	
	//assign F_D_clear = (D_Is_New == 1&&D_Condition == 0&&Stall==0) ? 1'b1 : 1'b0;
	assign F_D_clear = 1'b0;
    assign D_E_clear = Stall==1 ? 1'b1:1'b0;//Stall
    assign E_M_clear = 1'b0;
    assign M_W_clear = 1'b0;

endmodule
