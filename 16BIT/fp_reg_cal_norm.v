`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:26:12 03/24/2017 
// Design Name: 
// Module Name:    float_adder 
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
module reg_cal_norm (c_rm,c_is_nan,c_is_inf,c_inf_nan_frac,c_sign,c_exp,
c_frac,clk,clrn,e,n_rm,n_is_nan,n_is_inf,
n_inf_nan_frac,n_sign,n_exp,n_frac); // pipeline regs
	input [14:0] c_frac;
	input [9:0] c_inf_nan_frac;
	input [4:0] c_exp;
	input [1:0] c_rm;
	input c_is_nan, c_is_inf, c_sign;
	input e; // e: enable
	input clk, clrn; // clock and reset
	output reg [14:0] n_frac;
	output reg [9:0] n_inf_nan_frac;
	output reg [4:0] n_exp;
	output reg [1:0] n_rm;
	output reg n_is_nan,n_is_inf,n_sign;
	always @ (posedge clk or negedge clrn) begin
		if (!clrn) begin
			n_rm <= 0;
			n_is_nan <= 0;
			n_is_inf <= 0;
			n_inf_nan_frac <= 0;
			n_sign <= 0;
			n_exp <= 0;
			n_frac <= 0;
		end else if (e) begin
			n_rm <= c_rm;
			n_is_nan <= c_is_nan;
			n_is_inf <= c_is_inf;
			n_inf_nan_frac <= c_inf_nan_frac;
			n_sign <= c_sign;
			n_exp <= c_exp;
			n_frac <= c_frac;
		end
	end
endmodule
