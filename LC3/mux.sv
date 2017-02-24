module mux_2x1 (
	input  logic IN_0, IN_1,
	input  logic SELECT,
	output logic OUT
);
	always_comb begin
		unique case(SELECT)
		1'b0 : OUT = IN_0;
		1'b1 : OUT = IN_1;
		default : OUT = 1'bx;
		endcase // SELECT
	end
endmodule

module mux_2x3 (
	input  logic [2:0] IN_0, IN_1,
	input  logic       SELECT,
	output logic [2:0] OUT
);
	always_comb begin
		unique case(SELECT)
		1'b0 : OUT = IN_0;
		1'b1 : OUT = IN_1;
		default : OUT = 3'bx;
		endcase // SELECT
	end
endmodule

module mux_2x16 (
	input  logic [15:0] IN_0, IN_1,
	input  logic        SELECT,
	output logic [15:0] OUT
);
	always_comb begin
		unique case(SELECT)
		1'b0 : OUT = IN_0;
		1'b1 : OUT = IN_1;
		default : OUT = 16'bx;
		endcase // SELECT
	end
endmodule

module mux_4x16 (
	input  logic [15:0] IN_0, IN_1, IN_2, IN_3,
	input  logic [1:0]  SELECT,
	output logic [15:0] OUT
);
	always_comb begin
		unique case(SELECT)
		2'b00 : OUT = IN_0;
		2'b01 : OUT = IN_1;
		2'b10 : OUT = IN_2;
		2'b11 : OUT = IN_3;
		default : OUT = 16'bx;
		endcase // SELECT
	end
endmodule