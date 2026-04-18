`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2026 17:13:04
// Design Name: 
// Module Name: tile_rom
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


module tile_rom(
    input logic [7:0] tile_id,
    input logic [3:0] tile_px,
    input logic [3:0] tile_py,
    output logic [3:0] pixel_idx
    );
    
    localparam logic [7:0] TILE_GRASS = 8'd0;
    localparam logic [7:0] TILE_PATH  = 8'd1;
    localparam logic [7:0] TILE_WATER = 8'd2;
    
    localparam logic [3:0] grass = 4'd0;
    localparam logic [3:0] water = 4'd1;
    localparam logic [3:0] path = 4'd2;
    
    always_comb begin
        pixel_idx = grass;
    
        case (tile_id)
            TILE_GRASS: pixel_idx = grass;
            TILE_WATER: pixel_idx = water;
            TILE_PATH: pixel_idx = path;
            default: pixel_idx = grass;
        endcase
    end 
endmodule
