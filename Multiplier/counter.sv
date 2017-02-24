module counter ( 
	input  logic      Reset, Enable, Clk,
	output logic[3:0] Count
);
	
    always_ff @ (posedge Clk)
    begin
    	if (Reset)
    		Count <= 4'b0;
    	else if (Enable)
    		Count++;
    	else 
    		Count <= Count;
    end

endmodule // counter