//synchronizer with reset to 0 (d_ff)
module sync_r0 (
	input  logic Clk, Reset, d, 
	output logic q
);

initial
begin	
	q <= 1'b0;
end

always_ff @ (posedge Clk or posedge Reset)
begin
	if (Reset)
		q <= 1'b0;
	else
		q <= d;
end

endmodule