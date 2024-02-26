`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2023 04:12:15 AM
// Design Name: 
// Module Name: MUX_4x1
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


module MUX_4x1 #(parameter N = 32) (input [N-1:0] a, input [N-1:0] b, input [N-1:0] c, input [N-1:0] d, input [1:0] sel, output reg [N-1:0] out);
always@(*) begin
  case(sel)
  2'b00: out = a;
  2'b01: out = b;
  2'b10: out = c;
  2'b11: out = d;
  endcase
end
endmodule
