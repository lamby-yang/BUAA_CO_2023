`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:58:02 11/03/2023 
// Design Name: 
// Module Name:    grf 
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
module grf(
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD3,
    input clk,
    input reset,
    input WE,
    input [31:0] PC,
	 
    output [31:0] RD1,
    output [31:0] RD2
    );

    reg [31:0] RF [0:31];
	 reg [31:0] WD;
    integer i;
	 initial begin
			i=0;
			for (i = 0;i < 32;i = i + 1) 
            begin
                RF[i]=32'b0;
            end
			WD=0;
	 end
    always @(posedge clk)
    begin
        if(reset == 1)
        begin
            for (i = 0;i < 32;i = i + 1) 
            begin
                RF[i]=32'b0;
            end
        end
        else if(WE == 1)
        begin
				WD = WD3;
            if(A3 == 0)begin
                WD = 0;
            end
            RF[A3] <= WD;
            $display("@%h: $%d <= %h", PC, A3, WD);
        end
    end
    assign RD1 = RF[A1];
    assign RD2 = RF[A2];


endmodule