`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:10:24 11/24/2023 
// Design Name: 
// Module Name:    E_M 
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
module E_M(
    input clk,
    input reset,
    input E_M_RegWE,
    input E_M_clear,

    input [31:0] E_RD2,
    input [31:0] E_PC,
    input E_Mem_Write,//DM
    input [31:0] E_ALU_Result,
    input E_Reg_Write,//GRF
    input E_Mem_To_Reg,//Choose
    input E_Jump_link,
    input [4:0] E_A3,//Forwarding
    input [4:0] E_A2,
	input [4:0] E_A1,
	input [3:0] E_Tnew,//Delay
    input E_A2use,
    input [1:0] E_width,
	input E_Is_New,
	input E_Condition,

	output reg M_Condition,
	output reg M_Is_New,
    output reg [31:0] M_RD2,
    output reg [31:0] M_PC,
    output reg M_Mem_Write,//DM
    output reg [31:0] M_ALU_Result,
    output reg M_Reg_Write,//GRF
    output reg M_Mem_To_Reg,//Choose
    output reg M_Jump_link,
    output reg [4:0] M_A3,//Forwarding
    output reg [4:0] M_A2,
	output reg [4:0] M_A1,
	output reg [3:0] M_Tnew,//Delay
    output reg M_A2use,
    output reg [1:0] M_width
    );

    always @(posedge clk) begin
        if(reset == 1)begin
            M_RD2 <= 0;
            M_PC <= 0;
            M_Mem_Write <= 0;
            M_ALU_Result <= 0;
            M_Reg_Write <= 0;
            M_Mem_To_Reg <= 0;
            M_Jump_link <= 0;
            M_A3 <= 0;
            M_A2 <= 0;
			M_A1 <= 0;
            M_Tnew <= 0;
            M_A2use <= 0;
			M_width <= 0;
			M_Is_New <= 0;
			M_Condition <= 0;
        end
        else begin
            M_RD2 <= E_RD2;
            M_PC <= E_PC;
            M_Mem_Write <= E_Mem_Write;
            M_ALU_Result <= E_ALU_Result;
            M_Reg_Write <= E_Reg_Write;
            M_Mem_To_Reg <= E_Mem_To_Reg;
            M_Jump_link <= E_Jump_link;
            M_A3 <= E_A3;
            M_A2 <= E_A2;
			M_A1 <= E_A1;
            if(E_Tnew >= 1)begin
                M_Tnew <= E_Tnew-1;
            end
            else M_Tnew <= 0;
            M_A2use <= E_A2use;
			M_width <= E_width;
			M_Is_New <= E_Is_New;
			M_Condition <= E_Condition;
        end
    end

endmodule
