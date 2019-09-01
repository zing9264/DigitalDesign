`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:16:19 04/07/2017 
// Design Name: 
// Module Name:    float_control_2 
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
module reg_align_cal (a_rm,a_is_nan,a_is_inf,a_inf_nan_frac,a_sign,a_exp,
a_op_sub,a_large_frac,a_small_frac,clk,clrn,e,c_rm,
c_is_nan,c_is_inf,c_inf_nan_frac,c_sign,c_exp,
c_op_sub,c_large_frac,c_small_frac); // pipeline regs
	input [13:0] a_small_frac;
	input [10:0] a_large_frac;
	input [9:0] a_inf_nan_frac;
	input [4:0] a_exp;
	input [1:0] a_rm;
	input a_is_nan, a_is_inf, a_sign, a_op_sub;
	input e; // e: enable
	input clk, clrn; // clock and reset
	output reg [13:0] c_small_frac;
	output reg [10:0] c_large_frac;
	output reg [9:0] c_inf_nan_frac;
	output reg [4:0] c_exp;
	output reg [1:0] c_rm;
	output reg c_is_nan,c_is_inf,c_sign,c_op_sub;
	always @ (posedge clk or negedge clrn) begin
		if (!clrn) begin
			c_rm <= 0;
			c_is_nan <= 0;
			c_is_inf <= 0;
			c_inf_nan_frac <= 0;
			c_sign <= 0;
			c_exp <= 0;
			c_op_sub <= 0;
			c_large_frac <= 0;
			c_small_frac <= 0;
		end else if (e) begin
			c_rm <= a_rm;
			c_is_nan <= a_is_nan;
			c_is_inf <= a_is_inf;
			c_inf_nan_frac <= a_inf_nan_frac;
			c_sign <= a_sign;
			c_exp <= a_exp;
			c_op_sub <= a_op_sub;
			c_large_frac <= a_large_frac;
			c_small_frac <= a_small_frac;
		end
	end
endmodule
