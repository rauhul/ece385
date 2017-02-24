module ripple_adder
(
    input   logic[7:0]     A_In,
    input   logic[7:0]     B,
	 input   logic          Add,
    output  logic[7:0]     Sum,
    output  logic           CO
);


	logic C_In;
	logic[7:0] A;
	
	assign A = Add ? A_In : ~A_In;
	assign C_In = Add ? 1'b0 :  1'b1;
	
	
	// define wire bus
	logic c1, c2, c3, c4, c5, c6, c7;
	
	// chain successive full adders together via their carry bits to output each
	// sum bit and final carry bit
    full_adder FA0 (.x(A[ 0]), .y(B[ 0]), .z(C_In), .s(Sum[ 0]), .c( c1));
    full_adder FA1 (.x(A[ 1]), .y(B[ 1]), .z( c1), .s(Sum[ 1]), .c( c2));
    full_adder FA2 (.x(A[ 2]), .y(B[ 2]), .z( c2), .s(Sum[ 2]), .c( c3));
    full_adder FA3 (.x(A[ 3]), .y(B[ 3]), .z( c3), .s(Sum[ 3]), .c( c4));
    full_adder FA4 (.x(A[ 4]), .y(B[ 4]), .z( c4), .s(Sum[ 4]), .c( c5));
    full_adder FA5 (.x(A[ 5]), .y(B[ 5]), .z( c5), .s(Sum[ 5]), .c( c6));
    full_adder FA6 (.x(A[ 6]), .y(B[ 6]), .z( c6), .s(Sum[ 6]), .c( c7));
    full_adder FA7 (.x(A[ 7]), .y(B[ 7]), .z( c7), .s(Sum[ 7]), .c( CO));

endmodule