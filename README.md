# FPGA Tile-Based VGA Game

A simple tile-based VGA game implemented on FPGA in SystemVerilog. The project renders a scrolling tilemap to VGA, supports player movement with collision detection, and uses a camera controller to follow the player through a larger world.

## Features

- 640x480 VGA output
- Tile-based world rendering
- Shared world definitions via `world_pkg.sv`
- Player movement using Basys3 buttons
- Collision detection against blocked map tiles
- Camera follow / scrolling across a world larger than one screen
- Direction-based player sprite coloring
- Simple test map with path and water tiles

## Project Structure

- `main.sv`  
  Top-level module. Connects timing, game logic, renderer, palette ROM, and camera controller.

- `vga_timing.sv`  
  Generates VGA timing signals, screen coordinates, and `video_on`.

- `renderer.sv`  
  Converts screen coordinates plus camera offset into world coordinates, samples the tilemap, and overlays the player.

- `game_logic.sv`  
  Handles player movement, movement tick timing, and collision detection using map tile lookups.

- `camera_controller.sv`  
  Computes camera position from player position and clamps the camera to map bounds.

- `tilemap_rom.sv`  
  Defines the world layout by mapping tile coordinates to tile IDs.

- `tile_rom.sv`  
  Maps tile IDs to pixel indices.

- `palette_rom.sv`  
  Maps pixel indices to VGA RGB values.

- `world_pkg.sv`  
  Shared package containing tile enums, direction enums, world/screen/map constants, and collision helper functions.

## Current Gameplay Logic

- Grass and path tiles are walkable
- Water tiles are blocked
- Player collision is checked against the 4 corners of the proposed next bounding box
- Camera attempts to keep the player centered while staying within world bounds

## Recent Architecture Changes

This version introduces a more scalable world/rendering structure:

- Moved shared constants and enums into `world_pkg.sv`
- Added tile-based collision detection in `game_logic.sv`
- Added `camera_controller.sv` for scrolling
- Refactored rendering to sample the world using:
  - `world_x = camera_x + screen_x`
  - `world_y = camera_y + screen_y`
- Improved map debugging by adding x-dependent landmarks to verify horizontal scrolling

## Notes

- Collision is based on tile IDs, not palette colors
- The map is currently hardcoded in `tilemap_rom.sv`
- Buttons are functional, though input synchronization/debouncing could still be improved in a future update

## Future Work

- Replace hardcoded map logic with a fuller tilemap representation
- Add bridges, walls, and more varied terrain
- Add collectibles, goals, or win conditions
- Improve player rendering beyond flat color blocks
- Add synchronized / debounced button handling

## Recent updates

- Added new tile sprites
- Added memory-backed tilemap/map generation flow
- Pipelined `game_logic.sv` to improve timing closure
- Design now meets 100 MHz timing in Vivado