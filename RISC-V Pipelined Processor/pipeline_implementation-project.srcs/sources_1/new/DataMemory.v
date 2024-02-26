`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2023 04:07:50 AM
// Design Name: 
// Module Name: DataMemory
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
* Module: DataMemeory.v
* Project: pipeline_implementation
* Author: Ahmed Amin & Amena Hossam and aahmedamr221201@aucegypt.edu & amna_elsaqa12@aucegypt.edu
* Description: single memeory which contains both the instrustion and date memory
*
* Change history: 28/04/2023: the module was created including the testing 
*
**********************************************************************/
`include "defines.v" 

module DataMemory(input clk, input MemRead,input [2:0]func3, input MemWrite,input [7:0] addr,
input [31:0] data_in, output reg [31:0] data_out);

wire [11:0]offset =200;
wire [7:0] data_addess = addr + offset;
reg [7:0] mem [0:400]; 




///////////////////////Data_Memory/////////////////////////////////
always @(*)begin 

if(clk==1)
    data_out<={mem[addr+3],mem[addr+2],mem[addr+1],mem[addr]};
else if(MemRead==1) 
  begin 
    case(func3) 
      `F3_LB: data_out = {{24{mem[data_addess][7]}},mem[data_addess]};         
      `F3_LH: data_out = {{16{mem[data_addess+1][7]}},mem[data_addess+1],mem[data_addess]};           
      `F3_LW: data_out = {mem[data_addess+3],mem[data_addess+2],mem[data_addess+1],mem[data_addess]};         
      `F3_LBU: data_out = {24'd0,mem[data_addess]};          
      `F3_LHU: data_out = {16'd0,mem[data_addess+1],mem[data_addess]};          
    endcase
  end
else data_out=0 ;
end

always @(posedge clk)begin 

if(MemWrite==1)
    case(func3) 
      `F3_SB: mem[data_addess] = data_in[7:0];
      `F3_SH: 
          begin 
            mem[data_addess] = data_in[7:0];
            mem[data_addess+1] = data_in[15:8];
          end
      `F3_SW:
           begin 
            mem[data_addess] = data_in[7:0];
            mem[data_addess+1] = data_in[15:8];
            mem[data_addess+2] = data_in[23:15];
            mem[data_addess+3] = data_in[31:24];
           end
    endcase
end
//////////////////////////////////////////////////////////////////////////
///////////////////////Instruction_Memory/////////////////////////////////

initial begin 

// Test the lab program 
//$readmemh("test.mem",mem);
// Test 2 : finding the maximum and multiply by 5 
//$readmemh("test2.mem",mem);
//--> Test 3 : Test the 40 instruction 
$readmemh("test3.mem",mem);



//////////////////Date_MEMORY///////////////////////////////////
//0
{mem[203],mem[202],mem[201],mem[200]} = 32'd2000;
//1
{mem[207],mem[206],mem[205],mem[204]} = 32'd10;
//2
{mem[211],mem[210],mem[209],mem[208]} = 32'd15;
//3
{mem[212]} = 32'd32;
//4 
{mem[214],mem[213]} = 32'd51200; 
end 

endmodule

