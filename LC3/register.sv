module register_16 (
	input  logic        Clk, load, reset,
	input  logic [15:0] data_in,
	output logic [15:0] data_out
);

	always_ff @(posedge Clk) begin
		if(reset) begin
			data_out <= 16'b0;
		end else if(load) begin
			data_out <= data_in;
		end
	end
endmodule

module register_1 (
    input  logic Clk, load, reset,
    input  logic data_in,
    output logic data_out
);

    always_ff @(posedge Clk) begin
        if(reset) begin
            data_out <= 1'b0;
        end else if(load) begin
            data_out <= data_in;
        end
    end
endmodule

module register_unit_8x16 (
    input  logic        Clk, LD_REG, reset,
    input  logic [2:0]  DR, SR1, SR2,
    input  logic [15:0] data_in,
    output logic [15:0] SR1_OUT, SR2_OUT
);
    logic        r0_load, r1_load, r2_load, r3_load, r4_load, r5_load, r6_load, r7_load;
    logic [15:0] r0_data, r1_data, r2_data, r3_data, r4_data, r5_data, r6_data, r7_data;

    register_16 r0(.Clk, .load(r0_load), .reset, .data_in, .data_out(r0_data));
    register_16 r1(.Clk, .load(r1_load), .reset, .data_in, .data_out(r1_data));
    register_16 r2(.Clk, .load(r2_load), .reset, .data_in, .data_out(r2_data));
    register_16 r3(.Clk, .load(r3_load), .reset, .data_in, .data_out(r3_data));
    register_16 r4(.Clk, .load(r4_load), .reset, .data_in, .data_out(r4_data));
    register_16 r5(.Clk, .load(r5_load), .reset, .data_in, .data_out(r5_data));
    register_16 r6(.Clk, .load(r6_load), .reset, .data_in, .data_out(r6_data));
    register_16 r7(.Clk, .load(r7_load), .reset, .data_in, .data_out(r7_data));

    always_comb begin
        unique case(SR1)
        3'b000 : SR1_OUT <= r0_data;
        3'b001 : SR1_OUT <= r1_data;
        3'b010 : SR1_OUT <= r2_data;
        3'b011 : SR1_OUT <= r3_data;
        3'b100 : SR1_OUT <= r4_data;
        3'b101 : SR1_OUT <= r5_data;
        3'b110 : SR1_OUT <= r6_data;
        3'b111 : SR1_OUT <= r7_data;
		  default : SR1_OUT <= 16'bx;
        endcase // SR1
        unique case(SR2)
        3'b000 : SR2_OUT <= r0_data;
        3'b001 : SR2_OUT <= r1_data;
        3'b010 : SR2_OUT <= r2_data;
        3'b011 : SR2_OUT <= r3_data;
        3'b100 : SR2_OUT <= r4_data;
        3'b101 : SR2_OUT <= r5_data;
        3'b110 : SR2_OUT <= r6_data;
        3'b111 : SR2_OUT <= r7_data;
		  default : SR2_OUT <= 16'bx;
        endcase // SR2
    end

    always_comb begin // decode DR and LD_REG signals
        r0_load <= 1'b0;
        r1_load <= 1'b0;
        r2_load <= 1'b0;
        r3_load <= 1'b0;
        r4_load <= 1'b0;
        r5_load <= 1'b0;
        r6_load <= 1'b0;
        r7_load <= 1'b0;
        if (LD_REG) begin
            unique case(DR)
            3'b000 : r0_load <= 1'b1;
            3'b001 : r1_load <= 1'b1;
            3'b010 : r2_load <= 1'b1;
            3'b011 : r3_load <= 1'b1;
            3'b100 : r4_load <= 1'b1;
            3'b101 : r5_load <= 1'b1;
            3'b110 : r6_load <= 1'b1;
            3'b111 : r7_load <= 1'b1;
            endcase // DR
        end
    end

endmodule