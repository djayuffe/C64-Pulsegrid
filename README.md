# C64 - Pulsegrid

Pulsegrid is a Commodore 64 procedural eurodance visualizer: a cycle-aware
6502 assembly production that combines a SID-driven music engine with layered
CRT-style geometric effects.

It is a standalone C64 project, not an ArpSID plugin or emulator component.

## Features

- 42 layered visual effects, including starfields, cube geometry, colour
  cycles, depth cues, and the V8.1 damped camera-inertia sequence.
- SID music and a music-only IRQ build mode.
- A black-background and no-wrap viewport contract, with right-edge scrubbing
  to prevent visual artefacts.
- A Python structural audit that detects duplicate labels, unresolved references,
  unsafe coordinates, and regressions in the raster/visual hot paths.

## Runtime capture

The following frame was captured while the built PRG was running in VICE.

![Pulsegrid running in VICE](docs/screenshots/runtime.png)

## Build

Requirements:

- Python 3 for the static release audit
- [ACME](https://sourceforge.net/projects/acme-crossass/) to generate binaries

```sh
./build.sh
```

When ACME is available, the script produces:

- `build/Pulsegrid.prg` — normal demo build
- `build/Pulsegrid_music_irq_basic.prg` — music IRQ build
- `build/Pulsegrid_songmodule.bin` — SID music module

Without ACME, the script runs the static audit and reports that binary output
was skipped.

## Verify

```sh
python3 tools/audit_release.py
shasum -a 256 -c SHA256SUMS.txt
```

The audit validates the release-critical IRQ, viewport, drawing, and label
invariants before a binary is assembled.

## Key locks
- Background remains black via `$d021` lock and black colour-RAM blank policy.
- Right-edge scrub / viewport guards are preserved.
- SID/audio timing is unchanged.
- V4.6 layered-order experiment remains reverted.

## New in V8.1
- `visual_draw_cube_camera_inertia_lock`
- `camera_inertia_lock_fr00..15`
- `camera_inertia_lock_frame_lo/hi`
- `camera_inertia_lock_color_cycle`

The cue is phase-correct, locked to `vis_frame`, uses cached `star_color_index` for colour, and stays inside x<=25.

## Documentation

- [CHANGELOG.md](CHANGELOG.md) summarizes recent optimisation work.
- [OPTIMIZATION_AUDIT.md](OPTIMIZATION_AUDIT.md) records the performance and
  code-size decisions.
- [RELEASE_LOCK.md](RELEASE_LOCK.md) lists the visual and timing invariants
  maintained by the release.
- [docs/LINEAGE.md](docs/LINEAGE.md) documents the source archive lineage.
