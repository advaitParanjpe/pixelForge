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
    output logic [3:0] vgaRed, vgaGreen, vgaBlue
    );
    
    localparam logic [9:0] WIDTH = 10'd10;
    
    always_comb begin
        vgaRed   = 4'b0000;
        vgaGreen = 4'b0000;
        vgaBlue  = 4'b0000;
        
        if (video_on) begin
            if ((current_x >= player_x) && (current_x <= player_x + WIDTH-1) && (current_y >= player_y) && (current_y <= player_y + WIDTH-1)) begin
                vgaRed   = 4'b1111;
                vgaGreen = 4'b0000;
                vgaBlue  = 4'b0000;
            end
        end
    end

endmodule
