module finalTermProject(
	input [4:0] SW,
	input CLOCK_50,
	output reg [0:6] HEX3,HEX1,HEX0,HEX4,HEX7
	);
	
	wire pulse;
	wire input_x,input_y,in_A,in_B,in_C;
	wire newClk_4;
	wire A,B,C;
	reg state_A, state_B, state_C;
	parameter Seg9 = 7'b000_1100; parameter Seg8 = 7'b000_0000; parameter Seg7 = 7'b000_1111; 
	parameter Seg6 = 7'b010_0000; parameter Seg5 = 7'b010_0100;	parameter Seg4 = 7'b100_1100; 
	parameter Seg3 = 7'b000_0110; parameter Seg2 = 7'b001_0010; parameter Seg1 = 7'b100_1111; 
	parameter Seg0 = 7'b000_0001; parameter SegX = 7'b111_1111;
	
	input_pulse(SW[0],SW[1],SW[2],SW[3],pulse);
	input_encoder(SW[0],SW[1],SW[2],SW[3],input_x,input_y);
	clock_4(CLOCK_50,newClk_4);
	
	conventionalLogic(A,B,C,input_x,input_y, in_A,in_B,in_C);
	
	d_flip_flop ( in_A ,pulse, SW[4], A);
	d_flip_flop ( in_B ,pulse, SW[4], B);
	d_flip_flop ( in_C ,pulse, SW[4], C);
	always@(*)
	begin
		case(pulse)
			1:HEX4=Seg1;
			0:HEX4=Seg0;
		endcase
	end
	always@(*)
	begin
		case({A,B,C})
			5: HEX0 = Seg0;
			4: HEX0 = Seg6;
			3: HEX0 = Seg2;
			2: HEX0 = Seg8;
			1: HEX0 = Seg4;
			0: HEX0 = Seg0;
			default: HEX0 = SegX;
		endcase
		case({A,B,C})
			5: HEX1 = Seg2;
			4: HEX1 = Seg1;
			3: HEX1 = Seg1;
			2: HEX1 = Seg0;
			1: HEX1 = Seg0;
			0: HEX1 = Seg0;
			default: HEX1 = SegX;
		endcase
		case({A,B,C})
			5: HEX3 = Seg2;
			4: HEX3 = Seg2;
			3: HEX3 = Seg1;
			2: HEX3 = Seg1;
			1: HEX3 = Seg0;
			0: HEX3 = Seg0;
			default: HEX3 = SegX;
		endcase
		case({A,B,C})
		9: HEX7=Seg9;
		8:HEX7=Seg8;
		7:HEX7=Seg7;
		6:HEX7=Seg6;
		5:HEX7=Seg5;
		4:HEX7=Seg4;
		3:HEX7=Seg3;
		2:HEX7=Seg2;
		1:HEX7=Seg1;
		0:HEX7=Seg0;
		default : HEX7=SegX;
		endcase
	end
endmodule

//design the module that output  1 when 0000>0001
module input_pulse(
input SW0,SW1,SW2,SW3,
output pulse
);
assign pulse=SW0|SW1|SW2|SW3;

endmodule

module input_encoder(
input SW0,SW1,SW2,SW3,
output encodedOutput_1,encodedOutput_0
);
assign encodedOutput_1 = SW3|SW2;
assign encodedOutput_0 = SW1|SW3;
endmodule

module conventionalLogic(
input A,B,C,D,E,
output a,b,c
);
assign a = A&~D|A&~E|B&~D&E|B&C&~D|~B&C&D&~E|B&~C&D&~E;
assign b =  A&D&E| ~A&~B&~D&E | ~A&~B&C&~D| B&~C&~D&~E | B&C&D&~E | ~A&~B&~C&D&~E;
assign c = A&C | ~A&~C&~E | ~B&C&E | ~C&~D&~E | B&C&D;
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

module clock_4(input clk, output newclk);
	reg [24:0]cnt;
	
	always@(posedge clk)
	begin
		cnt <= cnt + 1'b1;
	end
	assign newclk = cnt[4];
endmodule

module clock_8(input clk, output newclk);
	reg [24:0]cnt;
	
	always@(posedge clk)
	begin
		cnt <= cnt + 1'b1;
	end
	assign newclk = cnt[8];
endmodule

