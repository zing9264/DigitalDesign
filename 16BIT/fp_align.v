`timescale 1ns / 1ps

module fadd_align (a,b,sub,s_is_nan,s_is_inf,inf_nan_frac,sign,temp_exp,op_sub,large_frac11,small_frac14); //alignment stage
	input [15:0] a,b;
	input sub;
	output [13:0] small_frac14;
	output [10:0] large_frac11;
	output [9:0] inf_nan_frac;
	output [4:0] temp_exp;
	output s_is_nan;
	output s_is_inf;
	output sign;
	output op_sub;
	//不看sign bit,判斷a or b大
	wire exchange = (b[14:0] > a[14:0]);
	wire [15:0] fp_large = exchange? b : a;
	wire [15:0] fp_small = exchange? a : b;
	//轉成1.f格式
	wire fp_large_hidden_bit = |fp_large[14:10];
	wire fp_small_hidden_bit = |fp_small[14:10];
	wire [10:0] large_frac11 = {fp_large_hidden_bit,fp_large[9:0]};
	wire [10:0] small_frac11 = {fp_small_hidden_bit,fp_small[9:0]};
	//儲存較大數的exponent
	assign temp_exp = fp_large[14:10];
	//判斷正負
	assign sign = exchange? sub^b[15] : a[15];
	//使用sub or add
	assign op_sub = sub ^ fp_large[15] ^ fp_small[15];
	//例外狀況
	wire fp_large_expo_is_ff = &fp_large[14:10]; // exp == 0xff
	wire fp_small_expo_is_ff = &fp_small[14:10];
	wire fp_large_frac_is_00 = ~|fp_large[9:0]; // frac == 0x0
	wire fp_small_frac_is_00 = ~|fp_small[9:0];
	wire fp_large_is_inf=fp_large_expo_is_ff & fp_large_frac_is_00;
	wire fp_small_is_inf=fp_small_expo_is_ff & fp_small_frac_is_00;
	wire fp_large_is_nan=fp_large_expo_is_ff & ~fp_large_frac_is_00;
	wire fp_small_is_nan=fp_small_expo_is_ff & ~fp_small_frac_is_00;
	assign s_is_inf = fp_large_is_inf | fp_small_is_inf;
	wire s_is_nan = fp_large_is_nan | fp_small_is_nan | ((sub ^ fp_small[15] ^ fp_large[15]) & fp_large_is_inf & fp_small_is_inf);
	wire [9:0] nan_frac = (a[8:0] > b[8:0])?	{1'b1,a[8:0]} : {1'b1,b[8:0]};
	assign inf_nan_frac = s_is_nan? nan_frac : 10'h0;
	//ea-eb
	wire [4:0] exp_diff = fp_large[14:10] - fp_small[14:10];
	wire small_den_only = (fp_large[14:10] != 0) & (fp_small[14:10] == 0);
	//計算需要位移幾位,並且位移
	wire [4:0] shift_amount = small_den_only? exp_diff - 5'h1 : exp_diff;
	wire [23:0] small_frac24 = (shift_amount >= 13)? {13'h0,small_frac11} : {small_frac11,13'h0} >> shift_amount;
	//留下24bit以及保護.循環位,計算多出來的位數,使用reduction OR簡化成1bit
	assign small_frac14 = {small_frac24[23:11],|small_frac24[10:0]};
endmodule
