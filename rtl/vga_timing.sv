`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.04.2026 21:13:43
// Design Name: 
// Module Name: vga_timing
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


module vga_timing(
    input logic clk,
    input logic rst,
    output logic hsync, vsync, video_on, 
    output logic [9:0] x, 
    output logic [9:0] y
    );
    
    logic [1:0] counter;
    logic pixel_tick;
    
    always_ff @(posedge clk) begin
        if (rst) begin
            counter <= 2'b0;
        end else begin
            counter <= counter + 2'd1;
        end
    end
            
    assign pixel_tick = (counter == 2'd3);
    
    
    always_ff @ (posedge clk) begin
        if (rst) begin
            x <= 10'd0;
            y <= 10'd0;
        end else if (pixel_tick) begin
            if (x == 10'd799) begin
                x <= 10'd0;
                if (y == 10'd524) begin
                    y <= 10'd0;
                end else begin
                    y <= y + 10'd1;
                end
            end else begin
                x <= x + 10'd1;
            end
        end
    end
    
    
    always_comb begin
        video_on = 1'b0;    
        if ((x < 10'd640) && (y < 10'd480)) begin
            video_on = 1'b1;
        end
    end
    
    always_comb begin
         hsync = 1'b1; //active low
         vsync = 1'b1; //active low

         if ((x < 10'd752) && (x > 10'd655)) begin
             hsync = 1'b0;
         end
            
         if ((y < 10'd492) && (y > 10'd489)) begin
             vsync = 1'b0;
         end
     end


endmodule
