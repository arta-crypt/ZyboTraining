`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/30 01:44:22
// Design Name: 
// Module Name: CKTG
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


module CKTG(
    input  wire CLK_125M  , // 
    input  wire RST       , // 
    input  wire SYNCRST   , // 
    output wire PLS_1US   , // 
    output wire PLS_39US  , // 
    output wire PLS_1MS   , // 
    output wire PLS_25MS    // 
  );
  
//====================================================================================
// parameter
//====================================================================================
  
  parameter P_CNT_1US   = (125-1)             ; // 125MHz -> 1us
  parameter P_WIDTH_1US = $clog2(P_CNT_1US+1) ; // 
  parameter P_CNT_39US  = (39-1)              ; // 1us * 39 = 39us
  parameter P_WIDTH_39US= $clog2(P_CNT_39US+1); // 
  parameter P_CNT_1MS   = (1000-1)            ; // 1us * 1000 = 1ms
  parameter P_WIDTH_1MS = $clog2(P_CNT_1MS+1) ; // 
  parameter P_CNT_25MS  = (25-1)              ; // 1ms * 25 = 25ms
  parameter P_WIDTH_25MS= $clog2(P_CNT_25MS+1); // 
  
//====================================================================================
// reg
//====================================================================================
  
  reg [P_WIDTH_1US-1:0]  cnt_1us ; // 
  reg                    pls_1us ; // 
  reg [P_WIDTH_39US-1:0] cnt_39us; // 
  reg                    pls_39us; // 
  reg [P_WIDTH_1MS-1:0]  cnt_1ms ; // 
  reg                    pls_1ms ; // 
  reg [P_WIDTH_25MS-1:0] cnt_25ms; // 
  reg                    pls_25ms; // 
  
//====================================================================================
// Circuit Description                                                                
//====================================================================================
  
  always @(posedge CLK_125M or posedge RST) begin
    if (RST) begin
      cnt_1us <= {P_WIDTH_1US{1'b0}};
      pls_1us <= 1'b0               ;
    end else if (SYNCRST) begin
      cnt_1us <= {P_WIDTH_1US{1'b0}};
      pls_1us <= 1'b0               ;
    end else begin
      cnt_1us <= (cnt_1us == P_CNT_1US) ? {P_WIDTH_1US{1'b0}} : (cnt_1us+1'b1);
      pls_1us <= (cnt_1us == P_CNT_1US) ? 1'b1                : 1'b0          ;
    end
  end
  
  always @(posedge CLK_125M or posedge RST) begin
    if (RST) begin
      cnt_39us <= {P_WIDTH_39US{1'b0}};
      pls_39us <= 1'b0                ;
    end else if (SYNCRST) begin
      cnt_39us <= {P_WIDTH_39US{1'b0}};
      pls_39us <= 1'b0                ;
    end else if (pls_1us) begin
      cnt_39us <= (cnt_39us == P_CNT_39US) ? {P_WIDTH_39US{1'b0}} : (cnt_39us+1'b1);
      pls_39us <= (cnt_39us == P_CNT_39US) ? 1'b1                 : 1'b0           ;
    end else begin
      cnt_39us <= cnt_39us;
      pls_39us <= 1'b0    ;
    end
  end
  
  always @(posedge CLK_125M or posedge RST) begin
    if (RST) begin
      cnt_1ms <= {P_WIDTH_1MS{1'b0}};
      pls_1ms <= 1'b0               ;
    end else if (SYNCRST) begin
      cnt_1ms <= {P_WIDTH_1MS{1'b0}};
      pls_1ms <= 1'b0               ;
    end else if (pls_1us) begin
      cnt_1ms <= (cnt_1ms == P_CNT_1MS) ? {P_WIDTH_1MS{1'b0}} : (cnt_1ms+1'b1);
      pls_1ms <= (cnt_1ms == P_CNT_1MS) ? 1'b1                : 1'b0          ;
    end else begin
      cnt_1ms <= cnt_1ms;
      pls_1ms <= 1'b0   ;
    end
  end
  
  always @(posedge CLK_125M or posedge RST) begin
    if (RST) begin
      cnt_25ms <= {P_WIDTH_25MS{1'b0}};
      pls_25ms <= 1'b0                ;
    end else if (SYNCRST) begin
      cnt_25ms <= {P_WIDTH_25MS{1'b0}};
      pls_25ms <= 1'b0                ;
    end else if (pls_1ms) begin
      cnt_25ms <= (cnt_25ms == P_CNT_25MS) ? {P_WIDTH_25MS{1'b0}} : (cnt_25ms+1'b1);
      pls_25ms <= (cnt_25ms == P_CNT_25MS) ? 1'b1                 : 1'b0           ;
    end else begin
      cnt_25ms <= cnt_25ms;
      pls_25ms <= 1'b0    ;
    end
  end
  
//====================================================================================
// Output
//====================================================================================
  
  assign PLS_1US  = pls_1us ;
  assign PLS_39US = pls_39us;
  assign PLS_1MS  = pls_1ms ;
  assign PLS_25MS = pls_25ms;
  
endmodule
