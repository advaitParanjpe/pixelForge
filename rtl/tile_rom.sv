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
    input  logic [7:0] tile_id,
    input  logic [3:0] tile_px,
    input  logic [3:0] tile_py,
    output logic [7:0] pixel_idx
);

    import world_pkg::*;

    localparam logic [7:0] PIXEL_GRASS = 8'd0;
    localparam logic [7:0] PIXEL_WATER = 8'd1;
    localparam logic [7:0] PIXEL_PATH  = 8'd2;

    always_comb begin
        pixel_idx = PIXEL_GRASS;

        case (tile_id)
            TILE_GRASS: pixel_idx = PIXEL_GRASS;
            TILE_WATER: pixel_idx = PIXEL_WATER;
            TILE_PATH:  pixel_idx = PIXEL_PATH;
            default:    pixel_idx = PIXEL_GRASS;
        endcase
    end

endmodule
