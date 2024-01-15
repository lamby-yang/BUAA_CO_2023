`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:05:17 11/11/2023 
// Design Name: 
// Module Name:    mips 
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
module mips(
	input clk,
    input reset 
    );
/******************************************** Declarations ********************************************/
/*******************************F*******************************/
//IFU
    wire [31:0] Npc;//
    wire [31:0] F_PC;
    wire [31:0] F_Instr;

/*******************************D*******************************/
//F_D
    wire [31:0] D_PC;
    wire [31:0] D_Instr;

//Controller	
	wire D_ALU_Sel;//
    wire D_Mem_To_Reg;//
    wire D_Mem_Write;//
    wire D_Reg_Dst;//
    wire D_Reg_Write;//
    wire D_Branch;//
    wire D_Ext_Op;//
    wire D_Jal_Sel;//
    wire D_Jr_Sel;//
    wire [3:0] D_ALU_Ctr;//
    //Splitter	    
	wire [4:0] D_A1;///
    wire [4:0] D_A2;//
    wire [4:0] D_A3;//
    wire [15:0] D_Offset;//
    wire [4:0] D_Shamt;//
    wire [25:0] D_Instr_Index;//
    //Forward_control	
	wire [3:0] D_rs_Tuse;//
	wire [3:0] D_rt_Tuse;//
	wire [3:0] D_Tnew;//
    wire D_A1use;
    wire D_A2use;

//GRF
    wire [31:0] D_RD1;//D_
    wire [31:0] D_RD2;//D_

//EXT
    wire [31:0] D_SignImm;//

//CMP
	wire D_b_jump;//

//NPC
    //wire [31:0] RD1;//??FW_RD1?
	//wire Instr_Index;
	//wire D_PC;
    //wire Npc;

/*******************************E*******************************/
//D_E
    wire [31:0] E_PC;//M_DM
    wire E_Mem_Write;
    wire E_Reg_Write;//W_GRF_Write

    wire [31:0] E_SignImm;//Choose
    wire E_Mem_To_Reg;
    wire E_Jal_Sel;
    wire E_ALU_Sel;
    wire [3:0] E_Tnew;//Delay
    wire [4:0] E_A3;
    wire [4:0] E_A1;//Forwarding
    wire [4:0] E_A2;

    wire [31:0] E_RD1;
    wire [31:0] E_RD2;
    wire E_A1use;
    wire E_A2use;

//ALU    
    wire [4:0] E_Shamt;//D_E
	wire [3:0] E_ALU_Ctr;

    wire [31:0] E_ALU_Result;

/*******************************M*******************************/
//E_M
    wire [31:0] M_PC;
    wire M_Reg_Write;//GRF

    wire M_Mem_To_Reg;//Choose
    wire M_Jal_Sel;

    wire [4:0] M_A3;//Forwarding
    wire [4:0] M_A2;
    wire [31:0] M_RD2;
    wire M_A2use;
	wire [3:0] M_Tnew;//Delay

//DM
    wire M_Mem_Write;
    wire [31:0] M_ALU_Result;
	 
    wire [31:0] M_Read_Data;

/*******************************W*******************************/
//M_W
    wire W_Mem_To_Reg;//Choose
    wire W_Jal_Sel;
    wire [31:0] W_ALU_Result;
    wire [31:0] W_RegData;

//GRF
    wire [4:0] W_A3;//W_
    wire W_Reg_Write;//W_
    wire [31:0] W_PC;//W_

/*******************************Else*******************************/
//Forwarding
	wire [31:0] D_RD1_FW;//FW=Forwarding
	wire [31:0] D_RD2_FW;
	wire [31:0] E_RD1_FW;
	wire [31:0] E_RD2_FW;
	wire [31:0] M_WriteData_FW;

//Choose
	wire [4:0] D_A3_Ch;//Ch,Choose_output
    wire [31:0] E_RD2_Ch;
    wire [31:0] E_ALUResult_Ch;
	wire [31:0] M_RegData_Ch;
//Delay
	wire Stall;
    wire PC_RegWE;
    wire F_D_RegWE;
    wire D_E_RegWE;
    wire E_M_RegWE;
    wire M_W_RegWE;
	
	wire F_D_clear;
    wire D_E_clear;
    wire E_M_clear;
    wire M_W_clear;
/************************************************* Stage *************************************************/

/********************  Stage_F  ********************/
F_IFU F_IFU(
    .clk(clk),
    .reset(reset),
    .Npc(Npc),
    .PC_RegWE(PC_RegWE),
	
    .F_PC(F_PC),
    .F_Instr(F_Instr)
    );

F_D F_D(
    .clk(clk),
    .reset(reset),
    .F_D_RegWE(F_D_RegWE),
    .F_D_clear(F_D_clear),
    .F_PC(F_PC),
    .F_Instr(F_Instr),

    .D_PC(D_PC),
    .D_Instr(D_Instr)
    );

/********************  Stage_D  ********************/
//
D_Controller D_Controller(
    .Instr(D_Instr),
//Controller	
	.D_ALU_Sel(D_ALU_Sel),
    .D_Mem_To_Reg(D_Mem_To_Reg),
    .D_Mem_Write(D_Mem_Write),
    .D_Reg_Dst(D_Reg_Dst),
    .D_Reg_Write(D_Reg_Write),
    .D_Branch(D_Branch),
    .D_Ext_Op(D_Ext_Op),
    .D_Jal_Sel(D_Jal_Sel),
    .D_Jr_Sel(D_Jr_Sel),
    .ALU_Ctr(D_ALU_Ctr),
//Splitter	    
	.D_A1(D_A1),
    .D_A2(D_A2),
    .D_A3(D_A3),
    .D_Offset(D_Offset),
    .D_Shamt(D_Shamt),
    .D_Instr_Index(D_Instr_Index),
//Forward_control	
	.D_rs_Tuse(D_rs_Tuse),
	.D_rt_Tuse(D_rt_Tuse),
	.D_Tnew(D_Tnew),
    .D_A1use(D_A1use),//use
    .D_A2use(D_A2use)
    );

//
D_GRF D_GRF(
    .A1(D_A1),//D_
    .A2(D_A2),//D_
    .A3(W_A3),//W_
    .WD3(W_RegData),//W_
    .clk(clk),
    .reset(reset),
    .WE(W_Reg_Write),//W_
    .PC(W_PC),//W_
	 
    .RD1(D_RD1),//D_
    .RD2(D_RD2)//D_
    );

	
//
D_EXT D_EXT(
    .Offset(D_Offset),
    .Ext_Op(D_Ext_Op),
    .SignImm(D_SignImm)
    );
	
//	
D_CMP D_CMP(
    .RD1(D_RD1_FW),
	.RD2(D_RD2_FW),
	.Is_Branch(D_Branch),
	
	.B_jump(D_b_jump)
    );

//
D_NPC D_NPC(
    .B_jump(D_b_jump),
    .Branch(D_Branch),
    .Jr_Sel(D_Jr_Sel),
    .Jal_Sel(D_Jal_Sel),
	.SignImm(D_SignImm),
    .RD1(D_RD1_FW),
	.Instr_Index(D_Instr_Index),
    .F_PC(F_PC),
	.D_PC(D_PC),

    .Npc(Npc)
	);

//D_E    
D_E D_E(
    .clk(clk),
    .reset(reset),
    .D_E_RegWE(D_E_RegWE),
    .D_E_clear(D_E_clear),

    .D_PC(D_PC),//M_DM
    .D_Mem_Write(D_Mem_Write),
    .D_Reg_Write(D_Reg_Write),//W_GRF_Write
    .D_SignImm(D_SignImm),//Choose
    .D_Mem_To_Reg(D_Mem_To_Reg),
    .D_Jal_Sel(D_Jal_Sel),
    .D_ALU_Sel(D_ALU_Sel),
    .D_Tnew(D_Tnew),//Delay
    .D_A3(D_A3_Ch),
    .D_A1(D_A1),//Forwarding
    .D_A2(D_A2),
    .D_RD1(D_RD1_FW),//ALU
    .D_RD2(D_RD2_FW),
    .D_Shamt(D_Shamt),
	.D_ALU_Ctr(D_ALU_Ctr),
    .D_A1use(D_A1use),
    .D_A2use(D_A2use),

    .E_PC(E_PC),//M_DM
    .E_Mem_Write(E_Mem_Write),
    .E_Reg_Write(E_Reg_Write),//W_GRF_Write
    .E_SignImm(E_SignImm),//Choose
    .E_Mem_To_Reg(E_Mem_To_Reg),
    .E_Jal_Sel(E_Jal_Sel),
    .E_ALU_Sel(E_ALU_Sel),
    .E_Tnew(E_Tnew),//Delay
    .E_A3(E_A3),
    .E_A1(E_A1),//Forwarding
    .E_A2(E_A2),
    .E_RD1(E_RD1),//ALU
    .E_RD2(E_RD2),
    .E_Shamt(E_Shamt),
	.E_ALU_Ctr(E_ALU_Ctr),
    .E_A1use(E_A1use),
    .E_A2use(E_A2use)
);	
/********************  Stage_E  ********************/
E_ALU E_ALU(
    .SrcA(E_RD1_FW),
    .SrcB(E_RD2_Ch),
    .Shamt(E_Shamt),
	.ALU_Ctr(E_ALU_Ctr),
	  
	.ALU_Result(E_ALU_Result)
	);

E_M E_M(
    .clk(clk),
    .reset(reset),
    .E_M_RegWE(E_M_RegWE),
    .E_M_clear(E_M_clear),

    .E_RD2(E_RD2_FW),//M_Write_Data
    .E_PC(E_PC),
    .E_Mem_Write(E_Mem_Write),//DM
    .E_ALU_Result(E_ALUResult_Ch),
    .E_Reg_Write(E_Reg_Write),//GRF
    .E_Mem_To_Reg(E_Mem_To_Reg),//Choose
    .E_Jal_Sel(E_Jal_Sel),
    .E_A3(E_A3),//Forwarding
    .E_A2(E_A2),
	.E_Tnew(E_Tnew),//Delay
    .E_A2use(E_A2use),

    .M_RD2(M_RD2),//M_Write_Data
    .M_PC(M_PC),
    .M_Mem_Write(M_Mem_Write),//DM
    .M_ALU_Result(M_ALU_Result),
    .M_Reg_Write(M_Reg_Write),//GRF
    .M_Mem_To_Reg(M_Mem_To_Reg),//Choose
    .M_Jal_Sel(M_Jal_Sel),
    .M_A3(M_A3),//Forwarding
    .M_A2(M_A2),
	.M_Tnew(M_Tnew),//Delay
    .M_A2use(M_A2use)
); 
/********************  Stage_M  ********************/
M_DM M_DM(
    .clk(clk),
    .reset(reset),
    .Mem_Write(M_Mem_Write),
    .PC(M_PC),
    .ALU_Result(M_ALU_Result),
    .Write_Data(M_WriteData_FW),
	 
    .Read_Data(M_Read_Data)
);

M_W M_W(
    .clk(clk),
    .reset(reset),
    .M_W_RegWE(M_W_RegWE),
    .M_W_clear(M_W_clear),

    .M_A3(M_A3),
    .M_PC(M_PC),
    .M_Reg_Data(M_RegData_Ch),
    .M_Reg_Write(M_Reg_Write),

    .W_A3(W_A3),
    .W_PC(W_PC),
    .W_Reg_Data(W_RegData),
    .W_Reg_Write(W_Reg_Write)
);
/********************  Stage_W  ********************/



/********************  Else  ********************/
Choose Choose(
	.D_A2_in(D_A2),
	.D_A3_in(D_A3),
	.E_PC(E_PC),
    .E_ALUResult_in(E_ALU_Result),
    .E_RD2_in(E_RD2_FW),
	.E_SignImm(E_SignImm),
	.M_ReadData(M_Read_Data),
	.M_ALUResult(M_ALU_Result),

	.D_Reg_Dst(D_Reg_Dst),
	.D_Jal_Sel(D_Jal_Sel),
    .E_Jal_Sel(E_Jal_Sel),
	.E_ALU_Sel(E_ALU_Sel),
    .M_Mem_To_Reg(M_Mem_To_Reg),

	.D_A3_out(D_A3_Ch),
	.E_ALUResult_out(E_ALUResult_Ch),
    .E_RD2_out(E_RD2_Ch),
	.M_RegData(M_RegData_Ch)
    );

//
Forwarding Forwarding(
	.D_A1(D_A1),
	.D_A2(D_A2),
	.E_A1(E_A1),
	.E_A2(E_A2),
	.M_A2(M_A2),
    .D_A1use(D_A1use),
    .D_A2use(D_A2use),
    .E_A1use(E_A1use),
    .E_A2use(E_A2use),
    .M_A2use(M_A2use),
    
	.W_A3(W_A3),
    .M_A3(M_A3),
    .W_RegWrite(W_Reg_Write),
	.M_RegWrite(M_Reg_Write),
	
	.D_RD1(D_RD1),
	.D_RD2(D_RD2),
	.E_RD1(E_RD1),
	.E_RD2(E_RD2),
	.M_WriteData(M_RD2),
    
	.M_ALU_Result(M_ALU_Result),//M_A3
	.W_RegData(W_RegData),//W_A3
	
	.D_RD1_FW(D_RD1_FW),//FW=Forwarding
	.D_RD2_FW(D_RD2_FW),
	.E_RD1_FW(E_RD1_FW),
	.E_RD2_FW(E_RD2_FW),
	.M_WriteData_FW(M_WriteData_FW)
    ); 	

//
Delay Delay(
	.D_rs_Tuse(D_rs_Tuse),
	.D_rt_Tuse(D_rt_Tuse),
	
	.D_Tnew(D_Tnew),
	.E_Tnew(E_Tnew),
	.M_Tnew(M_Tnew),
	
	.D_A1(D_A1),
	.D_A2(D_A2),
	.E_A3(E_A3),//
	.M_A3(M_A3),//
	
    .E_RegWrite(E_Reg_Write),
	.M_RegWrite(M_Reg_Write),

	.Stall(Stall),
    .F_D_RegWE(F_D_RegWE),
    .F_D_clear(F_D_clear),
    .D_E_RegWE(D_E_RegWE),
    .D_E_clear(D_E_clear),
    .E_M_RegWE(E_M_RegWE),
    .E_M_clear(E_M_clear),
    .M_W_RegWE(M_W_RegWE),
    .M_W_clear(M_W_clear),
    .PC_RegWE(PC_RegWE)
    );   

endmodule
