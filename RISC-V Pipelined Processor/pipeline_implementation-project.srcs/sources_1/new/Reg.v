`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2023 02:49:52 PM
// Design Name: 
// Module Name: Reg
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


module Reg #(parameter N=32)(input clk,input rst,input load,input[N-1:0] data_in,output reg [N-1:0] data_out);


always @(posedge clk , posedge rst) begin 

if(rst==1)
    data_out<=0;
else begin 
        if(load==1)
            data_out<=data_in;
        else 
            data_out<=data_out;
     end

end


endmodule