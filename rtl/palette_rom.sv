`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2026 17:24:53
// Design Name: 
// Module Name: palette_rom
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


module palette_rom(
    input  logic [7:0] pixel_idx,
    output logic [3:0] vgaRed,
    output logic [3:0] vgaGreen,
    output logic [3:0] vgaBlue
);

    logic [11:0] palette_mem [0:255];
    logic [11:0] rgb444;

    // Reserved player palette indices
    localparam logic [7:0] PLAYER_UP_IDX    = 8'd252;
    localparam logic [7:0] PLAYER_DOWN_IDX  = 8'd253;
    localparam logic [7:0] PLAYER_LEFT_IDX  = 8'd254;
    localparam logic [7:0] PLAYER_RIGHT_IDX = 8'd255;

    initial begin
        $readmemh("palette_rgb444.mem", palette_mem);
    end

    always_comb begin
        // Default: look up from generated palette
        rgb444 = palette_mem[pixel_idx];

        // Override reserved player entries
        case (pixel_idx)
            PLAYER_UP_IDX:    rgb444 = 12'hFFF; // white
            PLAYER_DOWN_IDX:  rgb444 = 12'hF00; // red
            PLAYER_LEFT_IDX:  rgb444 = 12'h0FF; // cyan
            PLAYER_RIGHT_IDX: rgb444 = 12'hF0F; // magenta
            default: ;
        endcase

        vgaRed   = rgb444[11:8];
        vgaGreen = rgb444[7:4];
        vgaBlue  = rgb444[3:0];
    end

endmodule
