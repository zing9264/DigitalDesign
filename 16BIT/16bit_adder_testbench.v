`include "fp_16bit_adder.v"//
`timescale 1ns / 1ps

module test_bench;
reg clk; //clock
reg clrn; //負緣時清空
reg[15:0] a;
reg[15:0] b;
reg en;
wire [15:0] result;
pipelined_16bitfpadder test(a,b,1'b0,2'd0,result,clk,clrn,en);


initial #0 clk = 1'b1;
always #10 clk = ~clk;
  
initial begin
	a = 16'h4500;
	b = 16'h4700;
	en = 0;
	#0 clrn = 1'b0;
	#5 clrn = 1'b0;
	#10 clrn = 1'b1;
	en = 1'b1;
	#50
	if(result==16'h4A00)
		$display("----------Correct!----------");
	else
		$display("----------Wrong!----------");
	$display("Ans:%x, yours:%x\n",16'h4A00,result);
	a = 16'h4300;
	b = 16'hC500;
	en = 0;
	#0 clrn = 1'b0;
	#5 clrn = 1'b0;
	#10 clrn = 1'b1;
	en = 1'b1;
	#50
	if(result==16'hBE00)
		$display("----------Correct!----------");
	else
		$display("----------Wrong!----------");
	$display("Ans:%x, yours:%x\n",16'hBE00,result);
	a = 16'h7BFF;
	b = 16'h7BFF;
	en = 0;
	#0 clrn = 1'b0;
	#5 clrn = 1'b0;
	#10 clrn = 1'b1;
	en = 1'b1;
	#50
	$display("----------Exp!----------");
	$display("Ans:x, yours:%x\n",result);
	#500 $finish;
end

initial begin
	$dumpfile("fpadder.vcd");
	$dumpvars;
end

endmodule