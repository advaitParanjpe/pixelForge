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