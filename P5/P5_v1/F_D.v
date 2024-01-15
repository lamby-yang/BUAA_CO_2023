`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:19:56 11/14/2023 
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
    input [31:0] F_PC,
    input [31:0] F_Instr,

    output reg [31:0] D_PC,
    output reg [31:0] D_Instr
    );

    always @(posedge clk) begin
        if(reset == 1 || F_D_clear == 1)begin
            D_PC <= 32'b0;
            D_Instr <= 32'b0;
        end
		else  if(F_D_RegWE == 0)begin
			D_PC <= D_PC;
            D_Instr <= D_Instr;
		end
        else begin
            D_PC <= F_PC;
            D_Instr <= F_Instr;
        end
    end


endmodule
