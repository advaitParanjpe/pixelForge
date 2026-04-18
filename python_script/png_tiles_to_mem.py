#!/usr/bin/env python3
"""Convert 16x16 PNG tile art into Vivado-friendly .mem files.

Outputs:
  1) tile_pixels.mem   - one palette index per line (2 hex digits)
  2) palette_rgb444.mem - one RGB444 color per line (3 hex digits)
  3) tile_manifest.txt - tile-id mapping and palette summary

Intended addressing scheme in RTL:
    addr = tile_id * (TILE_SIZE*TILE_SIZE) + tile_py * TILE_SIZE + tile_px

Each input tile must be TILE_SIZE x TILE_SIZE.
The tile_id is determined by the order of the input specs.

Example:
    python png_tiles_to_mem.py \
        grass=grass.png path=path.png water=water.png \
        --out-dir build_assets

Then in SV, if those are passed in that order:
    TILE_GRASS = 0
    TILE_PATH  = 1
    TILE_WATER = 2
"""

from __future__ import annotations

import argparse
import os
from pathlib import Path
from typing import Dict, List, Sequence, Tuple

from PIL import Image

RGB = Tuple[int, int, int]


def parse_tile_spec(spec: str) -> Tuple[str, Path]:
    if "=" not in spec:
        raise argparse.ArgumentTypeError(
            f"Tile spec '{spec}' must look like name=path/to/file.png"
        )
    name, path_str = spec.split("=", 1)
    name = name.strip()
    path = Path(path_str.strip())
    if not name:
        raise argparse.ArgumentTypeError(f"Bad tile spec '{spec}': empty tile name")
    return name, path


def rgb888_to_rgb444(rgb: RGB) -> int:
    r, g, b = rgb
    r4 = r >> 4
    g4 = g >> 4
    b4 = b >> 4
    return (r4 << 8) | (g4 << 4) | b4


def load_tile_pixels(path: Path, tile_size: int) -> List[RGB]:
    if not path.exists():
        raise FileNotFoundError(f"Tile PNG not found: {path}")

    img = Image.open(path).convert("RGBA")
    if img.size != (tile_size, tile_size):
        raise ValueError(
            f"{path.name}: expected {tile_size}x{tile_size}, got {img.size[0]}x{img.size[1]}"
        )

    pixels: List[RGB] = []
    for y in range(tile_size):
        for x in range(tile_size):
            r, g, b, a = img.getpixel((x, y))
            if a != 255:
                raise ValueError(
                    f"{path.name}: found non-opaque pixel at ({x}, {y}) with alpha={a}. "
                    "This script expects fully opaque terrain tiles."
                )
            pixels.append((r, g, b))
    return pixels


def build_global_palette(tiles: Sequence[Tuple[str, Path]], tile_size: int) -> Tuple[Dict[RGB, int], List[RGB], Dict[str, List[int]]]:
    palette_map: Dict[RGB, int] = {}
    palette_list: List[RGB] = []
    tile_indices: Dict[str, List[int]] = {}

    for tile_name, tile_path in tiles:
        rgb_pixels = load_tile_pixels(tile_path, tile_size)
        idx_pixels: List[int] = []

        for rgb in rgb_pixels:
            if rgb not in palette_map:
                if len(palette_list) >= 256:
                    raise ValueError(
                        "Too many unique colors across all tiles. "
                        f"Found more than 256 colors; current count reached {len(palette_list)}."
                    )
                palette_map[rgb] = len(palette_list)
                palette_list.append(rgb)
            idx_pixels.append(palette_map[rgb])

        tile_indices[tile_name] = idx_pixels

    return palette_map, palette_list, tile_indices


def write_tile_pixels_mem(path: Path, tiles: Sequence[Tuple[str, Path]], tile_indices: Dict[str, List[int]]) -> None:
    with path.open("w", encoding="utf-8") as f:
        for tile_id, (tile_name, _tile_path) in enumerate(tiles):
            f.write(f"// tile_id {tile_id}: {tile_name}\n")
            for idx in tile_indices[tile_name]:
                f.write(f"{idx:02X}\n")


