`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:10:13 11/24/2023 
// Design Name: 
// Module Name:    E_ALU 
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
`define Alu_add 4'b0000 
`define Alu_sub 4'b0001
`define Alu_and 4'b0010
`define Alu_or  4'b0011
`define Alu_lui 4'b0100
`define Alu_slt 4'b0101
`define Alu_sltu 4'b0110
module E_ALU(
    input [31:0] SrcA,
    input [31:0] SrcB,
    input [4:0] Shamt,
	input [3:0] ALU_Ctr,
	input E_Is_New,
	
    output [31:0] ALU_Result
    );
	/*integer i;
	reg [31:0] temp;
	always @(*)begin
		temp=32'd0;
		for(i=0;i<32;i=i+1)begin
			if(SrcA[i]==1)begin
				temp=temp+32'd1;
			end
		end
	end
	*/
    wire [31:0] f_add = SrcA + SrcB;
    wire [31:0] f_sub = SrcA - SrcB;
	wire [31:0] f_and = SrcA & SrcB;
    wire [31:0] f_or  = SrcA | SrcB;
    wire [31:0] f_lui = SrcB << 16;
	wire [31:0] f_slt = $signed(SrcA) < $signed(SrcB);
	wire [31:0] f_sltu = (SrcA < SrcB) ;
	
    assign ALU_Result = (ALU_Ctr == `Alu_add) ? (f_add):
                        (ALU_Ctr == `Alu_sub) ? (f_sub):
						(ALU_Ctr == `Alu_and) ? (f_and):
                        (ALU_Ctr == `Alu_or ) ? (f_or ):
                        (ALU_Ctr == `Alu_lui) ? (f_lui):
						(ALU_Ctr == `Alu_slt) ? (f_slt):
						(ALU_Ctr == `Alu_sltu) ? (f_sltu):32'd0;

endmodule
