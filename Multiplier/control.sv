module control (
    input  logic[7:0] Switch, Adder_Result, 
    input  logic Clk, Reset, Run, ClearA_LoadB, M,

    output logic Load_A, Load_B, Shift_Enable_AB, Adder_Add,
    output logic[7:0] Load_Data_A, Load_Data_B
);

    logic      Counter_Reset_wire, Counter_Enable_wire;
    logic[3:0] Counter_Value;

    enum logic [2:0] {S_Init, S_Reset, S_ClearALoadB, 
                      S_Prep, S_Add, S_Subtract, S_Shift}  curr_state, next_state;
    
    counter COUNTER(.Reset(Counter_Reset_wire), .Enable(Counter_Enable_wire), .Clk, .Count(Counter_Value));

    always_ff @ (posedge Clk) begin
		  if (Reset)
		      curr_state = S_Reset;
		  else
            curr_state = next_state;
    end

    always_comb begin
        unique case (curr_state) 
            S_Init        : begin 
                if (ClearA_LoadB)
                    next_state = S_ClearALoadB;
                else if (Run)
                    next_state = S_Prep;
                else
                    next_state = S_Init;
            end 
            S_Reset       : next_state = S_Init;
            S_ClearALoadB : next_state = S_Init;
            S_Prep        : begin
                if (Counter_Value == 8) begin
                    if (Run)
                        next_state = S_Prep;
                    else 
                        next_state = S_Init;
                end else begin
                    if (M == 0) begin
                        next_state = S_Shift;
                    end else begin
                        if (Counter_Value == 7) begin
                            next_state = S_Subtract;
                        end else begin
                            next_state = S_Add;
                        end
                    end
                end
            end
            S_Add         : next_state = S_Shift;
            S_Subtract    : next_state = S_Shift;
            S_Shift       : next_state = S_Prep;
        endcase
   end

   always_comb begin
			Load_A          = 0;
			Load_B          = 0;
			Shift_Enable_AB = 0;
			Load_Data_A     = 8'b0;
			Load_Data_B     = 8'b0;
			Adder_Add       = 1;
			Counter_Reset_wire  = 0;
			Counter_Enable_wire = 0;

        // Assign outputs based on ‘state’
        unique case (curr_state)
            S_Init : begin
                Counter_Reset_wire  = 1;
					 if (next_state == S_Prep) 
					     Load_A = 1;
            end
            S_Reset : begin
                Load_A          = 1;
                Load_B          = 1;
                Counter_Reset_wire  = 1;
            end
            S_ClearALoadB : begin
                Load_A          = 1;
                Load_B          = 1;
                Load_Data_B     = Switch;
                Counter_Reset_wire  = 1;
            end
            S_Prep : begin end
            S_Add : begin
                Load_A          = 1;
                Load_Data_A     = Adder_Result;
            end
            S_Subtract : begin
					 Adder_Add       = 0;
                Load_A          = 1;
                Load_Data_A     = Adder_Result;
            end
            S_Shift : begin
                Shift_Enable_AB = 1;
                Counter_Enable_wire = 1;
            end
        endcase
    end
endmodule