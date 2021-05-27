`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/29 17:43:05
// Design Name: 
// Module Name: META_STABLE
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


module META_STABLE #(
    parameter INIT  = 1'b0      , // 
    parameter WIDTH = 1           // 
  ) (
    input  wire CLK             , // 
    input  wire RST             , // 
    input  wire [WIDTH-1:0]  IN , // 
    output wire [WIDTH-1:0]  OUT  // 
  );
  
//====================================================================================
// reg
//====================================================================================
  
  reg [WIDTH-1:0] ms;
  reg [WIDTH-1:0] ms_d;
  
//************************************************************************************
// main
//************************************************************************************
  
  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      ms   <= {WIDTH{INIT}};
      ms_d <= {WIDTH{INIT}};
    end else begin
      ms   <= IN ;
      ms_d <= ms;
    end
  end
  
//====================================================================================
// output
//====================================================================================
  
  assign OUT = ms_d;
  
endmodule
