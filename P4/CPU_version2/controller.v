`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:03:41 11/03/2023 
// Design Name: 
// Module Name:    controller 
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
module controller (
    input [5:0] Op,
    input [5:0] Funct,

    output ALU_Sel,
    output Mem_To_Reg,
    output Mem_Write,
    output Reg_Dst,
    output Reg_Write,
    output Branch,
    output Ext_Op,
    output Jal_Sel,
    output Jr_Sel,
	 output Byte,
	 output Half,
    output [3:0] ALU_Ctr
);

  wire add = (Op == 6'b000000 && Funct == 6'b100000);
  wire sub = (Op == 6'b000000 && Funct == 6'b100010);
  wire ori = (Op == 6'b001101);
  wire lw = (Op == 6'b100011);
  wire sw = (Op == 6'b101011);
  wire beq = (Op == 6'b000100);
  wire lui = (Op == 6'b001111);
  wire jal = (Op == 6'b000011);
  wire jr = (Op == 6'b000000 && Funct == 6'b001000);
  wire sb = (Op == 6'b101000);
  wire lb = (Op == 6'b100000);

  assign ALU_Sel    = ori | lui | lw | sw |sb|lb| 1'b0;//
  assign Mem_To_Reg = lw |lb| 1'b0;//
  assign Mem_Write  = sw |sb| 1'b0;//
  assign Reg_Dst    = add | sub | 1'b0;
  assign Reg_Write  = add | sub | ori | lw | lui | jal |lb| 1'b0;//
  assign Branch     = beq | 1'b0;
  assign Ext_Op     = beq | lw | sw |lb|sb| 1'b0;//
  assign Jal_Sel    = jal | 1'b0;
  assign Jr_Sel     = jr | 1'b0;
  assign Byte		  = sb | lb | 1'b0;
  assign ALU_Ctr[0] = sub | beq | lui | 1'b0;
  assign ALU_Ctr[1] = ori | lui | 1'b0;
  assign ALU_Ctr[2] = 1'b0;
  assign ALU_Ctr[3] = 1'b0;

  assign Half = 1'b0;


endmodule


