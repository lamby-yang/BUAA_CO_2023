`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:01:29 11/03/2023 
// Design Name: 
// Module Name:    splitter 
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
module splitter(
    input [31:0] Instr,
	 
    output [4:0] A1,
    output [4:0] A2,
    output [4:0] A3,
    output [15:0] Offset,
    output [4:0] Shamt,
    output [5:0] Op,
    output [5:0] Funct,
    output [25:0] Instr_Index
    );

    assign Funct = Instr[5:0];
    assign Shamt = Instr[10:6];
    assign A3 = Instr[15:11];
    assign A2 = Instr[20:16];
    assign A1 = Instr[25:21];
    assign Op = Instr[31:26];

    assign Instr_Index = Instr[25:0];
    assign Offset = Instr[15:0];

endmodule


