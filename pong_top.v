`timescale 1ns / 1ps

module pong_top(
    input clk,
    input reset,
    input btnP1U, btnP1D, // Player 1 controls
    input btnP2U, btnP2D, // Player 2 controls
    input switchMode, // Score mode toggle
    output hsync, vsync,
    output [3:0] vga_red, vga_green, vga_blue,
    output [6:0] segment,
    output [3:0] an,
    output [15:0] led
);

    wire [9:0] paddle1_y, paddle2_y;
    wire [9:0] ball_x, ball_y;
    wire [3:0] scoreP1, scoreP2;
    wire [5:0] timer_minutes, timer_seconds;
    wire game_active, game_over;
    wire [1:0] game_state;
    wire p_tick;
    wire visible;
    wire [9:0] x, y;
    wire db_btnP1U, db_btnP1D, db_btnP2U, db_btnP2D;
    wire clk_1hz, clk_2hz, clk_5hz, clk_fast, clk_25Mhz;
    
    clock_divider clk_div (
        .clk(clk),
        .rst(reset),
        .clk_1hz(clk_1hz),
        .clk_2hz(clk_2hz),
        .clk_5hz(clk_5hz),
        .clk_25Mhz(clk_25Mhz),
        .clk_fast(clk_fast)
    );

    // VGA Controller
    vga_controller vga_inst (
        .clk(clk),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .visible(visible),
        .p_tick(p_tick),
        .x(x),
        .y(y)
    );

    // Paddle Control
    paddle_control paddles (
        .clk(clk),
        .clk_fast(clk_fast),
        .reset(reset),
        .btnP1U(db_btnP1U),
        .btnP1D(db_btnP1D),
        .btnP2U(db_btnP2U),
        .btnP2D(db_btnP2D),
        .paddle1_y(paddle1_y),
        .paddle2_y(paddle2_y)
    );

    // Ball Control
    ball_control ball (
        .clk(clk),
        .reset(reset),
        .game_active(game_active),
        .game_over(game_over),
        .paddle1_y(paddle1_y),
        .paddle2_y(paddle2_y),
        .ball_x(ball_x),
        .ball_y(ball_y),
        .scoreP1(scoreP1),
        .scoreP2(scoreP2),
        .timer_minutes(timer_minutes),
        .timer_seconds(timer_seconds)
    );

    // VGA Renderer
    vga_renderer vga_render (
        .clk(clk),
        .reset(reset),
        .x(x),
        .y(y),
        .paddle1_y(paddle1_y),
        .paddle2_y(paddle2_y),
        .ball_x(ball_x),
        .ball_y(ball_y),
        .vga_red(vga_red),
        .vga_green(vga_green),
        .vga_blue(vga_blue)
    );

    // Game State Controller
    game_state_controller game_ctrl (
        .clk(clk),
        .clk_fst(clk_fast),
        .reset(reset),
        .switchMode(switchMode),
        .scoreP1(scoreP1),
        .scoreP2(scoreP2),
        .timer_minutes(timer_minutes),
        .timer_seconds(timer_seconds),
        .game_active(game_active),
        .game_over(game_over),
        .game_state(game_state)
    );

    // Seven-Segment Multiplexer
    score_display score (
        .clk(clk_fast),
        .switchMode(switchMode),
        .timer_minutes(timer_minutes),
        .timer_seconds(timer_seconds),
        .scoreP1(scoreP1),
        .scoreP2(scoreP2),
        .seg(segment),
        .an(an),
        .led(led)
    );
    
endmodule
