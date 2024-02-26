`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2023 04:03:07 AM
// Design Name: 
// Module Name: ALU_control
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


`include "defines.v"

module ALU_control(input [3:0] ALUOp, input [2:0] funct3, input bit30, output reg [3:0] ALU_sel);
always @(*) begin
if(ALUOp == 4'b0000) //R-Format instructions.
  begin
    case(funct3)
      `F3_OR: ALU_sel = `ALU_OR;
      `F3_AND: ALU_sel = `ALU_AND;
      `F3_XOR: ALU_sel = `ALU_XOR;
      `F3_ADD: 
        begin
          if(bit30 == 0)
            ALU_sel = `ALU_ADD;
          else
            ALU_sel = `ALU_SUB;
        end
      `F3_SLT: ALU_sel = `ALU_SLT;
      `F3_SLL: ALU_sel = `ALU_SLL;
      `F3_SLTU: ALU_sel = `ALU_SLTU;
      `F3_SRL: 
        begin
          if(bit30 == 0)
            ALU_sel = `ALU_SRL;
          else
            ALU_sel = `ALU_SRA;
        end
    endcase
  end
else if(ALUOp == 4'b0001) //I-Format Instructions
  begin
    case(funct3)
      `F3_ADD: ALU_sel = `ALU_ADD;
      `F3_OR: ALU_sel = `ALU_OR;
      `F3_AND: ALU_sel = `ALU_AND;
      `F3_XOR: ALU_sel = `ALU_XOR;
      `F3_SLT: ALU_sel = `ALU_SLT;
      `F3_SLTU: ALU_sel = `ALU_SLTU;
      `F3_SLL: ALU_sel = `ALU_SLL;
      `F3_SRL: 
        begin
          if(bit30 == 0)
            ALU_sel = `ALU_SRL;
          else
            ALU_sel = `ALU_SRA;
        end
    endcase
  end
else if (ALUOp==4'b1001)
  begin
    case(funct3)
      `F3_MUL: ALU_sel = `ALU_MUL;
      `F3_DIV: ALU_sel = `ALU_DIV;
      `F3_REM: ALU_sel = `ALU_REM;
      endcase
  end
else if(ALUOp == 4'b0010) //Branching
  ALU_sel = `ALU_SUB;
else if(ALUOp == 4'b0011) //Load
  ALU_sel = `ALU_ADD;
else if(ALUOp == 4'b0100) //Store
  ALU_sel = `ALU_ADD;
//else if(ALUOp == 4'b0111) //AUIPC
  //ALU_sel = `ALU_LUI_AUIPC;
else if(ALUOp == 4'b1000) //LUI
  ALU_sel = `ALU_LUI;
else if(ALUOp == 4'b0101) //JALR
  ALU_sel = `ALU_ADD;
//else if(ALUOp == 4'b0110) //JAL
  //ALU_sel = `ALU_ADD;
end
endmodule
