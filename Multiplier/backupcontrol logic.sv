        // Assign outputs based on ‘state’
        unique case (curr_state)
            S_Init : begin
                    Load_A          = 0;
                    Load_B          = 0;
                    Shift_Enable_AB = 0;
                    Load_Data_A     = 8'b0;
                    Load_Data_B     = 8'b0;
                    Adder_Add       = 1;
                    Counter_Reset_wire  = 1;
                    Counter_Enable_wire = 0;
                end
            S_Reset : begin
                    Load_A          = 1;
                    Load_B          = 1;
                    Shift_Enable_AB = 0;
                    Load_Data_A     = 8'b0;
                    Load_Data_B     = 8'b0;
                    Adder_Add       = 1;
                    Counter_Reset_wire  = 1;
                    Counter_Enable_wire = 0;
            end
            S_ClearALoadB : begin
                    Load_A          = 1;
                    Load_B          = 1;
                    Shift_Enable_AB = 0;
                    Load_Data_A     = 8'b0;
                    Load_Data_B     = Switch;
                    Adder_Add       = 1;
                    Counter_Reset_wire  = 1;
                    Counter_Enable_wire = 0;
            end
            S_Prep : begin
                if (next_state == S_Shift) begin
                    Load_A          = 0;
                    Load_B          = 0;
                    Shift_Enable_AB = 1;
                    Load_Data_A     = 8'b0;
                    Load_Data_B     = 8'b0;
                    Adder_Add       = 1;
                    Counter_Reset_wire  = 0;
                    Counter_Enable_wire = 0;
                end else begin 
                    Load_A          = 1;
                    Load_B          = 0;
                    Shift_Enable_AB = 0;
                    Load_Data_A     = 8'b0;
                    Load_Data_B     = 8'b0;
                    Adder_Add = 1;
                    Counter_Reset_wire  = 0;
                    Counter_Enable_wire = 0;
                end 
            end
            S_Add : begin
                Load_A          = 0;
                Load_B          = 0;
                Shift_Enable_AB = 0;
                Load_Data_A     = Adder;
                Load_Data_B     = 8'b0;
                Adder_Add       = 1;
                Counter_Reset_wire  = 0;
                Counter_Enable_wire = 0;

            end
            S_Subtract : begin

            end
            S_Shift : begin

            end

        endcase