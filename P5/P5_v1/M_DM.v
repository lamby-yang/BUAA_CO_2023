`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:52:41 11/11/2023 
// Design Name: 
// Module Name:    M_DM 
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
module M_DM(
    input clk,
    input reset,
    input Mem_Write,
    input [31:0]PC,
    input [31:0] ALU_Result,
    input [31:0] Write_Data,
	 
    output [31:0] Read_Data
    );

    reg [31:0] RAM [0:4096];
    integer i = 0;
    initial begin
        for (i = 0; i<4096; i=i+1 ) begin
            RAM[i]=32'b0;
        end
    end

    always @(posedge clk ) begin
        if(reset == 1)begin
            for (i = 0; i<4096; i=i+1 ) begin
                RAM[i]=32'b0;
            end
        end
        else if(Mem_Write == 1)
        begin
            RAM[ALU_Result[13:2]] = Write_Data;
			$display("%d@%h: *%h <= %h", $time, PC, ALU_Result, Write_Data);
        end 
    end

    assign Read_Data = RAM[ALU_Result[13:2]];

endmodule
