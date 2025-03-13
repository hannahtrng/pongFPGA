`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2025 10:51:16 AM
// Design Name: 
// Module Name: clock_divider
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
//1HZ Clock
module clock_divider(
    input wire clk,         // 100MHz input clock
    input wire rst,         // Reset
    output reg clk_1hz,     // 1Hz clock output
    output reg clk_2hz,
    output reg clk_5hz,     // 2Hz clock output
    output reg clk_25Mhz,
    output reg clk_fast     // Fast clock for display multiplexing
);
    reg [26:0] counter_1hz = 0;  
    reg [25:0] counter_2hz = 0;  
    reg [16:0] counter_fast = 0; 
    reg [24:0] counter_5hz = 0;
    reg [2:0] counter_25Mhz = 0;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter_1hz <= 0;
            counter_2hz <= 0;
            counter_fast <= 0;
            counter_5hz <=0;
            counter_25Mhz <= 0;
            clk_1hz <= 0;
            clk_2hz <= 0;
            clk_5hz <= 0;
            clk_fast <= 0;
            clk_25Mhz <=0;
        end else begin
            // 1Hz clock (50M cycles for 100MHz)
            if (counter_1hz >= 50_000_000) begin
                counter_1hz <= 0;
                clk_1hz <= ~clk_1hz;
            end else counter_1hz <= counter_1hz + 1;
            
            //25Mhz
             if (counter_25Mhz >= 2) begin
               counter_25Mhz <= 0;
               clk_25Mhz <= ~clk_25Mhz;
           end else counter_25Mhz <= counter_25Mhz + 1;
            
            
            // 2Hz clock (25M cycles for 100MHz)
            if (counter_2hz >= 25_000_000) begin
                counter_2hz <= 0;
                clk_2hz <= ~clk_2hz;
            end else counter_2hz <= counter_2hz + 1;
            
            // 5Hz
            if (counter_5hz >= 10_000_000) begin
                counter_5hz <=0;
                clk_5hz <= ~clk_5hz;
            end else counter_5hz <= counter_5hz+1;

            // Fast clock (~500Hz)
            if (counter_fast >= 50_000) begin
                counter_fast <= 0;
                clk_fast <= ~clk_fast;
            end else counter_fast <= counter_fast + 1;
        end
    end
endmodule


