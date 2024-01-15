`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:08:47 11/24/2023 
// Design Name: 
// Module Name:    D_controller 
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
//Splitter	    
	output [4:0] D_A1,
    output [4:0] D_A2,
    output [4:0] D_A3,
    output [4:0] D_rd,
    output [15:0] D_Offset,
    output [4:0] D_Shamt,
    output [25:0] D_Instr_Index,
//Controller	
	output D_ALU_Sel,
    output D_Mem_To_Reg,
    output D_Mem_Write,
    output [1:0] D_width,
    output D_Reg_Write,
    output [1:0] D_Branch,
    output D_Ext_Op,
    output D_Jump_addr,
    output D_Jump_reg,
	output D_Jump_link,
    output [3:0] D_ALU_Ctr,
	output [3:0] D_MDU_Ctr,
	output D_start,
	
	output D_RI,
	output D_Syscall,
	output D_eret,
	output D_mfc0,
	output D_mtc0,
	output D_CP0_WE,
	output BD,
	output D_Ov_sel,
	
	output D_Is_New,
	
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
	assign D_rd = Instr[15:11];
    wire [5:0]rd = Instr[15:11];
    assign D_A2 = Instr[20:16];
    assign D_A1 = Instr[25:21];
    assign Op = Instr[31:26];
    assign D_Instr_Index = Instr[25:0];
    assign D_Offset = Instr[15:0];
	
//control
	wire add = (Op == 6'b000000 && Funct == 6'b100000);
	wire sub = (Op == 6'b000000 && Funct == 6'b100010);
	wire And = (Op == 6'b000000 && Funct == 6'b100100);
	wire Or  = (Op == 6'b000000 && Funct == 6'b100101);
	wire slt = (Op == 6'b000000 && Funct == 6'b101010);
	wire sltu= (Op == 6'b000000 && Funct == 6'b101011);
	
	wire addi= (Op == 6'b001000);
	wire andi= (Op == 6'b001100);
	wire ori = (Op == 6'b001101);
	wire lui = (Op == 6'b001111);
	
	wire lw  = (Op == 6'b100011);
	wire lh  = (Op == 6'b100001);
	wire lb  = (Op == 6'b100000);

	wire sw  = (Op == 6'b101011);
	wire sh  = (Op == 6'b101001);
	wire sb  = (Op == 6'b101000);
	
	wire beq = (Op == 6'b000100);
	wire bne = (Op == 6'b000101);
	
	wire jal = (Op == 6'b000011);
	wire jr  = (Op == 6'b000000 && Funct == 6'b001000);

	wire mult  = (Op == 6'b000000 && Funct == 6'b011000);
	wire multu = (Op == 6'b000000 && Funct == 6'b011001);
	wire div   = (Op == 6'b000000 && Funct == 6'b011010);
	wire divu  = (Op == 6'b000000 && Funct == 6'b011011);
	
	wire mfhi  = (Op == 6'b000000 && Funct == 6'b010000);//(load from HI)
	wire mflo  = (Op == 6'b000000 && Funct == 6'b010010);
	wire mthi  = (Op == 6'b000000 && Funct == 6'b010001);//(write to HI)
	wire mtlo  = (Op == 6'b000000 && Funct == 6'b010011);	
	
	assign D_mfc0 = (Op == 6'b010000 && D_A1 == 5'b00000);
	assign D_mtc0 = (Op == 6'b010000 && D_A1 == 5'b00100);
	assign D_eret = (Instr == 32'b010000_1000_0000_0000_0000_0000_011000); 
	assign D_Syscall = (Op == 6'b000000 && Funct == 6'b001100);

	//wire new = (Op == 6'b000000 && Funct == 6'b010011);	
	//wire new = (Op == 6'b000011);
	
	assign D_RI = ~(add | sub | And | Or | slt | sltu |
					addi | andi | ori | lui |
					lw | lh | lb |
					sw | sh | sb |
					beq | bne | jal | jr |
					mult | multu | div | divu | 
					mthi | mtlo | mfhi | mflo |
					D_mtc0 | D_mfc0 | D_eret | D_Syscall |
					(Op == 6'b000000 && Funct == 6'b000000));

	assign D_CP0_WE = D_mtc0;
	assign D_Ov_sel = add | addi | sub;
	
	assign BD = beq | bne | jal | jr | 1'b0 ;
	
//decode
	assign D_A3	= 	(jal) 								? 5'd31 :		//chooose 31 as A3
					(addi | andi | ori | lui |
					lw | lh | lb | D_mfc0) 				? Instr[20:16]:	//chooose rt as A3
					(add | sub | And | Or | slt | sltu |
					mfhi | mflo) 						? Instr[15:11]:	//chooose rd as A3		(jalr)
					5'd0;
					
	assign D_ALU_Sel    = 	addi | andi | ori | lui |
							lw | lh | lb |
							sw | sh | sb | 1'b0;
//dm							
	assign D_Mem_To_Reg = lw | lh | lb | 1'b0;
	assign D_Mem_Write  = sw | sh | sb | 1'b0;
	assign D_width		= (lw | sw) ? 2'b00 :
						  (lh | sh) ? 2'b01 :
						  (lb | sb) ? 2'b10 : 2'b00;
//grf
	assign D_Reg_Write  = 	add | sub | And | Or | slt | sltu |
							addi | andi | ori | lui |
							lw | lh | lb |
							jal |
							mfhi | mflo |
							D_mfc0 | 1'b0;

	assign D_Branch   = beq ? 2'b01:
						bne ? 2'b10: 2'b00;
						
	assign D_Ext_Op   = addi |
						beq | bne |
						lw | lh | lb |
						sw | sh | sb | 1'b0;
	
	assign D_Jump_addr    = jal | 1'b0;//jump to instr_index
	assign D_Jump_reg     = jr | 1'b0; //jump to RD1
	assign D_Jump_link    = jal | 1'b0;//GPR[rd] <- PC+8 (主要是用来选PC+8的)
	
	assign D_ALU_Ctr = 	(add | addi) 	? 4'b0000 :
						(sub)			? 4'b0001 :
						(And | andi) 	? 4'b0010 :
						(Or  | ori ) 	? 4'b0011 :
						(lui) 			? 4'b0100 :
						(slt) 			? 4'b0101 :
						(sltu)			? 4'b0110 : 
						(lw|lh|lb|sw|sh|sb)? 4'b0000: 4'b0000;
						
	assign D_MDU_Ctr = 	mult ? 4'b0001 : 
						multu? 4'b0010 :
						div  ? 4'b0011 :
						divu ? 4'b0100 : 
						mfhi ? 4'b0101 :  
						mflo ? 4'b0110 : 
						mthi ? 4'b0111 : //用这个控制WD3_Sel
						mtlo ? 4'b1000 : 0;	
		
	assign D_start = mult | multu | div | divu | 1'b0;

	assign D_Is_New = 1'b0; 	

//Forwarding 	
	assign D_rs_Tuse = 	(beq | bne | jr ) 					? 4'd0 :
						(add | sub | And | Or | slt | sltu |
						addi | andi | ori |
						lw | lh | lb |
						sw | sh | sb |
						mult | multu | div | divu |
						mthi | mtlo ) 						? 4'd1 : 4'd5 ;
						
	assign D_rt_Tuse = 	(beq | bne ) 						? 4'd0 :
						(add | sub | And | Or | slt | sltu |
						mult | multu | div | divu ) 		? 4'd1 :
						(sw | sh | sb |
						D_mtc0 ) 								? 4'd2 : 4'd5 ;
					 
	assign D_Tnew  = //() ? 4'd1 :
					 (jal |
					 mfhi | mflo |
					 add | sub | And | Or | slt | sltu |
					 addi | andi | ori | lui) 			? 4'd2 :
					 (lw | lh | lb |
					 D_mfc0 ) 							? 4'd3 : 4'd0 ;
			 
	assign D_A1use = add | sub | And | Or | slt | sltu |
					 addi | andi | ori |
					 lw | lh | lb |
					 sw | sh | sb | 
					 beq | bne | jr | 
					 mult | multu | div | divu |
					 mthi | mtlo | 1'b0;
	assign D_A2use = add | sub | And | Or | slt | sltu |
					 sw | sh | sb | 
					 beq | bne |
					 mult | multu | div | divu | 
					 D_mtc0 |
					 1'b0;

endmodule

