# pixelForge_v2 Dev Log

## 2026-04-17
- Cleaned up project structure into `rtl/`, `constraints/`, and `tb/`
- Fixed Vivado project references after moving source/XDC files
- Got VGA output working on hardware
- Verified visible output on monitor
- Added modular `renderer.sv`
- Rendered a square on screen using coordinate-based pixel logic
- Added `game_logic.sv` for player position updates
- Implemented slow movement tick using a power-of-two divider
- Wired Basys 3 directional buttons into game logic
- Successfully moved the square on screen using hardware buttons

## Notes
Current architecture:
- `vga_timing` handles sync and pixel coordinates
- `renderer` handles pixel color generation
- `game_logic` handles player movement
- `main` wires all modules together

## Next goals
- convert square into a simple sprite
- add direction state
- build simple retro-style walking character
- eventually support tilemaps and sprite composition

## 2026-04-18

Today I implemented the first real world/gameplay architecture upgrade for the VGA game.

### What changed

#### 1. Shared world package
I introduced `world_pkg.sv` to centralize:
- tile ID definitions
- direction encodings
- tile size / player size
- screen and map dimensions
- tile collision helper functions

This removes duplicated constants across modules and sets up a cleaner foundation for future map growth.

#### 2. Tile-based collision detection
Player movement is now checked against the world tilemap instead of relying only on screen bounds.

The collision system:
- computes a proposed next player position
- checks the 4 corners of the proposed player bounding box
- queries the tilemap at each corner
- blocks movement if any corner overlaps a blocked tile

At the moment, water is treated as blocked, while grass and path are walkable.

#### 3. Camera controller
I added `camera_controller.sv` so the world can scroll as the player moves.

The camera:
- follows the player
- attempts to keep the player near screen center
- clamps to the map boundaries so it does not scroll outside the world

#### 4. Renderer refactor for world-space sampling
The renderer was updated to separate screen-space from world-space logic.

Instead of sampling tiles directly from VGA screen coordinates, it now computes:
- `sample_world_x = camera_x + current_x`
- `sample_world_y = camera_y + current_y`

This allows the screen to act as a moving window into a larger tilemap.

#### 5. Horizontal scrolling debug improvement
To confirm that horizontal camera movement was actually working, I added an x-dependent tile feature in the map. This made it much easier to visually verify scrolling, since a purely y-dependent map can make horizontal movement look like the player is hitting an invisible wall.

### Outcome

The game now supports:
- movement
- tile collision
- blocked water
- camera follow
- scrolling in a world larger than one screen

This feels like the point where the project stopped being just a VGA rendering demo and started looking like a small tile-based game engine.

### Main lessons

- Collision should use tile/world semantics, not palette/color semantics
- Shared constants become important very quickly once multiple modules need the same world definitions
- Camera scrolling only becomes visually obvious if the map has features that vary along the scrolling axis

### Next steps

- make the tilemap more interesting
- add bridges or intentional crossing points
- improve sprite rendering
- clean up button handling with synchronization/debouncing
- eventually move to a larger or more structured map representation

## 2026-04-19

- Added new tile sprites.
- Switched to a memory-backed map flow.
- Pipelined `game_logic.sv` to fix failing timing.
- Re-ran implementation and now timing meets at 100 MHz.