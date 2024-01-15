`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:24:24 11/14/2023 
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

    input [4:0] M_A3,
    input [31:0] M_PC,
    input [31:0] M_Reg_Data,
    input M_Reg_Write,
	input M_Is_New,

	output reg W_Is_New,
    output reg [4:0] W_A3,
    output reg [31:0] W_PC,
    output reg [31:0] W_Reg_Data,
    output reg W_Reg_Write
    );//chooose
    
    always @(posedge clk) begin
        if(reset == 1)begin
            W_A3 <= 0;
            W_PC <= 0;
            W_Reg_Data <= 0;
            W_Reg_Write <= 0;
			W_Is_New <= 0;
        end
        else begin
            W_A3 <= M_A3;
            W_PC <= M_PC;
            W_Reg_Data <= M_Reg_Data;
            W_Reg_Write <= M_Reg_Write;
			W_Is_New <= M_Is_New;
        end
    end

endmodule
