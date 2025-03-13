`timescale 1ns / 1ps

module score_display(
    input clk,
    input switchMode, // Score mode toggle
    input [5:0] timer_minutes, timer_seconds,
    input [3:0] scoreP1, scoreP2,
    output reg [6:0] seg,
    output reg [3:0] an,
    output reg [15:0] led
);
    
    reg [1:0] digit_select;
    reg [3:0] current_digit;
    
    always @(posedge clk) begin
        digit_select <= digit_select + 1;
        case (digit_select)
            2'b00: begin
                current_digit <= switchMode ? scoreP1 / 10 : timer_minutes / 10;
                an <= 4'b0111;
            end
            2'b01: begin
                an <= 4'b1011;
                current_digit <= switchMode ? scoreP1 % 10 : timer_minutes % 10;
            end
            2'b10: begin
                an <= 4'b1101;
                current_digit <= switchMode ? scoreP2 / 10 : timer_seconds / 10;
            end
            2'b11: begin
                an <= 4'b1110;
                current_digit <= switchMode ? scoreP2 % 10 : timer_seconds % 10;
            end
        endcase
    end
    
    always @(*) begin
        case (current_digit)
            4'd0: seg = 7'b1000000;
            4'd1: seg = 7'b1111001;
            4'd2: seg = 7'b0100100;
            4'd3: seg = 7'b0110000;
            4'd4: seg = 7'b0011001;
            4'd5: seg = 7'b0010010;
            4'd6: seg = 7'b0000010;
            4'd7: seg = 7'b1111000;
            4'd8: seg = 7'b0000000;
            4'd9: seg = 7'b0010000;
            default: seg = 7'b1111111;
        endcase
    end
    
    always @(posedge clk) begin
        if (scoreP1 == 6 || scoreP2 == 6) begin
            // Game over condition - blink LEDs
            led <= 16'hFFFF;
        end else begin
            led[15:8] <= scoreP1;
            led[7:0] <= scoreP2;   
        end
    end
    
endmodule
