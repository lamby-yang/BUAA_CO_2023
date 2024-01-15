`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:24:44 10/14/2023 
// Design Name: 
// Module Name:    expr 
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
module expr(
    input clk,
    input clr,
    input [7:0] in,
    output reg out
    );
reg [1:0] state;
initial begin
    state=2'b00;
end
parameter   S0=2'b00,
            S1=2'b01,
            S2=2'b10,
				S3=2'b11;
always @ (posedge clk or posedge clr)begin
    if(clr==1'b1)begin
	     state<=S0;
		  out<=1'b0;
	 end
	 else begin
    case(state)
        S0:begin
            if((in>=8'b00110000)&&(in<=8'b00111001))begin
                state<=S1;
                out<=1'b1;
            end
            else if((in==8'b00101010)||(in==8'b00101011))begin
                state<=S3;
                out<=1'b0;
            end
            else begin
                state<=S3;
                out<=1'b0;
            end
        end
        S1:begin
            if((in>=8'd48)&&(in<=8'd57))begin
                state<=S3;
                out<=1'b0;
            end
            else if((in==8'd42)||(in==8'd43))begin
                state<=S2;
                out<=1'b0;
            end
            else begin
                state<=S3;
                out<=1'b0;
            end
        end
        S2:begin
            if((in>=8'd48)&&(in<=8'd57))begin
                state<=S1;
                out<=1'b1;
            end
            else if((in==8'd42)||(in==8'd43))begin
                state<=S0;
                out<=1'b0;
            end
            else begin
                state<=S3;
                out<=1'b0;
            end
        end
		  S3:begin
            if((in>=8'd48)&&(in<=8'd57))begin
                state<=S3;
                out<=1'b0;
            end
            else if((in==8'd42)||(in==8'd43))begin
                state<=S3;
                out<=1'b0;
            end
            else begin
                state<=S3;
                out<=1'b0;
            end
        end

    endcase
	 end
end

endmodule
