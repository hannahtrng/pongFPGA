`timescale 1ns / 1ps

module game_state_controller(
    input clk,
    input clk_fst,
    input reset,
    input switchMode, // Score mode toggle
    input [3:0] scoreP1, scoreP2,
    input [5:0] timer_minutes, timer_seconds,
    output reg game_active, // 1 = game running, 0 = game paused
    output reg game_over, // 1 = game over state
    output reg [1:0] game_state // 0 = game mode, 1 = score mode, 2 = game over
);
    
    parameter GAME_MODE = 2'b00;
    parameter SCORE_MODE = 2'b01;
    parameter GAME_OVER = 2'b10;
    
    reg prev_switch = 0, switchMode_db = 0;
    
    always @(posedge clk_fst) begin
         if (switchMode && !prev_switch) begin
             switchMode_db <= ~switchMode_db; // Toggle adj state
         end
         prev_switch <= switchMode;
     end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            game_active <= 1;
            game_over <= 0;
            game_state <= GAME_MODE;
        end else begin
            case (game_state)
                GAME_MODE: begin
                    if (switchMode) begin
                        game_active <= 0;
                        game_state <= SCORE_MODE;
                    end else if (timer_minutes == 0 && timer_seconds == 0) begin
                        game_active <= 0;
                        game_over <= 1;
                        game_state <= GAME_OVER;
                    end else if (scoreP1 == 6 || scoreP2 == 6) begin
                        game_active <= 0;
                        game_over <= 1;
                        game_state <= GAME_OVER;
                    end else begin
                        game_active <= 1;
                    end
                end
                
                SCORE_MODE: begin
                    if (!switchMode) begin
                        game_active <= 1;
                        game_state <= GAME_MODE;
                    end
                end
                
                GAME_OVER: begin
                    game_active <= 0;
                end
            endcase
        end
    end
    
endmodule
