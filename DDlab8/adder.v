module adder(
input clk, 
input sw0,
input sw1,
input sw2,
input sw3,
input sw4,
input sw5,
input sw6,
input sw7,
input sw8,
input sw9,
input sw10,
input sw11,
input sw12,
input sw13,
input sw14,
input sw15,

output a,
output b,
output c,
output d,
output e,
output f,
output g,
output dp,
output d0,
output d1,
output d2,
output d3,
output d4,
output d5,
output d6,
output d7 
);

wire [9:0] second_number, first_number;
reg [17:0] counter;
reg [2:0] state;
reg [10:0] seg_number,seg_data;
wire [10:0] answer_number;
reg [7:0] scan;
//----------------------------Adder-------------------------------------//
assign	second_number = {4'b0,sw5,sw4,sw3,sw2,sw1,sw0}; //Input A
assign	first_number = {sw15,sw14,sw13,sw12,sw11,sw10,sw9,sw8,sw7,sw6};//Input B
assign	answer_number = first_number + second_number;// Answer
//-----------------------------------------------------------------------//

//8��(d0~d7)7-segment(a~g)��� dp���k�U����.
assign {d7,d6,d5,d4,d3,d2,d1,d0} = scan;
assign dp = ((state==2) || (state==4)) ? 0 : 1; //3,5dp light_on
always@(posedge clk) begin
  counter <=(counter<=100000) ? (counter +1) : 0;
  state <= (counter==100000) ? (state + 1) : state;
   case(state)
	0:begin
	  seg_number <= first_number/100;//���first_number�ʦ��
	  scan <= 8'b0111_1111;//0 �N����ܸ�7�q��ܾ�
	end
	1:begin
	  seg_number <= (first_number%100)/10;//���first_number�Q���
	  scan <= 8'b1011_1111;
	end
	2:begin
	  seg_number <= first_number%10;//���first_number�Ӧ��
	  scan <= 8'b1101_1111;
	end
	3:begin
	  seg_number <= second_number/10;//���second_number�Q���
	  scan <= 8'b1110_1111;
	end
	4:begin
	  seg_number <= second_number%10;//���second_number�Ӧ��
	  scan <= 8'b1111_0111;
	end
	5:begin
	  seg_number <= answer_number/100;//���answer_number�ʦ��
	  scan <= 8'b1111_1011;
	end
	6:begin
	  seg_number <= (answer_number%100)/10;
	  scan <= 8'b1111_1101;
	end
	7:begin
	  seg_number <= answer_number%10;
	  scan <= 8'b1111_1110;
	end
	default: state <= state;
  endcase 
end  

//7-segment ��X�Ʀr�ѽX
assign {g,f,e,d,c,b,a} = seg_data;
always@(posedge clk) begin  
  case(seg_number)
	16'd0:seg_data <= 7'b100_0000;
	16'd1:seg_data <= 7'b111_1001;
	16'd2:seg_data <= 7'b010_0100;
	16'd3:seg_data <= 7'b011_0000;
	16'd4:seg_data <= 7'b001_1001;
	16'd5:seg_data <= 7'b001_0010;
	16'd6:seg_data <= 7'b000_0010;
	16'd7:seg_data <= 7'b101_1000;
	16'd8:seg_data <= 7'b000_0000;
	16'd9:seg_data <= 7'b001_0000;
	default: seg_number <= seg_number;
  endcase
end 
endmodule
