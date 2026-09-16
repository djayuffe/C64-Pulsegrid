# Changelog

## Pulsegrid / V8.1+OPT
- Renamed project to Pulsegrid.
- Gate-flag precompute system: visual_gate_flash/energy/sync computed once per frame.
- Grouped dispatch in visual_update skips 27 JSR calls when gates are zero.
- Color cycle table deduplication (6 aliased tables, ~32 bytes saved).
- Saturated subtract in visual_decay_sync_pulses (24 bytes, ~15 cycles/frame).
- visual_scrub_right_edge table loop (510 bytes code space saved).
- All 42 draw layers preserved; V8.1 black lock, no-wrap, edge scrub intact.

## V8.1 CAMERA INERTIA BLACK LOCK
- Added damped camera-inertia body cue after V8.0 camera spline.
- New five-point phase-correct frame tables inside x<=25/y 10..15.
- Kept black background lock, full-width clear, edge scrub, and viewport guards.
- No SID/audio timing changes.
