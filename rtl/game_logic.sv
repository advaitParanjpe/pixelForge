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
    input logic clk,
    input logic rst,
    input logic btnU,
    input logic btnL,
    input logic btnR,
    input logic btnD,
    output logic [9:0] player_x,
    output logic [9:0] player_y,
    output logic [1:0] player_dir
    );
    
    logic [21:0] counter;
    logic player_tick;
    localparam [9:0] STEP = 10'd2;
    localparam [9:0] SIZE = 10'd10;
    
    always_ff @(posedge clk) begin
        if (rst) begin
            counter <= 22'b0;
        end else begin
            counter <= counter + 22'd1;
        end
    end
    
    assign player_tick = (counter == 22'd4194303);
    
    always_ff @(posedge clk) begin
        if (rst) begin
            player_x <= 10'd300;
            player_y <= 10'd250;
            player_dir <= 2'd3;
        end else if (player_tick) begin
            if ((btnU) && (player_y >= STEP)) begin
                player_y <= player_y - STEP;
                player_dir <= 2'd0;
            end
                
            if ((btnD) && (player_y + SIZE + STEP <= 10'd480)) begin
                player_y <= player_y + STEP;
                player_dir <= 2'd1;
            end
                
            if ((btnL) && (player_x >= STEP)) begin
                player_x <= player_x - STEP;
                player_dir <= 2'd2;
            end
                
            if ((btnR) && (player_x + SIZE + STEP <= 10'd640)) begin
                player_x <= player_x + STEP;
                player_dir <= 2'd3;
            end
        end
    end  
endmodule
