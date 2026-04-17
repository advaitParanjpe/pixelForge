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
    
    logic [9:0] camera_x;
    logic [9:0] camera_y;
    
    logic [1:0] player_dir;
    logic [7:0] final_pixel_idx;
    logic [3:0] rawRed, rawGreen, rawBlue;

 
    // Instantiate the VGA timing generator
    vga_timing timing_inst (
        .clk(clk),
        .rst(rst),
        .hsync(hsync),
        .vsync(vsync),
        .video_on(video_on),
        .x(x),
        .y(y)
    );
    
    // Instantiate the renderer
    renderer render_inst (
        .current_x(x),
        .current_y(y),
        .camera_x(camera_x),
        .camera_y(camera_y),
        .player_x(player_x),
        .player_y(player_y),
        .player_dir(player_dir),
        .final_pixel_idx(final_pixel_idx)
    );
    
    // Instantiate the game_logic
    game_logic game_inst (
        .clk(clk),
        .rst(rst),
        .btnU(btnU),
        .btnD(btnD),
        .btnL(btnL),
        .btnR(btnR),
        .player_x(player_x),
        .player_y(player_y),
        .player_dir(player_dir)
    );
    
    // instantiate palette_rom
    palette_rom palette_inst (
        .pixel_idx(final_pixel_idx),
        .vgaRed(rawRed),
        .vgaGreen(rawGreen),
        .vgaBlue(rawBlue)
    );
    
    
    // instantiate camera controller
    camera_controller cam_inst (
        .player_x(player_x),
        .player_y(player_y),
        .camera_x(camera_x),
        .camera_y(camera_y)
    );
        
    // Drive the board-facing sync outputs
    assign Hsync = hsync;
    assign Vsync = vsync;
    assign vgaRed   = video_on ? rawRed   : 4'h0;
    assign vgaGreen = video_on ? rawGreen : 4'h0;
    assign vgaBlue  = video_on ? rawBlue  : 4'h0;

endmodule
