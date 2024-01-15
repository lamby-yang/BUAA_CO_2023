`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:14:25 10/12/2023 
// Design Name: 
// Module Name:    gray 
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
`define s0 3'b000
`define s1 3'b001
`define s2 3'b011
`define s3 3'b010
`define s4 3'b110
`define s5 3'b111
`define s6 3'b101
`define s7 3'b100
module gray(
    input Clk,
    input Reset,
    input En,
    output reg [2:0] Output,
    output reg Overflow
    );
	 initial begin
	 Output=3'b000;
    Overflow=1'b0;
	 end
always @(posedge Clk) begin
    if (Reset==1'b1) begin
        Output<=3'b000;
        Overflow<=1'b0;
    end
    else begin
        
        case (Output)
            `s0:begin
              if (En==1'b1) begin
                Output<=3'b001;
              end
              else Output<=`s0;
            end 
            `s1:begin
              if (En==1'b1) begin
                Output<=3'b011;
              end
              else Output<=`s1;
            end 
            `s2:begin
              if (En==1'b1) begin
                Output<=3'b010;
              end
              else Output<=`s2;
            end 
            `s3:begin
              if (En==1'b1) begin
                Output<=3'b110;
              end
              else Output<=`s3;
            end 
            `s4:begin
              if (En==1'b1) begin
                Output<=3'b111;
              end
              else Output<=`s4;
            end 
            `s5:begin
              if (En==1'b1) begin
                Output<=3'b101;
              end
              else Output<=`s5;
            end 
            `s6:begin
              if (En==1'b1) begin
                Output<=3'b100;
              end
              else Output<=`s6;
            end 
            `s7:begin
              if (En==1'b1) begin
                Output<=3'b000;
                Overflow<=1'b1;
              end
              else Output<=`s7;
            end 
            default: Output<=`s0;
        endcase
        
    end
end

endmodule

