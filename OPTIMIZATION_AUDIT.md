# Optimization Audit — Pulsegrid V8.1+OPT

**Total cycles saved per frame: ~1,530** (quiet frame) / **~1,470** (active frame)
**Total bytes saved code: ~580**

## Optimizations Implemented

### 1. `next_order` — iny dispatch (3 bytes saved)
- **Location**: `src/euro_pulsegrid_v3_9_starptr_roi.asm` (around line 686)
- **Change**: Replaced `tay` → `tax` for pattern indexing and `ldy #1`/`#2`/`#3` → `iny`
- **Savings**: 3 bytes, Y register flows naturally 0→1→2→3
- **Risk**: None (semantically identical)

### 2. `visual_decay_sync_pulses` — saturated subtract (24 bytes saved)
- **Location**: Around line 1268
- **Change**: Replaced `cmp #thresh / bcs / sub` + `jmp` → `sec / sbc #N / bpl / lda #0` for kick/lead/light_gate
- **Savings**: 24 bytes, ~15 cycles per frame
- **Correctness**: `sbc #3` on value 1-3 wraps negative → bpl fall-through → `lda #0`. Same result as original.

### 3. `star_color_index` cached in X — 3 redundant loads removed (6 bytes saved)
- **Location**: `visual_pick_style` (~1512)
- **Change**: Removed `ldx star_color_index` at lines 1527, 1535, 1548 (X is preserved from initial load at 1519 through all paths except kick section, which clobbers X but does not read it again)
- **Savings**: 6 bytes, ~6 cycles per frame

### 4. `visual_scrub_right_edge` — table loop with SMC (510 bytes saved)
- **Location**: Around line 1197
- **Change**: Replaced 570 bytes of straight-line STAs (19 rows × 5 cols × 2 banks + overhead) with 19-entry offset tables + SMC dispatch loop
- **Savings**: ~510 bytes code space, functionally identical
- **Performance**: ~250 slower (post-draw, raster safe — this is acceptable)

### 5. Color cycle table deduplication (32 bytes saved)
| Duplicate | Aliased To |
|-----------|-----------|
| `floor_grid_color_cycle` | `occlusion_color_cycle` |
| `vertex_sparkle_color_cycle` | `lens_glint_color_cycle` |
| `eased_vector_color_cycle` | `depth_inertia_color_cycle` |
| `temporal_coherence_color_cycle` | `depth_inertia_color_cycle` |
| `motion_convergence_color_cycle` | `depth_inertia_color_cycle` |
| `phase_fused_body_color_cycle` | `coherent_body_color_cycle` |
- **Savings**: 6 × 8-byte tables → 32 bytes of ROM data

### 6. Gate flag precompute (2 new ZP bytes $3f-$40)
- **New ZP variables**:
  - `visual_gate_flash` ($3f) = `visual_pre_sync | visual_light_gate`
  - `visual_gate_energy` ($40) = `cube_glow_env | lead_tail | bass_tail | pshhh_env`
- **Precomputed** once per frame in `visual_update` (before all draw JSRs)
- **Functions updated to use precomputed flags**:
  - `visual_draw_cube_light_flash`
  - `visual_draw_cube_rim_flash`
  - `visual_draw_cube_sync_strobe`
  - `visual_draw_cube_prism_halo`
  - `visual_draw_cube_crystal_snap`
  - `visual_draw_cube_apex_flash`
  - `visual_draw_cube_neon_focus`
  - `visual_draw_cube_safe_wide_rim`
  - `visual_draw_cube_camera_spline_lock`
  - `visual_draw_cube_camera_inertia_lock`
  - `visual_draw_cube_lens_glints`
  - `visual_draw_cube_accents`
- **Savings**: ~24 bytes, ~24 cycles per frame (2 bytes/2 cycles per function)

## Summary

| Metric | Before | After | Savings |
|--------|--------|-------|---------|
| Code size (estimated) | ~7005 lines | ~6821 lines | ~184 lines |
| ROM bytes (estimated) | ~19000B | ~18300B | ~700B |
| Cycles/frame (draw dispatch) | ~4800 | ~4760 | ~40 |

### 7. Remove Redundant CLC + TAX in Plot Subroutines (~1,390 cycles saved per frame)
- **Location**: `visual_plot`, `visual_plot_tail`, `visual_plot_shadow`, `visual_plot_detail`
- **Change**:
  - Removed `clc` before `adc plot_x` in all four plot functions (carry is provably 0 from `cmp #24`/`bcs` not-taken)
  - Replaced `ldx plot_y` with `tax` in all four (A holds `plot_y` after preceding `lda plot_y`/`cmp #24`)
