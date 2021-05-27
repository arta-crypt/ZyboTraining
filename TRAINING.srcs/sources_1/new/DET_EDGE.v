`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/29 18:42:02
// Design Name: 
// Module Name: DET_EDGE
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


module DET_EDGE #(
    parameter INIT  = 1'b1          , // 
    parameter WIDTH = 1               // 
  )(
    input  wire CLK                 , // 
    input  wire RST                 , // 
    input  wire SYNCRST             , // 
    input  wire [WIDTH-1:0] IND     , // 
    output wire [WIDTH-1:0] PEDGE   , // 
    output wire [WIDTH-1:0] NEDGE     // 
  );
  
//====================================================================================
// reg
//====================================================================================
  
  reg [      1:0] s_dte [WIDTH-1:0];
  reg [WIDTH-1:0] pedge_d;
  reg [WIDTH-1:0] nedge_d;
  
//************************************************************************************
// main
//************************************************************************************
  
  genvar i;
  generate
    for (i=0; i<WIDTH; i=i+1) begin : GEN_DETEDGE_SHIFTR
      always @(posedge CLK or posedge RST) begin
        if (RST) begin
          s_dte[i]  <= {2{INIT}};
        end else if (SYNCRST) begin  
          s_dte[i]  <= {2{INIT}};
        end else begin
          s_dte[i]  <= {s_dte[i][0], IND[i]};
        end
      end
    end
  endgenerate
  
  genvar j;
  generate
    for (j=0; j<WIDTH; j=j+1) begin : GEN_DETEDGE_OUT
      always @(posedge CLK or posedge RST) begin
        if (RST) begin
          pedge_d[j] <= 1'b0;
          nedge_d[j] <= 1'b0;
        end else if (SYNCRST) begin
          pedge_d[j] <= 1'b0;
          nedge_d[j] <= 1'b0;
        end else if (s_dte[j] == 2'b01) begin
          pedge_d[j] <= 1'b1;
          nedge_d[j] <= 1'b0;
        end else if (s_dte[j] == 2'b10) begin
          pedge_d[j] <= 1'b0;
          nedge_d[j] <= 1'b1;
        end else begin
          pedge_d[j] <= 1'b0;
          nedge_d[j] <= 1'b0;
        end
      end
    end
  endgenerate
  
//====================================================================================
// Output
//====================================================================================
  
  assign PEDGE = pedge_d;
  assign NEDGE = nedge_d;
  
endmodule
