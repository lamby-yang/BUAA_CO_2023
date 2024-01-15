`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:09:12 11/24/2023 
// Design Name: 
// Module Name:    D_EXT 
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
module D_EXT(
    input [15:0] Offset,
    input Ext_Op,
	input D_Is_New,
	
    output [31:0] SignImm
    );

    assign SignImm = (Ext_Op == 0) ? {16'b0,Offset[15:0]} : {{16{Offset[15]}},Offset[15:0]};

endmodule
