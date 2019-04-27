module finalTermProject(
	input [4:0] SW,
	output reg [0:6] HEX3,HEX1,HEX0
	);
	
	wire pulse;
	reg[3:0]cnt;
	parameter Seg9 = 7'b000_1100; parameter Seg8 = 7'b000_0000; parameter Seg7 = 7'b000_1111; 
	parameter Seg6 = 7'b010_0000; parameter Seg5 = 7'b010_0100;	parameter Seg4 = 7'b100_1100; 
	parameter Seg3 = 7'b000_0110; parameter Seg2 = 7'b001_0010; parameter Seg1 = 7'b100_1111; 
	parameter Seg0 = 7'b000_0001; parameter SegX = 7'b111_1111;
	
	input_pulse(SW[0],SW[1],SW[2],SW[3],pulse);
	
	always@(posedge pulse)
	begin
	cnt <=cnt + 1'b1;
	end
	
	always@(*)
	begin
		case(cnt)
			9: HEX0 = Seg9;
				8: HEX0 = Seg8;
				7: HEX0 = Seg7;
				6: HEX0 = Seg6;
				5: HEX0 = Seg5;
				4: HEX0 = Seg4;
				3: HEX0 = Seg3;
				2: HEX0 = Seg2;
				1: HEX0 = Seg1;
				0: HEX0 = Seg0;
				default: HEX0 = SegX;
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