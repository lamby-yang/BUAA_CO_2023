`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:10:53 11/24/2023 
// Design Name: 
// Module Name:    F_IFU 
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
module F_IFU(
    input clk,
    input reset,
    input [31:0] Npc,
    input PC_RegWE,
	input Req,

    output reg [31:0] F_PC
    );

    initial begin
        F_PC = 32'h00003000;
    end

    always @(posedge clk ) begin
        if(reset == 1)begin
            F_PC <= 32'h00003000;
        end
        else if(PC_RegWE == 1 || Req == 1)begin
            F_PC <= Npc;
        end
    end

endmodule


