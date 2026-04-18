`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2026 00:29:13
// Design Name: 
// Module Name: renderer
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


module renderer(
    input logic video_on,
    input logic [9:0] current_x,
    input logic [9:0] current_y,
    input logic [9:0] player_x,
    input logic [9:0] player_y, 
    input logic [1:0] player_dir,
    output logic [7:0] final_pixel_idx
    );
    

    localparam logic [4:0] TILE_SIZE = 5'd16;

    localparam logic [9:0] WIDTH = 10'd10;
    
    logic [5:0] map_tile_x;
    logic [5:0] map_tile_y;
    logic [3:0] tile_px;
    logic [3:0] tile_py;
    logic [7:0] tile_id;
    logic [3:0] tile_pixel_idx;
    
    assign map_tile_x = current_x[9:4];
    assign map_tile_y = current_y[9:4];
    assign tile_px    = current_x[3:0];
    assign tile_py    = current_y[3:0];
    
    tilemap_rom map_inst (
        .tile_x(map_tile_x),
        .tile_y(map_tile_y),
        .tile_id(tile_id)
    );
    
    tile_rom tile_inst (
        .tile_id(tile_id),
        .tile_px(tile_px),
        .tile_py(tile_py),
        .pixel_idx(tile_pixel_idx)
    );

    
    always_comb begin
    final_pixel_idx = 8'd0;

    if (video_on) begin
        final_pixel_idx = tile_pixel_idx;

        if ((current_x >= player_x) && (current_x <= player_x + WIDTH - 1) &&
            (current_y >= player_y) && (current_y <= player_y + WIDTH - 1)) begin

            case (player_dir)
                2'd0: final_pixel_idx = 8'd3; // player_up
                2'd1: final_pixel_idx = 8'd4; // player_down
                2'd2: final_pixel_idx = 8'd5; // player_left
                2'd3: final_pixel_idx = 8'd6; // player_right
                default: final_pixel_idx = 8'd3;
            endcase
        end
    end
end

endmodule
