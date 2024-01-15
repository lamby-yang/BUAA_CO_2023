`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:53:25 12/09/2023 
// Design Name: 
// Module Name:    Bridge 
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
module Bridge(
    input interrupt,              //// 外部中断信号
	output [5:0] HWInt,
    output [31:0] m_int_addr,     //// 中断发生器待写入地址
    output [3 :0] m_int_byteen,   //// 中断发生器字节使能信号
    //cpu
    input [31:0] m_data_rdata,//in
	input [31:0] m_data_addr_in,
    input [31:0] m_data_wdata_in,
    input [3 :0] m_data_byteen_in,
    input [31:0] m_inst_addr_in,
	
	output [31:0] m_data_rdata_out,
    output [31:0] m_data_addr,//out
    output [31:0] m_data_wdata,
    output [3 :0] m_data_byteen,
    output [31:0] m_inst_addr,
	//timer0
    output [31:0] Timer0_Addr,
    output Timer0_WE,
    output [31:0] Timer0_Din,
    input [31:0] Timer0_Dout,
    input Timer0_IRQ,
	//timer1
	output [31:0] Timer1_Addr,
    output Timer1_WE,
    output [31:0] Timer1_Din,
    input [31:0] Timer1_Dout,
    input Timer1_IRQ
);
	wire Timer0_sel = (m_data_addr_in >= 32'h7f00) && (m_data_addr_in <= 32'h7f0b);
	wire Timer1_sel = (m_data_addr_in >= 32'h7f10) && (m_data_addr_in <= 32'h7f1b);
	wire Int_sel = 	  (m_data_addr_in >= 32'h7f20) && (m_data_addr_in <= 32'h7f23) && (|m_data_byteen_in);

	assign HWInt = {3'b0, interrupt, Timer1_IRQ, Timer0_IRQ};
	assign m_int_addr = (Int_sel == 1) ? m_data_addr_in : 32'b0;
	assign m_int_byteen = (Int_sel == 1) ? m_data_byteen_in : 1'b0;
	
	assign m_data_rdata_out = 	(Timer0_sel) ? Timer0_Dout :
								(Timer1_sel) ? Timer1_Dout : m_data_rdata;
	assign m_data_addr = m_data_addr_in;
	assign m_data_wdata = m_data_wdata_in;
    assign m_data_byteen = (Timer0_sel | Timer1_sel) ? 4'b0 : m_data_byteen_in;
    assign m_inst_addr = m_inst_addr_in;
	
	assign Timer0_Addr = m_data_addr_in;
    assign Timer0_WE = (Timer0_sel) && (&m_data_byteen_in) ;
    assign Timer0_Din = m_data_wdata;
	
	assign Timer1_Addr = m_data_addr_in;
	assign Timer1_WE = (Timer1_sel) && (&m_data_byteen_in) ;
	assign Timer1_Din = m_data_wdata;
endmodule
