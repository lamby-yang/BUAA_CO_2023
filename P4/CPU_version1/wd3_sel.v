`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:02:42 11/03/2023 
// Design Name: 
// Module Name:    wd3_sel 
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
module wd3_sel (
    input [31:0] Mem_Addr,
    input [31:0] Read_Data,
    input [31:0] PC,
    input Jal_Sel,
    input Mem_To_Reg,

    output [31:0] Reg_Data
);

    wire [1:0] wd3ctr = {Jal_Sel, Mem_To_Reg};

    assign Reg_Data =   (wd3ctr == 0)?Mem_Addr:
                        (wd3ctr == 1)?Read_Data:
                        (wd3ctr == 2)?(PC + 4):
                        0;

endmodule

