`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:04:51 11/14/2023 
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

    output reg [31:0] F_PC,
    output [31:0] F_Instr
    );

    reg [31:0] ROM [0:4096];

    initial begin
        $readmemh("code.txt", ROM, 0,4096);
        F_PC = 32'h00003000;
    end

    always @(posedge clk ) begin
        if(reset == 1)begin
            F_PC <= 32'h00003000;
        end
        else if(PC_RegWE == 1)begin
            F_PC <= Npc;
        end
    end

    wire [31:0] addr = F_PC-32'h00003000;
    wire [11:0] addr_in = addr[13:2];

    assign F_Instr = ROM[addr_in];

endmodule

