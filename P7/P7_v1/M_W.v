`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:17:57 11/25/2023 
// Design Name: 
// Module Name:    M_W 
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
module M_W(
    input clk,
    input reset,
    input M_W_RegWE,
    input M_W_clear,
	input Req,
	
	input [31:0] M_Instr,	
    input [4:0] M_A3,
    input [31:0] M_PC,
    input [31:0] M_Reg_Data,
    input M_Reg_Write,
	input M_Is_New,
    input [1:0] M_width,
	input [3:0] M_Tnew,
	
	output reg [31:0] W_Instr,	 
	output reg [3:0] W_Tnew,
	output reg W_Is_New,
    output reg [4:0] W_A3,
    output reg [31:0] W_PC,
    output reg [31:0] W_Reg_Data,
    output reg W_Reg_Write,
    output reg [1:0] W_width
    );//chooose
    
    always @(posedge clk) begin
        if(reset == 1 || Req)begin
            W_A3 <= 0;
            W_PC <= Req ? 32'h0000_4180 : 32'b0;
            W_Reg_Data <= 0;
            W_Reg_Write <= 0;
			W_width <= 0;
			W_Tnew <= 0;
			W_Is_New <= 0;
			W_Instr <= 0;
        end
        else begin
            W_A3 <= M_A3;
            W_PC <= M_PC;
            W_Reg_Data <= M_Reg_Data;
            W_Reg_Write <= M_Reg_Write;
			W_width <= M_width;
			if(M_Tnew >= 1)begin
                W_Tnew <= M_Tnew-1;
            end
			W_Is_New <= M_Is_New;
			W_Instr <= M_Instr;
        end
    end

endmodule

