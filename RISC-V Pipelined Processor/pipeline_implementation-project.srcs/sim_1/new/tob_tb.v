`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2023 05:05:36 PM
// Design Name: 
// Module Name: top_pipeline_tb
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


module top_tb();

	// Declarations
reg  clk;
reg  rst;
parameter period =10;

// Instantiation of Unit Under Test
top uut(.clk(clk),.rst(rst));

initial begin
	clk = 1;
	forever #(period/2) clk = ~clk;
end

initial begin
#(period)
rst = 1;
#(period)
rst = 0;
end

endmodule



