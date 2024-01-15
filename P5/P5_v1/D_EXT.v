`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:50:53 11/11/2023 
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
    output [31:0] SignImm
    );

    assign SignImm = (Ext_Op == 0) ? {16'b0,Offset[15:0]} : {{16{Offset[15]}},Offset[15:0]};

endmodule
