import argparse
from pathlib import Path

TOKEN_TO_ID = {
    "GRS": 0,
    "PAV": 1,
    "PAH": 2,
    "PDR": 3,
    "PUR": 4,
    "PRD": 5,
    "PRU": 6,
    "WTV": 7,
    "WTH": 8,
    "WDR": 9,
    "WUR": 10,
    "WRD": 11,
    "WRU": 12,
    "BRV": 13,
    "BRH": 14,
    "TRE": 15,
    "RPU": 16,
    "WVL": 17,
    "WVR": 18,
    "SHH": 19,
    "SDL": 20,
    "SDR": 21,
    "KEY": 22,
    "END": 23,
}


def parse_map_file(path: Path, expected_w: int, expected_h: int):
    rows = []

    with path.open("r", encoding="utf-8") as f:
        for line_num, raw_line in enumerate(f, start=1):
            line = raw_line.strip()

            # Skip blank lines and comment lines
            if not line or line.startswith("#"):
                continue

            tokens = [tok.strip() for tok in line.split(",")]

            if len(tokens) != expected_w:
                raise ValueError(
                    f"Line {line_num}: expected {expected_w} columns, got {len(tokens)}"
                )

            rows.append(tokens)

    if len(rows) != expected_h:
        raise ValueError(
            f"Expected {expected_h} rows, got {len(rows)}"
        )

    return rows


def convert_tokens_to_ids(rows):
    tile_ids = []
    unknown = set()

    for y, row in enumerate(rows):
        for x, token in enumerate(row):
            if token not in TOKEN_TO_ID:
                unknown.add((token, x, y))
            else:
                tile_ids.append(TOKEN_TO_ID[token])

    if unknown:
        msg_lines = ["Unknown token(s) found:"]
        for token, x, y in sorted(unknown):
            msg_lines.append(f"  token '{token}' at (x={x}, y={y})")
        raise ValueError("\n".join(msg_lines))

    return tile_ids


def write_mem_file(tile_ids, out_path: Path):
    with out_path.open("w", encoding="utf-8") as f:
        for value in tile_ids:
            f.write(f"{value:02X}\n")


def write_manifest(out_path: Path):
    with out_path.open("w", encoding="utf-8") as f:
        f.write("Token -> tile_id\n")
        for token, value in sorted(TOKEN_TO_ID.items(), key=lambda kv: kv[1]):
            f.write(f"{token:>3} -> {value}\n")


def main():
    parser = argparse.ArgumentParser(
        description="Convert a 64x64 text tilemap into a Vivado-friendly .mem file"
    )
    parser.add_argument("input_map", help="Path to the input text map file")
    parser.add_argument("--out-dir", default="generated_map_mem", help="Output directory")
    parser.add_argument("--width", type=int, default=64, help="Map width in tiles")
    parser.add_argument("--height", type=int, default=64, help="Map height in tiles")
    args = parser.parse_args()

    input_path = Path(args.input_map)
    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    rows = parse_map_file(input_path, args.width, args.height)
    tile_ids = convert_tokens_to_ids(rows)

    mem_path = out_dir / "tilemap.mem"
    manifest_path = out_dir / "tilemap_manifest.txt"

    write_mem_file(tile_ids, mem_path)
    write_manifest(manifest_path)

    print(f"Wrote: {mem_path}")
    print(f"Wrote: {manifest_path}")
    print(f"Entries: {len(tile_ids)} ({args.width}x{args.height})")


if __name__ == "__main__":
    main()