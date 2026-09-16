# Pulsegrid

Commodore 64 procedural eurodance visualizer. Continues from V8.1 with a final damped camera-inertia cue while preserving the black background lock and hard no-wrap viewport.

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
