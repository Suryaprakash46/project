module traffic_control (
    input wire clk,          // Clock signal
    input wire rst,          // Reset signal
    input wire x,           // Control input (1 = vehicles in country road)
    output reg main_green,   // Main road green light
    output reg country_green, // Country road green light
    output reg [1:0] state   // State for debugging
);

    // State encoding
    parameter MAIN_GREEN = 2'b00, 
              MAIN_RED = 2'b01, 
              COUNTRY_GREEN = 2'b10;

    reg [1:0] current_state, next_state;
    reg [3:0] timer; // Timer for light duration

    // State transition
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= MAIN_GREEN;
            timer <= 0;
        end else begin
            current_state <= next_state;
            if (timer > 0)
                timer <= timer - 1; // Decrement timer
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            MAIN_GREEN: begin
                if (timer == 0) begin
                    next_state = MAIN_RED;
                    timer = 4'b1111; // Set timer for red light duration
                end else begin
                    next_state = MAIN_GREEN; // Stay in current state
                end
            end
            
            MAIN_RED: begin
                if (x) begin
                    next_state = COUNTRY_GREEN;
                    timer = 4'b0111; // Set timer for country green duration
                end else begin
                    next_state = MAIN_GREEN;
                    timer = 4'b1111; // Reset timer for main green duration
                end
            end
            
            COUNTRY_GREEN: begin
                if (timer == 0) begin
                    next_state = MAIN_GREEN;
                    timer = 4'b1111; // Set timer for main green duration
                end else begin
                    next_state = COUNTRY_GREEN; // Stay in current state
                end
            end
            
            default: next_state = MAIN_GREEN; // Default state
        endcase
    end

    // Output logic
    always @(*) begin
        // Default output values
        main_green = 0;
        country_green = 0;
        
        case (current_state)
            MAIN_GREEN: begin
                main_green = 1; // Main road green
            end
            
            MAIN_RED: begin
                main_green = 0; // Main road red
            end
            
            COUNTRY_GREEN: begin
                country_green = 1; // Country road green
            end
        endcase
        
        // Debugging output
        state = current_state; // For observation
    end

endmodule
