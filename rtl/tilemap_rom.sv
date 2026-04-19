`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2026 17:00:44
// Design Name: 
// Module Name: tilemap_rom
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


module tilemap_rom(
    input  logic [5:0] tile_x,
    input  logic [5:0] tile_y,
    output world_pkg::tile_id_t tile_id
);

    import world_pkg::*;

    localparam int MAP_DEPTH = MAP_TILES_W * MAP_TILES_H;
    logic [7:0] map_mem [0:MAP_DEPTH-1];
    logic [11:0] addr;

    initial begin
        $readmemh("tilemap.mem", map_mem);
    end

    always_comb begin
        addr = tile_y * MAP_TILES_W + tile_x;
        tile_id = tile_id_t'(map_mem[addr]);
    end

endmodule