def write_palette_rgb444_mem(path: Path, palette_list: Sequence[RGB]) -> None:
    with path.open("w", encoding="utf-8") as f:
        for palette_idx, rgb in enumerate(palette_list):
            rgb444 = rgb888_to_rgb444(rgb)
            f.write(f"// palette_idx {palette_idx}: rgb888={rgb}\n")
            f.write(f"{rgb444:03X}\n")


def write_manifest(
    path: Path,
    tiles: Sequence[Tuple[str, Path]],
    palette_list: Sequence[RGB],
    tile_size: int,
) -> None:
    with path.open("w", encoding="utf-8") as f:
        f.write("Tile ID mapping\n")
        f.write("===============\n")
        for tile_id, (tile_name, tile_path) in enumerate(tiles):
            f.write(f"tile_id {tile_id:3d} -> {tile_name} ({tile_path})\n")
        f.write("\n")
        f.write(f"tile_size         : {tile_size}x{tile_size}\n")
        f.write(f"pixels_per_tile   : {tile_size * tile_size}\n")
        f.write(f"palette_entries   : {len(palette_list)}\n")
        f.write("\nPalette\n")
        f.write("=======\n")
        for palette_idx, rgb in enumerate(palette_list):
            rgb444 = rgb888_to_rgb444(rgb)
            f.write(f"palette_idx {palette_idx:3d} -> rgb888={rgb} rgb444=0x{rgb444:03X}\n")
        f.write("\nAddressing\n")
        f.write("==========\n")
        f.write("addr = tile_id * (TILE_SIZE*TILE_SIZE) + tile_py * TILE_SIZE + tile_px\n")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Convert 16x16 PNG tiles into Vivado-friendly .mem files."
    )
    parser.add_argument(
        "tiles",
        nargs="+",
        help="Tile specs in the form name=path/to/file.png. Order defines tile_id.",
    )
    parser.add_argument(
        "--tile-size",
        type=int,
        default=16,
        help="Tile size in pixels. Default: 16",
    )
    parser.add_argument(
        "--out-dir",
        type=Path,
        default=Path("generated_mem"),
        help="Directory to write outputs into. Default: generated_mem",
    )
    parser.add_argument(
        "--tile-mem-name",
        default="tile_pixels.mem",
        help="Filename for tile pixel-index memory. Default: tile_pixels.mem",
    )
    parser.add_argument(
        "--palette-mem-name",
        default="palette_rgb444.mem",
        help="Filename for palette RGB444 memory. Default: palette_rgb444.mem",
    )
    parser.add_argument(
        "--manifest-name",
        default="tile_manifest.txt",
        help="Filename for manifest/debug summary. Default: tile_manifest.txt",
    )

    args = parser.parse_args()

    tiles: List[Tuple[str, Path]] = [parse_tile_spec(spec) for spec in args.tiles]

    out_dir: Path = args.out_dir
    out_dir.mkdir(parents=True, exist_ok=True)

    palette_map, palette_list, tile_indices = build_global_palette(
        tiles, tile_size=args.tile_size
    )

    tile_mem_path = out_dir / args.tile_mem_name
    palette_mem_path = out_dir / args.palette_mem_name
    manifest_path = out_dir / args.manifest_name

    write_tile_pixels_mem(tile_mem_path, tiles, tile_indices)
    write_palette_rgb444_mem(palette_mem_path, palette_list)
    write_manifest(manifest_path, tiles, palette_list, args.tile_size)

    print("Done.")
    print(f"Wrote tile pixel mem : {tile_mem_path}")
    print(f"Wrote palette mem    : {palette_mem_path}")
    print(f"Wrote manifest       : {manifest_path}")
    print(f"Unique colors        : {len(palette_list)}")
    print("Tile IDs:")
    for tile_id, (tile_name, _tile_path) in enumerate(tiles):
        print(f"  {tile_id}: {tile_name}")
    if palette_map:
        print("Note: tile_id order is exactly the order of tile specs on the command line.")


if __name__ == "__main__":
    main()
