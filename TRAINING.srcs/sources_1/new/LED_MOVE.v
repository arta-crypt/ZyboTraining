`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/21 21:13:56
// Design Name: 
// Module Name: LED_MOVE
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


module LED_MOVE(
    input        CLK       , // 
    input        RST       , // 
    input        SYNCRST   , // 
    input        CNT_EN    , // 
    input        BTN_WORK  , // 
    output [3:0] LED         // 
  );
    
//====================================================================================
// reg
//====================================================================================
  
  reg   [ 2:0] speed    ; // 移動速度設定用カウンタ 0:遅～7:速
  reg   [10:0] cnt11    ; // 
  reg   [ 2:0] cnt3     ; // LED用カウンタ
  reg   [ 3:0] led_dec  ; // 
  
//====================================================================================
// Circuit Description                                                                
//====================================================================================
  
  // ボタン押下による移動速度変更
  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      speed <= 3'd1;
    end else if (SYNCRST) begin
      speed <= 3'd1;
    end else if (BTN_WORK) begin
      speed <= speed + 1'b1;
    end else begin
      speed <= speed;
    end
  end
  
  // 点灯位置移動用カウンタ
  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      cnt11 <= 11'h000;
    end else if (SYNCRST) begin
      cnt11 <= 11'h000;
    end else if (CNT_EN) begin
      cnt11 <= cnt11 + 1'b1;
    end else begin
      cnt11 <= cnt11;
    end
  end
  
  // 点灯位置移動イネーブル
  assign leden = f_leden(.cnt11(cnt11), .speed(speed));
  
  // 点灯位置変更
  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      cnt3  <= 3'd0;
    end else if (SYNCRST) begin
      cnt3  <= 3'd0;
    end else if (CNT_EN && leden) begin
      if (cnt3 == 3'd5) begin
        cnt3  <= 3'd0;
      end else begin
        cnt3  <= cnt3 + 1'b1;
      end
    end else begin
      cnt3  <= cnt3;
    end
  end
  
  // 点灯位置デコード
  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      led_dec <= 4'h0;
    end else if (SYNCRST) begin
      led_dec <= 4'h0;
    end else begin
      led_dec <= f_led_decorder(cnt3);
    end
  end
  
//====================================================================================
// Function                                                              
//====================================================================================
  
  function f_leden (
    input [10:0] cnt11 , // 
    input [ 2:0] speed   // 
  );
    case (speed)
      3'h0   : f_leden = (cnt11[ 3:0] ==  4'hF  );
      3'h1   : f_leden = (cnt11[ 4:0] ==  5'h1F );
      3'h2   : f_leden = (cnt11[ 5:0] ==  6'h3F );
      3'h3   : f_leden = (cnt11[ 6:0] ==  7'h7F );
      3'h4   : f_leden = (cnt11[ 7:0] ==  8'hFF );
      3'h5   : f_leden = (cnt11[ 8:0] ==  9'h1FF);
      3'h6   : f_leden = (cnt11[ 9:0] == 10'h3FF);
      3'h7   : f_leden = (cnt11[10:0] == 11'h7FF);
      default: f_leden = (cnt11[   0] ==  1'h1  );
    endcase
  endfunction
  
  function [3:0] f_led_decorder (
    input [2:0] cnt3 // 
  );
    case (cnt3)
      3'd0   : f_led_decorder = 4'b0001;
      3'd1   : f_led_decorder = 4'b0010;
      3'd2   : f_led_decorder = 4'b0100;
      3'd3   : f_led_decorder = 4'b1000;
      3'd4   : f_led_decorder = 4'b0100;
      3'd5   : f_led_decorder = 4'b0010;
      default: f_led_decorder = 4'b0000;
    endcase
  endfunction
  
//====================================================================================
// Output
//====================================================================================
  
  assign LED = led_dec;
  
endmodule
