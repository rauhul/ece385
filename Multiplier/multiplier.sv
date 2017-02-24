module multiplier (
    input  logic[7:0] Switch,
    input  logic Clk, Reset, Run, ClearA_LoadB,
    output logic[6:0] AhexU, AhexL, BhexU, BhexL,
    output logic[7:0] Aval, Bval,
    output logic X
);

    // register-register wires
    logic AB_Reg_wire;

    // register-control wires
    logic[7:0] A_Data_In_wire, B_Data_In_wire;
    logic      Load_A_wire, Load_B_wire, Shift_Enable_AB_wire;

    // adder-control wires
    logic[7:0] Adder_Result_wire;
    logic      Adder_Add_wire;
	
	 logic M;
    assign M = Bval[0];

    control control_unit(.Switch, .Adder_Result(Adder_Result_wire),
                         .Clk, .Reset, .Run, .ClearA_LoadB, .M,
                         .Load_A(Load_A_wire), .Load_B(Load_B_wire), .Shift_Enable_AB(Shift_Enable_AB_wire), .Adder_Add(Adder_Add_wire),
                         .Load_Data_A(A_Data_In_wire), .Load_Data_B(B_Data_In_wire));

    reg_8   A_REG(.Clk, .Reset, .Shift_In(X), .Load(Load_A_wire), .Shift_En(Shift_Enable_AB_wire),
                  .Data_In(A_Data_In_wire),
                  .Shift_Out(AB_Reg_wire),
                  .Data_Out(Aval));

    reg_8   B_REG(.Clk, .Reset, .Shift_In(AB_Reg_wire), .Load(Load_B_wire), .Shift_En(Shift_Enable_AB_wire),
                  .Data_In(B_Data_In_wire),
                  .Data_Out(Bval));
						
    ripple_adder ADDER(.A_In(Switch), .B(Aval), .Add(Adder_Add_wire), 
							  .Sum(Adder_Result_wire), .CO(X));
										  
	 HexDriver        HexAL (
                        .In0(Aval[3:0]),
                        .Out0(AhexL) );
	 HexDriver        HexBL (
                        .In0(Bval[3:0]),
                        .Out0(BhexL) );
	 HexDriver        HexAU (
                        .In0(Aval[7:4]),
                        .Out0(AhexU) );	
	 HexDriver        HexBU (
                        .In0(Bval[7:4]),
                        .Out0(BhexU) );

endmodule 