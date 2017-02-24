//------------------------------------------------------------------------------
// Company:          UIUC ECE Dept.
// Engineer:         Stephen Kempf
//
// Create Date:    
// Design Name:    ECE 385 Lab 6 Given Code - SLC-3 top-level (External SRAM)
// Module Name:    SLC3
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 09-22-2015    
//------------------------------------------------------------------------------


module slc3 (
    input  logic [15:0] S,
    input  logic        Clk, Reset, Run, Continue,
    output logic [11:0] LED,
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3,
    output logic        CE, UB, LB, OE, WE,
    output logic [19:0] ADDR,
    inout  wire  [15:0] Data //tristate buffers need to be of type wire
);

//Declaration of push button active high signals    
logic Reset_ah, Continue_ah, Run_ah;

assign Reset_ah = ~Reset;
assign Continue_ah = ~Continue;
assign Run_ah = ~Run;

// **** INTERCONNECTS ****
logic [15:0] BUS;

// register outputs
logic [15:0] REG_MAR_OUT, REG_MDR_OUT, REG_IR_OUT, REG_PC_OUT;
logic        REG_N_OUT, REG_Z_OUT, REG_P_OUT, REG_BEN_OUT;

logic [15:0] REG_SR1_OUT, REG_SR2_OUT;

// mux outputs
logic [2:0]  MUX_DR_OUT, MUX_SR1_OUT;
logic [15:0] MUX_ADDR1_OUT, MUX_ADDR2_OUT, MUX_MDR_OUT, MUX_PC_OUT, MUX_SR2_OUT;

// computation outputs
logic [15:0] ALU_MAIN_OUT, ALU_ADDER_OUT, ALU_PC_INCREMENT_OUT;

// An array of 4-bit wires to connect the hex_drivers efficiently to wherever we want
// For Lab 1, they will direclty be connected to the IR register through an always_comb circuit
// For Lab 2, they will be patched into the MEM2IO module so that Memory-mapped IO can take place
logic [3:0] hex_4[3:0]; 
HexDriver hex_drivers[3:0] (hex_4, {HEX3, HEX2, HEX1, HEX0});
// This works thanks to http://stackoverflow.com/questions/1378159/verilog-can-we-have-an-array-of-custom-modules

assign LED = REG_IR_OUT[11:0];

// Internal connections
logic        MIO_EN;

logic        LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC;
logic        GatePC, GateMDR, GateALU, GateMAR;
logic        DR_Mux_Select, SR1_Mux_Select, SR2_Mux_Select, ADDR1_Mux_Select;
logic [1:0]  PC_Mux_Select, ADDR2_Mux_Select, ALUK_Mux_Select;

// nzp register inputs
logic 		 N_Data_In, Z_Data_In, P_Data_In, BEN_Data_In;

logic [15:0] Data_Mem_In, Data_Mem_Out, Data_CPU_Out;

