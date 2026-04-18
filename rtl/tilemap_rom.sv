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
    output logic [7:0] tile_id
    );
    
    localparam logic [7:0] TILE_GRASS = 8'd0;
    localparam logic [7:0] TILE_PATH  = 8'd1;
    localparam logic [7:0] TILE_WATER = 8'd2;
    
    always_comb begin
        tile_id = TILE_GRASS; //otherwise grass
        
        if (tile_y == 6'd20) begin //path
            tile_id = TILE_PATH;
        end
        
        if (tile_y == 6'd16) begin // river
            tile_id = TILE_WATER;
        end

    end

endmodule
