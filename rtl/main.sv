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
    input logic btnU,
    input logic btnL,
    input logic btnR,
    input logic btnD,
    output logic [3:0] vgaRed,
    output logic [3:0] vgaGreen,
    output logic [3:0] vgaBlue,
    output logic Vsync,
    output logic Hsync
);
    
    // internal signals from  vga_timing
    logic hsync;
    logic vsync;
    logic video_on;
    logic [9:0] x;
    logic [9:0] y;
    
    // internal signals from renderer
    logic [9:0] player_x;
    logic [9:0] player_y;
    

    
    //assign player_x = 10'd300;
    //assign player_y = 10'd250;
    
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
    
    // Instantiate the renderer
    renderer square_inst (
        .video_on(video_on),
        .current_x(x),
        .current_y(y),
        .player_x(player_x),
        .player_y(player_y),
        .vgaRed(vgaRed),
        .vgaGreen(vgaGreen),
        .vgaBlue(vgaBlue)
    );
    
    // Instantiate the game_logic
    game_logic move_square_inst (
        .clk(clk),
        .rst(1'b0),
        .btnU(btnU),
        .btnD(btnD),
        .btnL(btnL),
        .btnR(btnR),
        .player_x(player_x),
        .player_y(player_y)
    );
    
    // Drive the board-facing sync outputs
    assign Hsync = hsync;
    assign Vsync = vsync;
    
    
endmodule
