`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/29 18:14:21
// Design Name: 
// Module Name: LPF
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


module LPF #(
    parameter INIT  = 1'b0          , // 
    parameter WIDTH = 1               // 
  )(
    input  wire CLK                 , // 
    input  wire RST                 , // 
    input  wire SYNCRST             , // 
    input  wire LATCH_EN            , // 
    input  wire [WIDTH-1:0] IND   , // 
    output wire [WIDTH-1:0] OUTD    // 
  );
  
//====================================================================================
// reg
//====================================================================================
  
  reg [      2:0] s_lpf [WIDTH-1:0] ;
  reg [WIDTH-1:0] outd_d;
  
//************************************************************************************
// main
//************************************************************************************
  
  genvar i;
  generate
    for (i=0; i<WIDTH; i=i+1) begin : GEN_LPF_SHIFTR
      always @(posedge CLK or posedge RST) begin
        if (RST) begin
          s_lpf[i] <= {3{INIT}};
        end else if (SYNCRST) begin  
          s_lpf[i] <= {3{INIT}};
        end else begin
          if (LATCH_EN) begin
            s_lpf[i] <= {s_lpf[i][1:0], IND[i]};
          end else begin
            s_lpf[i] <= s_lpf[i];
          end
        end
      end
    end
  endgenerate
  
  genvar j;
  generate
    for (j=0; j<WIDTH; j=j+1) begin : GEN_LPF_OUT
      always @(posedge CLK or posedge RST) begin
        if (RST) begin
          outd_d[j] <= INIT;
        end else if (SYNCRST) begin
          outd_d[j] <= INIT;
        end else if (&s_lpf[j]) begin
          outd_d[j] <= 1'b1;
        end else if (&(~s_lpf[j])) begin
          outd_d[j] <= 1'b0;
        end else begin
          outd_d[j] <= outd_d[j];
        end
      end
    end
  endgenerate
  
//====================================================================================
// output
//====================================================================================
  
  assign OUTD = outd_d;
  
endmodule
