`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2026 01:09:25
// Design Name: 
// Module Name: game_logic
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


  module game_logic(
    input  logic clk,
    input  logic rst,
    input  logic btnU,
    input  logic btnL,
    input  logic btnR,
    input  logic btnD,
    output logic [9:0] player_x,
    output logic [9:0] player_y,
    output logic [1:0] player_dir
);

    import world_pkg::*;

    logic [21:0] counter;
    logic player_tick;

    localparam logic [9:0] STEP = 10'd2;

    // Proposed next position
    logic [9:0] next_x, next_y;

    // Corner tile coordinates for proposed position
    logic [5:0] tl_tile_x, tl_tile_y;
    logic [5:0] tr_tile_x, tr_tile_y;
    logic [5:0] bl_tile_x, bl_tile_y;
    logic [5:0] br_tile_x, br_tile_y;

    // Tile IDs at the 4 corners
    tile_id_t tl_tile_id, tr_tile_id, bl_tile_id, br_tile_id;

    logic move_blocked;

    always_ff @(posedge clk) begin
        if (rst) begin
            counter <= 22'd0;
        end else begin
            counter <= counter + 22'd1;
        end
    end

    assign player_tick = (counter == 22'd4194303);

    // Default proposed position = current position
    always_comb begin
        next_x = player_x;
        next_y = player_y;
    
        if (btnU) begin
            if (player_y >= STEP)
                next_y = player_y - STEP;
        end else if (btnD) begin
            if (player_y + PLAYER_SIZE + STEP <= MAP_PIX_H)
                next_y = player_y + STEP;
        end else if (btnL) begin
            if (player_x >= STEP)
                next_x = player_x - STEP;
        end else if (btnR) begin
            if (player_x + PLAYER_SIZE + STEP <= MAP_PIX_W)
                next_x = player_x + STEP;
        end
    end

    logic [9:0] next_right;
    logic [9:0] next_bottom;
    
    assign next_right  = next_x + PLAYER_SIZE - 1;
    assign next_bottom = next_y + PLAYER_SIZE - 1;
    
    assign tl_tile_x = next_x[9:4];
    assign tl_tile_y = next_y[9:4];
    
    assign tr_tile_x = next_right[9:4];
    assign tr_tile_y = next_y[9:4];
    
    assign bl_tile_x = next_x[9:4];
    assign bl_tile_y = next_bottom[9:4];
    
    assign br_tile_x = next_right[9:4];
    assign br_tile_y = next_bottom[9:4];
    // Query map at each corner
    tilemap_rom map_tl (
        .tile_x(tl_tile_x),
        .tile_y(tl_tile_y),
        .tile_id(tl_tile_id)
    );

    tilemap_rom map_tr (
        .tile_x(tr_tile_x),
        .tile_y(tr_tile_y),
        .tile_id(tr_tile_id)
    );

    tilemap_rom map_bl (
        .tile_x(bl_tile_x),
        .tile_y(bl_tile_y),
        .tile_id(bl_tile_id)
    );

    tilemap_rom map_br (
        .tile_x(br_tile_x),
        .tile_y(br_tile_y),
        .tile_id(br_tile_id)
    );

    assign move_blocked =
        is_blocked_tile(tl_tile_id) ||
        is_blocked_tile(tr_tile_id) ||
        is_blocked_tile(bl_tile_id) ||
        is_blocked_tile(br_tile_id);

    always_ff @(posedge clk) begin
        if (rst) begin
            player_x   <= 10'd50;
            player_y   <= 10'd50;
            player_dir <= 2'd3;
        end else if (player_tick) begin
            if (btnU) begin
                player_dir <= DIR_UP;
                if ((player_y >= STEP) && !move_blocked)
                    player_y <= next_y;
            end else if (btnD) begin
                player_dir <= DIR_DOWN;
                if ((player_y + PLAYER_SIZE + STEP <= MAP_PIX_H) && !move_blocked)
                    player_y <= next_y;
            end else if (btnL) begin
                player_dir <= DIR_LEFT;
                if ((player_x >= STEP) && !move_blocked)
                    player_x <= next_x;
            end else if (btnR) begin
                player_dir <= DIR_RIGHT;
                if ((player_x + PLAYER_SIZE + STEP <= MAP_PIX_W) && !move_blocked)
                    player_x <= next_x;
            end
        end
    end

endmodule
