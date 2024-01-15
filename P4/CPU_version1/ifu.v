`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:59:14 11/03/2023 
// Design Name: 
// Module Name:    ifu 
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

module ifu(
    input clk,
    input reset,
    input [31:0] Npc,

    output reg [31:0] PC,
    output [31:0] Instr
    );

    reg [31:0] ROM [0:4096];
    integer i;
    //reg [31:0] PC; 

    initial begin
        i=0;
        //for (i = 0; i<4096 ;i=i+1 ) begin
          //  ROM[i]=32'h0;
        //end
        $readmemh("code.txt", ROM, 0,4096);
        PC = 32'h00003000;
    end

    always @(posedge clk ) begin
        if(reset == 1)begin
            PC <= 32'h00003000;
        end
        else begin
            PC <= Npc;
        end
    end

    wire [31:0] addr = PC-32'h00003000;
    wire [11:0] addr_in = addr[13:2];

    assign Instr = ROM[addr_in];

endmodule

