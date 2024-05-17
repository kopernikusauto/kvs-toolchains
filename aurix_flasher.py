import sys
import os
from pathlib import Path
import subprocess


def run(elf_src: Path, hex_src: Path) -> int:
    flasher_exe = None
    for p in sys.path:
        exe = Path(p) / "AurixFlasher.exe"
        if exe.exists():
            flasher_exe = exe
            break
    if flasher_exe is None:
        sys.stderr.write("Failed to locate AurixFlasher.exe!\n")
        sys.exit(1)

    print(f"{flasher_exe} -hex {hex_src} -elf {elf_src}")
    proc = subprocess.Popen([
        flasher_exe,
        "-hex",
        hex_src,
        "-elf",
        elf_src
    ])
    proc.wait()

    return proc.returncode

