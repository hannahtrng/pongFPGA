`timescale 1ns / 1ps

    module paddle_control(
        input clk,
        input clk_fast,
        input reset,
        input btnP1U, btnP1D, // Player 1: BTNN (Up), BTND (Down)
        input btnP2U, btnP2D, // Player 2: BTNU (Up), BTNR (Down)
        output reg [9:0] paddle1_y,
        output reg [9:0] paddle2_y
    );
    
        parameter PADDLE_HEIGHT = 60;
        parameter SCREEN_HEIGHT = 480;
        parameter PADDLE_SPEED = 5;
    
        wire db_btnP1U, db_btnP1D, db_btnP2U, db_btnP2D;
        reg [20:0] paddle_speed_counter;
        reg paddle_tick;
    
        // Instantiate debouncers for all buttons
        button_debouncer db_p1u (.clk(clk_fast), .btn_in(btnP1U), .btn_out(db_btnP1U));
        button_debouncer db_p1d (.clk(clk_fast), .btn_in(btnP1D), .btn_out(db_btnP1D));
        button_debouncer db_p2u (.clk(clk_fast), .btn_in(btnP2U), .btn_out(db_btnP2U));
        button_debouncer db_p2d (.clk(clk_fast), .btn_in(btnP2D), .btn_out(db_btnP2D));
    
        // Clock divider for paddle speed
        always @(posedge clk or posedge reset) begin
            if (reset) begin
                paddle_speed_counter <= 0;
                paddle_tick <= 0;
            end else begin
                if (paddle_speed_counter == 1_000_000) begin // Adjust this to slow down updates
                    paddle_speed_counter <= 0;
                    paddle_tick <= 1;
                end else begin
                    paddle_speed_counter <= paddle_speed_counter + 1;
                    paddle_tick <= 0;
                end
            end
        end
    
        // Paddle movement logic
        always @(posedge clk or posedge reset) begin
            if (reset) begin
                paddle1_y <= (SCREEN_HEIGHT - PADDLE_HEIGHT) / 2;
                paddle2_y <= (SCREEN_HEIGHT - PADDLE_HEIGHT) / 2;
            end else if (paddle_tick) begin // Move paddles only on tick
                if (db_btnP1U && paddle1_y > 0)
                    paddle1_y <= paddle1_y - PADDLE_SPEED;
                else if (db_btnP1D && paddle1_y < (SCREEN_HEIGHT - PADDLE_HEIGHT))
                    paddle1_y <= paddle1_y + PADDLE_SPEED;
    
                if (db_btnP2U && paddle2_y > 0)
                    paddle2_y <= paddle2_y - PADDLE_SPEED;
                else if (db_btnP2D && paddle2_y < (SCREEN_HEIGHT - PADDLE_HEIGHT))
                    paddle2_y <= paddle2_y + PADDLE_SPEED;
            end
        end
endmodule
