`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:11:05 11/24/2023 
// Design Name: 
// Module Name:    F_D 
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
module F_D(
    input clk,
    input reset,
    input F_D_RegWE,
    input F_D_clear,
	input Req,

    input [31:0] F_PC,
    input [31:0] F_Instr,
	input [4:0] F_ExcCode,
	input F_BD,
	
	output reg D_BD,
	output reg [4:0] D_ExcCode,
    output reg [31:0] D_PC,
    output reg [31:0] D_Instr
    );

    always @(posedge clk) begin
        if(reset == 1 || F_D_clear == 1 || Req)begin
            D_PC <= Req ? 32'h0000_4180 : 32'b0;
            D_Instr <= 32'b0;
			D_ExcCode <= 0;
			D_BD <= 0;
        end
		else  if(F_D_RegWE == 0)begin
			D_PC <= D_PC;
            D_Instr <= D_Instr;
			D_ExcCode <= D_ExcCode;
			D_BD <= D_BD;
		end
        else begin
            D_PC <= F_PC;
            D_Instr <= F_Instr;
			D_ExcCode <= F_ExcCode;
			D_BD <= F_BD;
        end
    end


endmodule

