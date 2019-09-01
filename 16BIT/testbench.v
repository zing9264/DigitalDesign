`include "fp_adder.v"
`timescale 1ns / 1ps

module test_bench;
reg clk; //??????
reg clrn; //??????
reg[31:0] a; //10 ??????????
reg[31:0] b;
reg en;
wire [31:0] result;
pipelined_fpadder test(a,b,1'b0,2'd0,result,clk,clrn,en);


initial #0 clk = 1'b1;
always #10 clk = ~clk;
  
initial begin
	a = 32'h3F000000;
	b = 32'h3E800000;
	en = 0;
	#0 clrn = 1'b0;
	#5 clrn = 1'b0;
	#10 clrn = 1'b1;
	en = 1'b1;
	#500 $finish;
end
    
initial begin
	//#11 a=32'b0001_1111_1111_1111_1111_1111_1111_1111;
	//#11 b=32'b1001_1111_1111_1111_1111_1111_1111_0000;
	//#11 a = 32'h3F000000;
	/*#11	b = 32'h3EC00000;
	#12 en = 1'b1;
	#20
	en = 1'b0;
	#11 a = 32'h3dcccccd;
	#11 b = 32'h3E4CCCCD;
	#12 en = 1'b1;
	*/
	//#10 clrn = 1'b0;
	//#10 clrn = 1'b1;
	//#11 a = 32'b00111111000000000000000000000000;
	//#11	b = 32'b00111110110000000000000000000000;
end

initial begin
	$dumpfile("fpadder.vcd");
	$dumpvars;
end

endmodule