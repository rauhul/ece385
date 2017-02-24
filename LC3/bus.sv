module bus (
    input  logic        GatePC, GateMDR, GateALU, GateMAR,
    input  logic [15:0] PC, MDR, ALU, MAR,
    output logic [15:0] BusValue
);

    always_comb begin
        assert(GatePC + GateMDR + GateALU + GateMAR < 2) else $error("Bus Overload");
        unique case ({GatePC, GateMDR, GateMAR, GateALU})
		  4'b1000 : BusValue = PC;
		  4'b0100 : BusValue = MDR;
		  4'b0010 : BusValue = MAR;
		  4'b0001 : BusValue = ALU;
		  default : BusValue = 16'bZZZZ_ZZZZ_ZZZZ_ZZZZ;
		  endcase
    end
endmodule 