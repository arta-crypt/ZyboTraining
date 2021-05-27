`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/21 21:40:42
// Design Name: 
// Module Name: LED_PWM
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


module LED_PWM(
    input        CLK       ,  // 
    input        RST       ,  // 
    input        SYNCRST   ,  // 
    input        PWMCNT_EN ,  // 
    input        BTN_WORK  ,  // 
    input  [3:0] LED_IN    ,  // 
    output [3:0] LED_OUT      // 
  );
  
//====================================================================================
// wire
//====================================================================================
  
  wire  [ 7:0] pwm      ; // 
  wire  [ 3:0] led_pwm  ; // 
  
//====================================================================================
// reg
//====================================================================================
  
  reg   [ 1:0] cnt2     ; // PWMデューティー比設定用カウンタ [0]12.5:87.5～[3]:100:0
  
//====================================================================================
// Circuit Description                                                                
//====================================================================================
  
  // ボタン押下によるPWMデューティー比変更
  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      cnt2 <= 2'd3;
    end else if (SYNCRST) begin
      cnt2 <= 2'd3;
    end else if (BTN_WORK) begin
      cnt2 <= cnt2 + 1'b1;
    end else begin
      cnt2 <= cnt2;
    end
  end
  
  assign pwm = f_duty_decorder(.cnt2(cnt2));
  
  // LED PWM点灯
  PWM #(
    .INIT    (1'b0     ), // 
    .WIDTH   (4        )  // 
  ) U_PWM (
    .CLK     (CLK      ) , // 
    .RST     (RST      ) , // 
    .SYNCRST (SYNCRST  ) , // 
    .CNT_EN  (PWMCNT_EN) , // 
    .PWM     (pwm      ) , // 
    .IN      (LED_IN   ) , // 
    .OUT     (led_pwm  )   // 
  );
  
//====================================================================================
// Function                                                              
//====================================================================================
  
  function [7:0] f_duty_decorder (
    input [1:0] cnt2 // 
  );
    case (cnt2)
      2'd0   : f_duty_decorder = 8'h1F;
      2'd1   : f_duty_decorder = 8'h3F;
      2'd2   : f_duty_decorder = 8'h7F;
      2'd3   : f_duty_decorder = 8'hFF;
      default: f_duty_decorder = 8'h01;
    endcase
  endfunction
  
//====================================================================================
// Output                                                                             
//====================================================================================
  
  assign LED_OUT = led_pwm;
  
endmodule
