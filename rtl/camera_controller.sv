`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2026 15:51:24
// Design Name: 
// Module Name: camera_controller
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


module camera_controller(
    input  logic [9:0] player_x,
    input  logic [9:0] player_y,
    output logic [9:0] camera_x,
    output logic [9:0] camera_y
);

    import world_pkg::*;

    localparam int HALF_SCREEN_W = SCREEN_W / 2;
    localparam int HALF_SCREEN_H = SCREEN_H / 2;
    localparam int HALF_PLAYER   = PLAYER_SIZE / 2;

    localparam int CAMERA_MAX_X =
        (MAP_PIX_W > SCREEN_W) ? (MAP_PIX_W - SCREEN_W) : 0;

    localparam int CAMERA_MAX_Y =
        (MAP_PIX_H > SCREEN_H) ? (MAP_PIX_H - SCREEN_H) : 0;

    integer player_center_x;
    integer player_center_y;
    integer desired_camera_x;
    integer desired_camera_y;

    always_comb begin
        player_center_x  = player_x + HALF_PLAYER;
        player_center_y  = player_y + HALF_PLAYER;

        desired_camera_x = player_center_x - HALF_SCREEN_W;
        desired_camera_y = player_center_y - HALF_SCREEN_H;

        if (MAP_PIX_W <= SCREEN_W) begin
            camera_x = 10'd0;
        end else if (desired_camera_x < 0) begin
            camera_x = 10'd0;
        end else if (desired_camera_x > CAMERA_MAX_X) begin
            camera_x = CAMERA_MAX_X[9:0];
        end else begin
            camera_x = desired_camera_x[9:0];
        end

        if (MAP_PIX_H <= SCREEN_H) begin
            camera_y = 10'd0;
        end else if (desired_camera_y < 0) begin
            camera_y = 10'd0;
        end else if (desired_camera_y > CAMERA_MAX_Y) begin
            camera_y = CAMERA_MAX_Y[9:0];
        end else begin
            camera_y = desired_camera_y[9:0];
        end
    end

endmodule
