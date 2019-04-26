module finalTermProject(
	input [4:0] SW,
	output reg [0:6] HEX3,HEX1,HEX0
	);
	wire pulse;
	//(number of people standing in line)/4
	reg [2:0] state;
	//input data
	reg [3:0] input_data;
	
	always@(*)
		input_data = SW[3:0];

	initial
		state = 3'b000;
	
	pulGen(a,b,c,pulse);
	
endmodule

module pulGen(in, clk, rst, out);
	output reg out;
	input clk, in, rst;
	reg [1:0] currstate0;
	reg [1:0] nextstate0;
	integer cnt;
	integer ncnt;
	parameter out_S0 = 2'b00; parameter out_S1 = 2'b01; parameter out_S2 = 2'b10;

	always @(posedge clk)//State Change
	begin
	if(rst)
		begin
		currstate0<=out_S0;cnt<=0;
		end
	else
		begin
		currstate0 <= nextstate0; cnt <= ncnt; 
		end
	end
	
	always @(*)
	begin
	case(currstate0)
		out_S0 : begin
			if(in) begin nextstate0 = out_S1; ncnt = 0; end
			else   begin nextstate0 = out_S0; ncnt = 0; end
		end
		out_S1 : begin 
			if(in) begin
				nextstate0 = out_S1;
				ncnt = cnt + 1;
			end
			else begin
				nextstate0 = out_S0; 
				if(cnt >= 1000)
					nextstate0 = out_S2;
				end
			end
		out_S2 : begin nextstate0 = out_S0; ncnt = 0; end
			default : nextstate0 = out_S0;
		endcase
	end
	
	always @(*)
		begin
			if (currstate0 == out_S2) out = 1'b1;
			else                      out = 1'b0;
		end
endmodule 
