`timescale 1ns / 1ps

module vga_renderer(
    input clk,
    input reset,
    input [9:0] x, y, // Current pixel position
    input [9:0] paddle1_y, paddle2_y, // Paddle positions
    input [9:0] ball_x, ball_y, // Ball position
    output reg [3:0] vga_red, vga_green, vga_blue
);
    
    parameter SCREEN_WIDTH = 640;
    parameter SCREEN_HEIGHT = 480;
    parameter PADDLE_WIDTH = 10;
    parameter PADDLE_HEIGHT = 60;
    parameter BALL_SIZE = 10;
    parameter CENTER_LINE_WIDTH = 4;
    
    always @(*) begin
        // Default background color (black)
        vga_red = 4'b0000;
        vga_green = 4'b0000;
        vga_blue = 4'b0000;
        
        // Draw left paddle
        if ((x >= 20 && x < 20 + PADDLE_WIDTH) && (y >= paddle1_y && y < paddle1_y + PADDLE_HEIGHT)) begin
            vga_red = 4'b1111;
            vga_green = 4'b0000;
            vga_blue = 4'b0000;
        end
        
        // Draw right paddle
        else if ((x >= SCREEN_WIDTH - 30 && x < SCREEN_WIDTH - 30 + PADDLE_WIDTH) && (y >= paddle2_y && y < paddle2_y + PADDLE_HEIGHT)) begin
            vga_red = 4'b0000;
            vga_green = 4'b1111;
            vga_blue = 4'b0000;
        end
        
        // Draw ball
        else if ((x >= ball_x && x < ball_x + BALL_SIZE) && (y >= ball_y && y < ball_y + BALL_SIZE)) begin
            vga_red = 4'b1111;
            vga_green = 4'b0000;
            vga_blue = 4'b0000;
        end
        
        // Draw center divider line
        else if ((x >= (SCREEN_WIDTH / 2) - (CENTER_LINE_WIDTH / 2) && x < (SCREEN_WIDTH / 2) + (CENTER_LINE_WIDTH / 2)) && (y % 20 < 10)) begin
            vga_red = 4'b0111;
            vga_green = 4'b0111;
            vga_blue = 4'b0111;
        end
    end
    
endmodule
