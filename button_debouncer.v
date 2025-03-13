`timescale 1ns / 1ps

module button_debouncer(
    input clk,
    input btn_in,
    output wire btn_out
);
    
 
    reg [19:0] counter = 0; // 20-bit counter for timing
    reg btn_stable = 0;
    reg btn_last = 0; // Previous state of the button

    always @(posedge clk) begin
        if (btn_in == btn_last) begin
            if (counter < 1_000_000) // Adjust for debounce delay (~20ms)
                counter <= counter + 1;
            else
                btn_stable <= btn_in; // Set stable output when counter expires
        end else begin
            counter <= 0; // Reset counter if the button state changes
        end
        btn_last <= btn_in; // Store the last button state
    end

    assign btn_out = btn_stable; // Output stable button value

endmodule
    