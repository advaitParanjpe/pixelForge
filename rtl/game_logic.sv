`timescale 1ns / 1ps

module game_logic(
    input  logic clk,
    input  logic rst,
    input  logic btnU,
    input  logic btnL,
    input  logic btnR,
    input  logic btnD,
    output logic [9:0] player_x,
    output logic [9:0] player_y,
    output logic [1:0] player_dir
);

    import world_pkg::*;

    logic [21:0] counter;
    logic        player_tick;

    localparam logic [9:0] STEP = 10'd2;

    typedef enum logic [0:0] {
        ST_IDLE  = 1'b0,
        ST_CHECK = 1'b1
    } move_state_t;

    move_state_t move_state;

    // Stage 0: requested move computed from current position
    logic        req_valid;
    logic [9:0]  req_x, req_y;
    logic [1:0]  req_dir;

    // Stage 1: registered candidate position used for collision check
    logic [9:0]  cand_x, cand_y;

    // Corner tile coordinates for candidate position
    logic [5:0] tl_tile_x, tl_tile_y;
    logic [5:0] tr_tile_x, tr_tile_y;
    logic [5:0] bl_tile_x, bl_tile_y;
    logic [5:0] br_tile_x, br_tile_y;

    // Tile IDs at the 4 corners
    tile_id_t tl_tile_id, tr_tile_id, bl_tile_id, br_tile_id;

    logic [9:0] cand_right;
    logic [9:0] cand_bottom;
    logic       move_blocked;

    always_ff @(posedge clk) begin
        if (rst) begin
            counter <= 22'd0;
        end else begin
            counter <= counter + 22'd1;
        end
    end

    assign player_tick = (counter == 22'd4194303);

    // Priority matches original sequential logic: U > D > L > R
    always_comb begin
        req_valid = 1'b0;
        req_x     = player_x;
        req_y     = player_y;
        req_dir   = player_dir;

        if (btnU) begin
            req_dir = DIR_UP;
            if (player_y >= STEP) begin
                req_y     = player_y - STEP;
                req_valid = 1'b1;
            end
        end else if (btnD) begin
            req_dir = DIR_DOWN;
            if (player_y + PLAYER_SIZE + STEP <= MAP_PIX_H) begin
                req_y     = player_y + STEP;
                req_valid = 1'b1;
            end
        end else if (btnL) begin
            req_dir = DIR_LEFT;
            if (player_x >= STEP) begin
                req_x     = player_x - STEP;
                req_valid = 1'b1;
            end
        end else if (btnR) begin
            req_dir = DIR_RIGHT;
            if (player_x + PLAYER_SIZE + STEP <= MAP_PIX_W) begin
                req_x     = player_x + STEP;
                req_valid = 1'b1;
            end
        end
    end

    // Collision check uses registered candidate position, not the live player regs.
    assign cand_right  = cand_x + PLAYER_SIZE - 1;
    assign cand_bottom = cand_y + PLAYER_SIZE - 1;

    assign tl_tile_x = cand_x[9:4];
    assign tl_tile_y = cand_y[9:4];

    assign tr_tile_x = cand_right[9:4];
    assign tr_tile_y = cand_y[9:4];

    assign bl_tile_x = cand_x[9:4];
    assign bl_tile_y = cand_bottom[9:4];

    assign br_tile_x = cand_right[9:4];
    assign br_tile_y = cand_bottom[9:4];

    tilemap_rom map_tl (
        .tile_x(tl_tile_x),
        .tile_y(tl_tile_y),
        .tile_id(tl_tile_id)
    );

    tilemap_rom map_tr (
        .tile_x(tr_tile_x),
        .tile_y(tr_tile_y),
        .tile_id(tr_tile_id)
    );

    tilemap_rom map_bl (
        .tile_x(bl_tile_x),
        .tile_y(bl_tile_y),
        .tile_id(bl_tile_id)
    );

    tilemap_rom map_br (
        .tile_x(br_tile_x),
        .tile_y(br_tile_y),
        .tile_id(br_tile_id)
    );

    assign move_blocked =
        is_blocked_tile(tl_tile_id) ||
        is_blocked_tile(tr_tile_id) ||
        is_blocked_tile(bl_tile_id) ||
        is_blocked_tile(br_tile_id);

    always_ff @(posedge clk) begin
        if (rst) begin
            player_x   <= 10'd50;
            player_y   <= 10'd50;
            player_dir <= DIR_RIGHT;
            cand_x     <= 10'd50;
            cand_y     <= 10'd50;
            move_state <= ST_IDLE;
        end else begin
            case (move_state)
                ST_IDLE: begin
                    if (player_tick && req_valid) begin
                        cand_x     <= req_x;
                        cand_y     <= req_y;
                        player_dir <= req_dir;
                        move_state <= ST_CHECK;
                    end
                end

                ST_CHECK: begin
                    if (!move_blocked) begin
                        player_x <= cand_x;
                        player_y <= cand_y;
                    end
                    move_state <= ST_IDLE;
                end
            endcase
        end
    end

endmodule
