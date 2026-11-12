#!/usr/bin/env python3

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "vectors" / "case_000"
DST = ROOT / "memh" / "case_000"

# file -> (type, width)
FILES = {
    # Input
    "input/f.txt":    ("signed", 8),
    "input/g.txt":    ("signed", 8),
    "input/bigF.txt": ("signed", 8),
    "input/bigG.txt": ("signed", 8),
    "input/hm.txt":   ("unsigned", 16),

    # Basis before FFT
    "basis/b00_prefft.txt":      ("rawhex", 64),
    "basis/b01_prefft_rawf.txt": ("rawhex", 64),
    "basis/b10_prefft.txt":      ("rawhex", 64),
    "basis/b11_prefft_rawF.txt": ("rawhex", 64),

    # Basis after FFT
    "fft/b00_fft.txt": ("rawhex", 64),
    "fft/b01_fft.txt": ("rawhex", 64),
    "fft/b10_fft.txt": ("rawhex", 64),
    "fft/b11_fft.txt": ("rawhex", 64),

    # Gram
    "gram/g00.txt": ("rawhex", 64),
    "gram/g01.txt": ("rawhex", 64),
    "gram/g11.txt": ("rawhex", 64),

    # Target
    "target/t0.txt": ("rawhex", 64),
    "target/t1.txt": ("rawhex", 64),

    # Sampling
    "sampling/z0.txt": ("rawhex", 64),
    "sampling/z1.txt": ("rawhex", 64),

    # IFFT
    "ifft/t0_ifft.txt": ("rawhex", 64),
    "ifft/t1_ifft.txt": ("rawhex", 64),

    # Signature
    "signature/s1.txt": ("signed", 16),
    "signature/s2.txt": ("signed", 16),
}


def convert(src: Path, dst: Path, kind: str, width: int):
    mask = (1 << width) - 1
    digits = width // 4
    count = 0

    dst.parent.mkdir(parents=True, exist_ok=True)

    with src.open("r") as fi, dst.open("w") as fo:
        for line in fi:
            line = line.strip()
            if not line:
                continue

            parts = line.split()
            if len(parts) != 2:
                raise ValueError(f"Bad line in {src}: {line}")

            index, value = parts

            if int(index) != count:
                raise ValueError(
                    f"Index mismatch in {src}: expected {count}, got {index}"
                )

            if kind == "rawhex":
                x = int(value, 16)
            else:
                x = int(value, 10)

            x &= mask
            fo.write(f"{x:0{digits}x}\n")
            count += 1

    if count != 512:
        raise ValueError(
            f"{src}: expected 512 entries, got {count}"
        )

    print(f"[OK] {src.relative_to(SRC)} -> {dst.relative_to(DST)}")


def main():
    if not SRC.exists():
        raise SystemExit(f"Golden case not found: {SRC}")

    for rel, (kind, width) in FILES.items():
        src = SRC / rel
        dst = DST / Path(rel).with_suffix(".memh")

        if not src.exists():
            raise FileNotFoundError(src)

        convert(src, dst, kind, width)

    print()
    print(f"Generated {len(FILES)} MEMH files")
    print(f"Output: {DST}")


if __name__ == "__main__":
    main()
