module full_adder 
(
    input  logic x,
    input  logic y,
    input  logic z,
    output logic s,
    output logic c
);
    
    assign s = x^y^z;
    assign c = (x & y) | (x & z) | (y & z);

endmodule