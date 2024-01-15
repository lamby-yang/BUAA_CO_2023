`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:03:37 11/11/2023 
// Design Name: 
// Module Name:    D_Controller 
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
module D_Controller(
	input [31:0] Instr,
	///没写完？写完了吗?

//Splitter	    
	output [4:0] D_A1,
    output [4:0] D_A2,
    output [4:0] D_A3,
    output [15:0] D_Offset,
    output [4:0] D_Shamt,
    output [25:0] D_Instr_Index,
//Controller	
	output D_ALU_Sel,
    output D_Mem_To_Reg,
    output D_Mem_Write,
    output D_Reg_Dst,
    output D_Reg_Write,
    output D_Branch,
    output D_Ext_Op,
    output D_Jal_Sel,
    output D_Jr_Sel,
    output [3:0] ALU_Ctr,
//Forward_control	
	output [3:0] D_rs_Tuse,
	output [3:0] D_rt_Tuse,
	output [3:0] D_Tnew,
	output D_A1use,//use
    output D_A2use
    );

//splitter
    wire [5:0] Op;
    wire [5:0] Funct;

    assign Funct = Instr[5:0];
    assign D_Shamt = Instr[10:6];
    assign D_A3 = Instr[15:11];
    assign D_A2 = Instr[20:16];
    assign D_A1 = Instr[25:21];
    assign Op = Instr[31:26];

    assign D_Instr_Index = Instr[25:0];
    assign D_Offset = Instr[15:0];
	
//control
	wire add = (Op == 6'b000000 && Funct == 6'b100000);
	wire sub = (Op == 6'b000000 && Funct == 6'b100010);
	wire ori = (Op == 6'b001101);
	wire lw  = (Op == 6'b100011);
	wire sw  = (Op == 6'b101011);
	wire beq = (Op == 6'b000100);
	wire lui = (Op == 6'b001111);
	wire jal = (Op == 6'b000011);
	wire jr  = (Op == 6'b000000 && Funct == 6'b001000);

	assign D_ALU_Sel    = ori | lui | lw | sw | 1'b0;
	assign D_Mem_To_Reg = lw | 1'b0;
	assign D_Mem_Write  = sw | 1'b0;
	assign D_Reg_Dst    = add | sub | 1'b0;
	assign D_Reg_Write  = add | sub | ori | lw | lui | jal | 1'b0;
	assign D_Branch     = beq | 1'b0;
	assign D_Ext_Op     = beq | lw | sw | 1'b0;
	assign D_Jal_Sel    = jal | 1'b0;
	assign D_Jr_Sel     = jr | 1'b0;
	assign ALU_Ctr[0] = sub | beq | lui | 1'b0;
	assign ALU_Ctr[1] = ori | lui | 1'b0;
	assign ALU_Ctr[2] = 1'b0;
	assign ALU_Ctr[3] = 1'b0;
//Forwarding 	
	wire rs_Tuse_0 = beq | jr | 1'b0 ;//0
	wire rs_Tuse_1 = add | sub | ori | lw | sw | 1'b0 ;//1
	wire rs_Tuse_x = lui | jal | 1'b0 ;//x(>3)
	wire rt_Tuse_0 = beq | 1'b0 ;//0
	wire rt_Tuse_1 = add | sub | 1'b0 ;//1
	wire rt_Tuse_2 = sw  | 1'b0 ;//2
	wire rt_Tuse_x = ori | lw | lui | jal | jr | 1'b0 ;//x(>3)
	wire D_Tnew_1  = jal | 1'b0 ;//1
	wire D_Tnew_2  = add | sub | ori | lui | 1'b0 ;//2
	wire D_Tnew_3  = lw | 1'b0 ;//3
	
	assign D_rs_Tuse = 	(rs_Tuse_0 == 1) ? 4'd0 :
						(rs_Tuse_1 == 1) ? 4'd1 : 4'd5 ;
						
	assign D_rt_Tuse = 	(rt_Tuse_0 == 1) ? 4'd0 :
						(rt_Tuse_1 == 1) ? 4'd1 :
						(rt_Tuse_2 == 1) ? 4'd2 : 4'd5 ;
					 
	assign D_Tnew  = (D_Tnew_1 == 1) ? 4'd1 :
					 (D_Tnew_2 == 1) ? 4'd2 :
					 (D_Tnew_3 == 1) ? 4'd3 : 4'd0 ;
			 
	assign D_A1use = add | sub | ori | lw | sw | beq | jr | 1'b0;
	assign D_A2use = add | sub | beq | sw | 1'b0;

endmodule
