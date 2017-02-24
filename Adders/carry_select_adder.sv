module carry_select_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);
     
	// define wires for bus
	wire c1, c2, c3;

	// add four four-bit carry-select submodules connected via bus
	carry_select_adder_submodule SUB0(.A(A[ 3: 0]), .B(B[ 3: 0]), .c_in( 0), .Sum(Sum[ 3: 0]), .c_out(c1));
	carry_select_adder_submodule SUB1(.A(A[ 7: 4]), .B(B[ 7: 4]), .c_in(c1), .Sum(Sum[ 7: 4]), .c_out(c2));
	carry_select_adder_submodule SUB2(.A(A[11: 8]), .B(B[11: 8]), .c_in(c2), .Sum(Sum[11: 8]), .c_out(c3));
	carry_select_adder_submodule SUB3(.A(A[15:12]), .B(B[15:12]), .c_in(c3), .Sum(Sum[15:12]), .c_out(CO));

endmodule

module carry_select_adder_submodule (
	input  logic[3:0]  A,
	input  logic[3:0]  B, 
	input  logic       c_in,
	output logic[3:0]  Sum,
	output logic       c_out
);

	// define wires for bus
	wire a1, a2, a3, a4;
	wire b1, b2, b3, b4;

	// define the two sums computed
	logic [3:0]Sum_A;
	logic [3:0]Sum_B;

	// add together the input and output assuming a carry of 1
    full_adder FA0_A(.x(A[ 0]), .y(B[ 0]), .z(1'b0), .s(Sum_A[ 0]), .c( a1));
    full_adder FA1_A(.x(A[ 1]), .y(B[ 1]), .z( a1), .s(Sum_A[ 1]), .c( a2));
    full_adder FA2_A(.x(A[ 2]), .y(B[ 2]), .z( a2), .s(Sum_A[ 2]), .c( a3));
    full_adder FA3_A(.x(A[ 3]), .y(B[ 3]), .z( a3), .s(Sum_A[ 3]), .c( a4));

	 // add together the input and output assuming a carry of 0
    full_adder FA0_B(.x(A[ 0]), .y(B[ 0]), .z(1'b1), .s(Sum_B[ 0]), .c( b1));
    full_adder FA1_B(.x(A[ 1]), .y(B[ 1]), .z( b1), .s(Sum_B[ 1]), .c( b2));
    full_adder FA2_B(.x(A[ 2]), .y(B[ 2]), .z( b2), .s(Sum_B[ 2]), .c( b3));
    full_adder FA3_B(.x(A[ 3]), .y(B[ 3]), .z( b3), .s(Sum_B[ 3]), .c( b4));

	 // select the correct c_out and sum based off the input carry
    assign c_out = c_in ? b4    : a4; 
    assign Sum   = c_in ? Sum_B : Sum_A;

endmodule