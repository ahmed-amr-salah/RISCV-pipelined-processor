`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2023 04:13:17 AM
// Design Name: 
// Module Name: Mux2x1
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


module Mux2x1 #(parameter N = 32) (input [N-1:0] a, input [N-1:0] b,
input sel, output reg [N-1:0] out);

always@(*) begin
  case(sel)
  1'b0: out = a;
  1'b1: out = b;
  endcase
end
endmodule