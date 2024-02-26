`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2023 01:27:24 AM
// Design Name: 
// Module Name: Forwarding_unit
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
* Module: Forwarding_Unit.v
* Project: pipeline_implementation
* Author: Ahmed Amin & Amena Hossam and aahmedamr221201@aucegypt.edu & amna_elsaqa12@aucegypt.edu
* Description: This module is responsible for checking if there is forwarding needed and if yes it passes the value before writing it back to the register 
*
* Change history: 29/04/2023: the module was created and tested 
*
**********************************************************************/

module Forwarding_unit(input [4:0] ID_EX_RegisterRs1,input [4:0] ID_EX_RegisterRs2,input [4:0] MEM_WB_RegisterRd,input MEM_WB_RegWrite,output reg forwardA,output reg forwardB);


always @(*)begin

  if((MEM_WB_RegWrite  == 1'b1) && (MEM_WB_RegisterRd != 5'b0) && (MEM_WB_RegisterRd == ID_EX_RegisterRs2))
        forwardB = 1'b1;
   else 
        forwardB = 1'b0;    
   

 if((MEM_WB_RegWrite  == 1'b1) && (MEM_WB_RegisterRd != 5'b0) && (MEM_WB_RegisterRd == ID_EX_RegisterRs1))
        forwardA = 1'b1;
   else 
        forwardA = 1'b0; 
       

end 

endmodule
