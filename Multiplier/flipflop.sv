module flipflop(
	input 	logic D,
	input 	logic Clk, Reset,
	output 	logic Q
);

    always_ff @ (posedge Clk)
	 begin
		if(Reset)
			Q <= 1'b0;
		else
			Q <= D;
	 end

endmodule 