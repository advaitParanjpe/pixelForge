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
    input logic [5:0] tile_x,
    input logic [5:0] tile_y,
    output world_pkg::tile_id_t tile_id
    );
    
    import world_pkg::*;

    always_comb begin
        tile_id = TILE_GRASS; //otherwise grass
        
        if (tile_y == 6'd13) begin //path
            tile_id = TILE_PATH;
        end
        
        if (tile_y == 6'd16) begin // river
            tile_id = TILE_WATER;
        end
        
        if (tile_x == 6'd20) begin // river
            tile_id = TILE_PATH;
        end

    end

endmodule
