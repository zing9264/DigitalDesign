`timescale 1ns / 1ps

module fadd_norm (rm,is_nan,is_inf,inf_nan_frac,sign,temp_exp,cal_frac,s);
	input [14:0] cal_frac;
	input [9:0] inf_nan_frac;
	input [4:0] temp_exp;
	input [1:0] rm;
	input is_nan,is_inf;
	input sign;
	output [15:0] s;
	wire [15:0] f3,f2,f1,f0;
	//從左邊找到第一個1
	wire [3:0] zeros;

	assign zeros[3] = ~|cal_frac[13:6]; // 8-bit 0
	assign f3 = zeros[3]?  {cal_frac[5:0],8'b0} : cal_frac[13:0];
	assign zeros[2] = ~|f3[13:10]; // 4-bit 0
	assign f2 = zeros[2]? {f3[9:0], 4'b0} : f3;
	assign zeros[1] = ~|f2[13:12]; // 2-bit 0
	assign f1 = zeros[1]? {f2[11:0], 2'b0} : f2;
	assign zeros[0] = ~f1[13]; // 1-bit 0
	assign f0 = zeros[0]? {f1[12:0], 1'b0} : f1;
	reg [13:0] frac0;
	reg [4:0] exp0;
	//位移以及修改exponent
	always @ * begin
		if (cal_frac[14]) begin
			frac0 = cal_frac[14:1]; // 1x.xxxxxxxxxxxxxxxxxxxxxxx xxx
			exp0 = temp_exp + 8'h1; // 1.xxxxxxxxxxxxxxxxxxxxxxx xxx
		end 
		else begin
			if ((temp_exp > zeros) && (f0[13])) begin // a normalized number
				exp0 = temp_exp - zeros;
				frac0 = f0; // 01.xxxxxxxxxxxxxxxxxxxxxxx xxx
			end
			else begin // is a denormalized number or 0
				exp0 = 0;
				if (temp_exp != 0) // (e - 127) = ((e - 1) - 126)
					frac0 = cal_frac[13:0] << (temp_exp - 8'h1);
				else frac0 = cal_frac[13:0];
			end
		end
	end
	//依照選取的模式執行round
	wire frac_plus_1 = // for rounding
	~rm[1] & ~rm[0] & frac0[2] & (frac0[1] | frac0[0]) |
	~rm[1] & ~rm[0] & frac0[2] & ~frac0[1] & ~frac0[0] & frac0[3] |
	~rm[1] & rm[0] & (frac0[2] | frac0[1] | frac0[0]) & sign |
	rm[1] & ~rm[0] & (frac0[2] | frac0[1] | frac0[0]) & ~sign;
	wire [11:0] frac_round = {1'b0,frac0[13:3]} + frac_plus_1;
	wire [4:0] exponent = frac_round[11]? exp0 + 5'h1 : exp0;
	wire overflow = &exp0 | &exponent;
	assign s = final_result(overflow, rm, sign, is_nan, is_inf, exponent, frac_round[9:0], inf_nan_frac);
	//處理例外狀況
	function [15:0] final_result;
		input overflow;
		input [1:0] rm;
		input sign, is_nan, is_inf;
		input [4:0] exponent;
		input [9:0] fraction, inf_nan_frac;
		casex ({overflow, rm, sign, is_nan, is_inf})
			6'b1_00_x_0_x : final_result = {sign,5'h1f,10'h0}; // inf
			6'b1_01_0_0_x : final_result = {sign,5'h1e,10'h3ff}; // max
			6'b1_01_1_0_x : final_result = {sign,5'h1f,10'h000}; // inf
			6'b1_10_0_0_x : final_result = {sign,5'h1f,10'h000}; // inf
			6'b1_10_1_0_x : final_result = {sign,5'h1e,10'h3ff}; // max
			6'b1_11_x_0_x : final_result = {sign,5'h1e,10'h3ff}; // max
			6'b0_xx_x_0_0 : final_result = {sign,exponent,fraction}; // nor
			6'bx_xx_x_1_x : final_result = {1'b1,5'h1f,inf_nan_frac}; // nan
			6'bx_xx_x_0_1 : final_result = {sign,5'h1f,inf_nan_frac}; // inf
			default : final_result = {sign,5'h00,10'h000}; // 0
		endcase
	endfunction
endmodule
