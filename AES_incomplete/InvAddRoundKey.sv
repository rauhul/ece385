module InvAddRoundKey ( input  logic [127:0] in,
                        input  logic [127:0] key,
                        output logic [127:0] out );

     assign out <= in ^ key;

endmodule