`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:08:58 11/24/2023 
// Design Name: 
// Module Name:    D_E 
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
module D_E(
    input clk,
    input reset,
    input D_E_RegWE,
    input D_E_clear,

    input [31:0] D_PC,//M_DM
    input D_Mem_Write,
    input D_Reg_Write,//W_GRF_Write
    input [31:0] D_SignImm,//Choose
    input D_Mem_To_Reg,
    input D_Jump_link,
    input D_ALU_Sel,
    input [3:0] D_Tnew,//Delay
    input [4:0] D_A3,
    input [4:0] D_A1,//Forwarding
    input [4:0] D_A2,
    input [31:0] D_RD1,//ALU
    input [31:0] D_RD2,
    input [4:0] D_Shamt,
	input [3:0] D_ALU_Ctr,
	input [3:0] D_MDU_Ctr,
	input D_start,
    input D_A1use,
    input D_A2use,
    input [1:0] D_width,
	input D_Is_New,
	input D_Condition,

	output reg E_Condition,
	output reg E_Is_New,	
    output reg [31:0] E_PC,//M_DM
    output reg E_Mem_Write,
    output reg E_Reg_Write,//W_GRF_Write
    output reg [31:0] E_SignImm,//Choose
    output reg E_Mem_To_Reg,
    output reg E_Jump_link,
    output reg E_ALU_Sel,
    output reg [3:0] E_Tnew,//Delay
    output reg [4:0] E_A3,
    output reg [4:0] E_A1,//Forwarding
    output reg [4:0] E_A2,
    output reg [31:0] E_RD1,//ALU
    output reg [31:0] E_RD2,
    output reg [4:0] E_Shamt,
	output reg [3:0] E_ALU_Ctr,
	output reg [3:0] E_MDU_Ctr,
	output reg E_start,
    output reg E_A1use,
    output reg E_A2use,
	output reg [1:0] E_width
    );

    always @(posedge clk) begin
        if(reset == 1 || D_E_clear == 1)begin
            E_PC <= 0;
            E_Mem_Write <= 0;
            E_Reg_Write <= 0;
            E_SignImm <= 0;
            E_Mem_To_Reg <= 0;
            E_Jump_link <= 0;
            E_ALU_Sel <= 0;
            E_Tnew <= 0;
            E_A3 <= 0;
            E_A1 <= 0;
            E_A2 <= 0;
            E_RD1 <= 0;
            E_RD2 <= 0;
            E_Shamt <= 0;
            E_ALU_Ctr <= 0;
			E_MDU_Ctr <= 0;
			E_start <= 0;
            E_A1use <= 0;
            E_A2use <= 0;
			E_width <= 0;
			E_Is_New <= 0;
			E_Condition <= 0;
        end
        else begin
            E_PC <= D_PC;
            E_Mem_Write <= D_Mem_Write;
            E_Reg_Write <= D_Reg_Write;
            E_SignImm <= D_SignImm;
            E_Mem_To_Reg <= D_Mem_To_Reg;
            E_Jump_link <= D_Jump_link;
            E_ALU_Sel <= D_ALU_Sel;
            if(D_Tnew >= 1)begin
                E_Tnew <= D_Tnew-1;
            end
            else E_Tnew <= 0;
            E_A3 <= D_A3;
            E_A1 <= D_A1;
            E_A2 <= D_A2;
            E_RD1 <= D_RD1;
            E_RD2 <= D_RD2;
            E_Shamt <= D_Shamt;
            E_ALU_Ctr <= D_ALU_Ctr;
			E_MDU_Ctr <= D_MDU_Ctr;
			E_start <= D_start;
            E_A1use <= D_A1use;
            E_A2use <= D_A2use;
			E_width <= D_width;
			E_Is_New <= D_Is_New;
			E_Condition <= D_Condition;
        end
    end

endmodule
