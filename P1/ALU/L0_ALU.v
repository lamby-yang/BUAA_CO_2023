`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:44:50 10/10/2023 
// Design Name: 
// Module Name:    alu
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
module alu(
    input [31:0] A,
    input [31:0] B,
    input [2:0]  ALUOp,
    output [31:0] C
    );
wire [31:0] temp=$signed(A) >>> B;
assign C = 	(ALUOp==3'b000)?(A+B):
				(ALUOp==3'b001)?(A-B):
				(ALUOp==3'b010)?(A&B):
				(ALUOp==3'b011)?(A|B):
				(ALUOp==3'b100)?(A>>B):
				(ALUOp==3'b101)?(temp):
				32'b0000_0000_0000_0000_0000_0000_0000_0000;
endmodule
/*这样也可以
module alu(
    input [31:0] A,
    input [31:0] B,
    input [2:0]  ALUOp,
    output [31:0] C
    );
assign C = 	(ALUOp==3'b000)?(A+B):
				(ALUOp==3'b001)?(A-B):
				(ALUOp==3'b010)?(A&B):
				(ALUOp==3'b011)?(A|B):
				(ALUOp==3'b100)?(A>>B):
				(ALUOp==3'b101)?($signed($signed(A) >>> B)):
				32'b0000_0000_0000_0000_0000_0000_0000_0000;
endmodule*/
/*这个也是对的，我一开使没有设temp,过不去，用这个方法过的
module alu(
    input [31:0] A,
    input [31:0] B,
    input [2:0]  ALUOp,
    output [31:0] C
    );
assign C = 	(ALUOp==3'b000)?(A+B):
				(ALUOp==3'b001)?(A-B):
				(ALUOp==3'b010)?(A&B):
				(ALUOp==3'b011)?(A|B):
				(ALUOp==3'b100)?(A>>B):
				(ALUOp==3'b101)?(A>>31==1?((A>>B)|(32'b1111_1111_1111_1111_1111_1111_1111_1111<<(32-B))):A>> B):
				32'b0000_0000_0000_0000_0000_0000_0000_0000;

endmodule*/