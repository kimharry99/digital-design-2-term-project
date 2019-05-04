module finalTermProject(
	input [4:0] SW,
	input CLOCK_50,
	output reg [0:6] HEX3,HEX1,HEX0
	);
	
	wire in_pulse, pulse;
	wire input_x,input_y,in_A,in_B,in_C;
	wire newClk_24;
	wire A,B,C;
	wire [0:6] h0,h1,h3;
	reg state_A, state_B, state_C;
	
	input_pulse(SW[0],SW[1],SW[2],SW[3],in_pulse);
	
	//correct hardware error
	d_flip_flop ( in_pulse ,newClk_24 ,1'b0 , pulse );
	
	input_encoder(SW[0],SW[1],SW[2],SW[3],input_x,input_y);
	clock_24(CLOCK_50,newClk_24);
	
	conventionalLogic(A,B,C,input_x,input_y, in_A,in_B,in_C);
	dffs(in_A,in_B,in_C,pulse,SW[4],A,B,C);
	
	print(A,B,C,h0,h1,h3);
	
	always@(*)
	begin
		HEX0<=h0;
		HEX1<=h1;
		HEX3<=h3;
	end
endmodule

/* design the module that output  1 when 0000>0001 */
module input_pulse(
input SW0,SW1,SW2,SW3,
output pulse
);
assign pulse=SW0|SW1|SW2|SW3;

endmodule

/* change input data to 2bit */
module input_encoder(
input SW0,SW1,SW2,SW3,
output encodedOutput_1,encodedOutput_0
);
assign encodedOutput_1 = SW3|SW2;
assign encodedOutput_0 = SW1|SW3;
endmodule

module conventionalLogic(
	input A, B, C, x, y,
	output a, b, c
);
assign a = A & ~x | A & ~y | B & ~x & y | B & C & ~x | ~B & C & x & ~y | B & ~C & x & ~y;
assign b = A & x & y | ~A & ~B & ~x & y | ~A & ~B & C & ~x | B & ~C & ~x & ~y | B & C & x & ~y | ~A & ~B & ~C & x & ~y;
assign c = C & y | A & C | ~A & ~C & ~y | ~C & ~x & ~y | B & x & ~y;
endmodule


module d_flip_flop ( input din ,input clk ,input reset ,output reg dout );
	initial
	begin
		dout<=0;
	end
	always @ (posedge clk)
	begin
		if (reset)
			dout <= 0;
		else
			dout <= din;
	end
endmodule 

/* slow clock */
module clock_24(input clk, output newclk);
	reg [24:0]cnt;
	
	always@(posedge clk)
	begin
		cnt <= cnt + 1'b1;
	end
	assign newclk = cnt[20];
endmodule

/* thee dff in one module */
module dffs(
input dinA, dinB, dinC, clk, reset,
output doutA, doutB, doutC
);
wire outA, outB, outC ;

d_flip_flop (dinA, clk, reset, doutA);
d_flip_flop (dinB, clk, reset, doutB);
d_flip_flop (dinC, clk, reset, doutC);

endmodule

/* print data to hex */
module print(
	input A,B,C,
	output reg [0:6] h0,h1,h3
);
	parameter Seg9 = 7'b000_1100; parameter Seg8 = 7'b000_0000; parameter Seg7 = 7'b000_1111; 
	parameter Seg6 = 7'b010_0000; parameter Seg5 = 7'b010_0100;	parameter Seg4 = 7'b100_1100; 
	parameter Seg3 = 7'b000_0110; parameter Seg2 = 7'b001_0010; parameter Seg1 = 7'b100_1111; 
	parameter Seg0 = 7'b000_0001; parameter SegX = 7'b111_1111;
	
	always@(*)
	begin
		case({ A,B,C })
			5: h0 = Seg0;
			4: h0 = Seg6;
			3: h0 = Seg2;
			2: h0 = Seg8;
			1: h0 = Seg4;
			0: h0 = Seg0;
			default: h0 = SegX;
		endcase
		case({ A,B,C })
			5: h1 = Seg2;
			4: h1 = Seg1;
			3: h1 = Seg1;
			2: h1 = Seg0;
			1: h1 = Seg0;
			0: h1 = Seg0;
			default: h1 = SegX;
		endcase
		case({ A,B,C })
			5: h3 = Seg2;
			4: h3 = Seg2;
			3: h3 = Seg1;
			2: h3 = Seg1;
			1: h3 = Seg0;
			0: h3 = Seg0;
			default: h3 = SegX;
		endcase
	end
endmodule