`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:01:02 11/03/2023 
// Design Name: 
// Module Name:    a3_sel 
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
module a3_sel(
    input [4:0] A2,
    input [4:0] A3,
    input Reg_Dst,
    input Jal_Sel,
	 
    output [4:0] Reg_Addr
    );

    wire [1:0] a3ctr = {Jal_Sel,Reg_Dst};

    assign Reg_Addr =   (a3ctr == 0)?(A2[4:0]):
                        (a3ctr == 1)?(A3[4:0]):
                        (a3ctr == 2)?(5'h1f):
                        5'b0;

endmodule

