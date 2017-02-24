	 module hpi_io_intf( input [1:0]  from_sw_address,
								output[15:0] from_sw_data_in,
								input [15:0] from_sw_data_out,
								input		 	 from_sw_r,from_sw_w,from_sw_cs,
								inout [15:0] OTG_DATA,    
								output[1:0]	 OTG_ADDR,    
								output		 OTG_RD_N, OTG_WR_N, OTG_CS_N, OTG_RST_N, 
								input 		 OTG_INT, Clk, Reset);
								
logic [15:0] tmp_data;
logic from_sw_int; 

//Fill in the blanks below. 
assign OTG_RST_N = ~Reset;
assign OTG_DATA = (~from_sw_r) ? 16'bz : tmp_data; //Should be tristated

always_ff @ (posedge Clk or posedge Reset)
begin
	if(Reset)
	begin
		tmp_data 		 <= 16'b0;
		OTG_ADDR 		 <=  2'b0;
		OTG_RD_N 		 <=  1'b1;
		OTG_WR_N 		 <=  1'b1;
		OTG_CS_N 		 <=  1'b1;
		from_sw_data_in <= 16'b0;
		from_sw_int 	 <=  1'b0;
	end
	else 
	begin
		tmp_data 		 <= from_sw_data_out;
		OTG_ADDR 		 <= from_sw_address;
		OTG_RD_N			 <= from_sw_r;
		OTG_WR_N			 <= from_sw_w;
		OTG_CS_N			 <= from_sw_cs;
		from_sw_data_in <= OTG_DATA;
		from_sw_int 	 <= OTG_INT;
	end
end
endmodule 