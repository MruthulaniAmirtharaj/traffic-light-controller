`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   07:34:53 02/25/2025
// Design Name:   Traffic_Light_Controller
// Module Name:   /home/mithu/xilinxpractice/traffic_light_controller/traffic_light_controller_tb.v
// Project Name:  traffic_light_controller
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Traffic_Light_Controller
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Traffic_Light_Controller_tb;
    reg clk, rst;
    wire [2:0] NS, EW;

    // Instantiate the Traffic Light Controller module
    Traffic_Light_Controller uut (
        .clk(clk),
        .rst(rst),
        .NS(NS),
        .EW(EW)
    );

    // Clock generation (10MHz clock)
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        clk = 0;
        rst = 1;  // Apply reset
        #20;
        rst = 0;  // Release reset

        // Run the simulation for a certain period
        #200_000_000;  // Adjust time as needed
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %0t | NS: %b | EW: %b", $time, NS, EW);
    end
endmodule 