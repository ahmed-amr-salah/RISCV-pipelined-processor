`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2023 01:06:50 AM
// Design Name: 
// Module Name: top_pipeline
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/*******************************************************************
*
* Module: top.v
* Project: pipeline_implementation
* Author: Ahmed Amin & Amena Hossam and aahmedamr221201@aucegypt.edu & amna_elsaqa12@aucegypt.edu
* Description: this is the top module that rums the pipeline
*
* Change history: 29/04/2023: the top module was ceated and tested 
*
**********************************************************************/

module top(input clk, input rst);


wire PCrst,Pc_halt;
wire [31:0] PC_in, PC_out;
//wire [31:0] instruction;
wire MemRead, MemWrite, RegWrite, MemToReg, ALUSrc;
wire  cf, zf, vf, sf;
wire [1:0] RegData;wire [1:0] branch_signal;wire [1:0]PCSrc;
wire [3:0] ALUOp; 
wire [12:0] Ctrl_Signals;
wire [31:0] memAddress;
wire [31:0] PcPlusImmediate;
wire [31:0] PcPlusFour;
wire [31:0] write_data;
wire [31:0] read1, read2;
wire [31:0] imm_out; 
wire forwardA,forwardB;
wire [31:0] ALU_input1,ALU_input2,ALU_pre_input2;
wire [3:0] ALUSel;
wire [31:0] ALUResult;
wire [31:0] shift_out;
wire [31:0] data_out_from_memory;
wire [31:0] muxTomux;
wire [31:0] IF_ID_PC, IF_ID_Inst, IF_ID_PcPlusFour;
wire [31:0] ID_EX_PC,ID_EX_PcPlusFour , ID_EX_Imm;
wire [12:0] ID_EX_Ctrl;
wire [2:0] ID_EX_Func3;wire [2:0] EX_MEM_Func3; 
wire [4:0] ID_EX_Rd;wire [4:0] ID_EX_RegR1;wire [4:0] ID_EX_RegR2;
wire [4:0] ID_EX_Shamt;
wire ID_EX_bit30;
wire [31:0] EX_MEM_PCaddImm,EX_MEM_PcFour, EX_MEM_ALU_out, EX_MEM_ALUInputTwo;
wire [5:0] EX_MEM_Ctrl;
wire EX_MEM_Zero;
wire [4:0] EX_MEM_Rd;
wire [31:0] MEM_WB_Mem_out, MEM_WB_ALU_out;
wire [3:0] MEM_WB_Ctrl;//(1:0)->Reg_Data // (3) RegWrite // MemToReg (2)
wire [4:0] MEM_WB_Rd; 
wire [31:0] MEM_WB_PcPlusFour,MEM_WB_PcPlusImmediate,MEM_WB_ALuOut,MEM_WB_MemData;
wire [31:0] ID_EX_RegisterRs1 , ID_EX_RegisterRs2;
wire stall;
//wire EX_MEM_RegWrite,MEM_WB_RegWrite;
//Slow clk 

//PC_mux
MUX_4x1 #(32) Pc_Mux(.a(PcPlusFour), .b(EX_MEM_PCaddImm),.c(EX_MEM_ALU_out), .d(32'b0),.sel(PCSrc),.out(PC_in));
//PC_reg
n_bit_register #(32) pc(.clk(clk),.rst(PCrst|rst),.load(~Pc_halt),.Data(PC_in),.Q(PC_out));  
//Dual Memory Mux
Mux2x1 MemMux(.a(EX_MEM_ALU_out),.b(PC_out),.sel(clk),.out(memAddress));
//Dual Memory  -- (MemRead,MemWrite,RegWrite,MemToReg,RegData)
DataMemory Dual_Memory(.clk(clk),.MemRead(EX_MEM_Ctrl[5]),.func3(EX_MEM_Func3),.MemWrite(EX_MEM_Ctrl[4]),.addr(memAddress),
.data_in(EX_MEM_ALUInputTwo),.data_out(data_out_from_memory));
//PC+4
Adder Pc_four(.sourceOne(PC_out),.sourceTwo(32'd4),.Result(PcPlusFour));
//IF/ID Reg
Reg #(200) IF_ID(.clk(~clk),.rst(rst),.load(1'b1),.data_in({PcPlusFour,PC_out,data_out_from_memory}),.data_out({IF_ID_PcPlusFour,IF_ID_PC,IF_ID_Inst}));
//Control Unit
Control_unit CU(.inst(IF_ID_Inst),.AluOp(ALUOp),.MemRead(MemRead),
.MemWrite(MemWrite),.RegWrite(RegWrite),.ALUSrc(ALUSrc),
.MemToReg(MemToReg),.RegData(RegData),.Branch(branch_signal),.pc_rst(PCrst),.pc_halt(Pc_halt));
//immediate_generator
imm_gen immGen(.IR(IF_ID_Inst), .Imm(imm_out));
//mux reg file 
MUX_4x1 #(32) Mux_reg_file(.a(MEM_WB_PcPlusFour), .b(MEM_WB_PcPlusImmediate),.c(muxTomux), .d(32'b0),.sel(MEM_WB_Ctrl[1:0]),.out(write_data));
//Register File 
reg_file #(32,32) RegisterFile(.RegWrite( MEM_WB_Ctrl[3]),.clk(~clk),.rst(rst),.RAdress1(IF_ID_Inst[`IR_rs1]),
.RAdress2(IF_ID_Inst[`IR_rs2]),.WAddress(MEM_WB_Rd),.WData(write_data),.RData1(read1),.RData2(read2));
//Control_Mux
Mux2x1 #(13) Control_mux(.a({ALUOp,MemRead,MemWrite,RegWrite,ALUSrc,MemToReg,RegData,branch_signal}),.b(13'd0),
.sel(PCSrc[0]|PCSrc[1]),.out(Ctrl_Signals));
// ID_Ex Register 
Reg #(400) ID_EX(.clk(clk),.rst(rst),.load(1'b1),
.data_in({Ctrl_Signals,IF_ID_PcPlusFour,IF_ID_PC,read1,read2,imm_out,IF_ID_Inst[`IR_funct3],IF_ID_Inst[`IR_rs1],IF_ID_Inst[`IR_rs2],IF_ID_Inst[`IR_rd],IF_ID_Inst[30],IF_ID_Inst[`IR_shamt]}),
.data_out({ID_EX_Ctrl,ID_EX_PcPlusFour,ID_EX_PC,ID_EX_RegisterRs1,ID_EX_RegisterRs2,ID_EX_Imm,ID_EX_Func3,ID_EX_RegR1,ID_EX_RegR2,ID_EX_Rd,ID_EX_bit30,ID_EX_Shamt}));
//PC_Imm
Adder Pc_imm(.sourceOne(ID_EX_PC),.sourceTwo(ID_EX_Imm),.Result(PcPlusImmediate));
//Forwarding_Unit
Forwarding_unit FW(.ID_EX_RegisterRs1(ID_EX_RegR1),.ID_EX_RegisterRs2(ID_EX_RegR2),.MEM_WB_RegisterRd(MEM_WB_Rd),.MEM_WB_RegWrite(MEM_WB_Ctrl[3]),
.forwardA(forwardA),.forwardB(forwardB));
//Src_Two_First_Mux -- ID_EX_RegisterRs2 -- muxTomux
Mux2x1 SrcTwoFirstMux(.a(ID_EX_RegisterRs2),.b(muxTomux),.sel(forwardB),.out(ALU_pre_input2));
//Src_two_Second_Mux
Mux2x1 SrcTwoSecondMux(.a(ALU_pre_input2),.b(ID_EX_Imm),.sel(ID_EX_Ctrl[5]),.out(ALU_input2));
//Scr_one_Mux  -- ID_EX_RegisterRs1 --muxTomux
Mux2x1 SrcOneMux(.a(ID_EX_RegisterRs1),.b(muxTomux),.sel(forwardA),.out(ALU_input1));
//ALUControlUnit 
ALU_control ALUControl(.ALUOp(ID_EX_Ctrl[12:9]),.funct3(ID_EX_Func3),.bit30(ID_EX_bit30),.ALU_sel(ALUSel));
//ALU 
prv32_ALU ALU(.a(ALU_input1),.b(ALU_input2),.shamt(ID_EX_Shamt),.r(ALUResult),.cf(cf),.zf(zf),.vf(vf),.sf(sf),.alufn(ALUSel));
//prv32_ALU ALU(.a(read1),.b(ALU_input2),.shamt(instruction[`IR_shamt]),.r(ALUResult),.cf(cf),.zf(zf),.vf(vf),.sf(sf),.alufn(ALUSel));
//Branching_Unit
branch_control BR(.branchOp(ID_EX_Ctrl[1:0]),.funct3(ID_EX_Func3),.zf(zf),.cf(cf),.sf(sf),.vf(vf),.PCSrc(PCSrc));
//Ex_MEM ctrl(MemRead,MemWrite,RegWrite,MemToReg,RegData)
Reg #(300) EX_MEM(.clk(~clk),.rst(rst),.load(1'b1),.data_in({ID_EX_Ctrl[8:6],ID_EX_Ctrl[4:2],ID_EX_PcPlusFour,PcPlusImmediate,ALUResult,ALU_pre_input2,ID_EX_Func3,ID_EX_Rd}),
.data_out({EX_MEM_Ctrl,EX_MEM_PcFour,EX_MEM_PCaddImm,EX_MEM_ALU_out,EX_MEM_ALUInputTwo,EX_MEM_Func3,EX_MEM_Rd}));
//MEM_WB
Reg #(300) MEM_WB(.clk(clk),.rst(rst),.load(1'b1),.data_in({EX_MEM_Ctrl[3:0],EX_MEM_PcFour,EX_MEM_PCaddImm,EX_MEM_ALU_out,data_out_from_memory,EX_MEM_Rd}),
.data_out({MEM_WB_Ctrl,MEM_WB_PcPlusFour,MEM_WB_PcPlusImmediate,MEM_WB_ALuOut,MEM_WB_MemData,MEM_WB_Rd}));
//Write_Back_Mux
Mux2x1 WriteBack(.a(MEM_WB_ALuOut),.b(MEM_WB_MemData),.sel(MEM_WB_Ctrl[2]),.out(muxTomux));
//
/* 
wire PCrst,Pc_halt;
wire [31:0] PC_in, PC_out,PC_four,PC_imm;
wire [31:0] instruction;
wire MemRead, MemWrite, RegWrite, MemToReg, ALUSrc;
wire  cf, zf, vf, sf;
wire [1:0] RegData;wire [1:0] Branch;wire [1:0]PCSrc;
wire [3:0] ALUOp;
wire [31:0] PcPlusImmediate;
wire [31:0] PcPlusFour;
wire [31:0] write_data;
wire [31:0] read1, read2;
wire [31:0] imm_out; 
wire [31:0] ALU_input2;
wire [3:0] ALUSel;
wire [31:0] ALUResult;
wire [31:0] shift_out;
wire [31:0] mem_data;
wire [31:0] muxTomux;


//Program_counter
n_bit_register pc(.clk(clk),.rst(PCrst|rst),.load(1'b1&~Pc_halt),.Data(PC_in),.Q(PC_out));
//instruction_memory 
inst_memory instructionMemory(.address({PC_out[7:2]}),.data(instruction));
//Control_unit
Control_unit ControlUnit(.op_code(instruction[`IR_opcode]),.bit21(instruction[21]),.AluOp(ALUOp),.MemRead(MemRead),
.MemWrite(MemWrite),.RegWrite(RegWrite),.ALUSrc(ALUSrc),
.MemToReg(MemToReg),.RegData(RegData),.Branch(Branch),.pc_rst(PCrst),.pc_halt(Pc_halt));
//Register_file
reg_file register_file(.RegWrite(RegWrite),.clk(clk), .rst(rst), .RAdress1(instruction[`IR_rs1]), .RAdress2(instruction[`IR_rs2]), 
.WAddress(instruction[`IR_rd]), .WData(write_data), .RData1(read1), .RData2(read2));
//Immediate_generator
imm_gen immediate_generator(.IR(instruction),.Imm(imm_out));
//AlU_Control_Unit
ALU_control ALUControl(.ALUOp(ALUOp),.funct3(instruction[`IR_funct3]),.bit30(instruction[30]),.ALU_sel(ALUSel));
//branch unit
branch_control bu(.branchOp(Branch),.funct3(instruction[`IR_funct3]),.zf(zf),.cf(cf),.sf(sf),.vf(vf),.PCSrc(PCSrc));
//ALU Mux
Mux2x1 ALU_MUX(.a(read2),.b(imm_out),.sel(ALUSrc),.out(ALU_input2));
//ALU
prv32_ALU ALU(.a(read1),.b(ALU_input2),.shamt(instruction[`IR_shamt]),.r(ALUResult),.cf(cf),.zf(zf),.vf(vf),.sf(sf),.alufn(ALUSel));
//Data Memory
DataMemory datamemory(.clk(clk),.MemRead(MemRead),.func3(instruction[`IR_funct3]),.MemWrite(MemWrite),.addr(ALUResult),
.data_in(read2),.data_out(mem_data));
// after memory mux
Mux2x1 Mux_Mux(.a(ALUResult),.b(mem_data),.sel(MemToReg),.out(muxTomux));
//Pc+immediate 
Adder Pc_Immediate(.sourceOne(PC_out),.sourceTwo(imm_out),.Result(PcPlusImmediate));
//Pc+four 
Adder Pc_four(.sourceOne(PC_out),.sourceTwo(32'd4),.Result(PcPlusFour));
//PC_MUX
MUX_4x1 PC_Mux(.a(PcPlusFour),.b(PcPlusImmediate ),.c(ALUResult),.d(32'd0),.sel(PCSrc),.out(PC_in));
//WB MUX
MUX_4x1 WB_Mux(.a(PcPlusFour),.b(PcPlusImmediate),.c(muxTomux),.d(32'd0),.sel(RegData),.out(write_data));   
*/
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
//PC_reg
NBitRegister#(32) pc(.clk(clk),.rst(rst),.load(~stall),.Data(PC_in),.Q(PC_out));
//Instruction Memory
InstructionMemory inst(.address({PC_out[7:2]}),.data(instruction));
//IF/ID Register
Reg #(200) IF_ID(.clk(clk),.rst(rst),.load(~stall),.data_in({PC_out,instruction}),.data_out({IF_ID_PC,IF_ID_Inst}));
// Control unit
ControlUnit#(32) CU(.instruction(IF_ID_Inst),.Branch(branch_signal),.MemRead(MemRead), .MemtoReg(MemToReg),
.ALUOp(ALUOp), .MemWrite(MemWrite), .ALUSrc(ALUSrc),.RegWrite(RegWrite));
//Reg File
RegFile #(32,32) RF(.RegWrite(MEM_WB_Ctrl[1]),.clk(~clk),.rst(rst), .RAdress1(IF_ID_Inst[19:15]), .RAdress2(IF_ID_Inst[24:20]),
.WAddress(MEM_WB_Rd), .WData(write_data), .RData1(read1), .RData2(read2));
//immediate_generator
immediate_generator imm_gen(.opCode(IF_ID_Inst), .immediate(imm_out));
//ID_EX
Reg #(300) ID_EX(.clk(clk),.rst(rst),.load(1'b1),.data_in({ID_EX_Ctrl_input,IF_ID_PC,read1,read2,imm_out,
IF_ID_Inst[30],IF_ID_Inst[14:12],IF_ID_Inst[11:7],IF_ID_Inst[19:15],IF_ID_Inst[24:20]}),.data_out({ID_EX_Ctrl,ID_EX_PC,ID_EX_RegR1,ID_EX_RegR2,ID_EX_Imm,ID_EX_Func,
ID_EX_Rd,ID_EX_RegisterRs1,ID_EX_RegisterRs2}));
//Shift imm left by 1
Shif_left#(32)shifter(.A(ID_EX_Imm), .out(shift_out));
//PC = PC + imm
RCA #(32)PC_Add_imm(.A(ID_EX_PC),.B(shift_out),.cin(1'b0),.sum(PC_imm));
//Hazard_detection 
hazard_detection_unit h(.clk(clk),.IF_ID_RegisterRs1(IF_ID_Inst[19:15]),.IF_ID_RegisterRs2(IF_ID_Inst[24:20]),.ID_EX_RegisterRd(ID_EX_Rd),
.ID_EX_MemRead(ID_EX_Ctrl[4]),.stall(stall));
//control_signal_mux 
NBit_mux#(8) controlSignalMUX(.A({RegWrite,MemToReg,branch_signal,MemRead,MemWrite,ALUOp,ALUSrc}), .B(8'd0), .sel(stall), .out(ID_EX_Ctrl_input));
// ALU MUX (Selects ALU second input)ID_EX_Imm
NBit_mux#(32) ALUMux(.A(ALU_Pre_input2), .B(ID_EX_Imm), .sel(ID_EX_Ctrl[0]), .out(ALU_input2));
//ALU Control
ALUControlUnit ALUC(.AluOP(ID_EX_Ctrl[2:1]), .bit30(ID_EX_Func[3]) , .func7(ID_EX_Func[2:0]),.ALUselction(ALUSel));
//fORWARDING_UNIT
Forwarding_unit FU(.ID_EX_RegisterRs1(ID_EX_RegisterRs1),.ID_EX_RegisterRs2(ID_EX_RegisterRs2),
.EX_MEM_RegisterRd(EX_MEM_Rd),.MEM_WB_RegisterRd(MEM_WB_Rd),.EX_MEM_RegWrite(EX_MEM_Ctrl[4]),.MEM_WB_RegWrite(MEM_WB_Ctrl[1]),.forwardA(forwardA),.forwardB(forwardB));
//MUX ALU Input 1 (rs1)
MUX_4x1 m1(.a(ID_EX_RegR1), .b(write_data), .c(EX_MEM_ALU_out), .d(32'd0), .sel(forwardA), .out(ALU_input1));
// MUX ALU Input 2 (rs2) // 
MUX_4x1 m2(.a(ID_EX_RegR2), .b(write_data), .c(EX_MEM_ALU_out), .d(32'd0), .sel(forwardB), .out(ALU_Pre_input2));
//ALU
NbitALU #(32) ALU(.A(ALU_input1), .B(ALU_input2), .sel(ALUSel),.out(ALUResult), .zero_flag(zero));
//EX/MEM
Reg #(300) EX_MEM(.clk(clk),.rst(rst),.load(1'b1),.data_in({ID_EX_Ctrl[7:3],PC_imm,zero,ALUResult,ALU_Pre_input2,ID_EX_Rd})
,.data_out({EX_MEM_Ctrl,EX_MEM_PCaddImm,EX_MEM_Zero,EX_MEM_ALU_out,EX_MEM_RegR2,EX_MEM_Rd}));
//Data Memory
DataMemory mem(.clk(clk), .MemRead(EX_MEM_Ctrl[1]), .MemWrite(EX_MEM_Ctrl[0]),.addr({2'b00,EX_MEM_ALU_out[5:2]}),
.data_in(EX_MEM_RegR2), .data_out(mem_data));
//MEM/WB
Reg #(300) MEM_WB(.clk(clk),.rst(rst),.load(1'b1),.data_in({EX_MEM_Ctrl[4:3],mem_data,EX_MEM_ALU_out,EX_MEM_Rd}),.data_out({MEM_WB_Ctrl,MEM_WB_Mem_out,MEM_WB_ALU_out,MEM_WB_Rd}));
//selects what to write to register
NBit_mux#(32) write_mux(.A(MEM_WB_ALU_out), .B(MEM_WB_Mem_out), .sel(MEM_WB_Ctrl[0]), .out(write_data));
//PC = PC + 4
RCA #(32)PC_Add_Four(.A(PC_out),.B(4),.cin(1'b0),.sum(PC_four));
//PC Mux 
NBit_mux#(32) PCMux(.A(PC_four), .B(EX_MEM_PCaddImm), .sel(EX_MEM_Ctrl[2]&EX_MEM_Zero), .out(PC_in));
*/
endmodule

