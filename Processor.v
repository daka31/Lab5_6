`timescale 1ns/100ps
module Processor(clk, op, rs, rt, rd, shamt, funct, is0, ReadData1, ReadData2, ALU_result, out_MemtoReg);
  input clk;
  input [5:0] op, funct;
  input [4:0] rs, rt, rd, shamt;
  output is0;
  output [31:0] ReadData1, ReadData2, ALU_result, out_MemtoReg;
  
  wire RegDst, MemRead, MemWrite, MemtoReg, ALUSrc, RegWrite;
  wire [1:0] ALUOp;
  wire [3:0] ALUcontrol;
  
  ControlUnit CU(op, RegDst, MemRead, MemWrite, MemtoReg, ALUOp, ALUSrc, RegWrite);
  
  ALU_ControlUnit ACU(ALUOp, ALUcontrol);
  
  Datapath DP0(clk, op, rs, rt, rd, shamt, funct, RegDst, RegWrite, ALUSrc, ALUcontrol, MemRead, MemWrite, MemtoReg, is0, ReadData1, ReadData2, ALU_result, out_MemtoReg);
  
endmodule

module Processor_tb();
  reg clk;
  reg [5:0] op, funct;
  reg [4:0] rs, rt, rd, shamt;
  wire is0;
  wire [31:0] ReadData1, ReadData2, ALU_result, out_MemtoReg;
  
  reg RegDst, MemRead, MemWrite, MemtoReg, ALUSrc, RegWrite;
  reg [1:0] ALUOp;
  reg [3:0] ALUcontrol;
  
  Processor P0(clk, op, rs, rt, rd, shamt, funct, is0, ReadData1, ReadData2, ALU_result, out_MemtoReg);
  
  initial begin
    forever #5 begin
    clk =~clk;
    $display("Time = %t, ReadData1 = %d, ReadData2 = %d, ALU_result = %d, out_MemtoReg = %d", $time, ReadData1, ReadData2, ALU_result, out_MemtoReg);
    end
  end
  
  initial begin
    clk = 0;  //add $1, $2, $3;
    op = 6'h01;
    rs = 5'd2;
    rt = 5'd3;
    rd = 5'd1;
    shamt = 5'd0;
    funct = 6'b0;
    
    #10
    op = 6'h02; //sw $1, 0($2);
    rs = 5'd2;
    rt = 5'd1;
    rd = 5'd0;
    shamt = 5'd0;
    funct = 6'b0;
    
    #10
    op = 6'h04; //lw $4, 0($2);
    rs = 5'd2;
    rt = 5'd4;
    rd = 5'd0;
    shamt = 5'd0;
    funct = 6'b0;
    
    #10
    op = 6'h01; //add $1, $4, $3;
    rs = 5'd4;
    rt = 5'd3;
    rd = 5'd1;
    shamt = 5'd0;
    funct = 6'b0;
    
    #10
    $finish;
  end
  //initial begin
//    $monitor("Time = %t, ReadData1 = %d, ReadData2 = %d, ALU_result = %d", $time, ReadData1, ReadData2, ALU_result);
//  end
endmodule