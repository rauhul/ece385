module carry_lookahead_adder (
    input   logic          Add,
    input   logic[7:0]     A,
    input   logic[7:0]     B,
    output  logic[7:0]     Sum,
	 output  logic 			X
);
	// define wires for bus
	logic c1, c2, C_In;
	logic[7:0] A_In;
	
	assign A_In = Add ? A : ~A;
	assign C_In = Add ? 1'b0 :  1'b1;

	// add three three-bit carry-lookahead submodules connected via bus
	carry_lookahead_adder_submodule S0(.A(A_In[ 2: 0]), .B(B[ 2: 0]), .Ci(C_In), .Sum(Sum[ 2: 0]), .C(c1));
	carry_lookahead_adder_submodule S1(.A(A_In[ 5: 3]), .B(B[ 5: 3]), .Ci(c1),   .Sum(Sum[ 5: 3]), .C(c2));
	carry_lookahead_adder_submodule S2(.A({A_In[7], A_In[ 7: 6]}), .B({B[7], B[ 7: 6]}), .Ci(c2), .Sum({X, Sum[ 7: 6]}));
endmodule

module carry_lookahead_adder_submodule (
    input   logic[2:0]   A,
    input   logic[2:0]   B,
    input   logic        Ci,
    output  logic[2:0]   Sum,
    output  logic        C
);
	// define wires for bus
	logic c1, c2;
	 
	 // add four bit carry-lookahead bits connected via bus
	carry_lookahead_adder_bit B0(.A(A[0]), .B(B[0]), .Ci(Ci), .Sum(Sum[0]), .C(c1));
	carry_lookahead_adder_bit B1(.A(A[1]), .B(B[1]), .Ci(c1), .Sum(Sum[1]), .C(c2));
	carry_lookahead_adder_bit B3(.A(A[2]), .B(B[2]), .Ci(c2), .Sum(Sum[2]), .C( C));
endmodule

module carry_lookahead_adder_bit (
    input   logic   A,
    input   logic   B,
    input   logic   Ci,
    output  logic   Sum,
    output  logic   C
);
	// generate, propogate terms
	logic G, P;
	assign G = A & B;
	assign P = A ^ B;
	
	// carry term
	assign C = G | (P & Ci);

	// compute sum
	full_adder FA0(.x(A), .y(B), .z(Ci), .s(Sum));
		  
endmodule