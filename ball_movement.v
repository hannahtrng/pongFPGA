`timescale 1ns / 1ps

module ball_control(
    input clk,
    input reset,
    input game_active, // Controlled by game_state_controller
    input game_over,   // Controlled by game_state_controller
    input switchMode,  // Pause timer in score mode
    input [9:0] paddle1_y, paddle2_y,
    output reg [9:0] ball_x, ball_y,
    output reg ball_dx, ball_dy,
    output reg [3:0] scoreP1, scoreP2,
    output reg [5:0] timer_minutes, timer_seconds // Timer countdown
);
    
    parameter BALL_SIZE = 10;
    parameter SCREEN_WIDTH = 640;
    parameter SCREEN_HEIGHT = 480;
    parameter BALL_SPEED = 1;
    parameter PADDLE_X1 = 20;
    parameter PADDLE_X2 = 620;
    parameter PADDLE_HEIGHT = 60;
    
    reg [3:0] random_seed;
    reg [25:0] timer_counter;
    reg [20:0] ball_speed_counter; // Speed control counter
    reg ball_tick;

    // Ball speed control (separate always block)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ball_speed_counter <= 0;
            ball_tick <= 0;
        end else begin
            if (ball_speed_counter == 1_000_000) begin // Adjust to slow down movement
                ball_speed_counter <= 0;
                ball_tick <= 1;
            end else begin
                ball_speed_counter <= ball_speed_counter + 1;
                ball_tick <= 0;
            end
        end
    end
    
    // Main game logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ball_x <= (SCREEN_WIDTH - BALL_SIZE) / 2;
            ball_y <= (SCREEN_HEIGHT - BALL_SIZE) / 2;
            random_seed <= random_seed + 1; // Basic pseudo-randomness
            ball_dx <= random_seed[0]; // Random initial horizontal direction
            ball_dy <= random_seed[1]; // Random initial vertical direction
            scoreP1 <= 0;
            scoreP2 <= 0;
            timer_minutes <= 5;
            timer_seconds <= 0;
            timer_counter <= 0;
        end else if (game_active && !game_over) begin // Ball moves only if game is active and not over
            // Timer Countdown (Pause when switchMode is active)
            if (!switchMode) begin
                if (timer_counter == 50_000_000) begin // 1-second decrement
                    timer_counter <= 0;
                    if (timer_seconds == 0) begin
                        if (timer_minutes > 0) begin
                            timer_minutes <= timer_minutes - 1;
                            timer_seconds <= 59;
                        end
                    end else begin
                        timer_seconds <= timer_seconds - 1;
                    end
                end else begin
                    timer_counter <= timer_counter + 1;
                end
            end
            
            if (ball_tick) begin
                // Ball movement
                if (ball_dx) ball_x <= ball_x + BALL_SPEED;
                else ball_x <= ball_x - BALL_SPEED;
                
                if (ball_dy) ball_y <= ball_y + BALL_SPEED;
                else ball_y <= ball_y - BALL_SPEED;
                
                // Collision with top and bottom walls
                if (ball_y <= 0 || ball_y >= SCREEN_HEIGHT - BALL_SIZE)
                    ball_dy <= ~ball_dy;
                
                // Collision with paddles
                if (ball_x <= PADDLE_X1 && ball_y >= paddle1_y && ball_y <= paddle1_y + PADDLE_HEIGHT)
                    ball_dx <= 1;
                else if (ball_x >= PADDLE_X2 && ball_y >= paddle2_y && ball_y <= paddle2_y + PADDLE_HEIGHT)
                    ball_dx <= 0;
                
                // Scoring conditions
                if (ball_x <= 0) begin
                    scoreP2 <= scoreP2 + 1;
                    ball_x <= (SCREEN_WIDTH - BALL_SIZE) / 2;
                    ball_y <= (SCREEN_HEIGHT - BALL_SIZE) / 2;
                    random_seed <= random_seed + 1;
                    ball_dx <= random_seed[0];
                    ball_dy <= random_seed[1];
                end else if (ball_x >= SCREEN_WIDTH) begin
                    scoreP1 <= scoreP1 + 1;
                    ball_x <= (SCREEN_WIDTH - BALL_SIZE) / 2;
                    ball_y <= (SCREEN_HEIGHT - BALL_SIZE) / 2;
                    random_seed <= random_seed + 1;
                    ball_dx <= random_seed[0];
                    ball_dy <= random_seed[1];
                end
            end
        end
    end
    
endmodule