//  Connect MAR to ADDR, which is also connected as an input into MEM2IO
//  MEM2IO will determine what gets put onto Data_CPU (which serves as a potential
//  input into MDR)
assign ADDR = { 4'b00, REG_MAR_OUT }; //Note, our external SRAM chip is 1Mx16, but address space is only 64Kx16
assign MIO_EN = ~OE;

// nzp register logic
assign N_Data_In   = BUS[15];
assign Z_Data_In   = (BUS == 16'b0) ? 1'b1 : 1'b0;
assign P_Data_In   = ~BUS[15] & ~Z_Data_In;
assign BEN_Data_In = (REG_IR_OUT[11] & REG_N_OUT) | (REG_IR_OUT[10] & REG_Z_OUT) | (REG_IR_OUT[9] & REG_P_OUT);

// Break the tri-state bus to the ram into input/outputs 
tristate #(.N(16)) tr0 (
    .Clk(Clk), .OE(~WE), .In(Data_Mem_Out), .Out(Data_Mem_In), .Data(Data)
);

// Our SRAM and I/O controller (note, this plugs into MDR/MAR
Mem2IO memory_subsystem (
    .Clk, .Reset(Reset_ah), .A(ADDR), .Switches(S),
    .CE, .UB, .LB, .OE, .WE,
    .Data_CPU_In(REG_MDR_OUT), .Data_Mem_In,
    .Data_CPU_Out, .Data_Mem_Out,
    .HEX0(hex_4[0]), .HEX1(hex_4[1]), .HEX2(hex_4[2]), .HEX3(hex_4[3])
);

//test_memory TEST_MEMORY (
//	.Clk, .Reset(Reset_ah),
//	.I_O(Data), .A(ADDR),
//   .CE, .UB, .LB, .OE, .WE
//);

ISDU state_controller (
    // INPUTS
    .Clk, .Reset(Reset_ah), .Run(Run_ah), .Continue(Continue_ah), .ContinueIR(Continue_ah),
    .Opcode(REG_IR_OUT[15:12]), .IR_5(REG_IR_OUT[5]), .REG_BEN_OUT,

    // OUTPUTS
    .LD_MAR, .LD_MDR, .LD_IR, .LD_BEN, .LD_CC, .LD_REG, .LD_PC,
    .GatePC, .GateMDR, .GateALU, .GateMAR,
    .PC_Mux_Select, .ADDR2_Mux_Select, .ALUK_Mux_Select,
    .DR_Mux_Select, .SR1_Mux_Select, .SR2_Mux_Select, .ADDR1_Mux_Select,
    .Mem_CE(CE), .Mem_UB(UB), .Mem_LB(LB), .Mem_OE(OE), .Mem_WE(WE)
);

// **** REGISTERS ****
register_16 REG_MAR (
    .Clk, .load(LD_MAR), .reset(Reset_ah),
    .data_in(BUS),
    .data_out(REG_MAR_OUT)
);

register_16 REG_MDR (
    .Clk, .load(LD_MDR), .reset(Reset_ah),
    .data_in(MUX_MDR_OUT),
    .data_out(REG_MDR_OUT)
);

register_16 REG_IR (
    .Clk, .load(LD_IR), .reset(Reset_ah),
    .data_in(BUS),
    .data_out(REG_IR_OUT)
);

register_16 REG_PC (
    .Clk, .load(LD_PC), .reset(Reset_ah),
    .data_in(MUX_PC_OUT),
    .data_out(REG_PC_OUT)
);


// **
register_1 REG_N (
    .Clk, .load(LD_CC), .reset(Reset_ah),
    .data_in(N_Data_In),
    .data_out(REG_N_OUT)
);

register_1 REG_Z (
    .Clk, .load(LD_CC), .reset(Reset_ah),
    .data_in(Z_Data_In),
    .data_out(REG_Z_OUT)
);

register_1 REG_P (
    .Clk, .load(LD_CC), .reset(Reset_ah),
    .data_in(P_Data_In),
    .data_out(REG_P_OUT)
);

register_1 REG_BEN (
    .Clk, .load(LD_BEN), .reset(Reset_ah),
    .data_in(BEN_Data_In),
    .data_out(REG_BEN_OUT)
);
// **

register_unit_8x16 REG_FILE (
    .Clk, .LD_REG, .reset(Reset_ah),
    .DR(MUX_DR_OUT), .SR1(MUX_SR1_OUT), .SR2(REG_IR_OUT[2:0]),
    .data_in(BUS),
    .SR1_OUT(REG_SR1_OUT), .SR2_OUT(REG_SR2_OUT)
);


// BUS
bus BUS_Main (
    .GatePC, .GateMDR, .GateALU, .GateMAR,
    .PC(REG_PC_OUT), .MDR(REG_MDR_OUT), .ALU(ALU_MAIN_OUT), .MAR(ALU_ADDER_OUT),
    .BusValue(BUS)
);


// MUXES
mux_2x3 MUX_DR (
    .IN_0(3'b111), .IN_1(REG_IR_OUT[11:9]),
    .SELECT(DR_Mux_Select),
    .OUT(MUX_DR_OUT)
);

mux_2x3 MUX_SR1 (
    .IN_0(REG_IR_OUT[11:9]), .IN_1(REG_IR_OUT[8:6]),
    .SELECT(SR1_Mux_Select),
    .OUT(MUX_SR1_OUT)
);

mux_2x16 MUX_ADDR1 (
    .IN_0(REG_SR1_OUT), .IN_1(REG_PC_OUT),
    .SELECT(ADDR1_Mux_Select),
    .OUT(MUX_ADDR1_OUT)
);

mux_2x16 MUX_SR2 (
    .IN_0( { {11{REG_IR_OUT[4]}}, REG_IR_OUT[4:0]} ), .IN_1(REG_SR2_OUT),
    .SELECT(SR2_Mux_Select),
    .OUT(MUX_SR2_OUT)
);

mux_2x16 MUX_MDR (
    .IN_0(BUS), .IN_1(Data_CPU_Out),
    .SELECT(MIO_EN),
    .OUT(MUX_MDR_OUT)
);

mux_4x16 MUX_PC (
    .IN_0(BUS), .IN_1(ALU_ADDER_OUT), .IN_2(ALU_PC_INCREMENT_OUT), .IN_3(16'bx),
    .SELECT(PC_Mux_Select),
    .OUT(MUX_PC_OUT)
);

mux_4x16 MUX_ADDR2 (
    .IN_0( {  {5{REG_IR_OUT[10]}}, REG_IR_OUT[10:0]} ),
    .IN_1( {  {7{REG_IR_OUT[ 8]}}, REG_IR_OUT[ 8:0]} ),
    .IN_2( { {10{REG_IR_OUT[ 5]}}, REG_IR_OUT[ 5:0]} ),
    .IN_3(16'b0),
    .SELECT(ADDR2_Mux_Select),
    .OUT(MUX_ADDR2_OUT)
);

// COMPUTATION
alu ALU_MAIN (
    .F(ALUK_Mux_Select),
    .A_In(REG_SR1_OUT), .B_In(MUX_SR2_OUT),
    .F_A_B(ALU_MAIN_OUT)
);

alu ALU_ADDER (
    .F(2'b10),
    .A_In(MUX_ADDR2_OUT), .B_In(MUX_ADDR1_OUT),
    .F_A_B(ALU_ADDER_OUT)
);

alu ALU_PC_INCREMENT (
    .F(2'b10),
    .A_In(REG_PC_OUT), .B_In(16'b01),
    .F_A_B(ALU_PC_INCREMENT_OUT)
);

endmodule 