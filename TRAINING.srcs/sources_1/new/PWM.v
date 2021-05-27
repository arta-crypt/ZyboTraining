`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/30 12:07:58
// Design Name: 
// Module Name: PWM
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


module PWM #(
    parameter INIT  = 1'b0          , // 
    parameter WIDTH = 1               // 
  )(
    input  wire             CLK     , // 
    input  wire             RST     , // 
    input  wire             SYNCRST , // 
    input  wire             CNT_EN  , // 
    input  wire [      7:0] PWM     , // 
    input  wire [WIDTH-1:0] IN      , // 
    output wire [WIDTH-1:0] OUT       // 
  );
  
//====================================================================================
// wire                                                                               
//====================================================================================
  
//====================================================================================
// reg                                                                                
//====================================================================================
  
  reg [      7:0] cntr   ;
  reg [WIDTH-1:0] pwm_out;
  
//====================================================================================
// Circuit Description                                                                
//====================================================================================
  
  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      cntr    <= 8'd0         ;
      pwm_out <= {WIDTH{INIT}};
    end else if (SYNCRST) begin
      cntr    <= 8'd0         ;
      pwm_out <= {WIDTH{INIT}};
    end else if (CNT_EN) begin
      cntr    <= cntr + 1'b1;
      pwm_out <= (cntr<=PWM) ? IN : {WIDTH{INIT}};
    end else begin
      cntr    <= cntr;
      pwm_out <= pwm_out;
    end
  end
  
//====================================================================================
// Output                                                                             
//====================================================================================
  
  assign OUT = pwm_out;
  
endmodule
