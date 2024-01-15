`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:48:31 11/11/2023 
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
`define Alu_add 4'd0
`define Alu_sub 4'd1
`define Alu_or  4'd2
`define Alu_lui 4'd3
`define Alu_new 4'd4
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
	wire [31:0] num = SrcB;
	wire [31:0] ans_new = 	(num[0]==1?32'd1:32'd0)+(num[1]==1?32'd1:32'd0)+
							(num[2]==1?32'd1:32'd0)+(num[3]==1?32'd1:32'd0)+
							(num[4]==1?32'd1:32'd0)+(num[5]==1?32'd1:32'd0)+
							(num[6]==1?32'd1:32'd0)+(num[7]==1?32'd1:32'd0)+
							(num[8]==1?32'd1:32'd0)+(num[9]==1?32'd1:32'd0)+
							(num[10]==1?32'd1:32'd0)+(num[11]==1?32'd1:32'd0)+
							(num[12]==1?32'd1:32'd0)+(num[13]==1?32'd1:32'd0)+
							(num[14]==1?32'd1:32'd0)+(num[15]==1?32'd1:32'd0)+
							(num[16]==1?32'd1:32'd0)+(num[17]==1?32'd1:32'd0)+
							(num[18]==1?32'd1:32'd0)+(num[19]==1?32'd1:32'd0)+
							(num[20]==1?32'd1:32'd0)+(num[21]==1?32'd1:32'd0)+
							(num[22]==1?32'd1:32'd0)+(num[23]==1?32'd1:32'd0)+
							(num[24]==1?32'd1:32'd0)+(num[25]==1?32'd1:32'd0)+
							(num[26]==1?32'd1:32'd0)+(num[27]==1?32'd1:32'd0)+
							(num[28]==1?32'd1:32'd0)+(num[29]==1?32'd1:32'd0)+
							(num[30]==1?32'd1:32'd0)+(num[31]==1?32'd1:32'd0);
	
    wire [31:0] f_add = $signed(SrcA)+$signed(SrcB);
    wire [31:0] f_sub = $signed(SrcA)-$signed(SrcB);
    wire [31:0] f_or  = SrcA | SrcB;
    wire [31:0] f_lui = SrcB << 16;
	
    assign ALU_Result = (ALU_Ctr == `Alu_add) ? (f_add):
                        (ALU_Ctr == `Alu_sub) ? (f_sub):
                        (ALU_Ctr == `Alu_or ) ? (f_or ):
                        (ALU_Ctr == `Alu_lui) ? (f_lui):
						(ALU_Ctr == `Alu_new) ? (ans_new) : 0;
						
	/*function reg [31:0] temp(
		input [31:0] SrcA,
		input [31:0] SrcB
		);
		integer i = 0;
		begin
			temp = 0;
			for(i=0;i<32;i=i+1)begin
				if(SrcA[i]&SrcB[i] == 1)begin
					temp = temp + 32'd1;
				end
			end
		end
	endfunction
	*/	
endmodule
