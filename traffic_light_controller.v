`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:13:54 02/25/2025 
// Design Name: 
// Module Name:    traffic_light_controller 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Traffic_Light_Controller(
    input clk,          // Clock signal
    input rst,          // Reset signal
    output reg [2:0] NS, // North-South Lights (Red, Yellow, Green)
    output reg [2:0] EW  // East-West Lights (Red, Yellow, Green)
);

// State Encoding (Replace typedef enum with parameter)
parameter S0 = 2'b00;  // NS Green, EW Red
parameter S1 = 2'b01;  // NS Yellow, EW Red
parameter S2 = 2'b10;  // NS Red, EW Green
parameter S3 = 2'b11;  // NS Red, EW Yellow

reg [1:0] current_state, next_state;
reg [31:0] counter;

// Define light outputs
parameter RED    = 3'b100;
parameter YELLOW = 3'b010;
parameter GREEN  = 3'b001;

// Time Delays (adjust as per FPGA clock speed)
parameter GREEN_TIME  = 50_000_000;  // 5 sec (assuming 10MHz clock)
parameter YELLOW_TIME = 10_000_000;  // 1 sec

// State Transition Logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        current_state <= S0;
        counter <= 0;
    end else begin
        if (counter >= GREEN_TIME && (current_state == S0 || current_state == S2)) begin
            current_state <= next_state;
            counter <= 0;
        end else if (counter >= YELLOW_TIME && (current_state == S1 || current_state == S3)) begin
            current_state <= next_state;
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
end

// Next State Logic
always @(*) begin
    case (current_state)
        S0: next_state = S1;  // NS Green → NS Yellow
        S1: next_state = S2;  // NS Yellow → EW Green
        S2: next_state = S3;  // EW Green → EW Yellow
        S3: next_state = S0;  // EW Yellow → NS Green
        default: next_state = S0;
    endcase
end

// Output Logic
always @(*) begin
    case (current_state)
        S0: begin // NS Green, EW Red
            NS = GREEN;
            EW = RED;
        end
        S1: begin // NS Yellow, EW Red
            NS = YELLOW;
            EW = RED;
        end
        S2: begin // NS Red, EW Green
            NS = RED;
            EW = GREEN;
        end
        S3: begin // NS Red, EW Yellow
            NS = RED;
            EW = YELLOW;
        end
        default: begin
            NS = RED;
            EW = RED;
        end
    endcase
end

endmodule
