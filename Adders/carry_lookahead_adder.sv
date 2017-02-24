module carry_lookahead_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);
	// define wires for bus
    wire c1, c2, c3;   

	 // add four four-bit carry-lookahead submodules connected via bus
    carry_lookahead_adder_submodule S0(.A(A[ 3: 0]), .B(B[ 3: 0]), .Ci( 0), .Sum(Sum[ 3: 0]), .C(c1));
    carry_lookahead_adder_submodule S1(.A(A[ 7: 4]), .B(B[ 7: 4]), .Ci(c1), .Sum(Sum[ 7: 4]), .C(c2));
    carry_lookahead_adder_submodule S2(.A(A[11: 8]), .B(B[11: 8]), .Ci(c2), .Sum(Sum[11: 8]), .C(c3));
    carry_lookahead_adder_submodule S3(.A(A[15:12]), .B(B[15:12]), .Ci(c3), .Sum(Sum[15:12]), .C(CO));

endmodule

module carry_lookahead_adder_submodule (
    input   logic[3:0]   A,
    input   logic[3:0]   B,
    input   logic        Ci,
    output  logic[3:0]   Sum,
    output  logic        C
);

	// define wires for bus
    wire c1, c2, c3;
	 
	 // add four bit carry-lookahead bits connected via bus
    carry_lookahead_adder_bit B0(.A(A[0]), .B(B[0]), .Ci(Ci), .Sum(Sum[0]), .C(c1));
    carry_lookahead_adder_bit B1(.A(A[1]), .B(B[1]), .Ci(c1), .Sum(Sum[1]), .C(c2));
    carry_lookahead_adder_bit B2(.A(A[2]), .B(B[2]), .Ci(c2), .Sum(Sum[2]), .C(c3));
    carry_lookahead_adder_bit B3(.A(A[3]), .B(B[3]), .Ci(c3), .Sum(Sum[3]), .C( C));

endmodule

module carry_lookahead_adder_bit (
    input   logic   A,
    input   logic   B,
    input   logic   Ci,
    output  logic   Sum,
    output  logic   C
);

	// generate, propogate terms
    assign G = A & B;
    assign P = A ^ B;
	 
	 // carry term
    assign C = G | (P & Ci);

	 // compute sum
    full_adder FA0 (.x(A), .y(B), .z(Ci), .s(Sum));

endmodule