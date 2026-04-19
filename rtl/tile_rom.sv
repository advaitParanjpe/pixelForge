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
    
    localparam int NUM_TILES       = 24;
    localparam int PIXELS_PER_TILE = TILE_SIZE * TILE_SIZE;
    localparam int MEM_DEPTH       = NUM_TILES * PIXELS_PER_TILE;
    localparam int ADDR_W = $clog2(MEM_DEPTH);
    
    logic [7:0] tile_mem [0:MEM_DEPTH-1];
    logic [ADDR_W-1:0] addr;
    
    initial begin
        $readmemh("tile_pixels.mem", tile_mem);
    end

    always_comb begin
        addr = tile_id * PIXELS_PER_TILE + tile_py * TILE_SIZE + tile_px;

        if (tile_id < NUM_TILES)
            pixel_idx = tile_mem[addr];
        else
            pixel_idx = 8'd0;
    end

endmodule
