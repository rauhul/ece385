//------------------------------------------------------------------------------
// Company:          UIUC ECE Dept.
// Engineer:         Stephen Kempf
//
// Create Date:    17:44:03 10/08/06
// Design Name:    ECE 385 Lab 6 Given Code - Incomplete ISDU
// Module Name:    ISDU - Behavioral
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//------------------------------------------------------------------------------


module ISDU (   input   Clk,
                        Reset,
                        Run,
                        Continue,
                        ContinueIR,

                input [3:0]  Opcode,
                input        IR_5, 
									  REG_BEN_OUT,

                output logic        LD_MAR,
                                    LD_MDR,
                                    LD_IR,
                                    LD_BEN,
                                    LD_CC,
                                    LD_REG,
                                    LD_PC,

                output logic        GatePC,
                                    GateMDR,
                                    GateALU,
                                    GateMAR,

                output logic [1:0]  PC_Mux_Select,
                                    ADDR2_Mux_Select,
                                    ALUK_Mux_Select,

                output logic        DR_Mux_Select,
                                    SR1_Mux_Select,
                                    SR2_Mux_Select,
                                    ADDR1_Mux_Select,

                output logic        Mem_CE,
                                    Mem_UB,
                                    Mem_LB,
                                    Mem_OE,
                                    Mem_WE
                );

    enum logic [5:0] {Halted,										//Init
							 S_18, S_33_1, S_33_2, S_35,        //Fetch
							 S_32,                              //Decode
							 S_00, S_01, S_04, S_05, S_06, S_07, S_09, S_12, S_16_1, S_16_2, S_21, S_22, S_23, S_25_1, S_25_2, S_27,
						
							 S_Pause_1, S_Pause_2} State, Next_state;

    always_ff @ (posedge Clk)
    begin : Assign_Next_State
        if (Reset)
            State <= Halted;
        else
            State <= Next_state;
    end

    always_comb
    begin
        Next_state <= State;

        unique case (State)
           Halted :
				   begin
                   if (Run)
                       Next_state <= S_18;
					end
           S_18 :
			      begin
                    Next_state <= S_33_1;
					end
           S_33_1 :
				   begin
                    Next_state <= S_33_2;
					end
           S_33_2 :
					begin
                    Next_state <= S_35;
					end
			  S_35 :
    			   begin
                    Next_state <= S_32;
    				end
			  S_32 :
               case (Opcode)
					    4'b0000 : // BR
						     Next_state <= S_00;
                   4'b0001 : // ADD
                       Next_state <= S_01;
						 4'b0100 : // JSR
						     Next_state <= S_04;
						 4'b0101 : // AND
						     Next_state <= S_05;
						 4'b0110 : // LDR
						     Next_state <= S_06;
						 4'b0111 : // STR
						     Next_state <= S_07;
						 4'b1001 : // NOT
							  Next_state <= S_09;
						 4'b1100 : // JMP
						     Next_state <= S_12;
						 4'b1101 : // PAUSE
					        Next_state <= S_Pause_1;
                   default :
                       Next_state <= S_18;
               endcase
			  S_00 :
					if (REG_BEN_OUT)
					    Next_state <= S_22;
					else
					    Next_state <= S_18;
           S_01 :
               Next_state <= S_18;
			  S_04 :
					Next_state <= S_21;
			  S_05 :
               Next_state <= S_18;
			  S_06 :
			      Next_state <= S_25_1;
			  S_07 :
			      Next_state <= S_23;
			  S_09 :
			      Next_state <= S_18;
			  S_12 :
			      Next_state <= S_18;
			  S_16_1 : 
			      Next_state <= S_16_2;
			  S_16_2 : 
			      Next_state <= S_18;
			  S_21 :
				   Next_state <= S_18;
			  S_22 :
			      Next_state <= S_18;
			  S_23 :
			      Next_state <= S_16_1;
			  S_25_1 :
			      Next_state <= S_25_2;
			  S_25_2 :
			      Next_state <= S_27;
			  S_27 :
			      Next_state <= S_18;
			  S_Pause_1 :
			      if (Continue)
					    Next_state <= S_Pause_2;
			  S_Pause_2 :
			      if (~Continue)
					    Next_state <= S_18;
            default : ;

         endcase
    end

    always_comb
    begin
        //default controls signal values; within a process, these can be
        //overridden further down (in the case statement, in this case)
        LD_MAR = 1'b0;
        LD_MDR = 1'b0;
        LD_IR  = 1'b0;
        LD_BEN = 1'b0;
        LD_CC  = 1'b0;
        LD_REG = 1'b0;
        LD_PC  = 1'b0;

        GatePC  = 1'b0;
        GateMDR = 1'b0;
        GateALU = 1'b0;
        GateMAR = 1'b0;

        ALUK_Mux_Select  = 2'b00;

        PC_Mux_Select    = 2'b00;
        DR_Mux_Select    = 1'b0;
        SR1_Mux_Select   = 1'b0;
        SR2_Mux_Select   = 1'b0;
        ADDR1_Mux_Select = 1'b0;
        ADDR2_Mux_Select = 2'b00;

        Mem_OE = 1'b1;
        Mem_WE = 1'b1;

        case (State)
            Halted: ;
            S_18 :
                begin
                    GatePC        = 1'b1;
                    LD_MAR        = 1'b1;
                    PC_Mux_Select = 2'b10;
                    LD_PC         = 1'b1;
                end
            S_33_1 :
                Mem_OE            = 1'b0;
            S_33_2 :
                begin
                    Mem_OE        = 1'b0;
                    LD_MDR        = 1'b1;
                end
            S_35 :
                begin
                    GateMDR       = 1'b1;
                    LD_IR         = 1'b1;
                end
            S_32 :
                LD_BEN            = 1'b1;
				S_00 : ;
            S_01 :
                begin
                    SR1_Mux_Select  = 1'b1;
                    SR2_Mux_Select  = ~IR_5;
                    ALUK_Mux_Select = 2'b10;
                    GateALU         = 1'b1;
                    LD_REG          = 1'b1;
                    LD_CC           = 1'b1;
                    DR_Mux_Select   = 1'b1;
                end
			   S_04 :
				    begin
					    GatePC          = 1'b1;
						 DR_Mux_Select   = 1'b0;
						 LD_REG          = 1'b1;
					 end
			   S_05 :
				    begin
                   SR1_Mux_Select  = 1'b1;
                   SR2_Mux_Select  = ~IR_5;
                   ALUK_Mux_Select = 2'b00;
                   GateALU         = 1'b1;
                   LD_REG          = 1'b1;
                   LD_CC           = 1'b1;
                   DR_Mux_Select   = 1'b1;
					 end
			   S_06 :
				    begin
                   SR1_Mux_Select   = 1'b1;
					    ADDR2_Mux_Select = 2'b10;
						 ADDR1_Mux_Select = 1'b0;
						 GateMAR          = 1'b1;
						 LD_MAR           = 1'b1;
					 end
			   S_07 :
				    begin
                   SR1_Mux_Select   = 1'b1;
					    ADDR2_Mux_Select = 2'b10;
						 ADDR1_Mux_Select = 1'b0;
						 GateMAR          = 1'b1;
						 LD_MAR           = 1'b1;
					 end
			   S_09 :
				    begin
                   SR1_Mux_Select  = 1'b1;
                   ALUK_Mux_Select = 2'b01;
                   GateALU         = 1'b1;
                   LD_REG          = 1'b1;
                   LD_CC           = 1'b1;
                   DR_Mux_Select   = 1'b1;
					 end
			   S_12 :
				    begin
                   SR1_Mux_Select  = 1'b1;
                   ALUK_Mux_Select = 2'b11;
                   GateALU         = 1'b1;
						 PC_Mux_Select   = 2'b00;
						 LD_PC           = 1'b1;
					 end
            S_16_1 :
					 Mem_WE             = 1'b0;
            S_16_2 :
			       Mem_WE             = 1'b0;
			   S_21 :
				    begin
					    ADDR2_Mux_Select = 2'b00;
						 ADDR1_Mux_Select = 1'b1;
			          PC_Mux_Select    = 2'b01;
						 LD_PC            = 1'b1;
					 end
			   S_22 :
				    begin
					    ADDR2_Mux_Select = 2'b01;
						 ADDR1_Mux_Select = 1'b1;
			          PC_Mux_Select    = 2'b01;
						 LD_PC            = 1'b1;
					 end
			   S_23 :
				    begin
						 SR1_Mux_Select   = 1'b0;
						 ALUK_Mux_Select  = 2'b11;
						 GateALU          = 1'b1;
						 LD_MDR           = 1'b1; 
					 end
            S_25_1 :
                Mem_OE            = 1'b0;
            S_25_2 :
                begin
                    Mem_OE        = 1'b0;
                    LD_MDR        = 1'b1;
                end
				S_27 :
					 begin
					     GateMDR       = 1'b1;
						  DR_Mux_Select = 1'b1;
						  LD_REG        = 1'b1;
						  LD_CC         = 1'b1;
					 end
            default : ;
           endcase
       end

    assign Mem_CE = 1'b0;
    assign Mem_UB = 1'b0;
    assign Mem_LB = 1'b0;

endmodule
