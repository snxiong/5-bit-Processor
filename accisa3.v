// Steven Xiong
// CSC 142
// Project#5

module accISA(
	input clock, reset,
	output reg signed [7:0] acc
);

	reg [5:0] pp; // program pointer, points to next instruction
	reg [2:0] opcode = 0; // opcode code for function that needs to be exected
	reg signed [7:0] operand = 0; // operand, actual data that needs to be worked on
	reg signed [7:0] result;
	reg [5:0] index = 0;
	integer i;
	
	(* ramstyle = "M512" *) reg [7:0] IM[0:20]; // 8-bit array[20]
	(* ramstyle = "M512" *) reg signed [7:0] DM[0:15]; // 8-bit array[16]
	
	parameter	LD_D = 1,
			LD_M = 2,
			ST = 3,
			ADD = 4,
			XOR = 5,
			JMP = 6;
	
	initial begin
		$display("	Steven Xiong	");	
		
		IM[0] = 8'h3D;	// LD -3	001-11101
		IM[1] = 8'h60;	// ST (X)	011-00000
		IM[2] = 8'h3A;	// LD -6	001-11010
		IM[3] = 8'h61;	// ST (Y)	011-00001
		IM[4] = 8'h3B;	// LD -5	001-11011
		IM[5] = 8'h62;	// ST (Z)	011-00010
		IM[6] = 8'h3F;	// LD -1	001-11111
		IM[7] = 8'h64;	// ST (A)	011-00100
		IM[8] = 8'h21;	// LD 1		001-00001
		IM[9] = 8'h65;	// ST (B)	011-00101
		IM[10] = 8'h42;	// LD (Z)	010-00010
		IM[11] = 8'hA4;	// XOR (A)	101-00100
		IM[12] = 8'h85;	// ADD (B)	100-00101
		IM[13] = 8'h62;	// ST (Z)	011-00010
		IM[14] = 8'h40;	// LD (X)	010-00000
		IM[15] = 8'h81;	// ADD (Y)	100-00001
		IM[16] = 8'h82;	// ADD (Z)	100-00010
		IM[17] = 8'h63;	// ST (T)	011-00011

		DM[0] = 8'h00;	// array[0] = 'X'
		DM[1] = 8'h00;	// array[1] = 'Y'
		DM[2] = 8'h00;	// array[2] = 'Z'
		DM[3] = 8'h00;	// array[3] = 'T'
		DM[4] = 8'h00;	// array[4] = 'A'
		DM[5] = 8'h00;	// array[5] = 'B'
		
		pp = 0;
	end

//--------------------------READ INSTRUCTION MEMORY (IM)--------------

	always@(pp)
	begin
		opcode = IM[pp][7:5];
		operand[4:0] = IM[pp][4:0];

		if(operand[4] == 0) begin
			operand[7:5] = 3'b000; end
		else if(operand[4] == 1) begin
			operand[7:5] = 3'b111; end
	end	

//--------------------------DEODE AND EXECUTE-------------------------

	always@(*)
	begin
		case(opcode)
			LD_D: begin
				result = operand; end
			LD_M: begin
				result = DM[operand]; end
			ST: begin
				result = acc; end
			ADD: begin
				result = acc + DM[operand]; end
			XOR: begin
				result = acc ^ DM[operand]; end
			JMP: begin
				result = 8'hx; end
		endcase
		index = index + 1;
	end

//--------------------------FETCH AND WRITE BACK---------------------

	always@(*)
	begin
		if(reset == 1)
		begin
			pp <= 0;
		end
		else
		begin
			case(opcode)
				LD_D: begin
					acc <= result;
					pp <= pp + 1; end
				LD_M: begin
					acc <= result;
					pp <= pp + 1; end
				ST: begin
					DM[operand] <= result;
					pp <= pp + 1; end
				ADD: begin
					acc <= result;
					pp <= pp + 1; end
				XOR: begin
					acc <= result;
					pp <= pp + 1; end
				JMP: begin
					pp <= operand[5:0]; end
			endcase
		end
		$display("PP = %d	ACC = %d", pp, acc);	
	end

//----------------------------------------------
endmodule
