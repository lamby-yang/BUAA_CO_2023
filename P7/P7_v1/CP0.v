`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:01:41 12/04/2023 
// Design Name: 
// Module Name:    CP0 
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

module CP0(
	input clk,
    input reset,
    input en,				//写使能信号。
    input [4:0] CP0Add,		//寄存器地址。
    input [31:0] CP0In,		//CP0 写入数据
    output [31:0] CP0Out,	//CP0 读出数据。
	
    input [31:0] VPC,		//受害 PC。
    input BDIn,				//是否是延迟槽指令。
    input [4:0] ExcCodeIn,	//记录异常类型。
    input [5:0] HWInt,		//输入中断信号。
    input EXLClr,			//用来复位 EXL。
    output [31:0] EPCOut,	//EPC 的值。
    output Req				//进入处理程序请求。
    );
 //SR=12
 //Cause=13
 //EPC=14
`define IM SR[15:10]
`define EXL SR[1]
`define IE SR[0]
`define BD Cause[31]
`define IP Cause[15:10]
`define ExcCode Cause[6:2]

	reg [31:0] SR;
	reg [31:0] Cause;
	reg [31:0] EPC;
	reg [31:0] PRId;
	
	wire IntReq = (|(HWInt & `IM)) & !`EXL & `IE; // 允许当前中断 且 不在中断异常中 且 允许中断发生
	wire ExcReq = (|ExcCodeIn) & !`EXL; // 存在异常，不在中断中
	assign Req  = (IntReq) | (ExcReq) ;
	
	always @ (posedge clk)begin
		if(reset)begin
			SR <= 0;
			Cause <= 0;
			EPC <= 0;
			PRId <= 0;
		end
		
		else begin
			`IP <= HWInt;
			if(EXLClr == 1'b1)begin
				`EXL <= 1'b0;
			end
			if(en == 1'b1)begin
				if (CP0Add == 5'd12) SR <= CP0In;
				if (CP0Add == 5'd14) EPC <= CP0In;
			end
			if(Req == 1'b1)begin
				`EXL <= 1'b1;
				EPC <= EPC_tmp;
				`BD <= BDIn;
				`ExcCode <= (IntReq == 1'b1) ? 5'b0 : ExcCodeIn;
			end
		end
	end
	wire [31:0] EPC_tmp = (Req == 1) ? ((BDIn == 1'b1) ? (VPC - 32'd4) : VPC) : EPC;
	assign EPCOut = EPC_tmp;
	assign CP0Out = (CP0Add == 12) ? SR : 
					(CP0Add == 13) ? Cause : 
					(CP0Add == 14) ? EPC : 
					(CP0Add == 15) ? PRId : 0;
endmodule
