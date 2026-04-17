# pixelForge_v2

A retro-style FPGA graphics project built in SystemVerilog on the Digilent Basys 3.

## Current status
Working VGA output on hardware with:
- VGA timing generator
- modular renderer
- game logic module
- movable on-screen player square controlled by board buttons

## Project structure
- `rtl/` — SystemVerilog source files
- `constraints/` — Basys 3 XDC constraints
- `tb/` — testbench files

## Modules
- `vga_timing.sv` — generates VGA timing, sync pulses, visible-area flag, and pixel coordinates
- `renderer.sv` — generates pixel color based on screen position and player position
- `game_logic.sv` — updates player position based on button inputs and movement tick
- `main.sv` — top-level wiring between timing, renderer, game logic, and VGA outputs

## Current functionality
- 640x480 VGA-style output on display
- on-screen square rendered in hardware
- square movement using Basys 3 buttons
- modular design split across timing, rendering, and game logic

## Planned next steps
- replace square with a sprite-based player
- add facing direction and simple animation
- build tile-based background rendering
- add BRAM-backed tilemaps
- move toward a small retro-style game engine

## Target platform
- Digilent Basys 3
- Vivado
- SystemVerilog