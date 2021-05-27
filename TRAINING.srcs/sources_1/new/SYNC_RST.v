`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/29 17:40:33
// Design Name: 
// Module Name: SYNC_RST
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


module SYNC_RST (
    input  wire CLK   , // 
    input  wire RST   , // 
    output wire OUT     // 
  );
  
//====================================================================================
// wire
//====================================================================================
  
  wire ms;
  
//====================================================================================
// reg
//====================================================================================  
  
  reg  [2:0] s_out;
  reg        out  ;
  
//************************************************************************************
// main
//************************************************************************************
  
  META_STABLE #(
    .INIT (1'b1 )  ,
    .WIDTH(1    )  
  ) U_SYNCRST_MS (
    .CLK  (CLK  )  ,
    .RST  (RST  )  ,
    .IN   (RST  )  ,
    .OUT  (ms   )   
  );
  
  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      s_out <= 3'b111;
    end else begin
      s_out <= {s_out[1:0], ms};
    end
  end
  
  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      out <= 1'b1;
    end else if (s_out == 3'b000) begin
      out <= 1'b0;
    end else if (s_out == 3'b111) begin
      out <= 1'b1;
    end else begin
      out <= out;
    end
  end
  
//====================================================================================
// Output
//====================================================================================
  
  assign OUT = out;
  
endmodule
