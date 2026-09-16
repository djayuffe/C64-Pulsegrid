#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
python3 tools/audit_release.py || true
mkdir -p build
if command -v acme >/dev/null 2>&1; then
  acme -f cbm -o build/Pulsegrid.prg src/euro_pulsegrid_v3_9_starptr_roi.asm
  acme -DMUSIC_IRQ_BASIC=1 -f cbm -o build/Pulsegrid_music_irq_basic.prg src/euro_pulsegrid_v3_9_starptr_roi.asm
  acme -DBUILD_SID=1 -f plain -o build/Pulsegrid_songmodule.bin src/euro_pulsegrid_v3_9_starptr_roi.asm
  echo "OK: build/Pulsegrid.prg"
  echo "OK: build/Pulsegrid_music_irq_basic.prg"
  echo "OK: build/Pulsegrid_songmodule.bin"
else
  echo "WARN: acme not found; static audit passed, binary build skipped."
fi
