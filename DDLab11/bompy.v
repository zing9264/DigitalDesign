`timescale 1ns/1ps
module lab(CLK, RST, in_a, in_b, Product, Product_Valid);
input CLK, RST;
input [31:0]	in_a;	// Multiplicand
input [31:0]	in_b;// Multiplier
output reg [63:0] Product;
output reg Product_Valid;

reg [63:0] Mplicand0;
reg [63:0] Mplicand1;
reg [32:0] Mplier;
reg [6:0]	Counter ;
reg	sign_a  ;
reg sign_b  ;
reg [31:0] change ;

//Counter
always @(posedge CLK or posedge RST)
begin
	if(RST)
		Counter <=6'b0;
	else
		Counter <= Counter +6'b1;
end

//Multiplier
always @(posedge CLK or posedge RST)
begin
	//初始化數值
	if(RST) begin
		Product  <= 64'b0;
		Mplicand0 <= 64'b0;
		Mplicand1 <= 64'b0 ;
		Mplier   <= 33'b0;
		sign_a <= 1'b0 ;
		sign_b <= 1'b0 ;

	end

	//輸入乘數與被乘數
	else if(Counter == 6'd0) begin


	    if(in_a[31]==1)
        begin
                Mplicand1 <= {32'b0,~in_a+1'b1};
                Mplicand0 <= {32'b11111111111111111111111111111111,in_a};
                sign_a <= 1'b1 ;
        end

	    else if(in_a[31]==0)
        begin
                Mplicand0 <= {32'b0,in_a};
                Mplicand1 <= {32'b11111111111111111111111111111111,~in_a+1'b1};
        end

        if(in_b[31]==1)
            sign_b <= 1'b1 ;


        Mplier <= in_b << 1'b1 ;
	end

	//乘法與數值移位
	/* write down your design below */
	else if(Counter <=6'd32)
	begin

		if(Mplier[1:0] == 2'b00)
		begin
		   Product <= 64'b0 + Product ;
		end

		else if(Mplier[1:0] == 2'b01)
		begin
		   Product <= Mplicand0 + Product ;
		end

		else if(Mplier[1:0] == 2'b10)
		begin
		   Product <= Mplicand1 + Product ;
		end

		else if(Mplier[1:0] == 2'b11)
		begin
		   Product <= 64'b0 + Product ;
		end

		Mplicand0 <= Mplicand0 << 1'b1;
		Mplicand1 <= Mplicand1 << 1'b1 ;
		Mplier <= Mplier >> 1'b1;


	end

	/* write down your design upon */
end

//判斷輸出
always @(posedge CLK or posedge RST)
begin
	if(RST)
		Product_Valid <=1'b0;
	else if(Counter==6'd32)
		Product_Valid <=1'b1;
	else
		Product_Valid <=1'b0;
end

endmodule
