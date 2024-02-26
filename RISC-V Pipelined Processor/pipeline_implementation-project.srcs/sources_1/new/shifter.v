`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2023 04:17:10 AM
// Design Name: 
// Module Name: shifter
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


module shifter (input [31:0] a, input [4:0] shamt, input [1:0] type, output reg [31:0] r);
integer i;

//r = {1'b0,r[31:1]};//SRL
//r = {r[30:0],1'b0};//SLL
//r = {r[31],r[31:1]};//SRA

always @(*) begin
//r = a;

//for(i = 0; i < shamt; i=i+1) 
  //begin
case(type)
 2'b00: r = a >> shamt; //SRL
 2'b01: r = a << shamt;//SLL
 2'b10: r = a >>> shamt;//SRA
endcase
  //end
end
endmodule