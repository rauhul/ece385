// AES module interface with all ports, commented for Week 1
module  AES ( input  [127:0]  Ciphertext,
                              Cipherkey,
              input           clk,
                              reset,
                              run,
              output [127:0]  Plaintext,
              output          ready);

    logic [0:1407] KeySchedule;

    KeyExpansion keyexpansion_0(.clk, .Cipherkey, .KeySchedule);

endmodule