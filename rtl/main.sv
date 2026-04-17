`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.04.2026 20:55:14
// Design Name: 
// Module Name: main
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


module main(
    input logic clk,
    input logic rst, 
    output logic [3:0] vgaRed,
    output logic [3:0] vgaGreen,
    output logic [3:0] vgaBlue,
    output logic Vsync,
    output logic Hsync
);
    
    // internal signals from other module
    logic hysnc;
    logic vsync;
    logic video_on;
    logic [9:0] x;
    logic [9:0] y;
    
    // Instantiate the VGA timing generator
    vga_timing timing_inst (
        .clk(clk),
        .rst(1'b0),
        .hsync(hsync),
        .vsync(vsync),
        .video_on(video_on),
        .x(x),
        .y(y)
    );
    
    // Drive the board-facing sync outputs
    assign Hsync = hsync;
    assign Vsync = vsync;
    
    // Simple first test pattern:
    // show solid white in the visible region, black elsewhere
    always_comb begin
        vgaRed   = 4'b0000;
        vgaGreen = 4'b0000;
        vgaBlue  = 4'b0000;

        if (video_on) begin
            if ((x > 212) && (x < 425)) begin
                vgaRed   = 4'b1111;
            end else if ((x > 425) && (x < 640)) begin
                vgaGreen = 4'b1111;
            end else if (x < 213) begin
                vgaBlue  = 4'b1111;
            end
        end
    end
    
endmodule
