module InvShiftRows  ( input        [0:127] in,
                       output logic [0:127] out );

     // Declaration of the individual Words in 'in' State
    logic [0:31] a0, a1, a2, a3;

    // Declaration of the individual Words in 'out' State
    logic [0:31] b0, b1, b2, b3;

    assign { a0, a1, a2, a3 } = in;

    assign b0 = a0;
    InvShiftRows1(a1, b1);
    InvShiftRows2(a2, b2);
    InvShiftRows3(a3, b3);

    assign { b0, b1, b2, b3 } = out;

endmodule

module InvShiftRows1 ( input        [0:31] in,
                       output logic [0:31] out );

    // Declaration of the individual Bytes in 'in' Word
    logic [0:7] a0, a1, a2, a3;

    // Declaration of the individual Bytes in 'out' Word
    logic [0:7] b0, b1, b2, b3;

    assign { a0, a1, a2, a3 } = in;

    assign b0 = a3;
    assign b1 = a0;
    assign b2 = a1;
    assign b3 = a2;

    assign { b0, b1, b2, b3 } = out;

endmodule

module InvShiftRows2 ( input        [0:31] in,
                       output logic [0:31] out );

    // Declaration of the individual Bytes in 'in' Word
    logic [0:7] a0, a1, a2, a3;

    // Declaration of the individual Bytes in 'out' Word
    logic [0:7] b0, b1, b2, b3;

    assign { a0, a1, a2, a3 } = in;

    assign b0 = a2;
    assign b1 = a3;
    assign b2 = a0;
    assign b3 = a1;

    assign { b0, b1, b2, b3 } = out;

endmodule

module InvShiftRows3 ( input        [0:31] in,
                       output logic [0:31] out );

    // Declaration of the individual Bytes in 'in' Word
    logic [0:7] a0, a1, a2, a3;

    // Declaration of the individual Bytes in 'out' Word
    logic [0:7] b0, b1, b2, b3;

    assign { a0, a1, a2, a3 } = in;

    assign b0 = a1;
    assign b1 = a2;
    assign b2 = a3;
    assign b3 = a0;

    assign { b0, b1, b2, b3 } = out;

endmodule