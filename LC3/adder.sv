module adder (
    input   logic[15:0]     A_In,
    input   logic[15:0]     B_In,
    output  logic[15:0]     Sum
);

    assign Sum = A_In + B_In;

endmodule