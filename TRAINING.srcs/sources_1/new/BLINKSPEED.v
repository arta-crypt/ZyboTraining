`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/29 02:09:20
// Design Name: 
// Module Name: BLINKSPEED
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


module BLINKSPEED(
    input  wire       CLK , // System clock 125MHz
    input  wire       RST , // 
    input  wire [1:0] BTN , // Hi=ON/Low=OFF
    output wire [3:0] LED   // 
  );
  
//====================================================================================
// wire
//====================================================================================
  
  wire  [ 1:0] btn_ms               ; // 
  wire  [ 1:0] btn_lpf              ; // 
  wire  [ 1:0] btn_pedge            ; // posedge
  wire  [ 1:0] btn_nedge            ; // negedge
  wire         sync_rst_sysclk_125m ; // System clock 125MHz 同期Reset
  wire         pls_1us              ; // 
  wire         pls_39us             ; // 
  wire         pls_1ms              ; // 
  wire         pls_25ms             ; // 
  wire  [ 3:0] led_move             ; // 
  wire  [ 3:0] led_pwm              ; // 
  
//====================================================================================
// Circuit Description                                                                
//====================================================================================
  
  // 125MHz 同期リセット
  SYNC_RST U_SYNC_RST (
    .CLK   (CLK                   ), // 
    .RST   (RST                   ), // 
    .OUT   (sync_rst_sysclk_125m  )  // 
  );
  
  // タイミング生成
  CKTG U_CKTG (
    .CLK_125M (CLK                  ), // 
    .RST      (RST                  ), // 
    .SYNCRST  (sync_rst_sysclk_125m ), // 
    .PLS_1US  (pls_1us              ), // 
    .PLS_39US (pls_39us             ), // 
    .PLS_1MS  (pls_1ms              ), // 
    .PLS_25MS (pls_25ms             )  // 
  );
  
  // メタステーブル対策
  META_STABLE #(
    .INIT (1'b0   ), // 
    .WIDTH(2      )  // 
  ) U_BLINKSPEED_BTN_MS (
    .CLK  (CLK    ), // 
    .RST  (RST    ), // 
    .IN   (BTN    ), // 
    .OUT  (btn_ms )  // 
  );
  
  // ローパスフィルタ
  LPF #(
    .INIT      (1'b0                ), // 
    .WIDTH     (2                   )  // 
  ) U_BLINKSPEED_BTN_LPF (
    .CLK       (CLK                 ), // 
    .RST       (RST                 ), // 
    .SYNCRST   (sync_rst_sysclk_125m), // 
    .LATCH_EN  (pls_25ms            ), // 
    .IND       (btn_ms              ), // 
    .OUTD      (btn_lpf             )  // 
  );
  
  // エッジ検出
  DET_EDGE #(
    .INIT     (1'b0                ), // 
    .WIDTH    (2                   )  // 
  ) U_DET_EDGE (
    .CLK      (CLK                 ), // 
    .RST      (RST                 ), // 
    .SYNCRST  (sync_rst_sysclk_125m), // 
    .IND      (btn_lpf             ), // 
    .PEDGE    (btn_pedge           ), // 
    .NEDGE    (btn_nedge           )  // 
  );
  
  // LED点灯位置移動
  LED_MOVE U_LED_MOVE (
    .CLK       (CLK                 ), // 
    .RST       (RST                 ), // 
    .SYNCRST   (sync_rst_sysclk_125m), // 
    .CNT_EN    (pls_1ms             ), // 
    .BTN_WORK  (btn_pedge[0]        ), // 
    .LED       (led_move            )  // 
  );
  
  // LED PWM点灯
  LED_PWM U_LED_PWM (
    .CLK       (CLK                 ), // 
    .RST       (RST                 ), // 
    .SYNCRST   (sync_rst_sysclk_125m), // 
    .PWMCNT_EN (pls_39us            ), // 
    .BTN_WORK  (btn_pedge[1]        ), // 
    .LED_IN    (led_move            ), // 
    .LED_OUT   (led_pwm             )  // 
  );
  
//====================================================================================
// Output
//====================================================================================
  
  assign LED = led_pwm;
  
endmodule
