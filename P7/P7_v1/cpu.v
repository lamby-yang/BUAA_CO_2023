`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:02:46 11/24/2023 
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
module cpu(
    input clk,
    input reset,
	//
	input [5:0] HWInt,
	input [31:0] macroscopic_pc, //// 宏观 PC(M_PC)
	//
    input [31:0] i_inst_rdata,
    input [31:0] m_data_rdata,
    output [31:0] i_inst_addr,
    output [31:0] m_data_addr,
    output [31:0] m_data_wdata,
    output [3 :0] m_data_byteen,                                                       
    output [31:0] m_inst_addr,
    output w_grf_we,
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr
); 
	/*always@(*)begin
		if((w_inst_addr==32'h301c)&&(w_grf_addr==10)&&(w_grf_wdata==32'h7fff0000))begin
			$display("%d@%h: $%d <= %h", $time, W_PC, w_grf_addr,W_Instr);
		
		end
	end*/
	assign w_grf_we = W_Reg_Write;
    //assign w_grf_addr = ((w_inst_addr==32'h301c)&&(w_grf_addr==10)&&(w_grf_wdata==32'h7fff0000))		?	0:W_A3;
	assign w_grf_addr = W_A3;
	assign w_grf_wdata = W_RegData;
    assign w_inst_addr = W_PC;
	
	
/******************************************** Declarations ********************************************/
//NEW
	wire D_Is_New;
	wire E_Is_New;
	wire M_Is_New;
	wire W_Is_New;
	wire D_Condition;
	wire E_Condition;
	wire M_Condition;
/*******************************F*******************************/
//IFU
    wire [31:0] Npc;//
    wire [31:0] F_PC;
	wire [31:0] F_PC_tmp;
    wire [31:0] F_Instr;

/*******************************D*******************************/
//F_D
    wire [31:0] D_PC;
    wire [31:0] D_Instr;

//Controller	
	wire D_ALU_Sel;
    wire D_Mem_To_Reg;
    wire D_Mem_Write;
    wire [1:0] D_width;
    wire D_Reg_Write;
    wire [1:0] D_Branch;
    wire D_Ext_Op;
	wire D_Jump_addr;
    wire D_Jump_reg;
	wire D_Jump_link;
    wire [3:0] D_ALU_Ctr;
	wire [3:0] D_MDU_Ctr;
	wire D_start;
    //Splitter	    
	wire [4:0] D_A1;///
    wire [4:0] D_A2;//
    wire [4:0] D_A3,D_rd;//
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

/*******************************E*******************************/
//D_E
    wire [31:0] E_PC;//M_DM
    wire E_Mem_Write;
    wire E_Reg_Write;//W_GRF_Write
	
    wire [1:0] E_width;
	
    wire [31:0] E_SignImm;//Choose
    wire E_Mem_To_Reg;
    wire E_Jump_link;
    wire E_ALU_Sel;
	wire [3:0] E_MDU_Ctr;//
	wire E_start;//
    wire [3:0] E_Tnew;//Delay
    wire [4:0] E_A3,E_rd;
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

//E_MDU
	wire [31:0] E_HI;
	wire [31:0] E_LO;
	wire E_Busy;
/*******************************M*******************************/
//E_M
    wire [31:0] M_PC;
    wire M_Reg_Write;//GRF

    wire [1:0] M_width;
	
    wire M_Mem_To_Reg;//Choose
    wire M_Jump_link;

    wire [4:0] M_A3,M_rd;//Forwarding
    wire [4:0] M_A2;
	wire [4:0] M_A1;
    wire [31:0] M_RD2;
    wire M_A2use;
	wire [3:0] M_Tnew;//Delay

//DM
    wire M_Mem_Write;
    wire [31:0] M_ALU_Result;
	 
    wire [31:0] M_Read_Data;
	wire [3:0] m_data_byteen_tmp;
	
//Exc
	wire [31:0] E_Instr,M_Instr,W_Instr;
	wire D_Syscall;
	wire D_RI;
	wire E_Overflow;
	wire M_Overflow;
	wire D_Ov_sel,E_Ov_sel,M_Ov_sel;

	//wire [31:0] M_MemAddr;
	wire [4:0] D_ExcCode_tmp;
	wire [4:0] E_ExcCode_tmp;
	wire [4:0] M_ExcCode_tmp;
	wire [4:0] F_ExcCode;
	wire [4:0] D_ExcCode;
	wire [4:0] E_ExcCode;
	wire [4:0] M_ExcCode;

//CP0
	wire D_CP0_WE;
	wire E_CP0_WE;
	wire M_CP0_WE;

    wire [31:0] M_CP0Out;
	wire [31:0] W_CP0Out;

    wire F_BD,D_BD;
	wire E_BD,M_BD;

	wire D_eret,E_eret,M_eret;
	wire D_mtc0,E_mtc0,M_mtc0;
	wire D_mfc0,E_mfc0,M_mfc0;

    wire [31:0] EPC;
    wire Req;

/*******************************W*******************************/
//M_W
    wire W_Mem_To_Reg;//Choose
    wire W_Jump_link;
    wire [31:0] W_ALU_Result;
    wire [31:0] W_RegData;
    wire [1:0] W_width;
	wire [3:0] W_Tnew;
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
    wire [31:0] E_RD2_Ch;//Ch,Choose_output
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
	.Req(Req),
	
    .F_PC(F_PC_tmp)
    );
    //assign F_Instr = i_inst_rdata;
	assign F_PC = D_eret ? EPC : F_PC_tmp;
	assign i_inst_addr = F_PC;
	
	assign F_Pc_Error = ((F_PC > 32'h6ffc)||(F_PC < 32'h3000)||(F_PC[1:0]!=0))&& !D_eret;
	assign F_ExcCode = F_Pc_Error ? 5'd4 : 5'd0;
	assign F_Instr 	= F_Pc_Error ? 0 : i_inst_rdata;
	
F_D F_D(
    .clk(clk),
    .reset(reset),
    .F_D_RegWE(F_D_RegWE),
    .F_D_clear(F_D_clear),
    .Req(Req),
	
    .F_PC(F_PC),
    .F_Instr(F_Instr),
	.F_ExcCode(F_ExcCode),
	.F_BD(F_BD),
	
	.D_BD(D_BD),
	.D_ExcCode(D_ExcCode_tmp),
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
    .D_width(D_width),
    .D_Reg_Write(D_Reg_Write),
    .D_Branch(D_Branch),
    .D_Ext_Op(D_Ext_Op),
    .D_Jump_addr(D_Jump_addr),
    .D_Jump_reg(D_Jump_reg),
	.D_Jump_link(D_Jump_link),
    .D_ALU_Ctr(D_ALU_Ctr),
	.D_MDU_Ctr(D_MDU_Ctr),
	.D_start(D_start),
	
	.D_RI(D_RI),
	.D_Syscall(D_Syscall),
	.D_eret(D_eret),
	.D_mfc0(D_mfc0),
	.D_mtc0(D_mtc0),
	.D_CP0_WE(D_CP0_WE),
	.BD(F_BD),
	.D_Ov_sel(D_Ov_sel),

	.D_Is_New(D_Is_New),
//Splitter	    
	.D_A1(D_A1),
    .D_A2(D_A2),
    .D_A3(D_A3),
	.D_rd(D_rd),//
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
	.D_Is_New(D_Is_New),
    .SignImm(D_SignImm)
    );
	
//	
D_CMP D_CMP(
    .RD1(D_RD1_FW),
	.RD2(D_RD2_FW),
	.D_Branch(D_Branch),
	.D_Is_New(D_Is_New),

	.D_Condition(D_Condition),	
	.B_jump(D_b_jump)
    );

//
D_NPC D_NPC(
    .B_jump(D_b_jump),
    .D_Jump_addr(D_Jump_addr),
    .D_Jump_reg(D_Jump_reg),
	.SignImm(D_SignImm),
    .RD1(D_RD1_FW),
	.RD2(D_RD2_FW),
	.Instr_Index(D_Instr_Index),
    .F_PC(F_PC),
	.D_PC(D_PC),
	.D_Is_New(D_Is_New),
	.D_Condition(D_Condition),

	.D_eret(D_eret),
	.Req(Req),
	.EPC(EPC),

    .Npc(Npc)
	);

//D_E    
D_E D_E(
    .clk(clk),
    .reset(reset),
    .D_E_RegWE(D_E_RegWE),
    .D_E_clear(D_E_clear),
    .Req(Req),
	
    .D_Instr(D_Instr),
    .D_PC(D_PC),//M_DM
    .D_Mem_Write(D_Mem_Write),
    .D_Reg_Write(D_Reg_Write),//W_GRF_Write
    .D_SignImm(D_SignImm),//Choose
    .D_Mem_To_Reg(D_Mem_To_Reg),
    .D_Jump_link(D_Jump_link),
    .D_ALU_Sel(D_ALU_Sel),
    .D_Tnew(D_Tnew),//Delay
    .D_A3(D_A3),
    .D_A1(D_A1),//Forwarding
    .D_A2(D_A2),
    .D_RD1(D_RD1_FW),//ALU
    .D_RD2(D_RD2_FW),
    .D_Shamt(D_Shamt),
	.D_ALU_Ctr(D_ALU_Ctr),
	.D_MDU_Ctr(D_MDU_Ctr),
	.D_start(D_start),
    .D_A1use(D_A1use),
    .D_A2use(D_A2use),
    .D_width(D_width),
	.D_Is_New(D_Is_New),
	.D_Condition(D_Condition),
	.D_ExcCode(D_ExcCode),
	.D_CP0_WE(D_CP0_WE),
	.D_BD(D_BD),
	.D_eret(D_eret),
	.D_mtc0(D_mtc0),	
	.D_Ov_sel(D_Ov_sel),
	.D_rd(D_rd),//
	.D_mfc0(D_mfc0),
	
	.E_mfc0(E_mfc0),	
	.E_rd(E_rd),//	
	.E_Ov_sel(E_Ov_sel),
	.E_eret(E_eret),
	.E_mtc0(E_mtc0),
	.E_BD(E_BD),
	.E_CP0_WE(E_CP0_WE),
	.E_ExcCode(E_ExcCode_tmp),
	.E_Condition(E_Condition),
	.E_Is_New(E_Is_New),
    .E_Instr(E_Instr),	
    .E_PC(E_PC),//M_DM
    .E_Mem_Write(E_Mem_Write),
    .E_Reg_Write(E_Reg_Write),//W_GRF_Write
    .E_SignImm(E_SignImm),//Choose
    .E_Mem_To_Reg(E_Mem_To_Reg),
    .E_Jump_link(E_Jump_link),
    .E_ALU_Sel(E_ALU_Sel),
    .E_Tnew(E_Tnew),//Delay
    .E_A3(E_A3),
    .E_A1(E_A1),//Forwarding
    .E_A2(E_A2),
    .E_RD1(E_RD1),//ALU
    .E_RD2(E_RD2),
    .E_Shamt(E_Shamt),
	.E_ALU_Ctr(E_ALU_Ctr),
	.E_MDU_Ctr(E_MDU_Ctr),
	.E_start(E_start),
    .E_A1use(E_A1use),
    .E_A2use(E_A2use),
	.E_width(E_width)
);	
/********************  Stage_E  ********************/
E_ALU E_ALU(
    .SrcA(E_RD1_FW),
    .SrcB(E_RD2_Ch),
    .Shamt(E_Shamt),
	.ALU_Ctr(E_ALU_Ctr),
	.E_Is_New(E_Is_New),
	
	.E_Overflow(E_Overflow),
	.ALU_Result(E_ALU_Result)
	);

E_MDU E_MDU(
	.clk(clk),
	.reset(reset),
    .Req(Req),
	
	.A(E_RD1_FW),
	.B(E_RD2_Ch),
	.MDU_Ctr(E_MDU_Ctr),
	.start(E_start),
	.E_Is_New(E_Is_New),
	
	.HI(E_HI),
	.LO(E_LO),
	.Busy(E_Busy)
    );
	
E_M E_M(
    .clk(clk),
    .reset(reset),
    .E_M_RegWE(E_M_RegWE),
    .E_M_clear(E_M_clear),
    .Req(Req),
	
    .E_Instr(E_Instr),	
    .E_RD2(E_RD2_FW),//M_Write_Data
    .E_PC(E_PC),
    .E_Mem_Write(E_Mem_Write),//DM
    .E_ALU_Result(E_ALUResult_Ch),
    .E_Reg_Write(E_Reg_Write),//GRF
    .E_Mem_To_Reg(E_Mem_To_Reg),//Choose
    .E_Jump_link(E_Jump_link),
    .E_A3(E_A3),//Forwarding
    .E_A2(E_A2),
	.E_A1(E_A1),
	.E_Tnew(E_Tnew),//Delay
    .E_A2use(E_A2use),
    .E_width(E_width),
	.E_Is_New(E_Is_New),
	.E_Condition(E_Condition),
	.E_ExcCode(E_ExcCode),
	.E_Overflow(E_Overflow),
	.E_CP0_WE(E_CP0_WE),
	.E_BD(E_BD),
	.E_eret(E_eret),
	.E_mtc0(E_mtc0),
	.E_Ov_sel(E_Ov_sel),
	.E_rd(E_rd),//
	.E_mfc0(E_mfc0),
	
	.M_mfc0(M_mfc0),
	.M_rd(M_rd),//	
	.M_Ov_sel(M_Ov_sel),
	.M_eret(M_eret),
	.M_mtc0(M_mtc0),
	.M_BD(M_BD),
	.M_CP0_WE(M_CP0_WE),
	.M_Overflow(M_Overflow),	
	.M_ExcCode(M_ExcCode_tmp),
	.M_Condition(M_Condition),
	.M_Is_New(M_Is_New),
    .M_Instr(M_Instr),	
	.M_RD2(M_RD2),//M_Write_Data
    .M_PC(M_PC),
    .M_Mem_Write(M_Mem_Write),//DM
    .M_ALU_Result(M_ALU_Result),
    .M_Reg_Write(M_Reg_Write),//GRF
    .M_Mem_To_Reg(M_Mem_To_Reg),//Choose
    .M_Jump_link(M_Jump_link),
    .M_A3(M_A3),//Forwarding
    .M_A2(M_A2),
	.M_A1(M_A1),
	.M_Tnew(M_Tnew),//Delay
    .M_A2use(M_A2use),
	.M_width(M_width)
); 
/********************  Stage_M  ********************/
/*M_DM M_DM(
    .clk(clk),
    .reset(reset),
    .Mem_Write(M_Mem_Write),
    .PC(M_PC),
    .ALU_Result(M_ALU_Result),
    .Write_Data(M_WriteData_FW),
	 
    .Read_Data(M_Read_Data)
);*/

    assign m_data_addr = M_ALU_Result;                                                  
    assign m_inst_addr = M_PC;
	assign macroscopic_pc = M_PC;
	assign m_data_byteen = (Req == 1'b1) ? 4'b0 : m_data_byteen_tmp;
	 
M_BE M_BE(
	.M_width(M_width),
    .M_Mem_Write(M_Mem_Write),
    .Addr(M_ALU_Result),//ALU_Result
    .Write_Data(M_WriteData_FW),
	.m_data_rdata(m_data_rdata),
	.M_Is_New(M_Is_New),
	
	.M_Read_Data(M_Read_Data),
    .m_data_wdata(m_data_wdata),
    .m_data_byteen(m_data_byteen_tmp)
);

Exc Exc(
	.Instr(M_Instr),
	.D_Syscall(D_Syscall),
	.D_RI(D_RI),
	.E_Overflow(E_Overflow),
	.M_Overflow(M_Overflow),
	.E_Ov_sel(E_Ov_sel),
	.M_MemAddr(M_ALU_Result),
	
	.D_Is_New(D_Is_New),
	.E_Is_New(E_Is_New),
	.M_Is_New(M_Is_New),
	
	.D_ExcCode_tmp(D_ExcCode_tmp),
	.E_ExcCode_tmp(E_ExcCode_tmp),
	.M_ExcCode_tmp(M_ExcCode_tmp),
	.D_ExcCode(D_ExcCode),
	.E_ExcCode(E_ExcCode),
	.M_ExcCode(M_ExcCode)
    );
	
CP0 CP0(
	.clk(clk),
    .reset(reset),
    .en(M_CP0_WE),
    .CP0Add(M_Instr[15:11]),
	//.CP0Add(M_A3),
    .CP0In(M_WriteData_FW),
    .CP0Out(M_CP0Out),
	.VPC(M_PC),
    .BDIn(M_BD),
    .ExcCodeIn(M_ExcCode),
    .HWInt(HWInt),
    .EXLClr(M_eret),
    .EPCOut(EPC),
    .Req(Req)
    );

M_W M_W(
    .clk(clk),
    .reset(reset),
    .M_W_RegWE(M_W_RegWE),
    .M_W_clear(M_W_clear),
	.Req(Req),

    .M_Instr(M_Instr),		
    .M_A3(M_A3),
    .M_PC(M_PC),
    .M_Reg_Data(M_RegData_Ch),
    .M_Reg_Write(M_Reg_Write),
    .M_width(M_width),
	.M_Tnew(M_Tnew),
	.M_Is_New(M_Is_New),
//	.M_CP0Out(M_CP0Out),
//  .M_CP0_WE(M_CP0_WE),
	
//	.W_CP0_WE(W_CP0_WE),	
//	.W_CP0Out(W_CP0Out),
	.W_Is_New(W_Is_New),	
	.W_Tnew(W_Tnew),	
    .W_Instr(W_Instr),	
    .W_A3(W_A3),
    .W_PC(W_PC),
    .W_Reg_Data(W_RegData),
    .W_Reg_Write(W_Reg_Write),
    .W_width(W_width)
);
/********************  Stage_W  ********************/



/********************  Else  ********************/
Choose Choose(
    .E_RD2_in(E_RD2_FW),
	.E_SignImm(E_SignImm),
	.E_PC(E_PC),
    .E_ALUResult_in(E_ALU_Result),
	.E_HI(E_HI),
	.E_LO(E_LO),
	.M_ReadData(M_Read_Data),
	.M_ALUResult(M_ALU_Result),
	.M_CP0Out(M_CP0Out),
	
    .E_Jump_link(E_Jump_link),
	.E_MDU_Ctr(E_MDU_Ctr),
	.E_ALU_Sel(E_ALU_Sel),
    .M_Mem_To_Reg(M_Mem_To_Reg),
	.M_mfc0(M_mfc0),
	
	.D_Condition(D_Condition),
	.E_Condition(E_Condition),

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

	.M_Tnew(M_Tnew),
	.W_Tnew(W_Tnew),
	
	.D_RD1_FW(D_RD1_FW),//FW=Forwarding
	.D_RD2_FW(D_RD2_FW),
	.E_RD1_FW(E_RD1_FW),
	.E_RD2_FW(E_RD2_FW),
	.M_WriteData_FW(M_WriteData_FW)
    ); 	

//
Delay Delay(
	.E_Is_New(E_Is_New),
	.M_Is_New(M_Is_New),
	
	.D_rs_Tuse(D_rs_Tuse),
	.D_rt_Tuse(D_rt_Tuse),
	
	.D_Tnew(D_Tnew),
	.E_Tnew(E_Tnew),
	.M_Tnew(M_Tnew),
	
	.D_A1(D_A1),
	.D_A2(D_A2),
	.E_A3(E_A3),//
	.M_A3(M_A3),//
	.E_A1(E_A1),//
	.M_A1(M_A1),//
	.E_A2(E_A2),//
	.M_A2(M_A2),//
	.E_rd(E_rd),//
	.M_rd(M_rd),//
	
    .E_RegWrite(E_Reg_Write),
	.M_RegWrite(M_Reg_Write),
	
	.E_start(E_start),
	.E_Busy(E_Busy),
	.D_MDU_Ctr(D_MDU_Ctr),
	
	.D_eret(D_eret),
	.E_CP0_WE(E_CP0_WE),
	.M_CP0_WE(M_CP0_WE),
	
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