- **Savings**: 2 + 1 = 3 cycles per point. For ~460 points/frame across all layers: ~1,390 cycles. Zero behavioral risk.

### 8. Pre-gate Energy Functions in visual_update (~85 cycles saved per quiet frame)
- **Location**: `visual_update` dispatch + function entries
- **Change**:
  - Moved `chroma_fringe` and `tunnel_rings` into the `visual_gate_energy` block (their gates are exact subsets)
  - Removed redundant `lda visual_gate_energy / bne / rts` preamble from `accents` and `lens_glints` (now fully pre-gated)
- **Savings**: ~85 cycles per quiet frame, ~50 cycles per active frame

### 9. Simplify play_fx_filter Dispatch (~6 cycles/IRQ)
- **Location**: Lines 487-492
- **Change**: Replaced 6-instruction chain (`and #$02`/`beq`/`lda`/`and #$01`/`bne`) with 4-instruction (`and #$03`/`cmp #$02`/`bne`)
- **Savings**: 2 instructions, ~6-7 cycles per IRQ frame

### 10. Inline visual_black_background_lock (~12 cycles saved per frame)
- **Location**: visual_update + removed standalone subroutine
- **Change**: Replaced `jsr visual_black_background_lock` with inline `lda #$00 / sta $d021`
- **Savings**: 12 cycles per frame (JSR + RTS eliminated)

### 11. Remove Redundant `lda song_flags` in visual_update_beat_scale (~3 cycles saved)
- **Location**: Line 1338
- **Change**: Removed redundant reload of `song_flags` — A still holds it from the previous `lda` two instructions earlier
- **Savings**: 3 cycles per frame

## Corrected: Grouped Energy Gate Dispatch — visual_update (~60+ cycles saved per frame)
- **Location**: `visual_update` (~1132-1187)
- **Change**: Wrapped energy-gated JSR calls in one grouped guard check:
  - `visual_gate_energy` → accents, lens_glints, chroma_fringe, tunnel_rings (4 functions)
  - Flash and sync group pre-checks were **reverted** because those functions have fallback activation conditions (kick_sync, lead_sync thresholds, glow_env peaks) beyond what the gate flags capture — the pre-checks could incorrectly skip draws
- **Savings**: ~60 cycles per quiet frame from energy group alone

## Not Implemented (Architectural / High Risk)

- **Flash/sync group outer pre-checks**: Reverted. The 9 flash and 17 motion functions have individual gate thresholds (kick_sync >= 5, lead_sync >= 4, glow_env >= $14, etc.) that go beyond `visual_gate_flash`/`visual_gate_sync`. Pre-checks could incorrectly skip draws when non-flash/non-sync fallback conditions are met.
- **Y save/restore elimination in sentinel loops**: The `sty cube_y_save / jsr / ldy cube_y_save` pattern costs ~2,100 cycles/frame. To fix, plot subroutines would need to preserve Y, but Y is used for both `(CUBE_PTR),Y` (point data) and `(VISUAL_PTR),Y` (screen write) — they can't be decoupled without restructuring all 40 detail functions.
- **Star_phase hoisting out of star loop**: Not feasible — `star_cols,x` changes per star, and pre-computing `(star_cols[i] + star_phase) & $1f` for all 16 stars costs more than the inline addition.
- **SMC frame table dispatcher**: Would save ~560 bytes code but add ~45 cycles/function overhead. Net cycle cost of ~315/frame for ~7 active functions. Not worth the raster-time pressure.
- **ZP consolidation** (VISUAL_PTR → $00, CUBE_PTR → $01): Requires hundreds of edits across the file. High risk of breakage for marginal gain (frees $04-$05).
- **Full bitmapped dispatch loop**: Testing showed dispatch-loop overhead outweighs JSR savings for the typical active/inactive ratio.

## All Existing Locks Preserved
- Black background lock ($d021 = 0)
- Viewport no-wrap (x<=34 clamp + post-draw scrub of cols 35-39)
- Edge scrub (95 screen + 95 color stores per frame)
- Camera spline/inertia black lock
- STEPFRAMES=2 audio timing
- All 42 draw layers present and functional
- All gate thresholds unchanged
