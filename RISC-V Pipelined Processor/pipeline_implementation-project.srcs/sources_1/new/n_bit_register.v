`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2023 04:14:00 AM
// Design Name: 
// Module Name: n_bit_register
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


module n_bit_register#(parameter N=32)(input clk,input rst,input load, input [N-1:0]Data,output reg [N-1:0] Q );


always@(posedge clk , posedge  rst)
begin
    if(rst==1)
        Q<='d0;
    else 
        begin 
           if(load==1)
               Q<=Data;
        end     
end
endmodule

