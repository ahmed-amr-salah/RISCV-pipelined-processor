`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2023 04:16:14 AM
// Design Name: 
// Module Name: reg_file
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


module reg_file #(parameter N=32,parameter size=32)(input RegWrite,input clk, input rst, input [4:0] RAdress1, input [4:0] RAdress2, input [4:0] WAddress, input [N-1:0] WData, output  [N-1:0] RData1, output  [N-1:0] RData2);

reg [N-1:0] regFile[size-1:0];
integer i;
assign RData1 = regFile[RAdress1];
assign RData2 = regFile[RAdress2];

always @(posedge clk , posedge rst)begin
if(rst == 1)
    begin
        for(i = 0; i < size; i=i+1)
            regFile[i] = 0;
    end
else if((RegWrite == 1) && (WAddress!=0)) 
    begin
        regFile[WAddress] = WData;
    end
end
endmodule

