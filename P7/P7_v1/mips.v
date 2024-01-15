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
module mips(
    input clk,                    // 时钟信号
    input reset,                  // 同步复位信号
    input interrupt,              //// 外部中断信号
    output [31:0] macroscopic_pc, //// 宏观 PC

    output [31:0] i_inst_addr,    // IM 读取地址（取指 PC）
    input  [31:0] i_inst_rdata,   // IM 读取数据

    output [31:0] m_data_addr,    // DM 读写地址
    input  [31:0] m_data_rdata,   // DM 读取数据
    output [31:0] m_data_wdata,   // DM 待写入数据
    output [3 :0] m_data_byteen,  // DM 字节使能信号

    output [31:0] m_int_addr,     //// 中断发生器待写入地址
    output [3 :0] m_int_byteen,   //// 中断发生器字节使能信号

    output [31:0] m_inst_addr,    // M 级 PC

    output w_grf_we,              // GRF 写使能信号
    output [4 :0] w_grf_addr,     // GRF 待写入寄存器编号
    output [31:0] w_grf_wdata,    // GRF 待写入数据

    output [31:0] w_inst_addr     // W 级 PC
);

	wire [5:0] HWInt;

	wire [31:0] m_data_addr_in;
    wire [31:0] m_data_wdata_in;
    wire [3 :0] m_data_byteen_in;
    wire [31:0] m_inst_addr_in;
	wire [31:0] m_data_rdata_out;
	
	wire [31:0] Timer0_Addr,Timer1_Addr;
	wire Timer0_WE,Timer1_WE;
	wire [31:0] Timer0_Din,Timer1_Din;
	wire [31:0] Timer0_Dout,Timer1_Dout;
	wire Timer0_IRQ,Timer1_IRQ;
	
    wire [31:0] m_int_addr_tmp;     //// 中断发生器待写入地址
    wire [3 :0] m_int_byteen_tmp;   //// 中断发生器字节使能信号	
	
	//assign m_int_addr = (interrupt == 1)? 32'h7f20 : m_int_addr_tmp;
	//assign m_int_byteen = (interrupt == 1)? 4'b1 : m_int_byteen_tmp;
	
	assign m_int_addr =  m_int_addr_tmp;
	assign m_int_byteen =  m_int_byteen_tmp;

cpu cpu(
    .clk(clk),
    .reset(reset),
	//
	.HWInt(HWInt),
	.macroscopic_pc(macroscopic_pc), //// 宏观 PC(M_PC)
	//
	.i_inst_addr(i_inst_addr),
	.i_inst_rdata(i_inst_rdata),

	.m_data_addr(m_data_addr_in),
	.m_data_rdata(m_data_rdata_out),
	.m_data_wdata(m_data_wdata_in),
	.m_data_byteen(m_data_byteen_in),
	.m_inst_addr(m_inst_addr_in),
	.w_grf_we(w_grf_we),
	.w_grf_addr(w_grf_addr),
	.w_grf_wdata(w_grf_wdata),
	.w_inst_addr(w_inst_addr)
);

TC Timer0(
    .clk(clk),
    .reset(reset),
    .Addr(Timer0_Addr[31:2]),
    .WE(Timer0_WE),
    .Din(Timer0_Din),
    .Dout(Timer0_Dout),
    .IRQ(Timer0_IRQ)
);

TC Timer1(
    .clk(clk),
    .reset(reset),
    .Addr(Timer1_Addr[31:2]),//this line?wrong?
    .WE(Timer1_WE),
    .Din(Timer1_Din),
    .Dout(Timer1_Dout),
    .IRQ(Timer1_IRQ)
);

Bridge Bridge(
	.HWInt(HWInt),
	.interrupt(interrupt),
    .m_int_addr(m_int_addr_tmp),
	.m_int_byteen(m_int_byteen_tmp),

	.m_data_rdata(m_data_rdata),
	.m_data_rdata_out(m_data_rdata_out),
	.m_data_addr_in(m_data_addr_in),
	.m_data_wdata_in(m_data_wdata_in),
	.m_data_byteen_in(m_data_byteen_in),
	.m_inst_addr_in(m_inst_addr_in),
	.m_data_addr(m_data_addr),
	.m_data_wdata(m_data_wdata),
	.m_data_byteen(m_data_byteen),
	.m_inst_addr(m_inst_addr),
	
    .Timer0_Addr(Timer0_Addr),
	.Timer0_WE(Timer0_WE),
    .Timer0_Din(Timer0_Din),
    .Timer0_Dout(Timer0_Dout),
    .Timer0_IRQ(Timer0_IRQ),

	.Timer1_Addr(Timer1_Addr),
    .Timer1_WE(Timer1_WE),
    .Timer1_Din(Timer1_Din),
    .Timer1_Dout(Timer1_Dout),
    .Timer1_IRQ(Timer1_IRQ)
);

endmodule
