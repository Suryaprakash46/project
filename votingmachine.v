module voting_machine (
    input clk,               // Clock signal
    input reset,             // Reset signal
    input [1:0] vote_input, // 2-bit input (representing candidate choice)
    input vote_enable,       // Signal to enable voting
    output reg [3:0] votes_A, // 4-bit vote count for Candidate A
    output reg [3:0] votes_B, // 4-bit vote count for Candidate B
    output reg [3:0] votes_C  // 4-bit vote count for Candidate C
);

    // Initialize vote counts on reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            votes_A <= 4'b0000;  // Reset vote count for Candidate A
            votes_B <= 4'b0000;  // Reset vote count for Candidate B
            votes_C <= 4'b0000;  // Reset vote count for Candidate C
        end
        else if (vote_enable) begin
            // Increase the vote count based on the input
            case (vote_input)
                2'b00: votes_A <= votes_A + 1;  // Vote for Candidate A
                2'b01: votes_B <= votes_B + 1;  // Vote for Candidate B
                2'b10: votes_C <= votes_C + 1;  // Vote for Candidate C
                default: ;
            endcase
        end
    end

    // Display the results (this would be done in hardware display or logs)
    always @(posedge clk) begin
        $display("Candidate A: %d votes", votes_A);
        $display("Candidate B: %d votes", votes_B);
        $display("Candidate C: %d votes", votes_C);
    end

endmodule
