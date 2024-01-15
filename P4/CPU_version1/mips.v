`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:56:13 11/03/2023 
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
module mips (
    input clk,
    input reset
);
  //IFU
  wire [31:0] Npc;
  wire [31:0] PC;
  wire [31:0] Instr;

  //Splitter
  wire [4:0] A1;
  wire [4:0] A2;
  wire [4:0] A3;
  wire [15:0] Offset;
  wire [4:0] Shamt;
  wire [5:0] Op;
  wire [5:0] Funct;
  wire [25:0] Instr_Index;

  //GRF
  wire [4:0] RegAddr;
  wire [31:0] WD3;
  wire WE;
  wire [31:0] RD1;
  wire [31:0] RD2;

  //Controller
  wire ALU_Sel;
  wire Mem_To_Reg;
  wire Mem_Write;
  wire Reg_Dst;
  wire Branch;
  wire Ext_Op;
  wire Jal_Sel;
  wire Jr_Sel;
  wire [3:0] ALU_Ctr;

  //EXT
  wire [31:0] SignImm;

  //ALU
  wire [31:0] ALU_Result;
  wire [31:0] SrcB;
  wire Zero;

  //DM
  wire [31:0] Read_Data;

  ifu IFU (
      .clk  (clk),
      .reset(reset),
      .Npc  (Npc),

      .PC(PC),
      .Instr(Instr)
  );
  npc NPC (
      .Zero(Zero),
      .Branch(Branch),
      .Jr_Sel(Jr_Sel),
      .Jal_Sel(Jal_Sel),
      .SignImm(SignImm),
      .RD1(RD1),
      .Instr_Index(Instr_Index),
      .PC(PC),

      .Npc(Npc)
  );
  splitter Splitter (
      .Instr(Instr),

      .A1(A1),
      .A2(A2),
      .A3(A3),
      .Offset(Offset),
      .Shamt(Shamt),
      .Op(Op),
      .Funct(Funct),
      .Instr_Index(Instr_Index)
  );
  ext EXT (
      .Offset (Offset),
      .Ext_Op (Ext_Op),
      .SignImm(SignImm)
  );
  controller Controller (
      .Op(Op),
      .Funct(Funct),

      .ALU_Sel(ALU_Sel),
      .Mem_To_Reg(Mem_To_Reg),
      .Mem_Write(Mem_Write),
      .Reg_Dst(Reg_Dst),
      .Reg_Write(WE),
      .Branch(Branch),
      .Ext_Op(Ext_Op),
      .Jal_Sel(Jal_Sel),
      .Jr_Sel(Jr_Sel),
      .ALU_Ctr(ALU_Ctr)
  );
  srcb_sel SrcB_Sel (
      .RD2(RD2),
      .SignImm(SignImm),
      .ALU_Sel(ALU_Sel),

      .SrcB(SrcB)
  );
  wd3_sel WD3_Sel (
      .Mem_Addr(ALU_Result),
      .Read_Data(Read_Data),
      .PC(PC),
      .Jal_Sel(Jal_Sel),
      .Mem_To_Reg(Mem_To_Reg),

      .Reg_Data(WD3)
  );
  a3_sel A3_Sel (
      .A2(A2),
      .A3(A3),
      .Reg_Dst(Reg_Dst),
      .Jal_Sel(Jal_Sel),

      .Reg_Addr(RegAddr)
  );
  alu ALU (
      .SrcA(RD1),
      .SrcB(SrcB),
      .Shamt(Shamt),
      .ALU_Ctr(ALU_Ctr),

      .Zero(Zero),
      .ALU_Result(ALU_Result)
  );
  grf GRF (
      .A1(A1),
      .A2(A2),
      .A3(RegAddr),
      .WD3(WD3),
      .clk(clk),
      .reset(reset),
      .WE(WE),
      .PC(PC),

      .RD1(RD1),
      .RD2(RD2)
  );
  
  dm DM (
      .clk(clk),
      .reset(reset),
      .Mem_Write(Mem_Write),
      .PC(PC),
      .ALU_Result(ALU_Result),
      .Write_Data(RD2),

      .Read_Data(Read_Data)
  );
  

endmodule

