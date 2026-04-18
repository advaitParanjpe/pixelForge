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

    localparam logic [7:0] grass        = 8'd0;
    localparam logic [7:0] water        = 8'd1;
    localparam logic [7:0] path         = 8'd2;
    localparam logic [7:0] player_up    = 8'd3;
    localparam logic [7:0] player_down  = 8'd4;
    localparam logic [7:0] player_left  = 8'd5;
    localparam logic [7:0] player_right = 8'd6;

    always_comb begin
        vgaRed   = 4'b0000;
        vgaGreen = 4'b0000;
        vgaBlue  = 4'b0000;
        
        case (pixel_idx)
            grass: begin
                vgaRed   = 4'b0001;
                vgaGreen = 4'b1010;
                vgaBlue  = 4'b0001;
            end
            
            water: begin
                vgaRed   = 4'b0000;
                vgaGreen = 4'b0011;
                vgaBlue  = 4'b1111;
            end
            
            path: begin
                // tan / sandy brown
                vgaRed   = 4'b1100;
                vgaGreen = 4'b1001;
                vgaBlue  = 4'b0101;
            end

            player_up: begin
                vgaRed   = 4'b0000;
                vgaGreen = 4'b1111;
                vgaBlue  = 4'b0000;
            end

            player_down: begin
                vgaRed   = 4'b1111;
                vgaGreen = 4'b1111;
                vgaBlue  = 4'b0000;
            end

            player_left: begin
                vgaRed   = 4'b0000;
                vgaGreen = 4'b1111;
                vgaBlue  = 4'b1111;
            end

            player_right: begin
                vgaRed   = 4'b0000;
                vgaGreen = 4'b0000;
                vgaBlue  = 4'b1111;
            end

            default: begin
                vgaRed   = 4'b0000;
                vgaGreen = 4'b0000;
                vgaBlue  = 4'b0000;
            end
        endcase
    end

endmodule
