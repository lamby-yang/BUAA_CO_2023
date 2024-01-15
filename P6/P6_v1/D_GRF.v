`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:09:26 11/24/2023 
// Design Name: 
// Module Name:    D_GRF 
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
module D_GRF(
    input [4:0] A1,//D_
    input [4:0] A2,//D_
    input [4:0] A3,//W_
    input [31:0] WD3,//W_
    input clk,
    input reset,
    input WE,//W_
    input [31:0] PC,//W_
	 
    output [31:0] RD1,//D_
    output [31:0] RD2//D_
    );

    reg [31:0] RF [0:31]; // Read From
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
            if(A3 == 0) WD = 0;
			
            RF[A3] <= WD;
            //$display("%d@%h: $%d <= %h", $time, PC, A3, WD);
        end
    end
	
    assign RD1 = (A1 == 5'd0) ? 32'h0000_0000:
				 (A1 == A3)&&(WE == 1) ? WD3 : RF[A1]; // 寄存器内部转发
    assign RD2 = (A2 == 5'd0) ? 32'h0000_0000:
				 (A2 == A3)&&(WE == 1) ? WD3 : RF[A2];


endmodule

