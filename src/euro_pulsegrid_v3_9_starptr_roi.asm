; =====================================================================
; PULSEGRID — EURO PULSEGRID V8.0 CAMERA SPLINE BLACK LOCK / EURO PULSEGRID V3.9 STARPTR ROI
; Commodore 64 / ACME assembler
; PAL 50Hz KERNAL-vector safe raster IRQ, STEPFRAMES=2, ZP ROI max closure
; A minor / hands-up eurodance arrangement
; V4.4_VOLUMETRIC_DEPTH_FX: volumetric under-shadow, rear fog veil, chroma fringe.
; V4.9_PHASELOCK_PREFLASH_FX: fixes V4.8 perceived lag with one-frame-only pre-arm, immediate stale-pre clear, and faster visual pulse decay.
; V8.1_CAMERA_INERTIA_BLACK_LOCK_FX
; - Adds final damped camera-inertia body cue after V8.0 camera spline.
; - Keeps V8.0 camera spline black lock intact and preserves all no-wrap guards.
; V8.0_CAMERA_SPLINE_BLACK_LOCK_FX
; - Adds a final phase-correct camera-spline body cue after V7.7 body projection.
;   The points form a small centre/near/far stabilizer that moves as one rigid
;   body with vis_frame, never star_phase, and stays deep inside x<=26.
; - Tightens older residual colour/frame lookups so depth dots/details/accent
;   colours use cached star_color_index and accent motion follows cube phase
;   instead of starfield shimmer.  Black background and no-wrap locks preserved.
; V7.9_UPLOADED_FIX_MERGE_BLACK_LOCK
; - Merges safe fixes from the uploaded V7.8/V3.9 ASM: cached star_color_index
;   reused by all colour-cycle lookups, preserving the uploaded star/colour ROI
;   improvement.  Kept the newer hard viewport guards, full-width clear,
;   right-edge scrub and black-background lock from V7.8 so the uploaded
;   no-guard optimization cannot reintroduce right-edge wrapping.
; V7.8_BLACK_BACKGROUND_LOCK_FX
; - Keeps the VIC background hard black every visual frame.  The FX-band and
;   full-screen clears now use black colour RAM for blank cells, and a final
;   black-background lock is called after drawing/edge scrub.  No SID/audio
;   timing change; cube/effect pixels still use their own colours, but the
;   empty backdrop and right-edge sealed cells remain black.
; V7.6_ORBITAL_STABILITY_BODY_FX
; - Adds phase-correct orbital-stability body anchors as a final low-noise
;   stabilizer after motion convergence.  It traces an inner body diagonal and
;   counter-diagonal with eased positions so the cube reads as one solid 3D
;   object.  Locked to vis_frame with only one-frame music lead/pre; no
;   star_phase, no SID-tail lag, and all points stay inside x<=28.
; V7.3_TEMPORAL_COHERENCE_MOTION_FX
; - Adds phase-correct temporal-coherence anchors as the final glue between
;   coherent-body, eased-vector, centroid and inertia cues.  It also removes
;   star_phase from the vertex-sparkle frame selector so hot vertices follow
;   cube rotation instead of starfield shimmer.  All new points are x<=30,
;   tail-free, and locked to vis_frame plus the one-frame music lead/pre only.
; V7.2_COHERENT_BODY_MOTION_FX
; - Adds phase-correct coherent-body motion anchors that tie the centroid,
;   eased-vector, inertia and face-normal cues into one perceived rigid body.
;   The path is deliberately slower/eased and centre-weighted, so movement feels
;   like a correct 3D cube rotation instead of independent shimmer. Locked to
;   vis_frame with only one-frame music lead/pre; no star_phase, no SID-tail lag,
;   and all points stay inside x<=30.
; V7.1_EASED_VECTOR_MOTION_FX
; - Adds phase-correct eased-vector motion anchors that bridge centroid/orbit
;   movement with a tiny eased lead/return path.  This reduces robotic stepping
;   and makes the cube rotation read as one continuous 3D body.  Locked to
;   vis_frame with only one-frame music lead/pre; no star_phase, no SID-tail lag,
;   and all points stay inside x<=31.
; V7.0_CENTROID_MOTION_LOCK_FX
; - Adds phase-correct centroid/axis-lock anchors between the orbit, rails,
;   hinge, spline, normal and inertia cues.  The points trace the perceived
;   centre-of-mass and front/back axis of the cube, making rotation feel more
;   mechanically correct and less like independent sparkles.  Locked to
;   vis_frame with only one-frame music lead/pre; no star_phase, no tail lag,
;   and all points stay inside x<=31.
; V6.9_INERTIA_NORMAL_DEPTH_FX
; - Adds phase-correct depth-inertia anchors: a tiny lead/trail pair that
;   follows the face-normal/orbit/rail stack with coherent one-frame inertia.
;   This makes cube rotation feel smoother and more physical without star_phase
;   shimmer, envelope-tail lag, or right-edge risk.  All points stay inside x<=32.
; V6.8_DEPTH_NORMAL_MOTION_FX
; - Adds phase-correct depth-normal vector anchors.  These are tiny front/back
;   normal cues that move on a coherent 16-frame path locked to vis_frame,
;   offset from the spline/rail/hinge stack.  They strengthen the 3D illusion
;   by showing which face is turning toward the viewer, without star_phase
;   shimmer, SID-tail lag, or right-edge risk.  All points stay inside x<=32.
; V6.7_MOTION_SPLINE_DEPTH_FX
; - Adds phase-correct motion-spline guide points between the orbit/rail/hinge
;   cues.  These use interpolated frame tables locked to vis_frame and avoid
;   star_phase/tail jitter, making the cube depth motion read smoother and more
;   physically coherent while staying inside x<=32.
; V6.6_PHASE_HINGE_MOTION_FX
; - Adds phase-hinge front/back anchor motion: the front corner cue and rear
;   counter-cue move in opposite-but-matched phases, making the cube rotation
;   read as hinge/perspective depth rather than just extra sparkles.  It is
;   locked to vis_frame only and stays inside x<=33.
; V6.5_KINEMATIC_DEPTH_LOCK_FX
; - Adds phase-locked kinematic depth rails and counter-motion anchors.  The
;   rails are locked to vis_frame/inverse phase only, never star_phase, so
;   they move as a coherent 3D structure instead of random shimmer.
; V6.4_PHASE_CORRECT_3D_MOTION_FX
; V6.3_INNER_DEPTH_WEAVE_FX: adds a small transient/chorus-gated inner weave inside x<=33 for extra depth while preserving the V6.2/V6.1 no-wrap viewport lock.
; V6.2_SAFE_WIDE_DEPTH_SNAP_FX: keeps the hard x<=34 live viewport, then adds an inward-only safe-wide depth rim so the cube regains width without touching the risky right edge.
; V6.1_INNER_VIEWPORT_SNAP_FX: clamps all live cube/tail/shadow/detail/star writes to x<=34 and scrubs columns 35..39 after draw.
; V6.0_TRUE_VIEWPORT_LOCK_FX: hard clamps main cube/shadow/tail/beat-scale writes to x<=34 before plotting, preserving V5.9 post-draw scrub.
; V5.9_EDGE_SEAL_DEPTH_POLISH_FX: final post-draw right-edge scrub + safe center polish, eliminating late wrap/bleed from any source.
; V5.8_HARD_RIGHT_EDGE_NOWRAP_FIX: full-width FX band clear + hard x>=35 overlay guard to eliminate right-edge wrap/stale bleed.
; V5.7_NOWRAP_FLASH_CLOSURE_FX: legacy nowrap flash closure retained, now hardened by V5.8.
; - Fixes visible right/bottom wrapping by clamping all flash/detail overlay
;   tables to a conservative safe viewport and adding a cheap detail-plot
;   runtime guard.  Main cube/audio/SID timing unchanged.
; - Light/scanline/rim/prism/crystal/apex/neon flash stack remains
;   peak/pre-only and V4.6 layer-order experiment remains reverted.
; V5.6_NEON_FOCUS_SNAP_CLOSURE_FX: adds tiny center-focus neon pulse after apex; peak/pre-only, no late tail, no audio timing change.
; V5.5_PERFECT_SNAP_CLOSURE_FX: final minimal apex flash + stricter peak governor; no layer-order experiment, no SID timing change.
; V5.4_CRYSTAL_SNAP_FINAL_FX: adds peak/pre-only crystal edge caustics after prism halo, keeps V5.2 no-late-flash closure.
; V5.3_PRISM_SNAP_POLISH_FX: adds peak/pre-only prism halo + colour snap, tightens sparkle gating, preserves V5.2 no-late-flash closure.
; V5.2_FINAL_SNAPLOCK_CLOSURE_FX: clamps late carry-over frames, makes all light/strobe FX peak/pre-only, and hard-clears phase lead after draw; no second-frame late sparkle.
; V5.1_SNAPLOCK_MICROSTROBE_FX: keeps V5.0 peak-only gates but removes prefetch light-gate tail and adds a tiny transient strobe for tighter perceived beat lock.
; V5.0_TIGHTLOCK_LIGHTSYNC_FX: removes tail-biased flash gates, adds a short visual_light_gate peak latch, and phase-leads flash tables for tighter music lock.
; V4.8_MUSIC_SYNC_PREFLASH_FX: V4.7 light flash stack plus visual trigger pulses and one-IRQ preflash.
; V4.7_LIGHT_FLASH_DEPTH_FX: reverted V4.6 layered order, adds beat light flash/flare overlays.
; V4.5_HOLO_PARALLAX_DEPTH_FX: rear tunnel rings, vertex sparkle, bass parallax beams.
; V4.3_PERFECT_DEPTH_ILLUSION: floor-grid shadow, z-slice silhouette, lens glints.
; V4.2_SHADOW_DEPTH_ILLUSION: cast shadow, back-face occlusion, parallax depth glow.
; V4.1_DETAILMAX_COLOUR_FX: adds depth dots, animated accent seams, 8-step colour cycles.
; V4.0_DETAILCOLOUR_FX: inner cube ribs, corner glints, colour-cycling star/detail FX.
; V3.9_STARPTR_ROI: v3.8 plus precomputed starfield row pointers.
; V3.8_BEATSCALE_GATE_ROI
; V3.7_ZP_ROI_MAX
; V3.6_STEPTOGGLE_TAILGATE
; V3.5_FLASHCACHE_CLOSURE: v3.4 lean IRQ plus inlined flash-color cache.
; V3.4_LEAN_IRQ_CLOSURE: v3.3 technical max plus lean IRQ final placement/hardening.
; V3.3_TECHNICAL_MAX: absolute clear + deterministic drum dispatch + v2.9 hotpath closure.
; =====================================================================

!ifndef BUILD_SID {
    BUILD_SID = 0
}

; MUSIC_IRQ_BASIC=1 builds a BASIC-startable music-only IRQ PRG.
!ifndef MUSIC_IRQ_BASIC {
    MUSIC_IRQ_BASIC = 0
}

!cpu 6510

V1F      = $d400
V1PW     = $d402
V1CTL    = $d404
V1AD     = $d405
V1SR     = $d406
V2F      = $d407
V2PW     = $d409
V2CTL    = $d40b
V2AD     = $d40c
V2SR     = $d40d
V3F      = $d40e
V3PW     = $d410
V3CTL    = $d412
V3AD     = $d413
V3SR     = $d414
FLO      = $d415
FHI      = $d416
FRES     = $d417
FMODE    = $d418

PAT_LEAD = $f7
ORD_PTR  = $f9
PAT_BASS = $fb
PAT_DRUM = $fd

; Visualizer zero-page pointers. Required for (zp),Y indirect addressing.
VISUAL_PTR = $02
CUBE_PTR   = $04

; V3.7 high-ROI zero-page promotion. These hot runtime bytes are touched
; from IRQ/music/visual plot paths. ZP saves one cycle per direct access
; and shrinks most load/store opcodes by one byte.
ZP_RUNTIME_START = $06
frame_cnt        = $06
step             = $07
song_flags       = $08
kick_env         = $09
lead_env         = $0a
bass_env         = $0b
drum_env         = $0c
flt_base         = $0d
flt_lfo          = $0e
flt_dir          = $0f
flt_cnt          = $10
pwm_phase        = $11
retrig_cnt       = $12
v2_gate_ctl      = $13
v2_off_ctl       = $14
v1_base_lo       = $15
v1_base_hi       = $16
v2_base_lo       = $17
v2_base_hi       = $18
space_latch      = $19
skip_target_lo   = $1a
skip_target_hi   = $1b
vis_frame        = $1c
vis_tick         = $1d
vis_char         = $1e
vis_color        = $1f
plot_x           = $20
plot_y           = $21
cube_y_save      = $22
flash_color      = $23
shimmer_phase    = $24
shimmer_mode     = $25
pshhh_env        = $26
glam_phase       = $27
star_phase       = $28
tail_frame       = $29
tail_frame2      = $2a
vis_tail_char    = $2b
vis_tail_color   = $2c
sidechain_env    = $2d
bass_tail        = $2e
lead_tail        = $2f
legato_phase     = $30
cube_scale_env   = $31
cube_glow_env    = $32
star_color_cache = $33
depth_low_color  = $34
scale_down_color = $35
filter_mode_state= $36
irq_frame_counter= $37
mix_glue_env     = $38
visual_kick_sync = $39  ; V4.9: short visual-only hit pulse, set at drum trigger / one-frame pre-arm only
visual_lead_sync = $3a  ; V4.9: short visual-only lead/flare pulse, independent of SID decay
visual_pre_sync  = $3b  ; V4.9: one-frame lookahead pulse, cleared on the real trigger frame to avoid late glow
visual_light_gate= $3c  ; V5.0: short peak-only light latch; prevents flash FX from following long SID envelope tails
visual_phase_lead= $3d  ; V5.0: visual-only table phase lead, set by prefetch/real hit and decayed after draw
star_color_index = $3e  ; V7.9: imported uploaded fix, cache star_phase & 7 once per frame for all colour cycles
ZP_RUNTIME_END   = $3e  ; V7.9: star_color_index is final byte in promoted runtime block
; V8.1_OPT: precomputed gate flags for dispatch optimization
visual_gate_flash  = $3f  ; visual_pre_sync | visual_light_gate (non-zero = flash active)
visual_gate_energy = $40  ; cube_glow_env | lead_tail | bass_tail | pshhh_env
visual_gate_sync   = $41  ; visual_gate_flash | visual_lead_sync | visual_kick_sync

SCREEN_RAM = $0400
COLOR_RAM  = $d800
SCREEN_TO_COLOR_HI_DELTA = $d4
FX_BAND_START = SCREEN_RAM + 120
COLOR_FX_BAND_START = COLOR_RAM + 120
FX_BAND_ROWS  = 19
FX_BAND_COLS  = 31
IRQ_RASTER_LINE = $f8
VIC_RASTER_IRQ_MASK = $01
RASTER_MSB_CLEAR_MASK = $7f
KERNAL_IRQ_EXIT = $ea81

; V2.8_DEPTH_CACHE_100_PERFECT: v2.7 raster hotpath plus cached
; depth colors for cube/beat-scale plots and no-op-free music-basic IRQ.
; V2.7_RASTER_HOTPATH_PERFECT: v2.6 hotpath inline plus stable border,
; keyboard throttle, and running-pointer bounded clear.
; Keep raster IRQ at 50 Hz, advance music step every 2 frames.
STEPFRAMES = 2

!if BUILD_SID = 0 {
    * = $0801
        !byte $0b,$08,$0a,$00,$9e,$32,$30,$36,$34,$00,$00,$00
    * = $0810
} else {
    * = $1000
        jmp sid_init
        jmp play
sid_init:
        jsr tune_init
        rts
}

init:
        sei
        jsr tune_init
!if BUILD_SID = 0 {
!if MUSIC_IRQ_BASIC = 0 {
        jsr visual_init
}
}
        lda #$ff
        sta $dc02          ; CIA1 Port A output for keyboard column scan
        lda #$00
        sta $dc03          ; CIA1 Port B input for keyboard rows
        lda #$ff
        sta $dc00          ; no keyboard column selected between scans
        lda #$00
        sta $d020          ; stable idle border before first IRQ
        sta $d021          ; stable idle background before first IRQ
        jsr install_true_raster_vsync_irq
        jsr wait_for_vsync_slot_before_cli
        cli
main_hang:
        ; V2.8: pure raster IRQ drives music and visuals. Mainline is idle.
        jmp main_hang

; =====================================================================
; V2.8 TRUE RASTER/VSYNC IRQ SETUP
; =====================================================================
install_true_raster_vsync_irq:
        lda #$7f
        sta $dc0d
        sta $dd0d
        lda $dc0d
        lda $dd0d
        lda #$00
        sta $dc0e
        sta $dc0f
        sta $dd0e
        sta $dd0f
        sta $d015              ; sprites off, no sprite DMA jitter
        lda #VIC_RASTER_IRQ_MASK
        sta $d01a
        lda #$1b
        and #RASTER_MSB_CLEAR_MASK
        sta $d011
        lda #IRQ_RASTER_LINE
        sta $d012
        lda #<irq
        sta $0314
        lda #>irq
        sta $0315
        lda #VIC_RASTER_IRQ_MASK
        sta $d019
        rts

wait_for_vsync_slot_before_cli:
wait_vsync_approach_target:
        lda $d012
        cmp #IRQ_RASTER_LINE
        bne wait_vsync_approach_target
wait_vsync_after_target:
        lda $d012
        cmp #IRQ_RASTER_LINE
        beq wait_vsync_after_target
        lda #VIC_RASTER_IRQ_MASK
        sta $d019              ; clear any latched target IRQ before CLI
        rts

; =====================================================================
; V2.8 DEPTH-CACHE 100-PERFECT IRQ
; Installed through $0314/$0315, so KERNAL has already saved A/X/Y.
; Do not PHA/PLA or RTI here. Exit via $EA81 KERNAL restore/RTI tail.
; =====================================================================
irq:
        lda #VIC_RASTER_IRQ_MASK
        sta $d019
        lda #IRQ_RASTER_LINE
        sta $d012
        ; V3.4: raster MSB is fixed in setup/visual_init.  Avoid per-frame
        ; $d011 read/and/write in the IRQ hotpath.
!if BUILD_SID = 0 {
!if MUSIC_IRQ_BASIC = 0 {
!ifdef DEBUG_TIMING_BAR {
        lda #$0e
        sta $d020
}
}
}
        inc irq_frame_counter
        jsr play               ; inlined FX hotpath, STEPFRAMES=2

!if BUILD_SID = 0 {
!if MUSIC_IRQ_BASIC = 0 {
        jsr visual_update
        lda flash_color
        sta $d020              ; single final border write in release path
        ; V3.4: keyboard scan stays outside music tick and after final border
        ; write, so the visible border timing is stable even on scan frames.
        lda irq_frame_counter
        and #$03
        bne irq_skip_keyboard_scan
        jsr scan_space_skip
irq_skip_keyboard_scan:
} else {
        ; V2.8: music IRQ BASIC does no visual, keyboard or border work.
}
} else {
        ; V2.8: BUILD_SID=1 exports init/play only; no IRQ visual work.
}
        jmp irq_kernal_exit

irq_kernal_exit:
        jmp KERNAL_IRQ_EXIT

tune_init:
        jsr sound_init
        lda #<order
        sta ORD_PTR
        lda #>order
        sta ORD_PTR+1
        lda #0
        sta frame_cnt
        lda #$ff
        sta step
        jsr next_order
        jsr next_step
        rts

sound_init:
        lda #0
        ldx #0
sound_init_loop:
        sta $d400,x
        inx
        cpx #$19
        bne sound_init_loop
        ; FIX11: raw loud mode by default.
        lda #$0f
        sta FMODE              ; volume 15, no filter mode
        lda #$00
        sta FRES
        lda #$09
        sta V1AD
        lda #$f8
        sta V1SR
        lda #$08
        sta V2AD
        lda #$f8
        sta V2SR
        lda #$02
        sta V3AD
        lda #$f2
        sta V3SR
        ; V3.7: all hot runtime state lives in zero page; clear it as one
        ; compact block instead of many absolute stores.
        lda #0
        ldx #ZP_RUNTIME_END-ZP_RUNTIME_START-1
sound_init_zp_clear:
        sta ZP_RUNTIME_START,x
        dex
        bpl sound_init_zp_clear
        lda #92
        sta flt_base
        rts

play:
        ; V3.6: STEPFRAMES=2 optimized as a 1-bit toggle.  This replaces
        ; inc/lda/cmp/bcc/lda/sta with lda/eor/sta/bne and keeps the same
        ; every-second-IRQ musical step timing without changing raster rate.
        lda frame_cnt
        eor #$01
        sta frame_cnt
        bne play_no_step
        jsr next_step
play_no_step:
        jsr visual_prefetch_next_hits ; V4.8: pre-arm light FX one IRQ before the next musical step

        ; ---- inlined fx_kick ----
play_fx_kick:
        lda kick_env
        beq play_fx_kick_pshhh
        dec kick_env
        lda kick_env
        asl
        asl
        clc
        adc #$18
        sta V3F
        lda #$08
        sta V3F+1
        jmp play_fx_kick_done
play_fx_kick_pshhh:
        lda pshhh_env
        beq play_fx_kick_drum_decay
        dec pshhh_env
        lda pshhh_env
        and #$01
        bne play_fx_pshhh_hold_gate
        lda pshhh_env
        asl
        asl
        ora #$40
        sta V3F
        lda pshhh_env
        lsr
        lsr
        clc
        adc #$18
        sta V3F+1
play_fx_pshhh_hold_gate:
        lda #$81
        sta V3CTL
        jmp play_fx_kick_done
play_fx_kick_drum_decay:
        lda drum_env
        beq play_fx_kick_off
        dec drum_env
        bne play_fx_kick_keep
play_fx_kick_off:
        lda #$80
        sta V3CTL
play_fx_kick_keep:
play_fx_kick_done:

        ; ---- inlined stateful fx_filter ----
play_fx_filter:
        lda song_flags
        and #$03
        cmp #$02
        bne play_fx_filter_raw_loud
play_fx_filter_build_mode:
        lda filter_mode_state
        cmp #1
        beq play_fx_filter_build_already
        lda #1
        sta filter_mode_state
        lda #$0f
        sta FMODE
        lda #$00
        sta FRES
play_fx_filter_build_already:
        inc flt_cnt
        lda flt_cnt
        and #$03
        bne play_fx_filter_done
        inc flt_lfo
        lda flt_lfo
        and #$7f
        clc
        adc #$30
        sta FLO
        lda #$01
        sta FHI
        jmp play_fx_filter_done
play_fx_filter_raw_loud:
        lda filter_mode_state
        beq play_fx_filter_done
        lda #0
        sta filter_mode_state
        lda #$0f
        sta FMODE
        lda #$00
        sta FRES
play_fx_filter_done:

        ; ---- inlined fx_pwm ----
play_fx_pwm:
        inc pwm_phase
        lda sidechain_env
        beq play_fx_pwm_no_pump_decay
        dec sidechain_env
play_fx_pwm_no_pump_decay:
        lda mix_glue_env
        beq play_fx_pwm_no_glue_decay
        dec mix_glue_env
play_fx_pwm_no_glue_decay:
        lda pwm_phase
        and #$7f
        clc
        adc #$20
        sta V1PW
        lda sidechain_env
        beq play_fx_pwm_bass_no_duck
        lda #$07
        jmp play_fx_pwm_bass_store_hi
play_fx_pwm_bass_no_duck:
        lda #$08
play_fx_pwm_bass_store_hi:
        sta V1PW+1
        lda pwm_phase
        asl
        eor pwm_phase
        clc
        adc legato_phase
        and #$7f
        clc
        adc #$50
        sta V2PW
        lda #$08
        sta V2PW+1
        inc legato_phase

        ; ---- inlined fx_lead ----
play_fx_lead:
        lda v2_base_lo
        sta V2F
        lda v2_base_hi
        sta V2F+1
        lda lead_env
        beq play_fx_lead_done
        dec lead_env
        inc shimmer_phase
        lda shimmer_mode
        beq play_fx_lead_retrig
        lda shimmer_phase
        and #$07
        bne play_fx_lead_sync_saw
        lda #$15
        sta V2CTL
        jmp play_fx_lead_done
play_fx_lead_sync_saw:
        lda v2_gate_ctl
        sta V2CTL
play_fx_lead_retrig:
        lda v2_gate_ctl
        beq play_fx_lead_done
        sta V2CTL
play_fx_lead_done:

        ; ---- inlined fx_bass ----
play_fx_bass:
        lda v1_base_lo
        sta V1F
        lda v1_base_hi
        sta V1F+1
        lda bass_env
        beq play_fx_bass_sustain_sidechain
        dec bass_env
        lda bass_env
        asl
        asl
        clc
        adc #$24
        sta V1PW
        lda sidechain_env
        beq play_fx_bass_env_no_duck
        lda #$07
        jmp play_fx_bass_env_store_hi
play_fx_bass_env_no_duck:
        lda #$08
play_fx_bass_env_store_hi:
        sta V1PW+1
        rts
play_fx_bass_sustain_sidechain:
        lda sidechain_env
        beq play_fx_bass_done
        lda #$40
        sta V1PW
        lda #$07
        sta V1PW+1
play_fx_bass_done:
        rts

; =====================================================================
; V4.8 visual/musical sync helper
; =====================================================================
; Called on the non-step IRQ, exactly one frame before the next STEPFRAMES=2
; sequencer tick.  It peeks at the next drum/lead cell and sets small
; visual-only pre-pulses.  Audio timing is untouched; the next real trigger
; still happens in next_step.  This makes light flashes feel aligned instead
; of one redraw late.
visual_prefetch_next_hits:
        ; V4.9 phase-lock: prefetch must only run on the non-step IRQ.
        ; In V4.8 it also ran just after next_step, which could create a
        ; too-early/late-looking glow tail.  frame_cnt=1 means the next IRQ
        ; will be the real musical step, so this is the only valid preflash.
        lda frame_cnt
        beq visual_prefetch_done
        lda step
        clc
        adc #1
        and #$0f
        tay
        lda (PAT_DRUM),y
        cmp #1              ; next row is kick -> one-frame prewarm
        bne visual_prefetch_no_kick
        lda #$03              ; V5.0: stronger but still one-frame preflash, visible before audio transient
        sta visual_pre_sync
        lda #$03
        sta visual_phase_lead
        ; V5.1: do NOT set visual_light_gate from lookahead.  V5.0 could
        ; leave a small gate into the real beat frame and feel smeared.
        ; Prefetch now primes only visual_pre_sync/phase; real hit owns light.
visual_prefetch_kick_gate_ok:
        lda visual_kick_sync
        bne visual_prefetch_no_kick
        lda #$02
        sta visual_kick_sync
visual_prefetch_no_kick:
        lda (PAT_LEAD),y
        beq visual_prefetch_done
        lda #$02              ; V5.0: lead lookahead may light scanline/rim before SID note lands
        sta visual_phase_lead
        ; V5.1: lead lookahead primes phase only; scan/rim peak gate is
        ; set by the real lead row to avoid a post-hit afterglow smear.
visual_prefetch_lead_gate_ok:
        lda visual_lead_sync
        bne visual_prefetch_done
        lda #$02
        sta visual_lead_sync
visual_prefetch_done:
        rts

next_step:
        inc step
        lda step
        cmp #16
        bcc next_step_trig
        lda #0
        sta step
        jsr next_order
next_step_trig:
        jsr trig_bass
        jsr trig_drum
        jsr trig_lead
        rts

next_order:
        ldy #0
        lda (ORD_PTR),y
        cmp #$ff
        bne next_order_read
        lda #<order
        sta ORD_PTR
        lda #>order
        sta ORD_PTR+1
next_order_read:
        ldy #0
        lda (ORD_PTR),y
        tax
        lda bpat_lo,x
        sta PAT_BASS
        lda bpat_hi,x
        sta PAT_BASS+1

        iny
        lda (ORD_PTR),y
        tax
        lda dpat_lo,x
        sta PAT_DRUM
        lda dpat_hi,x
        sta PAT_DRUM+1

        iny
        lda (ORD_PTR),y
        tax
        lda lpat_lo,x
        sta PAT_LEAD
        lda lpat_hi,x
        sta PAT_LEAD+1

        iny
        lda (ORD_PTR),y
        sta song_flags

        clc
        lda ORD_PTR
        adc #4
        sta ORD_PTR
        lda ORD_PTR+1
        adc #0
        sta ORD_PTR+1
        rts

; =====================================================================
; Triggers
; =====================================================================
trig_bass:
        ldy step
        lda (PAT_BASS),y
        beq trig_bass_off
        tax
        dex
        lda freqlo,x
        sta V1F
        sta v1_base_lo
        lda freqhi,x
        sta V1F+1
        sta v1_base_hi
        lda #$12
        sta bass_env
        lda #$06
        sta bass_tail
        lda #$41
        sta V1CTL
        rts
trig_bass_off:
        lda bass_tail
        beq trig_bass_really_off
        sec
        sbc #1
        sta bass_tail
        lda #$41
        sta V1CTL
        rts
trig_bass_really_off:
        lda #$40
        sta V1CTL
        rts

trig_lead:
        ldy step
        lda (PAT_LEAD),y
        beq trig_lead_off
        tax
        dex
        lda freqlo,x
        sta V2F
        sta v2_base_lo
        lda freqhi,x
        sta V2F+1
        sta v2_base_hi
        lda #$18
        sta lead_env
        lda #$05
        sta lead_tail
        lda #0                ; V4.9: consume any stale preflash on the real musical hit
        sta visual_pre_sync
        lda #$04              ; V5.0: real lead hit gets a short peak-only light gate, not a long tail gate
        sta visual_light_gate
        lda #$03
        sta visual_phase_lead
        lda #$05              ; V4.9: short immediate visual sync pulse for scanline/rim flash
        sta visual_lead_sync
        lda song_flags
        and #$01
        beq trig_lead_pulse
        lda #$23
        sta v2_gate_ctl
        lda #$22
        sta v2_off_ctl
        lda #1
        sta shimmer_mode
        jmp trig_lead_gate
trig_lead_pulse:
        lda #$41
        sta v2_gate_ctl
        lda #$40
        sta v2_off_ctl
        lda #0
        sta shimmer_mode
trig_lead_gate:
        lda v2_gate_ctl
        sta V2CTL
        rts
trig_lead_off:
        lda lead_tail
        beq trig_lead_real_off
        sec
        sbc #1
        sta lead_tail
        lda v2_gate_ctl
        beq trig_lead_tail_default
        sta V2CTL
        rts
trig_lead_tail_default:
        lda #$41
        sta V2CTL
        rts
trig_lead_real_off:
        lda v2_off_ctl
        beq trig_lead_off_default
        sta V2CTL
        rts
trig_lead_off_default:
        lda #$40
        sta V2CTL
        rts

trig_drum:
        ldy step
        lda (PAT_DRUM),y
        beq trig_drum_none
        cmp #7
        bcs trig_drum_none
        tax
        dex
        lda drum_jump_lo,x      ; V3.3 deterministic O(1) drum dispatch
        sta trig_drum_smc+1
        lda drum_jump_hi,x
        sta trig_drum_smc+2
trig_drum_smc:
        jmp $ffff
trig_drum_none:
        rts

drum_jump_lo:
        !byte <drum_kick,<drum_snare,<drum_hat,<drum_crash,<drum_lift,<drum_pshhh
drum_jump_hi:
        !byte >drum_kick,>drum_snare,>drum_hat,>drum_crash,>drum_lift,>drum_pshhh

drum_kick:
        lda #$02
        sta V3AD
        lda #$f2
        sta V3SR
        lda #$1f
        sta kick_env
        lda #0                ; V4.9: real kick owns the frame; no stale preflash after-hit
        sta visual_pre_sync
        lda #$07              ; V5.0: immediate peak latch for light/rim flash, independent of kick_env decay
        sta visual_light_gate
        lda #$04
        sta visual_phase_lead
        lda #$06              ; V4.9: short immediate visual sync pulse, fast-decayed after draw
        sta visual_kick_sync
        lda #$16
        sta sidechain_env
        lda #$12
        sta cube_scale_env
        lda #$10
        sta cube_glow_env
        lda #$12
        sta mix_glue_env
        lda #$24
        sta drum_env
        lda #0
        sta pshhh_env
        lda #$08
        sta V3CTL
        lda #$00
        sta V3F
        lda #$0c
        sta V3F+1
        lda #$11
        sta V3CTL
        rts

drum_snare:
        lda #$04
        sta V3AD
        lda #$84
        sta V3SR
        lda #0
        sta kick_env
        lda #$0a
        sta drum_env
        lda #$60
        sta V3F
        lda #$18
        sta V3F+1
        lda #$81
        sta V3CTL
        rts

drum_hat:
        lda #$02
        sta V3AD
        lda #$43
        sta V3SR
        lda #0
        sta kick_env
        lda #$04
        sta drum_env
        lda #$f8
        sta V3F
        lda #$2d
        sta V3F+1
        lda #$81
        sta V3CTL
        rts

drum_crash:
        lda #$06
        sta V3AD
        lda #$34
        sta V3SR
        lda #0
        sta kick_env
        lda #$12
        sta drum_env
        lda #$0c
        sta pshhh_env
        lda #$ff
        sta V3F
        lda #$3f
        sta V3F+1
        lda #$81
        sta V3CTL
        rts

drum_lift:
        lda #$07
        sta V3AD
        lda #$24
        sta V3SR
        lda #0
        sta kick_env
        lda #$0c
        sta drum_env
        lda #$0a
        sta pshhh_env
        lda step
        asl
        asl
        ora #$40
        sta V3F
        lda #$2a
        sta V3F+1
        lda #$81
        sta V3CTL
        rts

drum_pshhh:
        lda #$08
        sta V3AD
        lda #$22
        sta V3SR
        lda #0
        sta kick_env
        lda #$08
        sta drum_env
        lda #$0c
        sta pshhh_env
        lda #$f0
        sta V3F
        lda #$38
        sta V3F+1
        lda #$81
        sta V3CTL
        rts

; =====================================================================
; V2.7: FX routines inlined into play; old JSR wrappers removed.
; =====================================================================

; =====================================================================
; Keyboard control - SPACE skips to next musical section
; =====================================================================
scan_space_skip:
        lda #$7f
        sta $dc00
        lda $dc01
        and #$10
        bne scan_space_released
scan_space_pressed:
        lda space_latch
        bne scan_space_done
        lda #1
        sta space_latch
        jsr skip_to_next_part
        jmp scan_space_done
scan_space_released:
        lda #0
        sta space_latch
scan_space_done:
        lda #$ff
        sta $dc00
        rts

skip_to_next_part:
        ldx #0
skip_find_loop:
        lda section_lo,x
        cmp #$ff
        beq skip_wrap_intro
        sta skip_target_lo
        lda section_hi,x
        sta skip_target_hi

        lda skip_target_hi
        cmp ORD_PTR+1
        bcc skip_next_candidate
        bne skip_candidate_found
        lda skip_target_lo
        cmp ORD_PTR
        bcc skip_next_candidate
        beq skip_next_candidate

skip_candidate_found:
        lda skip_target_lo
        sta ORD_PTR
        lda skip_target_hi
        sta ORD_PTR+1
        jmp skip_apply

skip_next_candidate:
        inx
        jmp skip_find_loop

skip_wrap_intro:
        lda #<order_intro
        sta ORD_PTR
        lda #>order_intro
        sta ORD_PTR+1

skip_apply:
        lda #$ff
        sta step
        lda #0
        sta frame_cnt
        sta kick_env
        sta drum_env
        jsr next_order
        jsr next_step
        rts

section_lo:
        !byte <order_verse1,<order_build1,<order_chorus1,<order_verse2
        !byte <order_build2,<order_chorus2,<order_break,<order_final,<order_outro
        !byte $ff
section_hi:
        !byte >order_verse1,>order_build1,>order_chorus1,>order_verse2
        !byte >order_build2,>order_chorus2,>order_break,>order_final,>order_outro
        !byte $ff


; =====================================================================
; Beat-reactive wireframe cube visualizer
; =====================================================================
visual_init:
        lda #$1b
        sta $d011
        lda #$08
        sta $d016
        lda #$14
        sta $d018
        lda #0
        sta $d020
        sta $d021
        jsr visual_clear_screen
        rts

visual_update:
        ; V8.1_OPT: precompute common gate flags once per frame for all draw layers
        lda visual_pre_sync
        ora visual_light_gate
        sta visual_gate_flash
        ora visual_lead_sync
        ora visual_kick_sync
        sta visual_gate_sync
        lda cube_glow_env
        ora lead_tail
        ora bass_tail
        ora pshhh_env
        sta visual_gate_energy

        lda tail_frame
        sta tail_frame2
        lda vis_frame
        sta tail_frame
        inc vis_tick
        lda kick_env
        beq visual_no_kick_speed
        inc vis_frame
visual_no_kick_speed:
        lda vis_tick
        cmp #2
        bcc visual_redraw
        lda #0
        sta vis_tick
        inc vis_frame
visual_redraw:
        lda vis_frame
        and #$0f
        sta vis_frame
        jsr visual_update_beat_scale
        jsr visual_pick_style       ; V3.5: also caches flash_color
        jsr visual_clear_fx_band
        jsr visual_draw_starfield
        lda cube_glow_env          ; V3.6: avoid dead tail JSR when no glow/tail
        beq visual_update_no_tail
        jsr visual_draw_cube_tail
visual_update_no_tail:
        jsr visual_draw_cube_shadow
        jsr visual_draw_cube_cast_shadow ; V4.2: projected floor/deep cast shadow illusion
        jsr visual_draw_cube_floor_grid   ; V4.3: perspective floor/grid shadow locks cube to depth plane
        jsr visual_draw_cube
        jsr visual_draw_cube_zslice      ; V4.3: rear z-slice silhouette for stronger inside/outside depth
        jsr visual_draw_cube_depth_fog   ; V4.4: dim rear fog veil to hide/soften back plane
        jsr visual_draw_cube_depth_dots ; V4.1: far-corner depth dots/back-face anchors
        jsr visual_draw_cube_details    ; V4.0: extra inner ribs/glints after main edges
        lda visual_gate_energy         ; V8.1_OPT: skip energy FX when no voices
        beq visual_update_no_energy
        jsr visual_draw_cube_accents    ; V4.1: beat/voice-driven moving seams
        jsr visual_draw_cube_lens_glints ; V4.3: hot front glints only when energy is present
        jsr visual_draw_cube_tunnel_rings  ; V4.5: rear vanishing-point tunnel/room illusion
visual_update_no_energy:
        jsr visual_draw_cube_light_flash    ; V4.7: kick/glow radial light burst, draw-order safe
        jsr visual_draw_cube_scanline_flare ; V4.7: lead/noise horizontal flare streaks
        jsr visual_draw_cube_rim_flash      ; V4.7: front rim/vertex pulse highlights
        jsr visual_draw_cube_sync_strobe    ; V5.2: pre/peak-only transient dot pop, no late carry flash
        jsr visual_draw_cube_crystal_snap     ; V5.4: final peak/pre-only crystal caustic edge snap
        jsr visual_draw_cube_apex_flash       ; V5.5: tiny final apex lock flash, peak/pre only, no tail smear
        jsr visual_draw_cube_neon_focus       ; V5.6: tiny center-focus pulse, peak/pre only, adds depth without tail lag
        jsr visual_draw_cube_safe_wide_rim    ; V6.2: inward-only width/depth polish, never touches edge scrub band
        jsr visual_draw_cube_inner_depth_weave ; V6.4: phase-locked inner weave, no star jitter, x<=33
        jsr visual_draw_cube_perspective_orbit ; V6.4: smooth phase-correct 3D orbit anchors, x<=34
        jsr visual_draw_cube_kinematic_depth_rails ; V6.5: phase-locked vanishing rails/counter-motion, x<=33
        jsr visual_draw_cube_phase_hinge_motion ; V6.6: matched front/back hinge anchors, phase-correct x<=33
        jsr visual_draw_cube_motion_spline_depth ; V6.7: interpolated phase-spline depth cues, x<=32
        jsr visual_draw_cube_depth_normal_motion ; V6.8: phase-correct face-normal anchors, x<=32
        jsr visual_draw_cube_depth_inertia_motion ; V6.9: coherent lead/trail inertia cues, x<=32
        jsr visual_draw_cube_centroid_motion_lock ; V7.0: centre-of-mass/axis cue unifies the 3D motion stack, x<=31
        jsr visual_draw_cube_eased_vector_motion ; V7.1: eased lead/return vector anchors smooth 3D body motion, x<=31
        jsr visual_draw_cube_coherent_body_motion ; V7.2: rigid-body phase anchors unify all 3D cues, x<=30
        jsr visual_draw_cube_temporal_coherence_motion ; V7.3: final phase-glue anchors, cube-locked and tail-free, x<=30
        jsr visual_draw_cube_phase_fused_body_motion ; V7.4: phase-fused body motion, corrected 3D illusion x<=30
        jsr visual_draw_cube_motion_convergence_lock ; V7.5: damped convergence lock anchors, unifies motion stack x<=29
        jsr visual_draw_cube_orbital_stability_body ; V7.6: final low-noise body stabilizer x<=28
        jsr visual_draw_cube_body_projection_lock ; V7.7: stable projected body-axis cue, x<=27
        jsr visual_draw_cube_camera_spline_lock ; V8.0: final camera/body spline stabilizer, x<=26
        jsr visual_draw_cube_camera_inertia_lock ; V8.1: damped near/far camera inertia cue, x<=25
        jsr visual_scrub_right_edge          ; V5.9: post-draw edge seal, kills any remaining right wrap/bleed
        lda #$00                            ; V8.1_OPT: inline visual_black_background_lock
        sta $d021                           ; keep VIC background black
        jsr visual_decay_sync_pulses        ; V4.8: visual-only sync decay after all FX consumed it
        rts

; ---------------------------------------------------------------------
; V5.9 post-draw edge seal.
; Even with detail guards and full-band pre-clear, the main cube and old
; wider overlays can still legally touch the far right cells.  On some VIC
; setups/CRT crops those bright cells look like right-side wrapping.
; This final tiny absolute scrub runs after all visual drawing and blanks
; columns 35..39 on rows 3..21, so no late artifact can survive.
visual_scrub_right_edge:
        ; V6.1: hard edge seal blanks columns 35..39 on rows 3..21.
        ; V8.1_OPT: table-loop with SMC address dispatch, saves ~500 bytes code.
        lda #$20
        ldx #18
scrub_screen_loop:
        lda scrub_screen_lo,x
        sta scr_ptrs+1
        lda scrub_screen_hi,x
        sta scr_ptrs+2
        lda #$20
scr_ptrs:
        sta SCREEN_RAM+4
        sta SCREEN_RAM+3
        sta SCREEN_RAM+2
        sta SCREEN_RAM+1
        sta SCREEN_RAM+0
        dex
        bpl scrub_screen_loop
        lda #$00
        ldx #18
scrub_color_loop:
        lda scrub_color_lo,x
        sta scr_ptrc+1
        lda scrub_color_hi,x
        sta scr_ptrc+2
        lda #$00
scr_ptrc:
        sta COLOR_RAM+4
        sta COLOR_RAM+3
        sta COLOR_RAM+2
        sta COLOR_RAM+1
        sta COLOR_RAM+0
        dex
        bpl scrub_color_loop
        rts

; Row start offsets (col 35) for rows 3..21
scrub_screen_lo:
        !byte <(SCREEN_RAM+155),<(SCREEN_RAM+195),<(SCREEN_RAM+235)
        !byte <(SCREEN_RAM+275),<(SCREEN_RAM+315),<(SCREEN_RAM+355)
        !byte <(SCREEN_RAM+395),<(SCREEN_RAM+435),<(SCREEN_RAM+475)
        !byte <(SCREEN_RAM+515),<(SCREEN_RAM+555),<(SCREEN_RAM+595)
        !byte <(SCREEN_RAM+635),<(SCREEN_RAM+675),<(SCREEN_RAM+715)
        !byte <(SCREEN_RAM+755),<(SCREEN_RAM+795),<(SCREEN_RAM+835)
        !byte <(SCREEN_RAM+875)
scrub_screen_hi:
        !byte >(SCREEN_RAM+155),>(SCREEN_RAM+195),>(SCREEN_RAM+235)
        !byte >(SCREEN_RAM+275),>(SCREEN_RAM+315),>(SCREEN_RAM+355)
        !byte >(SCREEN_RAM+395),>(SCREEN_RAM+435),>(SCREEN_RAM+475)
        !byte >(SCREEN_RAM+515),>(SCREEN_RAM+555),>(SCREEN_RAM+595)
        !byte >(SCREEN_RAM+635),>(SCREEN_RAM+675),>(SCREEN_RAM+715)
        !byte >(SCREEN_RAM+755),>(SCREEN_RAM+795),>(SCREEN_RAM+835)
        !byte >(SCREEN_RAM+875)
scrub_color_lo:
        !byte <(COLOR_RAM+155),<(COLOR_RAM+195),<(COLOR_RAM+235)
        !byte <(COLOR_RAM+275),<(COLOR_RAM+315),<(COLOR_RAM+355)
        !byte <(COLOR_RAM+395),<(COLOR_RAM+435),<(COLOR_RAM+475)
        !byte <(COLOR_RAM+515),<(COLOR_RAM+555),<(COLOR_RAM+595)
        !byte <(COLOR_RAM+635),<(COLOR_RAM+675),<(COLOR_RAM+715)
        !byte <(COLOR_RAM+755),<(COLOR_RAM+795),<(COLOR_RAM+835)
        !byte <(COLOR_RAM+875)
scrub_color_hi:
        !byte >(COLOR_RAM+155),>(COLOR_RAM+195),>(COLOR_RAM+235)
        !byte >(COLOR_RAM+275),>(COLOR_RAM+315),>(COLOR_RAM+355)
        !byte >(COLOR_RAM+395),>(COLOR_RAM+435),>(COLOR_RAM+475)
        !byte >(COLOR_RAM+515),>(COLOR_RAM+555),>(COLOR_RAM+595)
        !byte >(COLOR_RAM+635),>(COLOR_RAM+675),>(COLOR_RAM+715)
        !byte >(COLOR_RAM+755),>(COLOR_RAM+795),>(COLOR_RAM+835)
        !byte >(COLOR_RAM+875)

visual_decay_sync_pulses:
        ; V5.2: final snaplock closure.  fast visual-only decay is kept. SID envelopes may decay musically,
        ; but visual flash/strobe gates are peak/pre-only.  Carry-over frames
        ; are allowed for scale/depth breathing, not for bright late flashes.
        ; V8.1_OPT: saturated subtract eliminates redundant cmp+branch+jmp per sync,
        ; saving ~24 bytes and ~15 cycles per frame.
        lda visual_kick_sync
        beq visual_decay_no_kick
        sec
        sbc #3
        bpl visual_decay_kick_store
        lda #0
visual_decay_kick_store:
        sta visual_kick_sync
visual_decay_no_kick:
        lda visual_lead_sync
        beq visual_decay_no_lead
        sec
        sbc #3
        bpl visual_decay_lead_store
        lda #0
visual_decay_lead_store:
        sta visual_lead_sync
visual_decay_no_lead:
        lda visual_light_gate
        beq visual_decay_no_light_gate
        sec
        sbc #4                ; V5.2: flash gate is peak-only and cannot leak into a late second flash
        bpl visual_decay_light_store
        lda #0
visual_decay_light_store:
        sta visual_light_gate
visual_decay_no_light_gate:
        lda visual_phase_lead
        beq visual_decay_no_phase_lead
        lda #0                ; V5.2: phase lead is strictly consumed by the current visual frame
        sta visual_phase_lead
visual_decay_no_phase_lead:
        lda visual_pre_sync
        beq visual_decay_done
        lda #0                ; preflash is strictly one rendered frame
        sta visual_pre_sync
visual_decay_done:
        rts

visual_update_beat_scale:
        lda kick_env
        ora visual_kick_sync
        ora visual_pre_sync
        ora visual_light_gate
        beq visual_scale_decay
        lda song_flags
        cmp #$03
        bne visual_scale_not_final
        lda #$1c
        jmp visual_scale_candidate
visual_scale_not_final:
        and #$01
        beq visual_scale_not_chorus
        lda #$18
        jmp visual_scale_candidate
visual_scale_not_chorus:
        lda song_flags
        and #$02
        beq visual_scale_verse
        lda #$16
        jmp visual_scale_candidate
visual_scale_verse:
        lda #$12
visual_scale_candidate:
        cmp cube_scale_env
        bcc visual_scale_decay
        sta cube_scale_env
visual_scale_decay:
        lda cube_scale_env
        beq visual_scale_glow_decay
        dec cube_scale_env
visual_scale_glow_decay:
        lda cube_glow_env
        beq visual_scale_done
        dec cube_glow_env
visual_scale_done:
        rts

visual_pick_style:
        ; V4.0_DETAILCOLOUR_FX: base cube colour now rotates through
        ; electric blue/cyan/purple/light-green, while section/beat states still
        ; override deterministically.  No VIC writes here; IRQ keeps one final
        ; border/background write through flash_color.
        lda #$2a
        sta vis_char
        ldx star_color_index
        lda cube_color_cycle,x
        sta vis_color
        lda song_flags
        and #$01
        beq visual_not_chorus_style
        lda #$51
        sta vis_char
        lda cube_chorus_color_cycle,x
        sta vis_color
        lda song_flags
        cmp #$03
        bne visual_chorus_not_final
        lda #$a0
        sta vis_char
        lda cube_final_color_cycle,x
        sta vis_color
visual_chorus_not_final:
visual_not_chorus_style:
        lda song_flags
        and #$02
        beq visual_not_build_style
        lda song_flags
        and #$01
        bne visual_not_build_style
        lda #$2b
        sta vis_char
        lda cube_build_color_cycle,x
        sta vis_color
visual_not_build_style:
        lda pshhh_env
        beq visual_style_no_pshhh
        lda pshhh_env
        and #$03
        bne visual_style_no_pshhh
        lda #$2e
        sta vis_char
        lda #$03              ; cyan pshhh wash
        sta vis_color
visual_style_no_pshhh:
        lda kick_env
        ora visual_kick_sync
        ora visual_pre_sync
        beq visual_style_done
        lda #$a0
        sta vis_char
        lda star_phase
        and #$07
        tax
        lda cube_kick_color_cycle,x
        sta vis_color
visual_style_done:
        ; V3.5: cache final border/flash color here too, eliminating the
        ; separate visual_beat_flash JSR/RTS from the IRQ visual path.
        lda cube_glow_env
        beq visual_style_flash_section
        lda song_flags
        cmp #$03
        bne visual_style_flash_not_finalbeat
        lda #$01
        jmp visual_style_flash_store
visual_style_flash_not_finalbeat:
        lda song_flags
        and #$01
        beq visual_style_flash_not_chorusbeat
        lda #$07
        jmp visual_style_flash_store
visual_style_flash_not_chorusbeat:
        lda #$0a
visual_style_flash_store:
        sta flash_color          ; no mid-frame border/background writes
        jmp visual_style_depth_cache
visual_style_flash_section:
        lda song_flags
        and #$02
        beq visual_style_flash_not_build
        lda #$06
        sta flash_color
        jmp visual_style_depth_cache
visual_style_flash_not_build:
        lda song_flags
        and #$01
        beq visual_style_flash_not_chorus
        lda #$07
        sta flash_color
        jmp visual_style_depth_cache
visual_style_flash_not_chorus:
        lda #$00
        sta flash_color

visual_style_depth_cache:
        ; V2.8: cache depth colors once per visual frame instead of branching
        ; on song_flags for every low-depth cube/beat-scale plot.
        lda song_flags
        and #$01
        beq visual_depth_nonchorus_cache
        lda #$08
        sta depth_low_color
        sta scale_down_color
        rts
visual_depth_nonchorus_cache:
        lda #$0c
        sta depth_low_color
        lda #$06
        sta scale_down_color
        rts

; V2.7: old VU/top-spark/side-glam code removed.
; V3.5: old visual_beat_flash routine removed; flash_color is cached in visual_pick_style.

; ---------------------------------------------------------------------
; V3.3 absolute-store bounded IRQ clear.
; Generated straight-line stores for rows 3..21, columns 0..31.
; No X/Y loop, no pointer math, no mul40, no screen/color delta in runtime clear.
; V5.8 hard right-edge fix: clear the full 40-column FX band.
; V5.7 only cleared cols 0..31 while later cube/flash overlays could draw
; out to 35/36.  On real VIC/CRT that looked like right-side wrap/stale
; sparkle.  Full-row band clear is slightly more work, but deterministic.
visual_clear_fx_band:
        lda #$20
; clear screen row 3 cols 0..39
        sta SCREEN_RAM+159
        sta SCREEN_RAM+158
        sta SCREEN_RAM+157
        sta SCREEN_RAM+156
        sta SCREEN_RAM+155
        sta SCREEN_RAM+154
        sta SCREEN_RAM+153
        sta SCREEN_RAM+152
        sta SCREEN_RAM+151
        sta SCREEN_RAM+150
        sta SCREEN_RAM+149
        sta SCREEN_RAM+148
        sta SCREEN_RAM+147
        sta SCREEN_RAM+146
        sta SCREEN_RAM+145
        sta SCREEN_RAM+144
        sta SCREEN_RAM+143
        sta SCREEN_RAM+142
        sta SCREEN_RAM+141
        sta SCREEN_RAM+140
        sta SCREEN_RAM+139
        sta SCREEN_RAM+138
        sta SCREEN_RAM+137
        sta SCREEN_RAM+136
        sta SCREEN_RAM+135
        sta SCREEN_RAM+134
        sta SCREEN_RAM+133
        sta SCREEN_RAM+132
        sta SCREEN_RAM+131
        sta SCREEN_RAM+130
        sta SCREEN_RAM+129
        sta SCREEN_RAM+128
        sta SCREEN_RAM+127
        sta SCREEN_RAM+126
        sta SCREEN_RAM+125
        sta SCREEN_RAM+124
        sta SCREEN_RAM+123
        sta SCREEN_RAM+122
        sta SCREEN_RAM+121
        sta SCREEN_RAM+120
; clear screen row 4 cols 0..39
        sta SCREEN_RAM+199
        sta SCREEN_RAM+198
        sta SCREEN_RAM+197
        sta SCREEN_RAM+196
        sta SCREEN_RAM+195
        sta SCREEN_RAM+194
        sta SCREEN_RAM+193
        sta SCREEN_RAM+192
        sta SCREEN_RAM+191
        sta SCREEN_RAM+190
        sta SCREEN_RAM+189
        sta SCREEN_RAM+188
        sta SCREEN_RAM+187
        sta SCREEN_RAM+186
        sta SCREEN_RAM+185
        sta SCREEN_RAM+184
        sta SCREEN_RAM+183
        sta SCREEN_RAM+182
        sta SCREEN_RAM+181
        sta SCREEN_RAM+180
        sta SCREEN_RAM+179
        sta SCREEN_RAM+178
        sta SCREEN_RAM+177
        sta SCREEN_RAM+176
        sta SCREEN_RAM+175
        sta SCREEN_RAM+174
        sta SCREEN_RAM+173
        sta SCREEN_RAM+172
        sta SCREEN_RAM+171
        sta SCREEN_RAM+170
        sta SCREEN_RAM+169
        sta SCREEN_RAM+168
        sta SCREEN_RAM+167
        sta SCREEN_RAM+166
        sta SCREEN_RAM+165
        sta SCREEN_RAM+164
        sta SCREEN_RAM+163
        sta SCREEN_RAM+162
        sta SCREEN_RAM+161
        sta SCREEN_RAM+160
; clear screen row 5 cols 0..39
        sta SCREEN_RAM+239
        sta SCREEN_RAM+238
        sta SCREEN_RAM+237
        sta SCREEN_RAM+236
        sta SCREEN_RAM+235
        sta SCREEN_RAM+234
        sta SCREEN_RAM+233
        sta SCREEN_RAM+232
        sta SCREEN_RAM+231
        sta SCREEN_RAM+230
        sta SCREEN_RAM+229
        sta SCREEN_RAM+228
        sta SCREEN_RAM+227
        sta SCREEN_RAM+226
        sta SCREEN_RAM+225
        sta SCREEN_RAM+224
        sta SCREEN_RAM+223
        sta SCREEN_RAM+222
        sta SCREEN_RAM+221
        sta SCREEN_RAM+220
        sta SCREEN_RAM+219
        sta SCREEN_RAM+218
        sta SCREEN_RAM+217
        sta SCREEN_RAM+216
        sta SCREEN_RAM+215
        sta SCREEN_RAM+214
        sta SCREEN_RAM+213
        sta SCREEN_RAM+212
        sta SCREEN_RAM+211
        sta SCREEN_RAM+210
        sta SCREEN_RAM+209
        sta SCREEN_RAM+208
        sta SCREEN_RAM+207
        sta SCREEN_RAM+206
        sta SCREEN_RAM+205
        sta SCREEN_RAM+204
        sta SCREEN_RAM+203
        sta SCREEN_RAM+202
        sta SCREEN_RAM+201
        sta SCREEN_RAM+200
; clear screen row 6 cols 0..39
        sta SCREEN_RAM+279
        sta SCREEN_RAM+278
        sta SCREEN_RAM+277
        sta SCREEN_RAM+276
        sta SCREEN_RAM+275
        sta SCREEN_RAM+274
        sta SCREEN_RAM+273
        sta SCREEN_RAM+272
        sta SCREEN_RAM+271
        sta SCREEN_RAM+270
        sta SCREEN_RAM+269
        sta SCREEN_RAM+268
        sta SCREEN_RAM+267
        sta SCREEN_RAM+266
        sta SCREEN_RAM+265
        sta SCREEN_RAM+264
        sta SCREEN_RAM+263
        sta SCREEN_RAM+262
        sta SCREEN_RAM+261
        sta SCREEN_RAM+260
        sta SCREEN_RAM+259
        sta SCREEN_RAM+258
        sta SCREEN_RAM+257
        sta SCREEN_RAM+256
        sta SCREEN_RAM+255
        sta SCREEN_RAM+254
        sta SCREEN_RAM+253
        sta SCREEN_RAM+252
        sta SCREEN_RAM+251
        sta SCREEN_RAM+250
        sta SCREEN_RAM+249
        sta SCREEN_RAM+248
        sta SCREEN_RAM+247
        sta SCREEN_RAM+246
        sta SCREEN_RAM+245
        sta SCREEN_RAM+244
        sta SCREEN_RAM+243
        sta SCREEN_RAM+242
        sta SCREEN_RAM+241
        sta SCREEN_RAM+240
; clear screen row 7 cols 0..39
        sta SCREEN_RAM+319
        sta SCREEN_RAM+318
        sta SCREEN_RAM+317
        sta SCREEN_RAM+316
        sta SCREEN_RAM+315
        sta SCREEN_RAM+314
        sta SCREEN_RAM+313
        sta SCREEN_RAM+312
        sta SCREEN_RAM+311
        sta SCREEN_RAM+310
        sta SCREEN_RAM+309
        sta SCREEN_RAM+308
        sta SCREEN_RAM+307
        sta SCREEN_RAM+306
        sta SCREEN_RAM+305
        sta SCREEN_RAM+304
        sta SCREEN_RAM+303
        sta SCREEN_RAM+302
        sta SCREEN_RAM+301
        sta SCREEN_RAM+300
        sta SCREEN_RAM+299
        sta SCREEN_RAM+298
        sta SCREEN_RAM+297
        sta SCREEN_RAM+296
        sta SCREEN_RAM+295
        sta SCREEN_RAM+294
        sta SCREEN_RAM+293
        sta SCREEN_RAM+292
        sta SCREEN_RAM+291
        sta SCREEN_RAM+290
        sta SCREEN_RAM+289
        sta SCREEN_RAM+288
        sta SCREEN_RAM+287
        sta SCREEN_RAM+286
        sta SCREEN_RAM+285
        sta SCREEN_RAM+284
        sta SCREEN_RAM+283
        sta SCREEN_RAM+282
        sta SCREEN_RAM+281
        sta SCREEN_RAM+280
; clear screen row 8 cols 0..39
        sta SCREEN_RAM+359
        sta SCREEN_RAM+358
        sta SCREEN_RAM+357
        sta SCREEN_RAM+356
        sta SCREEN_RAM+355
        sta SCREEN_RAM+354
        sta SCREEN_RAM+353
        sta SCREEN_RAM+352
        sta SCREEN_RAM+351
        sta SCREEN_RAM+350
        sta SCREEN_RAM+349
        sta SCREEN_RAM+348
        sta SCREEN_RAM+347
        sta SCREEN_RAM+346
        sta SCREEN_RAM+345
        sta SCREEN_RAM+344
        sta SCREEN_RAM+343
        sta SCREEN_RAM+342
        sta SCREEN_RAM+341
        sta SCREEN_RAM+340
        sta SCREEN_RAM+339
        sta SCREEN_RAM+338
        sta SCREEN_RAM+337
        sta SCREEN_RAM+336
        sta SCREEN_RAM+335
        sta SCREEN_RAM+334
        sta SCREEN_RAM+333
        sta SCREEN_RAM+332
        sta SCREEN_RAM+331
        sta SCREEN_RAM+330
        sta SCREEN_RAM+329
        sta SCREEN_RAM+328
        sta SCREEN_RAM+327
        sta SCREEN_RAM+326
        sta SCREEN_RAM+325
        sta SCREEN_RAM+324
        sta SCREEN_RAM+323
        sta SCREEN_RAM+322
        sta SCREEN_RAM+321
        sta SCREEN_RAM+320
; clear screen row 9 cols 0..39
        sta SCREEN_RAM+399
        sta SCREEN_RAM+398
        sta SCREEN_RAM+397
        sta SCREEN_RAM+396
        sta SCREEN_RAM+395
        sta SCREEN_RAM+394
        sta SCREEN_RAM+393
        sta SCREEN_RAM+392
        sta SCREEN_RAM+391
        sta SCREEN_RAM+390
        sta SCREEN_RAM+389
        sta SCREEN_RAM+388
        sta SCREEN_RAM+387
        sta SCREEN_RAM+386
        sta SCREEN_RAM+385
        sta SCREEN_RAM+384
        sta SCREEN_RAM+383
        sta SCREEN_RAM+382
        sta SCREEN_RAM+381
        sta SCREEN_RAM+380
        sta SCREEN_RAM+379
        sta SCREEN_RAM+378
        sta SCREEN_RAM+377
        sta SCREEN_RAM+376
        sta SCREEN_RAM+375
        sta SCREEN_RAM+374
        sta SCREEN_RAM+373
        sta SCREEN_RAM+372
        sta SCREEN_RAM+371
        sta SCREEN_RAM+370
        sta SCREEN_RAM+369
        sta SCREEN_RAM+368
        sta SCREEN_RAM+367
        sta SCREEN_RAM+366
        sta SCREEN_RAM+365
        sta SCREEN_RAM+364
        sta SCREEN_RAM+363
        sta SCREEN_RAM+362
        sta SCREEN_RAM+361
        sta SCREEN_RAM+360
; clear screen row 10 cols 0..39
        sta SCREEN_RAM+439
        sta SCREEN_RAM+438
        sta SCREEN_RAM+437
        sta SCREEN_RAM+436
        sta SCREEN_RAM+435
        sta SCREEN_RAM+434
        sta SCREEN_RAM+433
        sta SCREEN_RAM+432
        sta SCREEN_RAM+431
        sta SCREEN_RAM+430
        sta SCREEN_RAM+429
        sta SCREEN_RAM+428
        sta SCREEN_RAM+427
        sta SCREEN_RAM+426
        sta SCREEN_RAM+425
        sta SCREEN_RAM+424
        sta SCREEN_RAM+423
        sta SCREEN_RAM+422
        sta SCREEN_RAM+421
        sta SCREEN_RAM+420
        sta SCREEN_RAM+419
        sta SCREEN_RAM+418
        sta SCREEN_RAM+417
        sta SCREEN_RAM+416
        sta SCREEN_RAM+415
        sta SCREEN_RAM+414
        sta SCREEN_RAM+413
        sta SCREEN_RAM+412
        sta SCREEN_RAM+411
        sta SCREEN_RAM+410
        sta SCREEN_RAM+409
        sta SCREEN_RAM+408
        sta SCREEN_RAM+407
        sta SCREEN_RAM+406
        sta SCREEN_RAM+405
        sta SCREEN_RAM+404
        sta SCREEN_RAM+403
        sta SCREEN_RAM+402
        sta SCREEN_RAM+401
        sta SCREEN_RAM+400
; clear screen row 11 cols 0..39
        sta SCREEN_RAM+479
        sta SCREEN_RAM+478
        sta SCREEN_RAM+477
        sta SCREEN_RAM+476
        sta SCREEN_RAM+475
        sta SCREEN_RAM+474
        sta SCREEN_RAM+473
        sta SCREEN_RAM+472
        sta SCREEN_RAM+471
        sta SCREEN_RAM+470
        sta SCREEN_RAM+469
        sta SCREEN_RAM+468
        sta SCREEN_RAM+467
        sta SCREEN_RAM+466
        sta SCREEN_RAM+465
        sta SCREEN_RAM+464
        sta SCREEN_RAM+463
        sta SCREEN_RAM+462
        sta SCREEN_RAM+461
        sta SCREEN_RAM+460
        sta SCREEN_RAM+459
        sta SCREEN_RAM+458
        sta SCREEN_RAM+457
        sta SCREEN_RAM+456
        sta SCREEN_RAM+455
        sta SCREEN_RAM+454
        sta SCREEN_RAM+453
        sta SCREEN_RAM+452
        sta SCREEN_RAM+451
        sta SCREEN_RAM+450
        sta SCREEN_RAM+449
        sta SCREEN_RAM+448
        sta SCREEN_RAM+447
        sta SCREEN_RAM+446
        sta SCREEN_RAM+445
        sta SCREEN_RAM+444
        sta SCREEN_RAM+443
        sta SCREEN_RAM+442
        sta SCREEN_RAM+441
        sta SCREEN_RAM+440
; clear screen row 12 cols 0..39
        sta SCREEN_RAM+519
        sta SCREEN_RAM+518
        sta SCREEN_RAM+517
        sta SCREEN_RAM+516
        sta SCREEN_RAM+515
        sta SCREEN_RAM+514
        sta SCREEN_RAM+513
        sta SCREEN_RAM+512
        sta SCREEN_RAM+511
        sta SCREEN_RAM+510
        sta SCREEN_RAM+509
        sta SCREEN_RAM+508
        sta SCREEN_RAM+507
        sta SCREEN_RAM+506
        sta SCREEN_RAM+505
        sta SCREEN_RAM+504
        sta SCREEN_RAM+503
        sta SCREEN_RAM+502
        sta SCREEN_RAM+501
        sta SCREEN_RAM+500
        sta SCREEN_RAM+499
        sta SCREEN_RAM+498
        sta SCREEN_RAM+497
        sta SCREEN_RAM+496
        sta SCREEN_RAM+495
        sta SCREEN_RAM+494
        sta SCREEN_RAM+493
        sta SCREEN_RAM+492
        sta SCREEN_RAM+491
        sta SCREEN_RAM+490
        sta SCREEN_RAM+489
        sta SCREEN_RAM+488
        sta SCREEN_RAM+487
        sta SCREEN_RAM+486
        sta SCREEN_RAM+485
        sta SCREEN_RAM+484
        sta SCREEN_RAM+483
        sta SCREEN_RAM+482
        sta SCREEN_RAM+481
        sta SCREEN_RAM+480
; clear screen row 13 cols 0..39
        sta SCREEN_RAM+559
        sta SCREEN_RAM+558
        sta SCREEN_RAM+557
        sta SCREEN_RAM+556
        sta SCREEN_RAM+555
        sta SCREEN_RAM+554
        sta SCREEN_RAM+553
        sta SCREEN_RAM+552
        sta SCREEN_RAM+551
        sta SCREEN_RAM+550
        sta SCREEN_RAM+549
        sta SCREEN_RAM+548
        sta SCREEN_RAM+547
        sta SCREEN_RAM+546
        sta SCREEN_RAM+545
        sta SCREEN_RAM+544
        sta SCREEN_RAM+543
        sta SCREEN_RAM+542
        sta SCREEN_RAM+541
        sta SCREEN_RAM+540
        sta SCREEN_RAM+539
        sta SCREEN_RAM+538
        sta SCREEN_RAM+537
        sta SCREEN_RAM+536
        sta SCREEN_RAM+535
        sta SCREEN_RAM+534
        sta SCREEN_RAM+533
        sta SCREEN_RAM+532
        sta SCREEN_RAM+531
        sta SCREEN_RAM+530
        sta SCREEN_RAM+529
        sta SCREEN_RAM+528
        sta SCREEN_RAM+527
        sta SCREEN_RAM+526
        sta SCREEN_RAM+525
        sta SCREEN_RAM+524
        sta SCREEN_RAM+523
        sta SCREEN_RAM+522
        sta SCREEN_RAM+521
        sta SCREEN_RAM+520
; clear screen row 14 cols 0..39
        sta SCREEN_RAM+599
        sta SCREEN_RAM+598
        sta SCREEN_RAM+597
        sta SCREEN_RAM+596
        sta SCREEN_RAM+595
        sta SCREEN_RAM+594
        sta SCREEN_RAM+593
        sta SCREEN_RAM+592
        sta SCREEN_RAM+591
        sta SCREEN_RAM+590
        sta SCREEN_RAM+589
        sta SCREEN_RAM+588
        sta SCREEN_RAM+587
        sta SCREEN_RAM+586
        sta SCREEN_RAM+585
        sta SCREEN_RAM+584
        sta SCREEN_RAM+583
        sta SCREEN_RAM+582
        sta SCREEN_RAM+581
        sta SCREEN_RAM+580
        sta SCREEN_RAM+579
        sta SCREEN_RAM+578
        sta SCREEN_RAM+577
        sta SCREEN_RAM+576
        sta SCREEN_RAM+575
        sta SCREEN_RAM+574
        sta SCREEN_RAM+573
        sta SCREEN_RAM+572
        sta SCREEN_RAM+571
        sta SCREEN_RAM+570
        sta SCREEN_RAM+569
        sta SCREEN_RAM+568
        sta SCREEN_RAM+567
        sta SCREEN_RAM+566
        sta SCREEN_RAM+565
        sta SCREEN_RAM+564
        sta SCREEN_RAM+563
        sta SCREEN_RAM+562
        sta SCREEN_RAM+561
        sta SCREEN_RAM+560
; clear screen row 15 cols 0..39
        sta SCREEN_RAM+639
        sta SCREEN_RAM+638
        sta SCREEN_RAM+637
        sta SCREEN_RAM+636
        sta SCREEN_RAM+635
        sta SCREEN_RAM+634
        sta SCREEN_RAM+633
        sta SCREEN_RAM+632
        sta SCREEN_RAM+631
        sta SCREEN_RAM+630
        sta SCREEN_RAM+629
        sta SCREEN_RAM+628
        sta SCREEN_RAM+627
        sta SCREEN_RAM+626
        sta SCREEN_RAM+625
        sta SCREEN_RAM+624
        sta SCREEN_RAM+623
        sta SCREEN_RAM+622
        sta SCREEN_RAM+621
        sta SCREEN_RAM+620
        sta SCREEN_RAM+619
        sta SCREEN_RAM+618
        sta SCREEN_RAM+617
        sta SCREEN_RAM+616
        sta SCREEN_RAM+615
        sta SCREEN_RAM+614
        sta SCREEN_RAM+613
        sta SCREEN_RAM+612
        sta SCREEN_RAM+611
        sta SCREEN_RAM+610
        sta SCREEN_RAM+609
        sta SCREEN_RAM+608
        sta SCREEN_RAM+607
        sta SCREEN_RAM+606
        sta SCREEN_RAM+605
        sta SCREEN_RAM+604
        sta SCREEN_RAM+603
        sta SCREEN_RAM+602
        sta SCREEN_RAM+601
        sta SCREEN_RAM+600
; clear screen row 16 cols 0..39
        sta SCREEN_RAM+679
        sta SCREEN_RAM+678
        sta SCREEN_RAM+677
        sta SCREEN_RAM+676
        sta SCREEN_RAM+675
        sta SCREEN_RAM+674
        sta SCREEN_RAM+673
        sta SCREEN_RAM+672
        sta SCREEN_RAM+671
        sta SCREEN_RAM+670
        sta SCREEN_RAM+669
        sta SCREEN_RAM+668
        sta SCREEN_RAM+667
        sta SCREEN_RAM+666
        sta SCREEN_RAM+665
        sta SCREEN_RAM+664
        sta SCREEN_RAM+663
        sta SCREEN_RAM+662
        sta SCREEN_RAM+661
        sta SCREEN_RAM+660
        sta SCREEN_RAM+659
        sta SCREEN_RAM+658
        sta SCREEN_RAM+657
        sta SCREEN_RAM+656
        sta SCREEN_RAM+655
        sta SCREEN_RAM+654
        sta SCREEN_RAM+653
        sta SCREEN_RAM+652
        sta SCREEN_RAM+651
        sta SCREEN_RAM+650
        sta SCREEN_RAM+649
        sta SCREEN_RAM+648
        sta SCREEN_RAM+647
        sta SCREEN_RAM+646
        sta SCREEN_RAM+645
        sta SCREEN_RAM+644
        sta SCREEN_RAM+643
        sta SCREEN_RAM+642
        sta SCREEN_RAM+641
        sta SCREEN_RAM+640
; clear screen row 17 cols 0..39
        sta SCREEN_RAM+719
        sta SCREEN_RAM+718
        sta SCREEN_RAM+717
        sta SCREEN_RAM+716
        sta SCREEN_RAM+715
        sta SCREEN_RAM+714
        sta SCREEN_RAM+713
        sta SCREEN_RAM+712
        sta SCREEN_RAM+711
        sta SCREEN_RAM+710
        sta SCREEN_RAM+709
        sta SCREEN_RAM+708
        sta SCREEN_RAM+707
        sta SCREEN_RAM+706
        sta SCREEN_RAM+705
        sta SCREEN_RAM+704
        sta SCREEN_RAM+703
        sta SCREEN_RAM+702
        sta SCREEN_RAM+701
        sta SCREEN_RAM+700
        sta SCREEN_RAM+699
        sta SCREEN_RAM+698
        sta SCREEN_RAM+697
        sta SCREEN_RAM+696
        sta SCREEN_RAM+695
        sta SCREEN_RAM+694
        sta SCREEN_RAM+693
        sta SCREEN_RAM+692
        sta SCREEN_RAM+691
        sta SCREEN_RAM+690
        sta SCREEN_RAM+689
        sta SCREEN_RAM+688
        sta SCREEN_RAM+687
        sta SCREEN_RAM+686
        sta SCREEN_RAM+685
        sta SCREEN_RAM+684
        sta SCREEN_RAM+683
        sta SCREEN_RAM+682
        sta SCREEN_RAM+681
        sta SCREEN_RAM+680
; clear screen row 18 cols 0..39
        sta SCREEN_RAM+759
        sta SCREEN_RAM+758
        sta SCREEN_RAM+757
        sta SCREEN_RAM+756
        sta SCREEN_RAM+755
        sta SCREEN_RAM+754
        sta SCREEN_RAM+753
        sta SCREEN_RAM+752
        sta SCREEN_RAM+751
        sta SCREEN_RAM+750
        sta SCREEN_RAM+749
        sta SCREEN_RAM+748
        sta SCREEN_RAM+747
        sta SCREEN_RAM+746
        sta SCREEN_RAM+745
        sta SCREEN_RAM+744
        sta SCREEN_RAM+743
        sta SCREEN_RAM+742
        sta SCREEN_RAM+741
        sta SCREEN_RAM+740
        sta SCREEN_RAM+739
        sta SCREEN_RAM+738
        sta SCREEN_RAM+737
        sta SCREEN_RAM+736
        sta SCREEN_RAM+735
        sta SCREEN_RAM+734
        sta SCREEN_RAM+733
        sta SCREEN_RAM+732
        sta SCREEN_RAM+731
        sta SCREEN_RAM+730
        sta SCREEN_RAM+729
        sta SCREEN_RAM+728
        sta SCREEN_RAM+727
        sta SCREEN_RAM+726
        sta SCREEN_RAM+725
        sta SCREEN_RAM+724
        sta SCREEN_RAM+723
        sta SCREEN_RAM+722
        sta SCREEN_RAM+721
        sta SCREEN_RAM+720
; clear screen row 19 cols 0..39
        sta SCREEN_RAM+799
        sta SCREEN_RAM+798
        sta SCREEN_RAM+797
        sta SCREEN_RAM+796
        sta SCREEN_RAM+795
        sta SCREEN_RAM+794
        sta SCREEN_RAM+793
        sta SCREEN_RAM+792
        sta SCREEN_RAM+791
        sta SCREEN_RAM+790
        sta SCREEN_RAM+789
        sta SCREEN_RAM+788
        sta SCREEN_RAM+787
        sta SCREEN_RAM+786
        sta SCREEN_RAM+785
        sta SCREEN_RAM+784
        sta SCREEN_RAM+783
        sta SCREEN_RAM+782
        sta SCREEN_RAM+781
        sta SCREEN_RAM+780
        sta SCREEN_RAM+779
        sta SCREEN_RAM+778
        sta SCREEN_RAM+777
        sta SCREEN_RAM+776
        sta SCREEN_RAM+775
        sta SCREEN_RAM+774
        sta SCREEN_RAM+773
        sta SCREEN_RAM+772
        sta SCREEN_RAM+771
        sta SCREEN_RAM+770
        sta SCREEN_RAM+769
        sta SCREEN_RAM+768
        sta SCREEN_RAM+767
        sta SCREEN_RAM+766
        sta SCREEN_RAM+765
        sta SCREEN_RAM+764
        sta SCREEN_RAM+763
        sta SCREEN_RAM+762
        sta SCREEN_RAM+761
        sta SCREEN_RAM+760
; clear screen row 20 cols 0..39
        sta SCREEN_RAM+839
        sta SCREEN_RAM+838
        sta SCREEN_RAM+837
        sta SCREEN_RAM+836
        sta SCREEN_RAM+835
        sta SCREEN_RAM+834
        sta SCREEN_RAM+833
        sta SCREEN_RAM+832
        sta SCREEN_RAM+831
        sta SCREEN_RAM+830
        sta SCREEN_RAM+829
        sta SCREEN_RAM+828
        sta SCREEN_RAM+827
        sta SCREEN_RAM+826
        sta SCREEN_RAM+825
        sta SCREEN_RAM+824
        sta SCREEN_RAM+823
        sta SCREEN_RAM+822
        sta SCREEN_RAM+821
        sta SCREEN_RAM+820
        sta SCREEN_RAM+819
        sta SCREEN_RAM+818
        sta SCREEN_RAM+817
        sta SCREEN_RAM+816
        sta SCREEN_RAM+815
        sta SCREEN_RAM+814
        sta SCREEN_RAM+813
        sta SCREEN_RAM+812
        sta SCREEN_RAM+811
        sta SCREEN_RAM+810
        sta SCREEN_RAM+809
        sta SCREEN_RAM+808
        sta SCREEN_RAM+807
        sta SCREEN_RAM+806
        sta SCREEN_RAM+805
        sta SCREEN_RAM+804
        sta SCREEN_RAM+803
        sta SCREEN_RAM+802
        sta SCREEN_RAM+801
        sta SCREEN_RAM+800
; clear screen row 21 cols 0..39
        sta SCREEN_RAM+879
        sta SCREEN_RAM+878
        sta SCREEN_RAM+877
        sta SCREEN_RAM+876
        sta SCREEN_RAM+875
        sta SCREEN_RAM+874
        sta SCREEN_RAM+873
        sta SCREEN_RAM+872
        sta SCREEN_RAM+871
        sta SCREEN_RAM+870
        sta SCREEN_RAM+869
        sta SCREEN_RAM+868
        sta SCREEN_RAM+867
        sta SCREEN_RAM+866
        sta SCREEN_RAM+865
        sta SCREEN_RAM+864
        sta SCREEN_RAM+863
        sta SCREEN_RAM+862
        sta SCREEN_RAM+861
        sta SCREEN_RAM+860
        sta SCREEN_RAM+859
        sta SCREEN_RAM+858
        sta SCREEN_RAM+857
        sta SCREEN_RAM+856
        sta SCREEN_RAM+855
        sta SCREEN_RAM+854
        sta SCREEN_RAM+853
        sta SCREEN_RAM+852
        sta SCREEN_RAM+851
        sta SCREEN_RAM+850
        sta SCREEN_RAM+849
        sta SCREEN_RAM+848
        sta SCREEN_RAM+847
        sta SCREEN_RAM+846
        sta SCREEN_RAM+845
        sta SCREEN_RAM+844
        sta SCREEN_RAM+843
        sta SCREEN_RAM+842
        sta SCREEN_RAM+841
        sta SCREEN_RAM+840
        lda #$00              ; V7.8: blank backdrop colour is black
; clear color row 3 cols 0..39
        sta COLOR_RAM+159
        sta COLOR_RAM+158
        sta COLOR_RAM+157
        sta COLOR_RAM+156
        sta COLOR_RAM+155
        sta COLOR_RAM+154
        sta COLOR_RAM+153
        sta COLOR_RAM+152
        sta COLOR_RAM+151
        sta COLOR_RAM+150
        sta COLOR_RAM+149
        sta COLOR_RAM+148
        sta COLOR_RAM+147
        sta COLOR_RAM+146
        sta COLOR_RAM+145
        sta COLOR_RAM+144
        sta COLOR_RAM+143
        sta COLOR_RAM+142
        sta COLOR_RAM+141
        sta COLOR_RAM+140
        sta COLOR_RAM+139
        sta COLOR_RAM+138
        sta COLOR_RAM+137
        sta COLOR_RAM+136
        sta COLOR_RAM+135
        sta COLOR_RAM+134
        sta COLOR_RAM+133
        sta COLOR_RAM+132
        sta COLOR_RAM+131
        sta COLOR_RAM+130
        sta COLOR_RAM+129
        sta COLOR_RAM+128
        sta COLOR_RAM+127
        sta COLOR_RAM+126
        sta COLOR_RAM+125
        sta COLOR_RAM+124
        sta COLOR_RAM+123
        sta COLOR_RAM+122
        sta COLOR_RAM+121
        sta COLOR_RAM+120
; clear color row 4 cols 0..39
        sta COLOR_RAM+199
        sta COLOR_RAM+198
        sta COLOR_RAM+197
        sta COLOR_RAM+196
        sta COLOR_RAM+195
        sta COLOR_RAM+194
        sta COLOR_RAM+193
        sta COLOR_RAM+192
        sta COLOR_RAM+191
        sta COLOR_RAM+190
        sta COLOR_RAM+189
        sta COLOR_RAM+188
        sta COLOR_RAM+187
        sta COLOR_RAM+186
        sta COLOR_RAM+185
        sta COLOR_RAM+184
        sta COLOR_RAM+183
        sta COLOR_RAM+182
        sta COLOR_RAM+181
        sta COLOR_RAM+180
        sta COLOR_RAM+179
        sta COLOR_RAM+178
        sta COLOR_RAM+177
        sta COLOR_RAM+176
        sta COLOR_RAM+175
        sta COLOR_RAM+174
        sta COLOR_RAM+173
        sta COLOR_RAM+172
        sta COLOR_RAM+171
        sta COLOR_RAM+170
        sta COLOR_RAM+169
        sta COLOR_RAM+168
        sta COLOR_RAM+167
        sta COLOR_RAM+166
        sta COLOR_RAM+165
        sta COLOR_RAM+164
        sta COLOR_RAM+163
        sta COLOR_RAM+162
        sta COLOR_RAM+161
        sta COLOR_RAM+160
; clear color row 5 cols 0..39
        sta COLOR_RAM+239
        sta COLOR_RAM+238
        sta COLOR_RAM+237
        sta COLOR_RAM+236
        sta COLOR_RAM+235
        sta COLOR_RAM+234
        sta COLOR_RAM+233
        sta COLOR_RAM+232
        sta COLOR_RAM+231
        sta COLOR_RAM+230
        sta COLOR_RAM+229
        sta COLOR_RAM+228
        sta COLOR_RAM+227
        sta COLOR_RAM+226
        sta COLOR_RAM+225
        sta COLOR_RAM+224
        sta COLOR_RAM+223
        sta COLOR_RAM+222
        sta COLOR_RAM+221
        sta COLOR_RAM+220
        sta COLOR_RAM+219
        sta COLOR_RAM+218
        sta COLOR_RAM+217
        sta COLOR_RAM+216
        sta COLOR_RAM+215
        sta COLOR_RAM+214
        sta COLOR_RAM+213
        sta COLOR_RAM+212
        sta COLOR_RAM+211
        sta COLOR_RAM+210
        sta COLOR_RAM+209
        sta COLOR_RAM+208
        sta COLOR_RAM+207
        sta COLOR_RAM+206
        sta COLOR_RAM+205
        sta COLOR_RAM+204
        sta COLOR_RAM+203
        sta COLOR_RAM+202
        sta COLOR_RAM+201
        sta COLOR_RAM+200
; clear color row 6 cols 0..39
        sta COLOR_RAM+279
        sta COLOR_RAM+278
        sta COLOR_RAM+277
        sta COLOR_RAM+276
        sta COLOR_RAM+275
        sta COLOR_RAM+274
        sta COLOR_RAM+273
        sta COLOR_RAM+272
        sta COLOR_RAM+271
        sta COLOR_RAM+270
        sta COLOR_RAM+269
        sta COLOR_RAM+268
        sta COLOR_RAM+267
        sta COLOR_RAM+266
        sta COLOR_RAM+265
        sta COLOR_RAM+264
        sta COLOR_RAM+263
        sta COLOR_RAM+262
        sta COLOR_RAM+261
        sta COLOR_RAM+260
        sta COLOR_RAM+259
        sta COLOR_RAM+258
        sta COLOR_RAM+257
        sta COLOR_RAM+256
        sta COLOR_RAM+255
        sta COLOR_RAM+254
        sta COLOR_RAM+253
        sta COLOR_RAM+252
        sta COLOR_RAM+251
        sta COLOR_RAM+250
        sta COLOR_RAM+249
        sta COLOR_RAM+248
        sta COLOR_RAM+247
        sta COLOR_RAM+246
        sta COLOR_RAM+245
        sta COLOR_RAM+244
        sta COLOR_RAM+243
        sta COLOR_RAM+242
        sta COLOR_RAM+241
        sta COLOR_RAM+240
; clear color row 7 cols 0..39
        sta COLOR_RAM+319
        sta COLOR_RAM+318
        sta COLOR_RAM+317
        sta COLOR_RAM+316
        sta COLOR_RAM+315
        sta COLOR_RAM+314
        sta COLOR_RAM+313
        sta COLOR_RAM+312
        sta COLOR_RAM+311
        sta COLOR_RAM+310
        sta COLOR_RAM+309
        sta COLOR_RAM+308
        sta COLOR_RAM+307
        sta COLOR_RAM+306
        sta COLOR_RAM+305
        sta COLOR_RAM+304
        sta COLOR_RAM+303
        sta COLOR_RAM+302
        sta COLOR_RAM+301
        sta COLOR_RAM+300
        sta COLOR_RAM+299
        sta COLOR_RAM+298
        sta COLOR_RAM+297
        sta COLOR_RAM+296
        sta COLOR_RAM+295
        sta COLOR_RAM+294
        sta COLOR_RAM+293
        sta COLOR_RAM+292
        sta COLOR_RAM+291
        sta COLOR_RAM+290
        sta COLOR_RAM+289
        sta COLOR_RAM+288
        sta COLOR_RAM+287
        sta COLOR_RAM+286
        sta COLOR_RAM+285
        sta COLOR_RAM+284
        sta COLOR_RAM+283
        sta COLOR_RAM+282
        sta COLOR_RAM+281
        sta COLOR_RAM+280
; clear color row 8 cols 0..39
        sta COLOR_RAM+359
        sta COLOR_RAM+358
        sta COLOR_RAM+357
        sta COLOR_RAM+356
        sta COLOR_RAM+355
        sta COLOR_RAM+354
        sta COLOR_RAM+353
        sta COLOR_RAM+352
        sta COLOR_RAM+351
        sta COLOR_RAM+350
        sta COLOR_RAM+349
        sta COLOR_RAM+348
        sta COLOR_RAM+347
        sta COLOR_RAM+346
        sta COLOR_RAM+345
        sta COLOR_RAM+344
        sta COLOR_RAM+343
        sta COLOR_RAM+342
        sta COLOR_RAM+341
        sta COLOR_RAM+340
        sta COLOR_RAM+339
        sta COLOR_RAM+338
        sta COLOR_RAM+337
        sta COLOR_RAM+336
        sta COLOR_RAM+335
        sta COLOR_RAM+334
        sta COLOR_RAM+333
        sta COLOR_RAM+332
        sta COLOR_RAM+331
        sta COLOR_RAM+330
        sta COLOR_RAM+329
        sta COLOR_RAM+328
        sta COLOR_RAM+327
        sta COLOR_RAM+326
        sta COLOR_RAM+325
        sta COLOR_RAM+324
        sta COLOR_RAM+323
        sta COLOR_RAM+322
        sta COLOR_RAM+321
        sta COLOR_RAM+320
; clear color row 9 cols 0..39
        sta COLOR_RAM+399
        sta COLOR_RAM+398
        sta COLOR_RAM+397
        sta COLOR_RAM+396
        sta COLOR_RAM+395
        sta COLOR_RAM+394
        sta COLOR_RAM+393
        sta COLOR_RAM+392
        sta COLOR_RAM+391
        sta COLOR_RAM+390
        sta COLOR_RAM+389
        sta COLOR_RAM+388
        sta COLOR_RAM+387
        sta COLOR_RAM+386
        sta COLOR_RAM+385
        sta COLOR_RAM+384
        sta COLOR_RAM+383
        sta COLOR_RAM+382
        sta COLOR_RAM+381
        sta COLOR_RAM+380
        sta COLOR_RAM+379
        sta COLOR_RAM+378
        sta COLOR_RAM+377
        sta COLOR_RAM+376
        sta COLOR_RAM+375
        sta COLOR_RAM+374
        sta COLOR_RAM+373
        sta COLOR_RAM+372
        sta COLOR_RAM+371
        sta COLOR_RAM+370
        sta COLOR_RAM+369
        sta COLOR_RAM+368
        sta COLOR_RAM+367
        sta COLOR_RAM+366
        sta COLOR_RAM+365
        sta COLOR_RAM+364
        sta COLOR_RAM+363
        sta COLOR_RAM+362
        sta COLOR_RAM+361
        sta COLOR_RAM+360
; clear color row 10 cols 0..39
        sta COLOR_RAM+439
        sta COLOR_RAM+438
        sta COLOR_RAM+437
        sta COLOR_RAM+436
        sta COLOR_RAM+435
        sta COLOR_RAM+434
        sta COLOR_RAM+433
        sta COLOR_RAM+432
        sta COLOR_RAM+431
        sta COLOR_RAM+430
        sta COLOR_RAM+429
        sta COLOR_RAM+428
        sta COLOR_RAM+427
        sta COLOR_RAM+426
        sta COLOR_RAM+425
        sta COLOR_RAM+424
        sta COLOR_RAM+423
        sta COLOR_RAM+422
        sta COLOR_RAM+421
        sta COLOR_RAM+420
        sta COLOR_RAM+419
        sta COLOR_RAM+418
        sta COLOR_RAM+417
        sta COLOR_RAM+416
        sta COLOR_RAM+415
        sta COLOR_RAM+414
        sta COLOR_RAM+413
        sta COLOR_RAM+412
        sta COLOR_RAM+411
        sta COLOR_RAM+410
        sta COLOR_RAM+409
        sta COLOR_RAM+408
        sta COLOR_RAM+407
        sta COLOR_RAM+406
        sta COLOR_RAM+405
        sta COLOR_RAM+404
        sta COLOR_RAM+403
        sta COLOR_RAM+402
        sta COLOR_RAM+401
        sta COLOR_RAM+400
; clear color row 11 cols 0..39
        sta COLOR_RAM+479
        sta COLOR_RAM+478
        sta COLOR_RAM+477
        sta COLOR_RAM+476
        sta COLOR_RAM+475
        sta COLOR_RAM+474
        sta COLOR_RAM+473
        sta COLOR_RAM+472
        sta COLOR_RAM+471
        sta COLOR_RAM+470
        sta COLOR_RAM+469
        sta COLOR_RAM+468
        sta COLOR_RAM+467
        sta COLOR_RAM+466
        sta COLOR_RAM+465
        sta COLOR_RAM+464
        sta COLOR_RAM+463
        sta COLOR_RAM+462
        sta COLOR_RAM+461
        sta COLOR_RAM+460
        sta COLOR_RAM+459
        sta COLOR_RAM+458
        sta COLOR_RAM+457
        sta COLOR_RAM+456
        sta COLOR_RAM+455
        sta COLOR_RAM+454
        sta COLOR_RAM+453
        sta COLOR_RAM+452
        sta COLOR_RAM+451
        sta COLOR_RAM+450
        sta COLOR_RAM+449
        sta COLOR_RAM+448
        sta COLOR_RAM+447
        sta COLOR_RAM+446
        sta COLOR_RAM+445
        sta COLOR_RAM+444
        sta COLOR_RAM+443
        sta COLOR_RAM+442
        sta COLOR_RAM+441
        sta COLOR_RAM+440
; clear color row 12 cols 0..39
        sta COLOR_RAM+519
        sta COLOR_RAM+518
        sta COLOR_RAM+517
        sta COLOR_RAM+516
        sta COLOR_RAM+515
        sta COLOR_RAM+514
        sta COLOR_RAM+513
        sta COLOR_RAM+512
        sta COLOR_RAM+511
        sta COLOR_RAM+510
        sta COLOR_RAM+509
        sta COLOR_RAM+508
        sta COLOR_RAM+507
        sta COLOR_RAM+506
        sta COLOR_RAM+505
        sta COLOR_RAM+504
        sta COLOR_RAM+503
        sta COLOR_RAM+502
        sta COLOR_RAM+501
        sta COLOR_RAM+500
        sta COLOR_RAM+499
        sta COLOR_RAM+498
        sta COLOR_RAM+497
        sta COLOR_RAM+496
        sta COLOR_RAM+495
        sta COLOR_RAM+494
        sta COLOR_RAM+493
        sta COLOR_RAM+492
        sta COLOR_RAM+491
        sta COLOR_RAM+490
        sta COLOR_RAM+489
        sta COLOR_RAM+488
        sta COLOR_RAM+487
        sta COLOR_RAM+486
        sta COLOR_RAM+485
        sta COLOR_RAM+484
        sta COLOR_RAM+483
        sta COLOR_RAM+482
        sta COLOR_RAM+481
        sta COLOR_RAM+480
; clear color row 13 cols 0..39
        sta COLOR_RAM+559
        sta COLOR_RAM+558
        sta COLOR_RAM+557
        sta COLOR_RAM+556
        sta COLOR_RAM+555
        sta COLOR_RAM+554
        sta COLOR_RAM+553
        sta COLOR_RAM+552
        sta COLOR_RAM+551
        sta COLOR_RAM+550
        sta COLOR_RAM+549
        sta COLOR_RAM+548
        sta COLOR_RAM+547
        sta COLOR_RAM+546
        sta COLOR_RAM+545
        sta COLOR_RAM+544
        sta COLOR_RAM+543
        sta COLOR_RAM+542
        sta COLOR_RAM+541
        sta COLOR_RAM+540
        sta COLOR_RAM+539
        sta COLOR_RAM+538
        sta COLOR_RAM+537
        sta COLOR_RAM+536
        sta COLOR_RAM+535
        sta COLOR_RAM+534
        sta COLOR_RAM+533
        sta COLOR_RAM+532
        sta COLOR_RAM+531
        sta COLOR_RAM+530
        sta COLOR_RAM+529
        sta COLOR_RAM+528
        sta COLOR_RAM+527
        sta COLOR_RAM+526
        sta COLOR_RAM+525
        sta COLOR_RAM+524
        sta COLOR_RAM+523
        sta COLOR_RAM+522
        sta COLOR_RAM+521
        sta COLOR_RAM+520
; clear color row 14 cols 0..39
        sta COLOR_RAM+599
        sta COLOR_RAM+598
        sta COLOR_RAM+597
        sta COLOR_RAM+596
        sta COLOR_RAM+595
        sta COLOR_RAM+594
        sta COLOR_RAM+593
        sta COLOR_RAM+592
        sta COLOR_RAM+591
        sta COLOR_RAM+590
        sta COLOR_RAM+589
        sta COLOR_RAM+588
        sta COLOR_RAM+587
        sta COLOR_RAM+586
        sta COLOR_RAM+585
        sta COLOR_RAM+584
        sta COLOR_RAM+583
        sta COLOR_RAM+582
        sta COLOR_RAM+581
        sta COLOR_RAM+580
        sta COLOR_RAM+579
        sta COLOR_RAM+578
        sta COLOR_RAM+577
        sta COLOR_RAM+576
        sta COLOR_RAM+575
        sta COLOR_RAM+574
        sta COLOR_RAM+573
        sta COLOR_RAM+572
        sta COLOR_RAM+571
        sta COLOR_RAM+570
        sta COLOR_RAM+569
        sta COLOR_RAM+568
        sta COLOR_RAM+567
        sta COLOR_RAM+566
        sta COLOR_RAM+565
        sta COLOR_RAM+564
        sta COLOR_RAM+563
        sta COLOR_RAM+562
        sta COLOR_RAM+561
        sta COLOR_RAM+560
; clear color row 15 cols 0..39
        sta COLOR_RAM+639
        sta COLOR_RAM+638
        sta COLOR_RAM+637
        sta COLOR_RAM+636
        sta COLOR_RAM+635
        sta COLOR_RAM+634
        sta COLOR_RAM+633
        sta COLOR_RAM+632
        sta COLOR_RAM+631
        sta COLOR_RAM+630
        sta COLOR_RAM+629
        sta COLOR_RAM+628
        sta COLOR_RAM+627
        sta COLOR_RAM+626
        sta COLOR_RAM+625
        sta COLOR_RAM+624
        sta COLOR_RAM+623
        sta COLOR_RAM+622
        sta COLOR_RAM+621
        sta COLOR_RAM+620
        sta COLOR_RAM+619
        sta COLOR_RAM+618
        sta COLOR_RAM+617
        sta COLOR_RAM+616
        sta COLOR_RAM+615
        sta COLOR_RAM+614
        sta COLOR_RAM+613
        sta COLOR_RAM+612
        sta COLOR_RAM+611
        sta COLOR_RAM+610
        sta COLOR_RAM+609
        sta COLOR_RAM+608
        sta COLOR_RAM+607
        sta COLOR_RAM+606
        sta COLOR_RAM+605
        sta COLOR_RAM+604
        sta COLOR_RAM+603
        sta COLOR_RAM+602
        sta COLOR_RAM+601
        sta COLOR_RAM+600
; clear color row 16 cols 0..39
        sta COLOR_RAM+679
        sta COLOR_RAM+678
        sta COLOR_RAM+677
        sta COLOR_RAM+676
        sta COLOR_RAM+675
        sta COLOR_RAM+674
        sta COLOR_RAM+673
        sta COLOR_RAM+672
        sta COLOR_RAM+671
        sta COLOR_RAM+670
        sta COLOR_RAM+669
        sta COLOR_RAM+668
        sta COLOR_RAM+667
        sta COLOR_RAM+666
        sta COLOR_RAM+665
        sta COLOR_RAM+664
        sta COLOR_RAM+663
        sta COLOR_RAM+662
        sta COLOR_RAM+661
        sta COLOR_RAM+660
        sta COLOR_RAM+659
        sta COLOR_RAM+658
        sta COLOR_RAM+657
        sta COLOR_RAM+656
        sta COLOR_RAM+655
        sta COLOR_RAM+654
        sta COLOR_RAM+653
        sta COLOR_RAM+652
        sta COLOR_RAM+651
        sta COLOR_RAM+650
        sta COLOR_RAM+649
        sta COLOR_RAM+648
        sta COLOR_RAM+647
        sta COLOR_RAM+646
        sta COLOR_RAM+645
        sta COLOR_RAM+644
        sta COLOR_RAM+643
        sta COLOR_RAM+642
        sta COLOR_RAM+641
        sta COLOR_RAM+640
; clear color row 17 cols 0..39
        sta COLOR_RAM+719
        sta COLOR_RAM+718
        sta COLOR_RAM+717
        sta COLOR_RAM+716
        sta COLOR_RAM+715
        sta COLOR_RAM+714
        sta COLOR_RAM+713
        sta COLOR_RAM+712
        sta COLOR_RAM+711
        sta COLOR_RAM+710
        sta COLOR_RAM+709
        sta COLOR_RAM+708
        sta COLOR_RAM+707
        sta COLOR_RAM+706
        sta COLOR_RAM+705
        sta COLOR_RAM+704
        sta COLOR_RAM+703
        sta COLOR_RAM+702
        sta COLOR_RAM+701
        sta COLOR_RAM+700
        sta COLOR_RAM+699
        sta COLOR_RAM+698
        sta COLOR_RAM+697
        sta COLOR_RAM+696
        sta COLOR_RAM+695
        sta COLOR_RAM+694
        sta COLOR_RAM+693
        sta COLOR_RAM+692
        sta COLOR_RAM+691
        sta COLOR_RAM+690
        sta COLOR_RAM+689
        sta COLOR_RAM+688
        sta COLOR_RAM+687
        sta COLOR_RAM+686
        sta COLOR_RAM+685
        sta COLOR_RAM+684
        sta COLOR_RAM+683
        sta COLOR_RAM+682
        sta COLOR_RAM+681
        sta COLOR_RAM+680
; clear color row 18 cols 0..39
        sta COLOR_RAM+759
        sta COLOR_RAM+758
        sta COLOR_RAM+757
        sta COLOR_RAM+756
        sta COLOR_RAM+755
        sta COLOR_RAM+754
        sta COLOR_RAM+753
        sta COLOR_RAM+752
        sta COLOR_RAM+751
        sta COLOR_RAM+750
        sta COLOR_RAM+749
        sta COLOR_RAM+748
        sta COLOR_RAM+747
        sta COLOR_RAM+746
        sta COLOR_RAM+745
        sta COLOR_RAM+744
        sta COLOR_RAM+743
        sta COLOR_RAM+742
        sta COLOR_RAM+741
        sta COLOR_RAM+740
        sta COLOR_RAM+739
        sta COLOR_RAM+738
        sta COLOR_RAM+737
        sta COLOR_RAM+736
        sta COLOR_RAM+735
        sta COLOR_RAM+734
        sta COLOR_RAM+733
        sta COLOR_RAM+732
        sta COLOR_RAM+731
        sta COLOR_RAM+730
        sta COLOR_RAM+729
        sta COLOR_RAM+728
        sta COLOR_RAM+727
        sta COLOR_RAM+726
        sta COLOR_RAM+725
        sta COLOR_RAM+724
        sta COLOR_RAM+723
        sta COLOR_RAM+722
        sta COLOR_RAM+721
        sta COLOR_RAM+720
; clear color row 19 cols 0..39
        sta COLOR_RAM+799
        sta COLOR_RAM+798
        sta COLOR_RAM+797
        sta COLOR_RAM+796
        sta COLOR_RAM+795
        sta COLOR_RAM+794
        sta COLOR_RAM+793
        sta COLOR_RAM+792
        sta COLOR_RAM+791
        sta COLOR_RAM+790
        sta COLOR_RAM+789
        sta COLOR_RAM+788
        sta COLOR_RAM+787
        sta COLOR_RAM+786
        sta COLOR_RAM+785
        sta COLOR_RAM+784
        sta COLOR_RAM+783
        sta COLOR_RAM+782
        sta COLOR_RAM+781
        sta COLOR_RAM+780
        sta COLOR_RAM+779
        sta COLOR_RAM+778
        sta COLOR_RAM+777
        sta COLOR_RAM+776
        sta COLOR_RAM+775
        sta COLOR_RAM+774
        sta COLOR_RAM+773
        sta COLOR_RAM+772
        sta COLOR_RAM+771
        sta COLOR_RAM+770
        sta COLOR_RAM+769
        sta COLOR_RAM+768
        sta COLOR_RAM+767
        sta COLOR_RAM+766
        sta COLOR_RAM+765
        sta COLOR_RAM+764
        sta COLOR_RAM+763
        sta COLOR_RAM+762
        sta COLOR_RAM+761
        sta COLOR_RAM+760
; clear color row 20 cols 0..39
        sta COLOR_RAM+839
        sta COLOR_RAM+838
        sta COLOR_RAM+837
        sta COLOR_RAM+836
        sta COLOR_RAM+835
        sta COLOR_RAM+834
        sta COLOR_RAM+833
        sta COLOR_RAM+832
        sta COLOR_RAM+831
        sta COLOR_RAM+830
        sta COLOR_RAM+829
        sta COLOR_RAM+828
        sta COLOR_RAM+827
        sta COLOR_RAM+826
        sta COLOR_RAM+825
        sta COLOR_RAM+824
        sta COLOR_RAM+823
        sta COLOR_RAM+822
        sta COLOR_RAM+821
        sta COLOR_RAM+820
        sta COLOR_RAM+819
        sta COLOR_RAM+818
        sta COLOR_RAM+817
        sta COLOR_RAM+816
        sta COLOR_RAM+815
        sta COLOR_RAM+814
        sta COLOR_RAM+813
        sta COLOR_RAM+812
        sta COLOR_RAM+811
        sta COLOR_RAM+810
        sta COLOR_RAM+809
        sta COLOR_RAM+808
        sta COLOR_RAM+807
        sta COLOR_RAM+806
        sta COLOR_RAM+805
        sta COLOR_RAM+804
        sta COLOR_RAM+803
        sta COLOR_RAM+802
        sta COLOR_RAM+801
        sta COLOR_RAM+800
; clear color row 21 cols 0..39
        sta COLOR_RAM+879
        sta COLOR_RAM+878
        sta COLOR_RAM+877
        sta COLOR_RAM+876
        sta COLOR_RAM+875
        sta COLOR_RAM+874
        sta COLOR_RAM+873
        sta COLOR_RAM+872
        sta COLOR_RAM+871
        sta COLOR_RAM+870
        sta COLOR_RAM+869
        sta COLOR_RAM+868
        sta COLOR_RAM+867
        sta COLOR_RAM+866
        sta COLOR_RAM+865
        sta COLOR_RAM+864
        sta COLOR_RAM+863
        sta COLOR_RAM+862
        sta COLOR_RAM+861
        sta COLOR_RAM+860
        sta COLOR_RAM+859
        sta COLOR_RAM+858
        sta COLOR_RAM+857
        sta COLOR_RAM+856
        sta COLOR_RAM+855
        sta COLOR_RAM+854
        sta COLOR_RAM+853
        sta COLOR_RAM+852
        sta COLOR_RAM+851
        sta COLOR_RAM+850
        sta COLOR_RAM+849
        sta COLOR_RAM+848
        sta COLOR_RAM+847
        sta COLOR_RAM+846
        sta COLOR_RAM+845
        sta COLOR_RAM+844
        sta COLOR_RAM+843
        sta COLOR_RAM+842
        sta COLOR_RAM+841
        sta COLOR_RAM+840
        rts
visual_clear_screen:
        lda #$20
        ldx #0
visual_clear_loop:
        sta SCREEN_RAM,x
        sta SCREEN_RAM+$100,x
        sta SCREEN_RAM+$200,x
        sta SCREEN_RAM+$300,x
        inx
        bne visual_clear_loop
        lda #$00              ; V7.8: initial colour RAM backdrop is black
        ldx #0
visual_color_loop:
        sta COLOR_RAM,x
        sta COLOR_RAM+$100,x
        sta COLOR_RAM+$200,x
        sta COLOR_RAM+$300,x
        inx
        bne visual_color_loop
        rts


visual_draw_cube_tail:
        lda cube_glow_env
        bne visual_tail_has_energy
        rts
visual_tail_has_energy:
        inc glam_phase          ; v2.7 tail shimmer phase without side-glam
        lda tail_frame2
        and #$0f
        tax
        lda cube_frame_lo,x
        sta CUBE_PTR
        lda cube_frame_hi,x
        sta CUBE_PTR+1
        lda cube_glow_env
        cmp #$08
        bcs visual_tail2_hot
        lda #$2e
        sta vis_tail_char
        lda #$0b
        sta vis_tail_color
        jmp visual_tail2_draw
visual_tail2_hot:
        lda glam_phase
        and #$01
        beq visual_tail2_star
        lda #$2b
        jmp visual_tail2_store_char
visual_tail2_star:
        lda #$2a
visual_tail2_store_char:
        sta vis_tail_char
        lda #$0c
        sta vis_tail_color
visual_tail2_draw:
        jsr visual_draw_tail_from_ptr

        lda tail_frame
        and #$0f
        tax
        lda cube_frame_lo,x
        sta CUBE_PTR
        lda cube_frame_hi,x
        sta CUBE_PTR+1
        lda cube_glow_env
        cmp #$04
        bcs visual_tail1_hot
        lda #$2e
        sta vis_tail_char
        lda #$0b
        sta vis_tail_color
        jmp visual_tail1_draw
visual_tail1_hot:
        lda glam_phase
        and #$02
        beq visual_tail1_plus
        lda #$2a
        jmp visual_tail1_store_char
visual_tail1_plus:
        lda #$2b
visual_tail1_store_char:
        sta vis_tail_char
        lda #$01
        sta vis_tail_color
visual_tail1_draw:
        jsr visual_draw_tail_from_ptr
        rts

visual_draw_tail_from_ptr:
        ldy #0
visual_tail_loop:
        lda (CUBE_PTR),y
        cmp #$ff
        beq visual_tail_done
        sta plot_x
        iny
        lda (CUBE_PTR),y
        sta plot_y
        iny
        sty cube_y_save
        jsr visual_plot_tail
        ldy cube_y_save
        jmp visual_tail_loop
visual_tail_done:
        rts

visual_plot_tail:
        ; V6.0: tail/decay points use the same safe viewport as main plot.
        lda plot_x
        cmp #35
        bcs visual_plot_tail_skip
        lda plot_y
        cmp #24
        bcs visual_plot_tail_skip
        tax
        lda mul40_lo,x
        adc plot_x
        sta VISUAL_PTR
        lda mul40_hi,x
        adc #>SCREEN_RAM
        sta VISUAL_PTR+1
        ldy #0
        lda vis_tail_char
        sta (VISUAL_PTR),y
        lda VISUAL_PTR+1
        clc
        adc #SCREEN_TO_COLOR_HI_DELTA
        sta VISUAL_PTR+1
        lda vis_tail_color
        sta (VISUAL_PTR),y
visual_plot_tail_skip:
        rts

visual_draw_cube_shadow:
        lda vis_frame
        clc
        adc #2
        and #$0f
        tax
        lda cube_frame_lo,x
        sta CUBE_PTR
        lda cube_frame_hi,x
        sta CUBE_PTR+1
        ldy #0
visual_shadow_loop:
        lda (CUBE_PTR),y
        cmp #$ff
        beq visual_shadow_done
        clc
        adc #1
        sta plot_x
        iny
        lda (CUBE_PTR),y
        clc
        adc #1
        sta plot_y
        iny
        sty cube_y_save
        jsr visual_plot_shadow
        ldy cube_y_save
        jmp visual_shadow_loop
visual_shadow_done:
        rts

visual_plot_shadow:
        ; V6.0: shadow follows safe viewport too; no shifted cube dot
        ; may touch columns 35..39 or invalid bottom row.
        lda plot_x
        cmp #35
        bcs visual_plot_shadow_skip
        lda plot_y
        cmp #24
        bcs visual_plot_shadow_skip
        tax
        lda mul40_lo,x      ; V2.9 duplicate-load cleanup
        adc plot_x
        sta VISUAL_PTR
        lda mul40_hi,x
        adc #>SCREEN_RAM
        sta VISUAL_PTR+1
        ldy #0
        lda #$2e
        sta (VISUAL_PTR),y
        lda VISUAL_PTR+1
        clc
        adc #SCREEN_TO_COLOR_HI_DELTA
        sta VISUAL_PTR+1
        lda #$0b
        sta (VISUAL_PTR),y
visual_plot_shadow_skip:
        rts

visual_draw_starfield:
        inc star_phase
        lda star_phase
        and #$07
        sta star_color_index         ; V7.9: imported uploaded fix: one cached colour-cycle index per frame
        ; V4.0: colour-spark starfield.  Choose once per visual frame, then
        ; reuse star_color_cache in the hot star loop.
        lda song_flags
        and #$01
        beq visual_star_color_normal
        ldx star_color_index
        lda star_chorus_color_cycle,x
        jmp visual_star_color_store
visual_star_color_normal:
        ldx star_color_index
        lda star_normal_color_cycle,x
visual_star_color_store:
        sta star_color_cache
        ldx #0
visual_star_loop:
        ; V3.9 ROI: rows are fixed, so use precomputed screen row pointers
        ; instead of star_rows -> TAY -> mul40_lo/hi every star.
        lda star_screen_lo,x
        sta VISUAL_PTR
        lda star_screen_hi,x
        sta VISUAL_PTR+1
        lda star_cols,x
        clc
        adc star_phase
        and #$1f
        tay
        lda star_chars,x
        sta (VISUAL_PTR),y
        lda VISUAL_PTR+1
        clc
        adc #SCREEN_TO_COLOR_HI_DELTA
        sta VISUAL_PTR+1
        lda star_color_cache
        sta (VISUAL_PTR),y
        inx
        cpx #16
        bne visual_star_loop
        rts

star_screen_lo:
        !byte <(SCREEN_RAM+120),<(SCREEN_RAM+160),<(SCREEN_RAM+200),<(SCREEN_RAM+240)
        !byte <(SCREEN_RAM+280),<(SCREEN_RAM+320),<(SCREEN_RAM+400),<(SCREEN_RAM+440)
        !byte <(SCREEN_RAM+480),<(SCREEN_RAM+560),<(SCREEN_RAM+600),<(SCREEN_RAM+640)
        !byte <(SCREEN_RAM+720),<(SCREEN_RAM+760),<(SCREEN_RAM+800),<(SCREEN_RAM+840)
star_screen_hi:
        !byte >(SCREEN_RAM+120),>(SCREEN_RAM+160),>(SCREEN_RAM+200),>(SCREEN_RAM+240)
        !byte >(SCREEN_RAM+280),>(SCREEN_RAM+320),>(SCREEN_RAM+400),>(SCREEN_RAM+440)
        !byte >(SCREEN_RAM+480),>(SCREEN_RAM+560),>(SCREEN_RAM+600),>(SCREEN_RAM+640)
        !byte >(SCREEN_RAM+720),>(SCREEN_RAM+760),>(SCREEN_RAM+800),>(SCREEN_RAM+840)
star_cols:
        !byte 1,7,14,22,30,5,27,3,33,9,18,25,2,12,29,34 ; V6.1: no star in risky col35+
star_chars:
        !byte $2e,$20,$2a,$20,$2e,$2b,$20,$2e,$20,$2a,$20,$2e,$2b,$20,$2e,$2a

visual_draw_cube:
        lda vis_frame
        and #$0f
        tax
        lda cube_scale_env
        cmp #$04
        bcc visual_frame_normal
        txa
        clc
        adc #16
        tax
visual_frame_normal:
        lda cube_frame_lo,x
        sta CUBE_PTR
        lda cube_frame_hi,x
        sta CUBE_PTR+1
        ldy #0
visual_draw_loop:
        lda (CUBE_PTR),y
        cmp #$ff
        beq visual_draw_done
        sta plot_x
        iny
        lda (CUBE_PTR),y
        sta plot_y
        iny
        sty cube_y_save
        jsr visual_plot
        ldy cube_y_save
        jmp visual_draw_loop
visual_draw_done:
        rts

visual_plot:
        ; V6.0 true viewport lock: main cube writes are now also
        ; clamped away from columns 35..39 before pointer math.
        ; V5.9 scrub still seals the edge after drawing, but this
        ; prevents live-frame writes from ever touching the risky band.
        lda plot_x
        cmp #35
        bcs visual_plot_skip
        lda plot_y
        cmp #24
        bcs visual_plot_skip
        tax
        lda mul40_lo,x
        adc plot_x
        sta VISUAL_PTR
        lda mul40_hi,x
        adc #>SCREEN_RAM
        sta VISUAL_PTR+1
        ldy #0
        lda vis_char
        sta (VISUAL_PTR),y
        lda VISUAL_PTR+1
        clc
        adc #SCREEN_TO_COLOR_HI_DELTA
        sta VISUAL_PTR+1
        lda plot_y
        cmp #10
        bcs visual_plot_not_high
        lda #$01
        jmp visual_plot_store_color
visual_plot_not_high:
        cmp #16
        bcs visual_plot_low_depth
        lda vis_color
        jmp visual_plot_store_color
visual_plot_low_depth:
        lda depth_low_color     ; V2.8 cached low-depth color
visual_plot_store_color:
        sta (VISUAL_PTR),y
        ; V3.8 ROI: beat-scale extras are inactive most frames.  Gate the JSR
        ; here instead of paying JSR+RTS+lda/cmp/rts inside every cube point.
        lda cube_scale_env
        cmp #$06
        bcs visual_plot_beat_scale_active
        rts
visual_plot_beat_scale_active:
        jsr visual_plot_beat_scale
        rts
visual_plot_skip:
        rts

visual_plot_beat_scale:
        ; V3.8: caller has already verified cube_scale_env >= 6.
visual_scale_extra_right:
        lda plot_x
        ; V6.0: x+1 expansion must also stay inside safe viewport.
        ; plot_x >=34 would write into columns 35..39 after INC ptr.
        cmp #34
        bcs visual_scale_extra_down_check
        ldx plot_y
        lda mul40_lo,x
        clc
        adc plot_x
        sta VISUAL_PTR
        lda mul40_hi,x
        adc #>SCREEN_RAM
        sta VISUAL_PTR+1
        inc VISUAL_PTR
        bne visual_scale_extra_screen_ptr_ok
        inc VISUAL_PTR+1
visual_scale_extra_screen_ptr_ok:
        ldy #0
        lda #$2b
        sta (VISUAL_PTR),y
        lda VISUAL_PTR+1
        clc
        adc #SCREEN_TO_COLOR_HI_DELTA
        sta VISUAL_PTR+1
        lda #$01
        sta (VISUAL_PTR),y
visual_scale_extra_down_check:
        lda cube_scale_env
        cmp #$10
        bcs visual_scale_extra_down
        rts
visual_scale_extra_down:
        lda plot_y
        cmp #23
        bcs visual_scale_extra_done
        tax
        inx
        lda mul40_lo,x
        clc
        adc plot_x
        sta VISUAL_PTR
        lda mul40_hi,x
        adc #>SCREEN_RAM
        sta VISUAL_PTR+1
        ldy #0
        lda #$2e
        sta (VISUAL_PTR),y
        lda VISUAL_PTR+1
        clc
        adc #SCREEN_TO_COLOR_HI_DELTA
        sta VISUAL_PTR+1
        lda scale_down_color    ; V2.8 cached scale-down color
visual_scale_extra_store_color:
        sta (VISUAL_PTR),y
visual_scale_extra_done:
        rts


; ---------------------------------------------------------------------
; V4.0_DETAILCOLOUR_FX tables/routines
; Extra cube detail is deliberately separate from cube_frame tables: it keeps
; the audited main cube data stable, draws only 10 points/frame, and overlays
; after the main edges so the ribs/glints are visible.
; ---------------------------------------------------------------------
cube_color_cycle:
        !byte $0e,$03,$0d,$01,$0f,$06,$0c,$0b ; V4.1 8-step blue/cyan/green/silver sweep
cube_chorus_color_cycle:
        !byte $07,$01,$0a,$0e,$03,$0d,$0f,$08 ; chorus: yellow/white/red/blue/cyan/green
cube_final_color_cycle:
        !byte $01,$07,$03,$0a,$0e,$0d,$08,$0f ; final: white-hot rainbow strobe
cube_build_color_cycle:
        !byte $0e,$06,$03,$0d,$0f,$01,$0b,$0c ; build: blue/green/cyan/silver lift
cube_kick_color_cycle:
        !byte $0a,$07,$01,$08,$02,$0f,$0e,$03 ; kick: hot red/yellow/white/orange plus cold snap
star_normal_color_cycle:
        !byte $0c,$0f,$0e,$0b,$03,$06,$01,$00 ; grey/silver/blue/dark/cyan fade
star_chorus_color_cycle:
        !byte $07,$01,$03,$0a,$0e,$0d,$08,$0f ; chorus sparks, 8-step
detail_color_cycle:
        !byte $03,$0e,$01,$0d,$0f,$06,$07,$0c ; cyan/blue/white/green/yellow ribs
detail_hot_color_cycle:
        !byte $07,$01,$0a,$08,$03,$0e,$0d,$0f ; yellow/white/red/orange/cyan hot glints
depth_dot_color_cycle:
        !byte $0b,$0c,$0f,$00,$06,$0b,$0c,$0f ; dark far-corner shimmer
cast_shadow_color_cycle:
        !byte $00,$0b,$00,$0c,$0b,$00,$0c,$0f ; V4.2 floor shadow breathes with star/beat phase
floor_grid_color_cycle:
        !byte $00,$0b,$0c,$00,$0b,$0f,$0c,$00 ; V4.2/4.3 floor grid shadow shimmer
accent_color_cycle:
        !byte $01,$03,$07,$0a,$0e,$0d,$08,$0f ; moving seam accents
zslice_color_cycle:
        !byte $0b,$00,$0c,$0b,$00,$0f,$0b,$0c ; V4.3 rear z-slice silhouette
lens_glint_color_cycle:
        !byte $01,$07,$03,$0e,$0d,$0f,$08,$0a ; V4.3 hot specular front glints
depth_fog_color_cycle:
        !byte $0b,$00,$0c,$0b,$00,$0c,$0f,$00 ; V4.4 rear fog/atmospheric occlusion
holo_tunnel_color_cycle:
        !byte $00,$0b,$0c,$0b,$00,$0f,$0c,$00 ; V4.5 rear vanishing tunnel rings
light_flash_color_cycle:
        !byte $01,$07,$0a,$08,$03,$0e,$0f,$0d ; V4.7 bright kick/glow burst whites/yellows/cyan
scanline_flare_color_cycle:
        !byte $03,$0e,$01,$07,$0f,$0d,$08,$0a ; V4.7 horizontal CRT flare sweep
rim_flash_color_cycle:
        !byte $01,$07,$03,$0e,$0d,$0f,$0a,$08 ; V4.7 front rim sparkle/highlight
sync_strobe_color_cycle:
        !byte $01,$0f,$07,$01,$0e,$0a,$01,$03 ; V5.1 tiny transient snap whites/yellows/cyan
crystal_snap_color_cycle:
        !byte $01,$03,$0e,$0f,$01,$07,$0d,$0a ; V5.4 peak/pre-only crystal edge caustic, no tail-follow
apex_flash_color_cycle:
        !byte $01,$01,$0f,$07,$01,$0e,$0f,$03 ; V5.5 tiny final peak/pre apex flash, never envelope-tail driven
neon_focus_color_cycle:
        !byte $03,$01,$0e,$0f,$01,$07,$0d,$0a ; V5.6 center-focus neon pulse, peak/pre-only and no tail-follow
safe_wide_rim_color_cycle:
        !byte $0b,$0c,$0f,$03,$0e,$01,$07,$0a ; V6.2 safe inward width/rim colour, x<=34 only
inner_depth_weave_color_cycle:
        !byte $0c,$0b,$0f,$03,$0e,$06,$01,$07 ; V6.4 phase-locked inner depth weave, safe x<=33 only
perspective_orbit_color_cycle:
        !byte $06,$0e,$03,$0d,$01,$0d,$03,$0e ; V6.4 smooth 3D orbit/depth anchors
kinematic_rail_color_cycle:
        !byte $0b,$06,$0e,$03,$01,$03,$0e,$06 ; V6.5 coherent vanishing-rail motion, phase locked to cube
phase_hinge_color_cycle:
        !byte $0c,$0b,$06,$0e,$03,$01,$03,$0e ; V6.6 front/back phase-hinge cue, locked to vis_frame
motion_spline_color_cycle:
        !byte $0b,$0c,$06,$0e,$03,$01,$03,$0e ; V6.7 interpolated motion-spline cue, phase locked to cube

depth_normal_color_cycle:
        !byte $0f,$07,$0a,$08,$02,$09,$02,$08 ; V6.8 face-normal cue, phase-correct and tail-free
depth_inertia_color_cycle:
        !byte $0b,$0c,$0f,$06,$0e,$03,$01,$07 ; V6.9 coherent depth-inertia cue, lead/trail not random
eased_vector_color_cycle = depth_inertia_color_cycle    ; V8.1_OPT: identical table
temporal_coherence_color_cycle = depth_inertia_color_cycle ; V8.1_OPT: identical table
motion_convergence_color_cycle = depth_inertia_color_cycle ; V8.1_OPT: identical table
centroid_lock_color_cycle:
        !byte $0c,$0f,$06,$0e,$03,$01,$03,$0e ; V7.0 centre-axis lock cue, coherent centre-of-mass motion
coherent_body_color_cycle:
        !byte $0c,$0b,$06,$0e,$03,$01,$03,$0e ; V7.2 coherent rigid-body cue, centre-weighted motion
phase_fused_body_color_cycle = coherent_body_color_cycle ; V8.1_OPT: identical table
orbital_stability_color_cycle:
        !byte $06,$0b,$0c,$0f,$0c,$0b,$06,$0e ; V7.6 low-noise orbital body stabilizer
body_projection_lock_color_cycle:
        !byte $0b,$06,$0c,$0f,$0c,$06,$0b,$0e ; V7.7 body-projection lock, stable projected axis cue
camera_spline_lock_color_cycle:
        !byte $0c,$0f,$06,$0e,$06,$0f,$0c,$0b ; V8.0 final camera/body spline cue, cached-index colour only
camera_inertia_lock_color_cycle:
        !byte $0b,$0c,$0f,$06,$0e,$06,$0f,$0c ; V8.1 damped camera-inertia cue, cached-index colour only



visual_draw_cube_cast_shadow:
        ; V4.2: small precomputed projected floor shadow.  This draws between
        ; the old soft offset shadow and the main cube, so it reads as depth
        ; without overwriting the bright front edges.
        lda vis_frame
        and #$0f
        tax
        lda cast_shadow_frame_lo,x
        sta CUBE_PTR
        lda cast_shadow_frame_hi,x
        sta CUBE_PTR+1
        lda #$2e
        sta vis_tail_char
        ldx star_color_index
        lda cast_shadow_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start

visual_draw_cube_floor_grid:
        ; V4.3: another very cheap projected layer.  The grid points sit low
        ; and drift opposite the cube frame, so the shadow reads as perspective
        ; instead of just an offset duplicate.
        lda vis_frame
        clc
        adc #4
        and #$0f
        tax
        lda floor_grid_frame_lo,x
        sta CUBE_PTR
        lda floor_grid_frame_hi,x
        sta CUBE_PTR+1
        lda #$2e
        sta vis_tail_char
        ldx star_color_index
        lda floor_grid_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start

visual_draw_cube_zslice:
        ; V4.3: dim rear interior/silhouette slice.  This is drawn after the
        ; main cube but deliberately uses dark colours, creating an occluded
        ; inside plane instead of flattening the bright front edges.
        lda vis_frame
        clc
        adc #12
        and #$0f
        tax
        lda zslice_frame_lo,x
        sta CUBE_PTR
        lda zslice_frame_hi,x
        sta CUBE_PTR+1
        lda #$2e
        sta vis_tail_char
        lda star_phase
        lsr
        and #$07
        tax
        lda zslice_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start

visual_draw_cube_lens_glints:
        ; V4.3: gated specular/glass glints on energetic moments only.  Static
        ; frames stay clean; kick/lead/bass/pshhh frames get extra front depth.
        ; V8.1_OPT: pre-gated by visual_gate_energy in visual_update.
        lda vis_frame
        clc
        adc star_phase
        adc visual_pre_sync      ; V4.9: tiny ahead-of-beat phase bias, one frame only
        and #$0f
        tax
        lda lens_glint_frame_lo,x
        sta CUBE_PTR
        lda lens_glint_frame_hi,x
        sta CUBE_PTR+1
        lda #$a0
        sta vis_tail_char
        ldx star_color_index
        lda lens_glint_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start

visual_draw_cube_depth_fog:
        ; V4.4: atmospheric rear fog/occlusion.  Sparse dim points sit around
        ; the rear slice and hide hard back edges, increasing fake depth without
        ; expensive line filling or per-pixel maths.
        lda vis_frame
        clc
        adc #10
        and #$0f
        tax
        lda depth_fog_frame_lo,x
        sta CUBE_PTR
        lda depth_fog_frame_hi,x
        sta CUBE_PTR+1
        lda #$2e
        sta vis_tail_char
        lda star_phase
        lsr
        and #$07
        tax
        lda depth_fog_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start

visual_draw_cube_tunnel_rings:
        ; V4.5: dim rear tunnel rings around the cube centre.  This gives the
        ; wire cube a vanishing point/room behind it without touching the main
        ; cube tables or adding line-draw cost.
        lda cube_glow_env
        ora bass_tail
        ora lead_tail
        bne visual_tunnel_rings_active
        rts
visual_tunnel_rings_active:
        lda vis_frame
        clc
        adc #6
        and #$0f
        tax
        lda holo_tunnel_frame_lo,x
        sta CUBE_PTR
        lda holo_tunnel_frame_hi,x
        sta CUBE_PTR+1
        lda #$2e
        sta vis_tail_char
        lda star_phase
        lsr
        and #$07
        tax
        lda holo_tunnel_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start

visual_draw_cube_light_flash:
        ; V5.2: foreground flash is peak/pre-only.  Do not OR in visual_kick_sync,
        ; because that pulse can have a harmless carry frame for scale breathing;
        ; bright flash must not appear late.  Real beat uses visual_light_gate,
        ; pre-beat uses visual_pre_sync, and only very hot glow may fallback.
        lda visual_gate_flash
        bne visual_light_flash_active
        lda cube_glow_env       ; fallback only on very hot glow peak, not on decayed tail
        cmp #$14
        bcs visual_light_flash_active
        rts
visual_light_flash_active:
        lda vis_frame
        clc
        adc star_phase
        adc visual_phase_lead   ; V5.0: table phase lead makes the flash visually land earlier
        adc visual_pre_sync      ; V4.9: pre-armed flash phase is one frame only
        and #$0f
        tax
        lda light_flash_frame_lo,x
        sta CUBE_PTR
        lda light_flash_frame_hi,x
        sta CUBE_PTR+1
        lda #$a0
        sta vis_tail_char
        ldx star_color_index
        lda light_flash_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start

visual_draw_cube_scanline_flare:
        ; V5.2: scanline flare is real-lead peak or one-frame preflash only.
        ; visual_phase_lead can shift a current frame, but it no longer opens
        ; the gate by itself on the carry-over frame.
        lda visual_pre_sync
        bne visual_scanline_flare_active
        lda visual_lead_sync
        cmp #$04
        bcs visual_scanline_flare_active
        lda pshhh_env          ; noise flare only when noise burst is still strong
        cmp #$0c
        bcs visual_scanline_flare_active
        rts
visual_scanline_flare_active:
        lda vis_frame
        clc
        adc #3              ; V5.0: stronger phase lead; avoids perceived late scanline smear
        adc visual_phase_lead
        adc visual_lead_sync
        and #$0f
        tax
        lda scanline_flare_frame_lo,x
        sta CUBE_PTR
        lda scanline_flare_frame_hi,x
        sta CUBE_PTR+1
        lda #$2d
        sta vis_tail_char
        ldx star_color_index
        lda scanline_flare_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start

visual_draw_cube_rim_flash:
        ; V5.2: rim flash is strictly pre/peak gated.  It may draw on the
        ; preframe or on the true hit frame, but not on decayed carry frames.
        lda visual_gate_flash
        bne visual_rim_flash_active
        lda visual_kick_sync
        cmp #$05
        bcs visual_rim_flash_active
        lda visual_lead_sync
        cmp #$04
        bcs visual_rim_flash_active
        rts
visual_rim_flash_active:
        lda vis_frame
        clc
        adc #11             ; V5.0: phase-leading front-rim frame
        adc visual_phase_lead
        adc visual_kick_sync
        and #$0f
        tax
        lda rim_flash_frame_lo,x
        sta CUBE_PTR
        lda rim_flash_frame_hi,x
        sta CUBE_PTR+1
        lda #$2a
        sta vis_tail_char
        ldx star_color_index
        lda rim_flash_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start

visual_draw_cube_sync_strobe:
        ; V5.2: ultra-small snap marker is pre/peak only.  It deliberately
        ; ignores the lower carry values left after decay, so there is no
        ; second-frame late sparkle after the beat.
        lda visual_gate_flash
        bne visual_sync_strobe_active
        lda visual_kick_sync
        cmp #$05
        bcs visual_sync_strobe_active
        lda visual_lead_sync
        cmp #$04
        bcs visual_sync_strobe_active
        rts
visual_sync_strobe_active:
        lda vis_frame
        clc
        adc visual_phase_lead
        adc #5
        and #$0f
        tax
        lda sync_strobe_frame_lo,x
        sta CUBE_PTR
        lda sync_strobe_frame_hi,x
        sta CUBE_PTR+1
        lda #$2e
        sta vis_tail_char
        ldx star_color_index
        lda sync_strobe_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start

visual_draw_cube_crystal_snap:
        ; V5.4: final snap polish.  Very sparse edge caustics, drawn after
        ; prism halo, but only on one-frame pre-sync or real peak/light-gate.
        ; It never follows envelope tails, so it adds depth without lag smear.
        lda visual_gate_flash
        bne visual_crystal_snap_active
        lda visual_kick_sync
        cmp #$06
        bcs visual_crystal_snap_active
        lda visual_lead_sync
        cmp #$05
        bcs visual_crystal_snap_active
        rts
visual_crystal_snap_active:
        lda vis_frame
        clc
        adc visual_phase_lead
        adc #5
        and #$0f
        tax
        lda crystal_snap_frame_lo,x
        sta CUBE_PTR
        lda crystal_snap_frame_hi,x
        sta CUBE_PTR+1
        lda #$2a
        sta vis_tail_char
        lda star_phase
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        and #$07
        tax
        lda crystal_snap_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start


visual_draw_cube_apex_flash:
        ; V5.5: final perfect closure flash.  This is intentionally tiny:
        ; four apex/corner pixels only, after crystal snap.  It uses the same
        ; peak/pre locks as V5.2+ and refuses low carry values, so it gives a
        ; crisp final light hit without adding lag, smear, or heavy overdraw.
        lda visual_gate_flash
        bne visual_apex_flash_active
        lda visual_kick_sync
        cmp #$06
        bcs visual_apex_flash_active
        lda visual_lead_sync
        cmp #$05
        bcs visual_apex_flash_active
        rts
visual_apex_flash_active:
        lda vis_frame
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        adc #9
        and #$0f
        tax
        lda apex_flash_frame_lo,x
        sta CUBE_PTR
        lda apex_flash_frame_hi,x
        sta CUBE_PTR+1
        lda #$51
        sta vis_tail_char
        lda star_phase
        clc
        adc visual_phase_lead
        and #$07
        tax
        lda apex_flash_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start


visual_draw_cube_neon_focus:
        ; V5.6: tiny center-focus pulse.  This draws after apex flash but only
        ; on true peak/pre frames, giving the cube a sharper optical focus
        ; without following SID tails or reviving the failed V4.6 layer order.
        lda visual_gate_flash
        bne visual_neon_focus_active
        lda visual_kick_sync
        cmp #$06
        bcs visual_neon_focus_active
        lda visual_lead_sync
        cmp #$05
        bcs visual_neon_focus_active
        rts
visual_neon_focus_active:
        lda vis_frame
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        adc #11
        and #$0f
        tax
        lda neon_focus_frame_lo,x
        sta CUBE_PTR
        lda neon_focus_frame_hi,x
        sta CUBE_PTR+1
        lda #$2b
        sta vis_tail_char
        lda star_phase
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        and #$07
        tax
        lda neon_focus_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start


visual_draw_cube_safe_wide_rim:
        ; V6.2: after the x>=35 viewport lock, the cube can feel too narrow.
        ; This restores perceived width by drawing a tiny INNER right/left rim
        ; at x<=34 only, so V5.9/V6.1 edge scrubs still have a clean moat.
        ; It is peak/pre or strong chorus/bass gated, never tail-only.
        lda visual_gate_flash
        bne visual_safe_wide_active
        lda visual_kick_sync
        cmp #$06
        bcs visual_safe_wide_active
        lda visual_lead_sync
        cmp #$05
        bcs visual_safe_wide_active
        lda bass_tail
        cmp #$07
        bcs visual_safe_wide_active
        lda song_flags
        and #$01
        bne visual_safe_wide_active
        rts
visual_safe_wide_active:
        lda vis_frame
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        adc #13
        and #$0f
        tax
        lda safe_wide_rim_frame_lo,x
        sta CUBE_PTR
        lda safe_wide_rim_frame_hi,x
        sta CUBE_PTR+1
        lda #$2b
        sta vis_tail_char
        lda star_phase
        clc
        adc visual_phase_lead
        and #$07
        tax
        lda safe_wide_rim_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start


visual_draw_cube_inner_depth_weave:
        ; V6.4: phase-correct controlled inner parallax weave.  V6.3 used
        ; star_phase in frame selection, which could look like independent
        ; jitter instead of true cube motion.  This is now locked to vis_frame
        ; (+ one-frame visual lead only), so weave motion follows cube rotation.
        lda visual_pre_sync
        ora visual_light_gate
        bne visual_inner_weave_active
        lda visual_lead_sync
        cmp #$05
        bcs visual_inner_weave_active
        lda visual_kick_sync
        cmp #$07
        bcs visual_inner_weave_active
        lda song_flags
        and #$01
        bne visual_inner_weave_active
        rts
visual_inner_weave_active:
        lda vis_frame
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        and #$0f
        tax
        lda inner_depth_weave_frame_lo,x
        sta CUBE_PTR
        lda inner_depth_weave_frame_hi,x
        sta CUBE_PTR+1
        lda #$2e
        sta vis_tail_char
        lda star_phase
        clc
        adc visual_phase_lead
        adc #3
        and #$07
        tax
        lda inner_depth_weave_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start

visual_draw_cube_perspective_orbit:
        ; V6.4: phase-correct 3D illusion pass.  These orbit anchors move on
        ; a smooth 16-frame ellipse that follows cube vis_frame exactly.
        ; They deliberately avoid star_phase and audio-tail phase noise, so
        ; the motion reads as correct rotation instead of random sparkle.
        ; Coordinates are inside the V6.1 scrub moat: x<=34, y 6..19.
        lda visual_pre_sync
        ora visual_light_gate
        bne visual_perspective_orbit_active
        lda visual_lead_sync
        cmp #$04
        bcs visual_perspective_orbit_active
        lda visual_kick_sync
        cmp #$05
        bcs visual_perspective_orbit_active
        lda song_flags
        and #$01
        bne visual_perspective_orbit_active
        rts
visual_perspective_orbit_active:
        lda vis_frame
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        adc #8                ; opposite phase: reads as rear-to-front depth
        and #$0f
        tax
        lda perspective_orbit_frame_lo,x
        sta CUBE_PTR
        lda perspective_orbit_frame_hi,x
        sta CUBE_PTR+1
        lda #$5e              ; arrow-like chevron/caret = motion/depth cue
        sta vis_tail_char
        lda vis_frame
        lsr
        clc
        adc visual_phase_lead
        and #$07
        tax
        lda perspective_orbit_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start


visual_draw_cube_kinematic_depth_rails:
        ; V6.5: corrected 3D-motion cue.  The rail points are not random
        ; sparkles: they are a phase-locked vanishing-line structure.  Frame
        ; selection uses vis_frame + visual_phase_lead/pre only, while the
        ; coordinate tables contain the matching counter-motion anchors.
        ; This creates front/back parallax without touching the right scrub
        ; moat (all coordinates x<=33, y 6..19).
        lda visual_pre_sync
        ora visual_light_gate
        bne visual_kinematic_rails_active
        lda visual_lead_sync
        cmp #$04
        bcs visual_kinematic_rails_active
        lda visual_kick_sync
        cmp #$06
        bcs visual_kinematic_rails_active
        lda bass_tail
        cmp #$08
        bcs visual_kinematic_rails_active
        lda song_flags
        and #$01
        bne visual_kinematic_rails_active
        rts
visual_kinematic_rails_active:
        lda vis_frame
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        adc #4                ; quarter-phase: rails lead orbit, not random
        and #$0f
        tax
        lda kinematic_rail_frame_lo,x
        sta CUBE_PTR
        lda kinematic_rail_frame_hi,x
        sta CUBE_PTR+1
        lda #$2f              ; diagonal rail glyph for vanishing-line cue
        sta vis_tail_char
        lda vis_frame
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        and #$07
        tax
        lda kinematic_rail_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start


visual_draw_cube_phase_hinge_motion:
        ; V6.6: movement-correct depth hinge.  Unlike sparkle overlays, this
        ; is a paired front/back cue: frame tables put the front anchor on the
        ; apparent near side while the rear/counter anchors follow the inverse
        ; hinge phase.  Selection is vis_frame + visual lead/pre only; no
        ; star_phase or tail phase is allowed, so motion stays coherent.
        ; All coordinates are x<=33/y 7..18, safely inside the scrub moat.
        lda visual_pre_sync
        ora visual_light_gate
        bne visual_phase_hinge_active
        lda visual_lead_sync
        cmp #$04
        bcs visual_phase_hinge_active
        lda visual_kick_sync
        cmp #$05
        bcs visual_phase_hinge_active
        lda bass_tail
        cmp #$08
        bcs visual_phase_hinge_active
        lda song_flags
        and #$01
        bne visual_phase_hinge_active
        rts
visual_phase_hinge_active:
        lda vis_frame
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        adc #12               ; three-quarter phase: completes rail/orbit stack
        and #$0f
        tax
        lda phase_hinge_frame_lo,x
        sta CUBE_PTR
        lda phase_hinge_frame_hi,x
        sta CUBE_PTR+1
        lda #$5c              ; opposite diagonal, pairs with rail '/' glyph
        sta vis_tail_char
        lda vis_frame
        lsr
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        and #$07
        tax
        lda phase_hinge_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start


visual_draw_cube_motion_spline_depth:
        ; V6.7: smooth motion-spline depth cue.  This fills the perceptual
        ; gap between V6.4 orbit, V6.5 rails and V6.6 hinge anchors.  It is
        ; phase-locked to vis_frame + the one-frame visual lead/pre only, never
        ; star_phase or long SID tails.  The table is an interpolated S-curve
        ; inside x<=32, so movement feels coherent and cannot hit the scrub moat.
        lda visual_pre_sync
        ora visual_light_gate
        bne visual_motion_spline_active
        lda visual_lead_sync
        cmp #$03
        bcs visual_motion_spline_active
        lda visual_kick_sync
        cmp #$04
        bcs visual_motion_spline_active
        lda bass_tail
        cmp #$06
        bcs visual_motion_spline_active
        lda song_flags
        and #$01
        bne visual_motion_spline_active
        rts
visual_motion_spline_active:
        lda vis_frame
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        adc #2                ; spline sits between orbit and rail phase
        and #$0f
        tax
        lda motion_spline_frame_lo,x
        sta CUBE_PTR
        lda motion_spline_frame_hi,x
        sta CUBE_PTR+1
        lda #$2e              ; dim point cue: motion guide, not noisy sparkle
        sta vis_tail_char
        lda vis_frame
        clc
        adc visual_phase_lead
        adc #1
        and #$07
        tax
        lda motion_spline_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start

visual_draw_cube_depth_normal_motion:
        ; V6.8: phase-correct depth-normal vector anchors.  The points act
        ; like tiny face-normal markers: one front-facing cue and one rear
        ; counter-cue move in matched inverse phase so rotation reads as
        ; physically coherent 3D.  Locked to vis_frame + one-frame music
        ; lead/pre only; never star_phase and never long SID envelope tails.
        lda visual_pre_sync
        ora visual_light_gate
        bne visual_depth_normal_active
        lda visual_lead_sync
        cmp #$04
        bcs visual_depth_normal_active
        lda visual_kick_sync
        cmp #$05
        bcs visual_depth_normal_active
        lda song_flags
        and #$02
        bne visual_depth_normal_active
        rts
visual_depth_normal_active:
        lda vis_frame
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        adc #6                ; normal cues sit between rail and hinge phase
        and #$0f
        tax
        lda depth_normal_frame_lo,x
        sta CUBE_PTR
        lda depth_normal_frame_hi,x
        sta CUBE_PTR+1
        lda #$7e              ; short vector/normal glyph
        sta vis_tail_char
        lda vis_frame
        lsr
        clc
        adc visual_phase_lead
        adc #2
        and #$07
        tax
        lda depth_normal_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start

visual_draw_cube_depth_inertia_motion:
        ; V6.9: phase-correct depth-inertia lead/trail anchors.  These are
        ; deliberately sparse and coherent: a near/front cue leads the normal
        ; motion, while a dim rear cue trails it.  This adds perceived mass and
        ; perfects the 3D rotation illusion without star_phase shimmer or SID
        ; envelope-tail lag.  Safe x<=32 so right-edge scrub is never touched.
        lda visual_pre_sync
        ora visual_light_gate
        bne visual_depth_inertia_active
        lda visual_lead_sync
        cmp #$03
        bcs visual_depth_inertia_active
        lda visual_kick_sync
        cmp #$04
        bcs visual_depth_inertia_active
        lda song_flags
        and #$03
        bne visual_depth_inertia_active
        rts
visual_depth_inertia_active:
        lda vis_frame
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        adc #7                ; inertia sits halfway between normal and spline phase
        and #$0f
        tax
        lda depth_inertia_frame_lo,x
        sta CUBE_PTR
        lda depth_inertia_frame_hi,x
        sta CUBE_PTR+1
        lda #$2e              ; dim dot/anchor cue, avoids noisy glyph shimmer
        sta vis_tail_char
        lda vis_frame
        clc
        adc visual_phase_lead
        adc #3
        and #$07
        tax
        lda depth_inertia_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start


visual_draw_cube_centroid_motion_lock:
        ; V7.0: phase-correct centroid/axis-lock anchors.  These sparse
        ; points trace the perceived cube centre-of-mass plus a short front/back
        ; axis pair, tying orbit/rail/hinge/spline/normal/inertia cues together.
        ; Locked to vis_frame with one-frame music lead/pre only; no star_phase
        ; and no SID-tail lag.  Safe x<=31/y 9..16 so edge scrub is untouched.
        lda visual_pre_sync
        ora visual_light_gate
        bne visual_centroid_lock_active
        lda visual_lead_sync
        cmp #$03
        bcs visual_centroid_lock_active
        lda visual_kick_sync
        cmp #$04
        bcs visual_centroid_lock_active
        lda song_flags
        and #$03
        bne visual_centroid_lock_active
        rts
visual_centroid_lock_active:
        lda vis_frame
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        adc #4                ; centre-axis sits between orbit and normal phase
        and #$0f
        tax
        lda centroid_lock_frame_lo,x
        sta CUBE_PTR
        lda centroid_lock_frame_hi,x
        sta CUBE_PTR+1
        lda #$2b              ; small plus/axis cue: centre lock, not sparkle noise
        sta vis_tail_char
        lda vis_frame
        lsr
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        and #$07
        tax
        lda centroid_lock_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start

visual_draw_cube_eased_vector_motion:
        ; V7.1: phase-correct eased-vector anchors.  These points bridge the
        ; centroid/orbit/normal stack with a tiny eased lead/return path, so
        ; cube motion reads as a continuous 3D body rather than stepped dots.
        ; Locked to vis_frame plus one-frame pre/phase lead only; no star_phase
        ; and no SID-tail lag.  Safe x<=31/y 8..17.
        lda visual_pre_sync
        ora visual_light_gate
        bne visual_eased_vector_active
        lda visual_lead_sync
        cmp #$03
        bcs visual_eased_vector_active
        lda visual_kick_sync
        cmp #$04
        bcs visual_eased_vector_active
        lda song_flags
        and #$03
        bne visual_eased_vector_active
        rts
visual_eased_vector_active:
        lda vis_frame
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        adc #5                ; sits between centroid and inertia phase
        and #$0f
        tax
        lda eased_vector_frame_lo,x
        sta CUBE_PTR
        lda eased_vector_frame_hi,x
        sta CUBE_PTR+1
        lda #$2e              ; dim anchor: motion vector guide, not flash noise
        sta vis_tail_char
        lda vis_frame
        lsr
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        adc #1
        and #$07
        tax
        lda eased_vector_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start

visual_draw_cube_coherent_body_motion:
        ; V7.2: phase-correct coherent-body anchors.  These centre-weighted
        ; points are placed between centroid/eased/inertia/normal cues so the
        ; eye reads one rigid cube body rotating, not separate sparkles.
        ; Locked to vis_frame plus one-frame pre/phase lead only; no star_phase
        ; and no SID-tail lag.  Safe x<=30/y 9..16.
        lda visual_pre_sync
        ora visual_light_gate
        bne visual_coherent_body_active
        lda visual_lead_sync
        cmp #$03
        bcs visual_coherent_body_active
        lda visual_kick_sync
        cmp #$04
        bcs visual_coherent_body_active
        lda song_flags
        and #$07
        bne visual_coherent_body_active
        rts
visual_coherent_body_active:
        lda vis_frame
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        adc #7                ; sits between eased vector and centroid phase
        and #$0f
        tax
        lda coherent_body_frame_lo,x
        sta CUBE_PTR
        lda coherent_body_frame_hi,x
        sta CUBE_PTR+1
        lda #$2e              ; dim rigid-body guide, never a noisy flash
        sta vis_tail_char
        lda vis_frame
        lsr
        lsr
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        adc #2
        and #$07
        tax
        lda coherent_body_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start

visual_draw_cube_temporal_coherence_motion:
        ; V7.3: phase-correct temporal-coherence anchors.  These are tiny
        ; body-axis glue points between coherent/eased/centroid/inertia cues,
        ; designed to make motion feel continuous across frames.  Locked to
        ; vis_frame plus one-frame music lead/pre only; no star_phase and no
        ; SID-tail lag.  Safe x<=30/y 9..16.
        lda visual_pre_sync
        ora visual_light_gate
        ora song_flags
        bne visual_temporal_coherence_active
        lda cube_glow_env
        cmp #$08
        bcs visual_temporal_coherence_active
        lda bass_tail
        cmp #$05
        bcs visual_temporal_coherence_active
        lda visual_phase_lead
        bne visual_temporal_coherence_active
        rts
visual_temporal_coherence_active:
        lda vis_frame
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        adc #3
        and #$0f
        tax
        lda temporal_coherence_frame_lo,x
        sta CUBE_PTR
        lda temporal_coherence_frame_hi,x
        sta CUBE_PTR+1
        lda #$2a
        sta vis_tail_char
        lda vis_frame
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        adc #3
        and #$07
        tax
        lda temporal_coherence_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start


visual_draw_cube_phase_fused_body_motion:
        ; V7.4: phase-fused rigid-body anchors.  This is not another random
        ; sparkle layer: it draws two tiny centre-line pairs plus one
        ; counter-phase rear pair that are aligned between temporal coherence,
        ; coherent body, eased vector and centroid cues.  The cadence is locked
        ; to vis_frame with only one-frame music lead/pre, so front/back motion
        ; feels like one corrected 3D body.  No star_phase, no SID-tail lag,
        ; and all points stay x<=30/y 9..16.
        lda visual_pre_sync
        ora visual_light_gate
        bne visual_phase_fused_body_active
        lda visual_lead_sync
        cmp #$03
        bcs visual_phase_fused_body_active
        lda visual_kick_sync
        cmp #$04
        bcs visual_phase_fused_body_active
        lda song_flags
        and #$07
        bne visual_phase_fused_body_active
        rts
visual_phase_fused_body_active:
        lda vis_frame
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        adc #6                ; fused halfway between temporal and coherent body
        and #$0f
        tax
        lda phase_fused_body_frame_lo,x
        sta CUBE_PTR
        lda phase_fused_body_frame_hi,x
        sta CUBE_PTR+1
        lda #$2e              ; dim body-vector cue: readable motion, no flash noise
        sta vis_tail_char
        lda vis_frame
        lsr
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        adc #4
        and #$07
        tax
        lda phase_fused_body_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start

visual_draw_cube_motion_convergence_lock:
        ; V7.5: phase-correct motion-convergence anchors.  This is the final
        ; rigid-body "glue" layer after phase-fused motion: it draws damped
        ; centre/near/rear convergence pairs that sit between centroid, inertia,
        ; normals and phase-fused body cues.  It is locked to vis_frame, uses
        ; only one-frame music pre/phase lead, never star_phase, never SID tail
        ; decay, and stays in the inner viewport (x<=29/y 9..16).
        lda visual_pre_sync
        ora visual_light_gate
        bne visual_motion_convergence_active
        lda visual_lead_sync
        cmp #$03
        bcs visual_motion_convergence_active
        lda visual_kick_sync
        cmp #$04
        bcs visual_motion_convergence_active
        lda song_flags
        and #$07
        bne visual_motion_convergence_active
        rts
visual_motion_convergence_active:
        lda vis_frame
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        adc #8                ; centred between phase-fused/front and inertia/rear cues
        and #$0f
        tax
        lda motion_convergence_frame_lo,x
        sta CUBE_PTR
        lda motion_convergence_frame_hi,x
        sta CUBE_PTR+1
        lda #$2a              ; damped convergence vector, softer than strobe/glint layers
        sta vis_tail_char
        lda vis_frame
        lsr
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        adc #5
        and #$07
        tax
        lda motion_convergence_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start

visual_draw_cube_orbital_stability_body:
        ; V7.6: phase-correct orbital-stability body anchors.  This is a
        ; final low-noise stabilizer after motion convergence: two tiny eased
        ; diagonals and one counter-diagonal memory cue make the cube read as
        ; one solid object rather than stacked independent sparkles.  It is
        ; locked to vis_frame, uses only one-frame music pre/phase lead, never
        ; star_phase, never SID tail decay, and stays deep inside the viewport
        ; (x<=28/y 10..15).
        lda visual_pre_sync
        ora visual_light_gate
        bne visual_orbital_stability_active
        lda visual_lead_sync
        cmp #$03
        bcs visual_orbital_stability_active
        lda visual_kick_sync
        cmp #$04
        bcs visual_orbital_stability_active
        lda song_flags
        and #$07
        bne visual_orbital_stability_active
        rts
visual_orbital_stability_active:
        lda vis_frame
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        adc #10               ; lags convergence slightly for stable body inertia
        and #$0f
        tax
        lda orbital_stability_frame_lo,x
        sta CUBE_PTR
        lda orbital_stability_frame_hi,x
        sta CUBE_PTR+1
        lda #$5e              ; subtle diagonal/stability cue, not a bright strobe
        sta vis_tail_char
        lda vis_frame
        lsr
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        adc #6
        and #$07
        tax
        lda orbital_stability_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start

visual_draw_cube_body_projection_lock:
        ; V7.7: phase-correct body-projection lock anchors.  This is not a
        ; sparkle layer: it draws a tiny projected body axis / near-far chord
        ; that sits inside the existing orbit/centroid/convergence stack.  It
        ; gives the viewer a stable rigid-body reference, reduces perceived
        ; dot drift, stays locked to vis_frame, never uses star_phase, never
        ; follows SID envelope tails, and stays deep inside the viewport
        ; (x<=27/y 9..16).
        lda visual_pre_sync
        ora visual_light_gate
        bne visual_body_projection_lock_active
        lda visual_lead_sync
        cmp #$03
        bcs visual_body_projection_lock_active
        lda visual_kick_sync
        cmp #$04
        bcs visual_body_projection_lock_active
        lda song_flags
        and #$07
        bne visual_body_projection_lock_active
        rts
visual_body_projection_lock_active:
        lda vis_frame
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        adc #12               ; final counter-phase projection, after stability body
        and #$0f
        tax
        lda body_projection_lock_frame_lo,x
        sta CUBE_PTR
        lda body_projection_lock_frame_hi,x
        sta CUBE_PTR+1
        lda #$7e              ; small axis/chord cue, not a bright flash layer
        sta vis_tail_char
        lda vis_frame
        lsr
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        adc #7
        and #$07
        tax
        lda body_projection_lock_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start

visual_draw_cube_camera_spline_lock:
        ; V8.0: final phase-correct camera-spline body cue.  This is a
        ; low-noise centre/near/far stabilizer after body projection.  It
        ; moves only with vis_frame plus one-frame music lead/pre, never with
        ; star_phase and never with SID envelope tails.  All points are x<=26
        ; and y 9..16, so the V6.x/V5.9 edge-lock and black background remain
        ; untouched.
        lda visual_gate_flash
        bne visual_camera_spline_lock_active
        lda visual_lead_sync
        cmp #$03
        bcs visual_camera_spline_lock_active
        lda visual_kick_sync
        cmp #$04
        bcs visual_camera_spline_lock_active
        lda song_flags
        and #$07
        bne visual_camera_spline_lock_active
        rts
visual_camera_spline_lock_active:
        lda vis_frame
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        adc #14
        and #$0f
        tax
        lda camera_spline_lock_frame_lo,x
        sta CUBE_PTR
        lda camera_spline_lock_frame_hi,x
        sta CUBE_PTR+1
        lda #$5c              ; subtle diagonal/body-axis cue
        sta vis_tail_char
        ldx star_color_index
        lda camera_spline_lock_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start

visual_draw_cube_camera_inertia_lock:
        ; V8.1: damped camera-inertia body cue.  This is the final low-noise
        ; near/far phase stabilizer after V8.0 camera spline.  It deliberately
        ; draws fewer points than the big flash layers: a tiny near-axis hint,
        ; centre-body memory and counter-phase far cue.  It is locked to
        ; vis_frame plus one-frame music lead/pre only, never star_phase, never
        ; long SID envelope tails.  All points are x<=25/y 10..15, so black
        ; background lock and right-edge scrub cannot be touched.
        lda visual_gate_flash
        bne visual_camera_inertia_lock_active
        lda visual_lead_sync
        cmp #$04
        bcs visual_camera_inertia_lock_active
        lda visual_kick_sync
        cmp #$05
        bcs visual_camera_inertia_lock_active
        lda song_flags
        and #$07
        bne visual_camera_inertia_lock_active
        rts
visual_camera_inertia_lock_active:
        lda vis_frame
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        adc #1                ; small phase lead after camera spline: damped, not random
        and #$0f
        tax
        lda camera_inertia_lock_frame_lo,x
        sta CUBE_PTR
        lda camera_inertia_lock_frame_hi,x
        sta CUBE_PTR+1
        lda #$2e              ; tiny centre/axis cue, subdued under black background
        sta vis_tail_char
        ldx star_color_index
        lda camera_inertia_lock_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start

visual_draw_cube_depth_dots:
        lda vis_frame
        and #$0f
        tax
        lda depth_dot_frame_lo,x
        sta CUBE_PTR
        lda depth_dot_frame_hi,x
        sta CUBE_PTR+1
        lda #$2e
        sta vis_tail_char
        ldx star_color_index
        lda depth_dot_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start

visual_draw_cube_accents:
        ; V4.1: only draw the moving seam accents when voices/noise still
        ; have energy.  This keeps static frames lean, but makes bass/lead/pshhh
        ; rows feel alive and gives the cube a stronger rotation cue.
        ; V8.1_OPT: pre-gated by visual_gate_energy in visual_update.
        lda vis_frame
        clc
        adc visual_phase_lead
        adc visual_pre_sync
        and #$0f
        tax
        lda accent_frame_lo,x
        sta CUBE_PTR
        lda accent_frame_hi,x
        sta CUBE_PTR+1
        lda pshhh_env
        beq visual_cube_accent_no_pshhh
        lda #$2e
        jmp visual_cube_accent_store_char
visual_cube_accent_no_pshhh:
        lda cube_glow_env
        beq visual_cube_accent_plus
        lda #$a0
        jmp visual_cube_accent_store_char
visual_cube_accent_plus:
        lda #$2b
visual_cube_accent_store_char:
        sta vis_tail_char
        ldx star_color_index
        lda accent_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start

visual_draw_cube_details:
        lda vis_frame
        and #$0f
        tax
        lda detail_frame_lo,x
        sta CUBE_PTR
        lda detail_frame_hi,x
        sta CUBE_PTR+1
        lda cube_glow_env
        beq visual_detail_normal_style
        lda #$a0
        sta vis_tail_char
        ldx star_color_index
        lda detail_hot_color_cycle,x
        sta vis_tail_color
        jmp visual_detail_loop_start
visual_detail_normal_style:
        lda #$2b
        sta vis_tail_char
        ldx star_color_index
        lda detail_color_cycle,x
        sta vis_tail_color
visual_detail_loop_start:
        ldy #0
visual_detail_loop:
        lda (CUBE_PTR),y
        cmp #$ff
        beq visual_detail_done
        sta plot_x
        iny
        lda (CUBE_PTR),y
        sta plot_y
        iny
        sty cube_y_save
        jsr visual_plot_detail
        ldy cube_y_save
        jmp visual_detail_loop
visual_detail_done:
        rts

visual_plot_detail:
        ; V5.8 hard right-edge guard: transient/detail FX never write into
        ; columns 35..39.  These columns are legal text cells, but bright
        ; strobe/flare points there looked like right-edge wrap/bleed on
        ; real VIC/CRT and some emulators.  Main cube is still allowed wider.
        lda plot_x
        cmp #35
        bcs visual_plot_detail_skip
        lda plot_y
        cmp #24
        bcs visual_plot_detail_skip
        tax
        lda mul40_lo,x
        adc plot_x
        sta VISUAL_PTR
        lda mul40_hi,x
        adc #>SCREEN_RAM
        sta VISUAL_PTR+1
        ldy #0
        lda vis_tail_char
        sta (VISUAL_PTR),y
        lda VISUAL_PTR+1
        clc
        adc #SCREEN_TO_COLOR_HI_DELTA
        sta VISUAL_PTR+1
        lda vis_tail_color
        sta (VISUAL_PTR),y
visual_plot_detail_skip:
        rts




crystal_snap_frame_lo:
        !byte <crystal_snap_fr00,<crystal_snap_fr01,<crystal_snap_fr02,<crystal_snap_fr03,<crystal_snap_fr04,<crystal_snap_fr05,<crystal_snap_fr06,<crystal_snap_fr07
        !byte <crystal_snap_fr08,<crystal_snap_fr09,<crystal_snap_fr10,<crystal_snap_fr11,<crystal_snap_fr12,<crystal_snap_fr13,<crystal_snap_fr14,<crystal_snap_fr15
crystal_snap_frame_hi:
        !byte >crystal_snap_fr00,>crystal_snap_fr01,>crystal_snap_fr02,>crystal_snap_fr03,>crystal_snap_fr04,>crystal_snap_fr05,>crystal_snap_fr06,>crystal_snap_fr07
        !byte >crystal_snap_fr08,>crystal_snap_fr09,>crystal_snap_fr10,>crystal_snap_fr11,>crystal_snap_fr12,>crystal_snap_fr13,>crystal_snap_fr14,>crystal_snap_fr15
apex_flash_frame_lo:
        !byte <apex_flash_fr00,<apex_flash_fr01,<apex_flash_fr02,<apex_flash_fr03,<apex_flash_fr04,<apex_flash_fr05,<apex_flash_fr06,<apex_flash_fr07
        !byte <apex_flash_fr08,<apex_flash_fr09,<apex_flash_fr10,<apex_flash_fr11,<apex_flash_fr12,<apex_flash_fr13,<apex_flash_fr14,<apex_flash_fr15
apex_flash_frame_hi:
        !byte >apex_flash_fr00,>apex_flash_fr01,>apex_flash_fr02,>apex_flash_fr03,>apex_flash_fr04,>apex_flash_fr05,>apex_flash_fr06,>apex_flash_fr07
        !byte >apex_flash_fr08,>apex_flash_fr09,>apex_flash_fr10,>apex_flash_fr11,>apex_flash_fr12,>apex_flash_fr13,>apex_flash_fr14,>apex_flash_fr15

neon_focus_frame_lo:
        !byte <neon_focus_fr00,<neon_focus_fr01,<neon_focus_fr02,<neon_focus_fr03,<neon_focus_fr04,<neon_focus_fr05,<neon_focus_fr06,<neon_focus_fr07
        !byte <neon_focus_fr08,<neon_focus_fr09,<neon_focus_fr10,<neon_focus_fr11,<neon_focus_fr12,<neon_focus_fr13,<neon_focus_fr14,<neon_focus_fr15
neon_focus_frame_hi:
        !byte >neon_focus_fr00,>neon_focus_fr01,>neon_focus_fr02,>neon_focus_fr03,>neon_focus_fr04,>neon_focus_fr05,>neon_focus_fr06,>neon_focus_fr07
        !byte >neon_focus_fr08,>neon_focus_fr09,>neon_focus_fr10,>neon_focus_fr11,>neon_focus_fr12,>neon_focus_fr13,>neon_focus_fr14,>neon_focus_fr15

safe_wide_rim_frame_lo:
        !byte <safe_wide_rim_fr00,<safe_wide_rim_fr01,<safe_wide_rim_fr02,<safe_wide_rim_fr03,<safe_wide_rim_fr04,<safe_wide_rim_fr05,<safe_wide_rim_fr06,<safe_wide_rim_fr07
        !byte <safe_wide_rim_fr08,<safe_wide_rim_fr09,<safe_wide_rim_fr10,<safe_wide_rim_fr11,<safe_wide_rim_fr12,<safe_wide_rim_fr13,<safe_wide_rim_fr14,<safe_wide_rim_fr15
safe_wide_rim_frame_hi:
        !byte >safe_wide_rim_fr00,>safe_wide_rim_fr01,>safe_wide_rim_fr02,>safe_wide_rim_fr03,>safe_wide_rim_fr04,>safe_wide_rim_fr05,>safe_wide_rim_fr06,>safe_wide_rim_fr07
        !byte >safe_wide_rim_fr08,>safe_wide_rim_fr09,>safe_wide_rim_fr10,>safe_wide_rim_fr11,>safe_wide_rim_fr12,>safe_wide_rim_fr13,>safe_wide_rim_fr14,>safe_wide_rim_fr15

inner_depth_weave_frame_lo:
        !byte <inner_depth_weave_fr00,<inner_depth_weave_fr01,<inner_depth_weave_fr02,<inner_depth_weave_fr03,<inner_depth_weave_fr04,<inner_depth_weave_fr05,<inner_depth_weave_fr06,<inner_depth_weave_fr07
        !byte <inner_depth_weave_fr08,<inner_depth_weave_fr09,<inner_depth_weave_fr10,<inner_depth_weave_fr11,<inner_depth_weave_fr12,<inner_depth_weave_fr13,<inner_depth_weave_fr14,<inner_depth_weave_fr15
inner_depth_weave_frame_hi:
        !byte >inner_depth_weave_fr00,>inner_depth_weave_fr01,>inner_depth_weave_fr02,>inner_depth_weave_fr03,>inner_depth_weave_fr04,>inner_depth_weave_fr05,>inner_depth_weave_fr06,>inner_depth_weave_fr07
        !byte >inner_depth_weave_fr08,>inner_depth_weave_fr09,>inner_depth_weave_fr10,>inner_depth_weave_fr11,>inner_depth_weave_fr12,>inner_depth_weave_fr13,>inner_depth_weave_fr14,>inner_depth_weave_fr15

perspective_orbit_frame_lo:
        !byte <perspective_orbit_fr00,<perspective_orbit_fr01,<perspective_orbit_fr02,<perspective_orbit_fr03,<perspective_orbit_fr04,<perspective_orbit_fr05,<perspective_orbit_fr06,<perspective_orbit_fr07
        !byte <perspective_orbit_fr08,<perspective_orbit_fr09,<perspective_orbit_fr10,<perspective_orbit_fr11,<perspective_orbit_fr12,<perspective_orbit_fr13,<perspective_orbit_fr14,<perspective_orbit_fr15
perspective_orbit_frame_hi:
        !byte >perspective_orbit_fr00,>perspective_orbit_fr01,>perspective_orbit_fr02,>perspective_orbit_fr03,>perspective_orbit_fr04,>perspective_orbit_fr05,>perspective_orbit_fr06,>perspective_orbit_fr07
        !byte >perspective_orbit_fr08,>perspective_orbit_fr09,>perspective_orbit_fr10,>perspective_orbit_fr11,>perspective_orbit_fr12,>perspective_orbit_fr13,>perspective_orbit_fr14,>perspective_orbit_fr15

kinematic_rail_frame_lo:
        !byte <kinematic_rail_fr00,<kinematic_rail_fr01,<kinematic_rail_fr02,<kinematic_rail_fr03,<kinematic_rail_fr04,<kinematic_rail_fr05,<kinematic_rail_fr06,<kinematic_rail_fr07
        !byte <kinematic_rail_fr08,<kinematic_rail_fr09,<kinematic_rail_fr10,<kinematic_rail_fr11,<kinematic_rail_fr12,<kinematic_rail_fr13,<kinematic_rail_fr14,<kinematic_rail_fr15
kinematic_rail_frame_hi:
        !byte >kinematic_rail_fr00,>kinematic_rail_fr01,>kinematic_rail_fr02,>kinematic_rail_fr03,>kinematic_rail_fr04,>kinematic_rail_fr05,>kinematic_rail_fr06,>kinematic_rail_fr07
        !byte >kinematic_rail_fr08,>kinematic_rail_fr09,>kinematic_rail_fr10,>kinematic_rail_fr11,>kinematic_rail_fr12,>kinematic_rail_fr13,>kinematic_rail_fr14,>kinematic_rail_fr15

phase_hinge_frame_lo:
        !byte <phase_hinge_fr00,<phase_hinge_fr01,<phase_hinge_fr02,<phase_hinge_fr03,<phase_hinge_fr04,<phase_hinge_fr05,<phase_hinge_fr06,<phase_hinge_fr07
        !byte <phase_hinge_fr08,<phase_hinge_fr09,<phase_hinge_fr10,<phase_hinge_fr11,<phase_hinge_fr12,<phase_hinge_fr13,<phase_hinge_fr14,<phase_hinge_fr15
phase_hinge_frame_hi:
        !byte >phase_hinge_fr00,>phase_hinge_fr01,>phase_hinge_fr02,>phase_hinge_fr03,>phase_hinge_fr04,>phase_hinge_fr05,>phase_hinge_fr06,>phase_hinge_fr07
        !byte >phase_hinge_fr08,>phase_hinge_fr09,>phase_hinge_fr10,>phase_hinge_fr11,>phase_hinge_fr12,>phase_hinge_fr13,>phase_hinge_fr14,>phase_hinge_fr15

motion_spline_frame_lo:
        !byte <motion_spline_fr00,<motion_spline_fr01,<motion_spline_fr02,<motion_spline_fr03,<motion_spline_fr04,<motion_spline_fr05,<motion_spline_fr06,<motion_spline_fr07
        !byte <motion_spline_fr08,<motion_spline_fr09,<motion_spline_fr10,<motion_spline_fr11,<motion_spline_fr12,<motion_spline_fr13,<motion_spline_fr14,<motion_spline_fr15
motion_spline_frame_hi:
        !byte >motion_spline_fr00,>motion_spline_fr01,>motion_spline_fr02,>motion_spline_fr03,>motion_spline_fr04,>motion_spline_fr05,>motion_spline_fr06,>motion_spline_fr07
        !byte >motion_spline_fr08,>motion_spline_fr09,>motion_spline_fr10,>motion_spline_fr11,>motion_spline_fr12,>motion_spline_fr13,>motion_spline_fr14,>motion_spline_fr15

depth_normal_frame_lo:
        !byte <depth_normal_fr00,<depth_normal_fr01,<depth_normal_fr02,<depth_normal_fr03,<depth_normal_fr04,<depth_normal_fr05,<depth_normal_fr06,<depth_normal_fr07
        !byte <depth_normal_fr08,<depth_normal_fr09,<depth_normal_fr10,<depth_normal_fr11,<depth_normal_fr12,<depth_normal_fr13,<depth_normal_fr14,<depth_normal_fr15
depth_normal_frame_hi:
        !byte >depth_normal_fr00,>depth_normal_fr01,>depth_normal_fr02,>depth_normal_fr03,>depth_normal_fr04,>depth_normal_fr05,>depth_normal_fr06,>depth_normal_fr07
        !byte >depth_normal_fr08,>depth_normal_fr09,>depth_normal_fr10,>depth_normal_fr11,>depth_normal_fr12,>depth_normal_fr13,>depth_normal_fr14,>depth_normal_fr15

depth_inertia_frame_lo:
        !byte <depth_inertia_fr00,<depth_inertia_fr01,<depth_inertia_fr02,<depth_inertia_fr03,<depth_inertia_fr04,<depth_inertia_fr05,<depth_inertia_fr06,<depth_inertia_fr07
        !byte <depth_inertia_fr08,<depth_inertia_fr09,<depth_inertia_fr10,<depth_inertia_fr11,<depth_inertia_fr12,<depth_inertia_fr13,<depth_inertia_fr14,<depth_inertia_fr15
depth_inertia_frame_hi:
        !byte >depth_inertia_fr00,>depth_inertia_fr01,>depth_inertia_fr02,>depth_inertia_fr03,>depth_inertia_fr04,>depth_inertia_fr05,>depth_inertia_fr06,>depth_inertia_fr07
        !byte >depth_inertia_fr08,>depth_inertia_fr09,>depth_inertia_fr10,>depth_inertia_fr11,>depth_inertia_fr12,>depth_inertia_fr13,>depth_inertia_fr14,>depth_inertia_fr15

centroid_lock_frame_lo:
        !byte <centroid_lock_fr00,<centroid_lock_fr01,<centroid_lock_fr02,<centroid_lock_fr03,<centroid_lock_fr04,<centroid_lock_fr05,<centroid_lock_fr06,<centroid_lock_fr07
        !byte <centroid_lock_fr08,<centroid_lock_fr09,<centroid_lock_fr10,<centroid_lock_fr11,<centroid_lock_fr12,<centroid_lock_fr13,<centroid_lock_fr14,<centroid_lock_fr15
centroid_lock_frame_hi:
        !byte >centroid_lock_fr00,>centroid_lock_fr01,>centroid_lock_fr02,>centroid_lock_fr03,>centroid_lock_fr04,>centroid_lock_fr05,>centroid_lock_fr06,>centroid_lock_fr07
        !byte >centroid_lock_fr08,>centroid_lock_fr09,>centroid_lock_fr10,>centroid_lock_fr11,>centroid_lock_fr12,>centroid_lock_fr13,>centroid_lock_fr14,>centroid_lock_fr15

eased_vector_frame_lo:
        !byte <eased_vector_fr00,<eased_vector_fr01,<eased_vector_fr02,<eased_vector_fr03,<eased_vector_fr04,<eased_vector_fr05,<eased_vector_fr06,<eased_vector_fr07
        !byte <eased_vector_fr08,<eased_vector_fr09,<eased_vector_fr10,<eased_vector_fr11,<eased_vector_fr12,<eased_vector_fr13,<eased_vector_fr14,<eased_vector_fr15
eased_vector_frame_hi:
        !byte >eased_vector_fr00,>eased_vector_fr01,>eased_vector_fr02,>eased_vector_fr03,>eased_vector_fr04,>eased_vector_fr05,>eased_vector_fr06,>eased_vector_fr07
        !byte >eased_vector_fr08,>eased_vector_fr09,>eased_vector_fr10,>eased_vector_fr11,>eased_vector_fr12,>eased_vector_fr13,>eased_vector_fr14,>eased_vector_fr15

coherent_body_frame_lo:
        !byte <coherent_body_fr00,<coherent_body_fr01,<coherent_body_fr02,<coherent_body_fr03,<coherent_body_fr04,<coherent_body_fr05,<coherent_body_fr06,<coherent_body_fr07
        !byte <coherent_body_fr08,<coherent_body_fr09,<coherent_body_fr10,<coherent_body_fr11,<coherent_body_fr12,<coherent_body_fr13,<coherent_body_fr14,<coherent_body_fr15
coherent_body_frame_hi:
        !byte >coherent_body_fr00,>coherent_body_fr01,>coherent_body_fr02,>coherent_body_fr03,>coherent_body_fr04,>coherent_body_fr05,>coherent_body_fr06,>coherent_body_fr07
        !byte >coherent_body_fr08,>coherent_body_fr09,>coherent_body_fr10,>coherent_body_fr11,>coherent_body_fr12,>coherent_body_fr13,>coherent_body_fr14,>coherent_body_fr15

temporal_coherence_frame_lo:
        !byte <temporal_coherence_fr00,<temporal_coherence_fr01,<temporal_coherence_fr02,<temporal_coherence_fr03,<temporal_coherence_fr04,<temporal_coherence_fr05,<temporal_coherence_fr06,<temporal_coherence_fr07
        !byte <temporal_coherence_fr08,<temporal_coherence_fr09,<temporal_coherence_fr10,<temporal_coherence_fr11,<temporal_coherence_fr12,<temporal_coherence_fr13,<temporal_coherence_fr14,<temporal_coherence_fr15
temporal_coherence_frame_hi:
        !byte >temporal_coherence_fr00,>temporal_coherence_fr01,>temporal_coherence_fr02,>temporal_coherence_fr03,>temporal_coherence_fr04,>temporal_coherence_fr05,>temporal_coherence_fr06,>temporal_coherence_fr07
        !byte >temporal_coherence_fr08,>temporal_coherence_fr09,>temporal_coherence_fr10,>temporal_coherence_fr11,>temporal_coherence_fr12,>temporal_coherence_fr13,>temporal_coherence_fr14,>temporal_coherence_fr15

phase_fused_body_frame_lo:
        !byte <phase_fused_body_fr00,<phase_fused_body_fr01,<phase_fused_body_fr02,<phase_fused_body_fr03,<phase_fused_body_fr04,<phase_fused_body_fr05,<phase_fused_body_fr06,<phase_fused_body_fr07
        !byte <phase_fused_body_fr08,<phase_fused_body_fr09,<phase_fused_body_fr10,<phase_fused_body_fr11,<phase_fused_body_fr12,<phase_fused_body_fr13,<phase_fused_body_fr14,<phase_fused_body_fr15
phase_fused_body_frame_hi:
        !byte >phase_fused_body_fr00,>phase_fused_body_fr01,>phase_fused_body_fr02,>phase_fused_body_fr03,>phase_fused_body_fr04,>phase_fused_body_fr05,>phase_fused_body_fr06,>phase_fused_body_fr07
        !byte >phase_fused_body_fr08,>phase_fused_body_fr09,>phase_fused_body_fr10,>phase_fused_body_fr11,>phase_fused_body_fr12,>phase_fused_body_fr13,>phase_fused_body_fr14,>phase_fused_body_fr15
motion_convergence_frame_lo:
        !byte <motion_convergence_fr00,<motion_convergence_fr01,<motion_convergence_fr02,<motion_convergence_fr03,<motion_convergence_fr04,<motion_convergence_fr05,<motion_convergence_fr06,<motion_convergence_fr07
        !byte <motion_convergence_fr08,<motion_convergence_fr09,<motion_convergence_fr10,<motion_convergence_fr11,<motion_convergence_fr12,<motion_convergence_fr13,<motion_convergence_fr14,<motion_convergence_fr15
motion_convergence_frame_hi:
        !byte >motion_convergence_fr00,>motion_convergence_fr01,>motion_convergence_fr02,>motion_convergence_fr03,>motion_convergence_fr04,>motion_convergence_fr05,>motion_convergence_fr06,>motion_convergence_fr07
        !byte >motion_convergence_fr08,>motion_convergence_fr09,>motion_convergence_fr10,>motion_convergence_fr11,>motion_convergence_fr12,>motion_convergence_fr13,>motion_convergence_fr14,>motion_convergence_fr15
orbital_stability_frame_lo:
        !byte <orbital_stability_fr00,<orbital_stability_fr01,<orbital_stability_fr02,<orbital_stability_fr03,<orbital_stability_fr04,<orbital_stability_fr05,<orbital_stability_fr06,<orbital_stability_fr07
        !byte <orbital_stability_fr08,<orbital_stability_fr09,<orbital_stability_fr10,<orbital_stability_fr11,<orbital_stability_fr12,<orbital_stability_fr13,<orbital_stability_fr14,<orbital_stability_fr15
orbital_stability_frame_hi:
        !byte >orbital_stability_fr00,>orbital_stability_fr01,>orbital_stability_fr02,>orbital_stability_fr03,>orbital_stability_fr04,>orbital_stability_fr05,>orbital_stability_fr06,>orbital_stability_fr07
        !byte >orbital_stability_fr08,>orbital_stability_fr09,>orbital_stability_fr10,>orbital_stability_fr11,>orbital_stability_fr12,>orbital_stability_fr13,>orbital_stability_fr14,>orbital_stability_fr15
body_projection_lock_frame_lo:
        !byte <body_projection_lock_fr00,<body_projection_lock_fr01,<body_projection_lock_fr02,<body_projection_lock_fr03,<body_projection_lock_fr04,<body_projection_lock_fr05,<body_projection_lock_fr06,<body_projection_lock_fr07
        !byte <body_projection_lock_fr08,<body_projection_lock_fr09,<body_projection_lock_fr10,<body_projection_lock_fr11,<body_projection_lock_fr12,<body_projection_lock_fr13,<body_projection_lock_fr14,<body_projection_lock_fr15
body_projection_lock_frame_hi:
        !byte >body_projection_lock_fr00,>body_projection_lock_fr01,>body_projection_lock_fr02,>body_projection_lock_fr03,>body_projection_lock_fr04,>body_projection_lock_fr05,>body_projection_lock_fr06,>body_projection_lock_fr07
        !byte >body_projection_lock_fr08,>body_projection_lock_fr09,>body_projection_lock_fr10,>body_projection_lock_fr11,>body_projection_lock_fr12,>body_projection_lock_fr13,>body_projection_lock_fr14,>body_projection_lock_fr15
camera_spline_lock_frame_lo:
        !byte <camera_spline_lock_fr00,<camera_spline_lock_fr01,<camera_spline_lock_fr02,<camera_spline_lock_fr03,<camera_spline_lock_fr04,<camera_spline_lock_fr05,<camera_spline_lock_fr06,<camera_spline_lock_fr07
        !byte <camera_spline_lock_fr08,<camera_spline_lock_fr09,<camera_spline_lock_fr10,<camera_spline_lock_fr11,<camera_spline_lock_fr12,<camera_spline_lock_fr13,<camera_spline_lock_fr14,<camera_spline_lock_fr15
camera_spline_lock_frame_hi:
        !byte >camera_spline_lock_fr00,>camera_spline_lock_fr01,>camera_spline_lock_fr02,>camera_spline_lock_fr03,>camera_spline_lock_fr04,>camera_spline_lock_fr05,>camera_spline_lock_fr06,>camera_spline_lock_fr07
        !byte >camera_spline_lock_fr08,>camera_spline_lock_fr09,>camera_spline_lock_fr10,>camera_spline_lock_fr11,>camera_spline_lock_fr12,>camera_spline_lock_fr13,>camera_spline_lock_fr14,>camera_spline_lock_fr15
camera_inertia_lock_frame_lo:
        !byte <camera_inertia_lock_fr00,<camera_inertia_lock_fr01,<camera_inertia_lock_fr02,<camera_inertia_lock_fr03,<camera_inertia_lock_fr04,<camera_inertia_lock_fr05,<camera_inertia_lock_fr06,<camera_inertia_lock_fr07
        !byte <camera_inertia_lock_fr08,<camera_inertia_lock_fr09,<camera_inertia_lock_fr10,<camera_inertia_lock_fr11,<camera_inertia_lock_fr12,<camera_inertia_lock_fr13,<camera_inertia_lock_fr14,<camera_inertia_lock_fr15
camera_inertia_lock_frame_hi:
        !byte >camera_inertia_lock_fr00,>camera_inertia_lock_fr01,>camera_inertia_lock_fr02,>camera_inertia_lock_fr03,>camera_inertia_lock_fr04,>camera_inertia_lock_fr05,>camera_inertia_lock_fr06,>camera_inertia_lock_fr07
        !byte >camera_inertia_lock_fr08,>camera_inertia_lock_fr09,>camera_inertia_lock_fr10,>camera_inertia_lock_fr11,>camera_inertia_lock_fr12,>camera_inertia_lock_fr13,>camera_inertia_lock_fr14,>camera_inertia_lock_fr15

sync_strobe_frame_lo:
        !byte <sync_strobe_fr00,<sync_strobe_fr01,<sync_strobe_fr02,<sync_strobe_fr03,<sync_strobe_fr04,<sync_strobe_fr05,<sync_strobe_fr06,<sync_strobe_fr07
        !byte <sync_strobe_fr08,<sync_strobe_fr09,<sync_strobe_fr10,<sync_strobe_fr11,<sync_strobe_fr12,<sync_strobe_fr13,<sync_strobe_fr14,<sync_strobe_fr15
sync_strobe_frame_hi:
        !byte >sync_strobe_fr00,>sync_strobe_fr01,>sync_strobe_fr02,>sync_strobe_fr03,>sync_strobe_fr04,>sync_strobe_fr05,>sync_strobe_fr06,>sync_strobe_fr07
        !byte >sync_strobe_fr08,>sync_strobe_fr09,>sync_strobe_fr10,>sync_strobe_fr11,>sync_strobe_fr12,>sync_strobe_fr13,>sync_strobe_fr14,>sync_strobe_fr15

light_flash_frame_lo:
        !byte <light_flash_fr00,<light_flash_fr01,<light_flash_fr02,<light_flash_fr03,<light_flash_fr04,<light_flash_fr05,<light_flash_fr06,<light_flash_fr07
        !byte <light_flash_fr08,<light_flash_fr09,<light_flash_fr10,<light_flash_fr11,<light_flash_fr12,<light_flash_fr13,<light_flash_fr14,<light_flash_fr15
light_flash_frame_hi:
        !byte >light_flash_fr00,>light_flash_fr01,>light_flash_fr02,>light_flash_fr03,>light_flash_fr04,>light_flash_fr05,>light_flash_fr06,>light_flash_fr07
        !byte >light_flash_fr08,>light_flash_fr09,>light_flash_fr10,>light_flash_fr11,>light_flash_fr12,>light_flash_fr13,>light_flash_fr14,>light_flash_fr15
scanline_flare_frame_lo:
        !byte <scanline_flare_fr00,<scanline_flare_fr01,<scanline_flare_fr02,<scanline_flare_fr03,<scanline_flare_fr04,<scanline_flare_fr05,<scanline_flare_fr06,<scanline_flare_fr07
        !byte <scanline_flare_fr08,<scanline_flare_fr09,<scanline_flare_fr10,<scanline_flare_fr11,<scanline_flare_fr12,<scanline_flare_fr13,<scanline_flare_fr14,<scanline_flare_fr15
scanline_flare_frame_hi:
        !byte >scanline_flare_fr00,>scanline_flare_fr01,>scanline_flare_fr02,>scanline_flare_fr03,>scanline_flare_fr04,>scanline_flare_fr05,>scanline_flare_fr06,>scanline_flare_fr07
        !byte >scanline_flare_fr08,>scanline_flare_fr09,>scanline_flare_fr10,>scanline_flare_fr11,>scanline_flare_fr12,>scanline_flare_fr13,>scanline_flare_fr14,>scanline_flare_fr15
rim_flash_frame_lo:
        !byte <rim_flash_fr00,<rim_flash_fr01,<rim_flash_fr02,<rim_flash_fr03,<rim_flash_fr04,<rim_flash_fr05,<rim_flash_fr06,<rim_flash_fr07
        !byte <rim_flash_fr08,<rim_flash_fr09,<rim_flash_fr10,<rim_flash_fr11,<rim_flash_fr12,<rim_flash_fr13,<rim_flash_fr14,<rim_flash_fr15
rim_flash_frame_hi:
        !byte >rim_flash_fr00,>rim_flash_fr01,>rim_flash_fr02,>rim_flash_fr03,>rim_flash_fr04,>rim_flash_fr05,>rim_flash_fr06,>rim_flash_fr07
        !byte >rim_flash_fr08,>rim_flash_fr09,>rim_flash_fr10,>rim_flash_fr11,>rim_flash_fr12,>rim_flash_fr13,>rim_flash_fr14,>rim_flash_fr15

holo_tunnel_frame_lo:
        !byte <holo_tunnel_fr00,<holo_tunnel_fr01,<holo_tunnel_fr02,<holo_tunnel_fr03,<holo_tunnel_fr04,<holo_tunnel_fr05,<holo_tunnel_fr06,<holo_tunnel_fr07
        !byte <holo_tunnel_fr08,<holo_tunnel_fr09,<holo_tunnel_fr10,<holo_tunnel_fr11,<holo_tunnel_fr12,<holo_tunnel_fr13,<holo_tunnel_fr14,<holo_tunnel_fr15
holo_tunnel_frame_hi:
        !byte >holo_tunnel_fr00,>holo_tunnel_fr01,>holo_tunnel_fr02,>holo_tunnel_fr03,>holo_tunnel_fr04,>holo_tunnel_fr05,>holo_tunnel_fr06,>holo_tunnel_fr07
        !byte >holo_tunnel_fr08,>holo_tunnel_fr09,>holo_tunnel_fr10,>holo_tunnel_fr11,>holo_tunnel_fr12,>holo_tunnel_fr13,>holo_tunnel_fr14,>holo_tunnel_fr15
depth_fog_frame_lo:
        !byte <depth_fog_fr00,<depth_fog_fr01,<depth_fog_fr02,<depth_fog_fr03,<depth_fog_fr04,<depth_fog_fr05,<depth_fog_fr06,<depth_fog_fr07
        !byte <depth_fog_fr08,<depth_fog_fr09,<depth_fog_fr10,<depth_fog_fr11,<depth_fog_fr12,<depth_fog_fr13,<depth_fog_fr14,<depth_fog_fr15
depth_fog_frame_hi:
        !byte >depth_fog_fr00,>depth_fog_fr01,>depth_fog_fr02,>depth_fog_fr03,>depth_fog_fr04,>depth_fog_fr05,>depth_fog_fr06,>depth_fog_fr07
        !byte >depth_fog_fr08,>depth_fog_fr09,>depth_fog_fr10,>depth_fog_fr11,>depth_fog_fr12,>depth_fog_fr13,>depth_fog_fr14,>depth_fog_fr15
floor_grid_frame_lo:
        !byte <floor_grid_fr00,<floor_grid_fr01,<floor_grid_fr02,<floor_grid_fr03,<floor_grid_fr04,<floor_grid_fr05,<floor_grid_fr06,<floor_grid_fr07
        !byte <floor_grid_fr08,<floor_grid_fr09,<floor_grid_fr10,<floor_grid_fr11,<floor_grid_fr12,<floor_grid_fr13,<floor_grid_fr14,<floor_grid_fr15
floor_grid_frame_hi:
        !byte >floor_grid_fr00,>floor_grid_fr01,>floor_grid_fr02,>floor_grid_fr03,>floor_grid_fr04,>floor_grid_fr05,>floor_grid_fr06,>floor_grid_fr07
        !byte >floor_grid_fr08,>floor_grid_fr09,>floor_grid_fr10,>floor_grid_fr11,>floor_grid_fr12,>floor_grid_fr13,>floor_grid_fr14,>floor_grid_fr15
zslice_frame_lo:
        !byte <zslice_fr00,<zslice_fr01,<zslice_fr02,<zslice_fr03,<zslice_fr04,<zslice_fr05,<zslice_fr06,<zslice_fr07
        !byte <zslice_fr08,<zslice_fr09,<zslice_fr10,<zslice_fr11,<zslice_fr12,<zslice_fr13,<zslice_fr14,<zslice_fr15
zslice_frame_hi:
        !byte >zslice_fr00,>zslice_fr01,>zslice_fr02,>zslice_fr03,>zslice_fr04,>zslice_fr05,>zslice_fr06,>zslice_fr07
        !byte >zslice_fr08,>zslice_fr09,>zslice_fr10,>zslice_fr11,>zslice_fr12,>zslice_fr13,>zslice_fr14,>zslice_fr15
lens_glint_frame_lo:
        !byte <lens_glint_fr00,<lens_glint_fr01,<lens_glint_fr02,<lens_glint_fr03,<lens_glint_fr04,<lens_glint_fr05,<lens_glint_fr06,<lens_glint_fr07
        !byte <lens_glint_fr08,<lens_glint_fr09,<lens_glint_fr10,<lens_glint_fr11,<lens_glint_fr12,<lens_glint_fr13,<lens_glint_fr14,<lens_glint_fr15
lens_glint_frame_hi:
        !byte >lens_glint_fr00,>lens_glint_fr01,>lens_glint_fr02,>lens_glint_fr03,>lens_glint_fr04,>lens_glint_fr05,>lens_glint_fr06,>lens_glint_fr07
        !byte >lens_glint_fr08,>lens_glint_fr09,>lens_glint_fr10,>lens_glint_fr11,>lens_glint_fr12,>lens_glint_fr13,>lens_glint_fr14,>lens_glint_fr15

holo_tunnel_fr00:
        !byte 15,8,20,7,25,8,14,12,26,12,15,16,20,17,25,16,$ff
holo_tunnel_fr01:
        !byte 16,8,21,7,26,8,15,12,27,12,16,16,21,17,26,16,$ff
holo_tunnel_fr02:
        !byte 17,8,22,7,27,8,16,12,28,12,17,16,22,17,27,16,$ff
holo_tunnel_fr03:
        !byte 17,9,22,8,27,9,16,13,28,13,17,17,22,18,27,17,$ff
holo_tunnel_fr04:
        !byte 16,9,21,8,26,9,15,13,27,13,16,17,21,18,26,17,$ff
holo_tunnel_fr05:
        !byte 15,8,20,7,25,8,14,12,26,12,15,16,20,17,25,16,$ff
holo_tunnel_fr06:
        !byte 14,8,19,7,24,8,13,12,25,12,14,16,19,17,24,16,$ff
holo_tunnel_fr07:
        !byte 13,8,18,7,23,8,12,12,24,12,13,16,18,17,23,16,$ff
holo_tunnel_fr08:
        !byte 13,8,18,7,23,8,12,12,24,12,13,16,18,17,23,16,$ff
holo_tunnel_fr09:
        !byte 14,8,19,7,24,8,13,12,25,12,14,16,19,17,24,16,$ff
holo_tunnel_fr10:
        !byte 15,8,20,7,25,8,14,12,26,12,15,16,20,17,25,16,$ff
holo_tunnel_fr11:
        !byte 16,9,21,8,26,9,15,13,27,13,16,17,21,18,26,17,$ff
holo_tunnel_fr12:
        !byte 17,9,22,8,27,9,16,13,28,13,17,17,22,18,27,17,$ff
holo_tunnel_fr13:
        !byte 16,8,21,7,26,8,15,12,27,12,16,16,21,17,26,16,$ff
holo_tunnel_fr14:
        !byte 15,8,20,7,25,8,14,12,26,12,15,16,20,17,25,16,$ff
holo_tunnel_fr15:
        !byte 14,8,19,7,24,8,13,12,25,12,14,16,19,17,24,16,$ff
depth_fog_fr00: !byte 16,9,18,9,22,9,24,10,17,15,19,16,22,15,24,14,20,12,$ff
depth_fog_fr01: !byte 17,9,19,9,23,9,25,10,18,15,20,16,23,15,25,14,21,12,$ff
depth_fog_fr02: !byte 18,9,20,9,24,9,26,10,19,15,21,16,24,15,26,14,22,12,$ff
depth_fog_fr03: !byte 18,10,20,10,24,10,26,11,19,16,21,17,24,16,26,15,22,13,$ff
depth_fog_fr04: !byte 17,10,19,10,23,10,25,11,18,16,20,17,23,16,25,15,21,13,$ff
depth_fog_fr05: !byte 16,9,18,9,22,9,24,10,17,15,19,16,22,15,24,14,20,12,$ff
depth_fog_fr06: !byte 15,9,17,9,21,9,23,10,16,15,18,16,21,15,23,14,19,12,$ff
depth_fog_fr07: !byte 14,8,16,8,20,8,22,9,15,14,17,15,20,14,22,13,18,11,$ff
depth_fog_fr08: !byte 14,8,16,8,20,8,22,9,15,14,17,15,20,14,22,13,18,11,$ff
depth_fog_fr09: !byte 15,9,17,9,21,9,23,10,16,15,18,16,21,15,23,14,19,12,$ff
depth_fog_fr10: !byte 16,9,18,9,22,9,24,10,17,15,19,16,22,15,24,14,20,12,$ff
depth_fog_fr11: !byte 17,10,19,10,23,10,25,11,18,16,20,17,23,16,25,15,21,13,$ff
depth_fog_fr12: !byte 18,10,20,10,24,10,26,11,19,16,21,17,24,16,26,15,22,13,$ff
depth_fog_fr13: !byte 17,9,19,9,23,9,25,10,18,15,20,16,23,15,25,14,21,12,$ff
depth_fog_fr14: !byte 16,9,18,9,22,9,24,10,17,15,19,16,22,15,24,14,20,12,$ff
depth_fog_fr15: !byte 15,8,17,8,21,8,23,9,16,14,18,15,21,14,23,13,19,11,$ff
floor_grid_fr00: !byte 14,18,17,18,20,18,23,18,26,18,16,19,20,19,24,19,$ff
floor_grid_fr01: !byte 13,18,16,18,19,18,22,18,25,18,15,19,19,19,23,19,$ff
floor_grid_fr02: !byte 12,18,15,18,18,18,21,18,24,18,14,19,18,19,22,19,$ff
floor_grid_fr03: !byte 12,17,15,18,18,18,21,19,24,19,14,20,18,20,22,20,$ff
floor_grid_fr04: !byte 13,17,16,18,19,18,22,19,25,19,15,20,19,20,23,20,$ff
floor_grid_fr05: !byte 14,17,17,18,20,18,23,19,26,20,16,20,20,20,24,20,$ff
floor_grid_fr06: !byte 15,17,18,18,21,18,24,19,27,19,17,20,21,20,25,20,$ff
floor_grid_fr07: !byte 16,17,19,18,22,18,25,19,28,19,18,20,22,20,26,20,$ff
floor_grid_fr08: !byte 26,18,23,18,20,18,17,18,14,18,24,19,20,19,16,19,$ff
floor_grid_fr09: !byte 27,18,24,18,21,18,18,18,15,18,25,19,21,19,17,19,$ff
floor_grid_fr10: !byte 28,18,25,18,22,18,19,18,16,18,26,19,22,19,18,19,$ff
floor_grid_fr11: !byte 28,17,25,18,22,18,19,19,16,19,26,20,22,20,18,20,$ff
floor_grid_fr12: !byte 27,17,24,18,21,18,18,19,15,19,25,20,21,20,17,20,$ff
floor_grid_fr13: !byte 26,17,23,18,20,18,17,19,14,20,24,20,20,20,16,20,$ff
floor_grid_fr14: !byte 25,17,22,18,19,18,16,19,13,19,23,20,19,20,15,20,$ff
floor_grid_fr15: !byte 24,17,21,18,18,18,15,19,12,19,22,20,18,20,14,20,$ff

zslice_fr00: !byte 18,10,19,11,20,11,21,11,22,10,19,14,20,14,21,14,$ff
zslice_fr01: !byte 18,10,19,10,20,11,21,12,22,13,19,14,20,15,21,15,$ff
zslice_fr02: !byte 17,11,18,10,19,10,20,11,21,12,22,13,20,15,$ff
zslice_fr03: !byte 17,11,18,12,19,10,20,11,21,12,22,12,21,14,$ff
zslice_fr04: !byte 18,11,19,10,20,10,21,11,22,11,21,14,20,14,$ff
zslice_fr05: !byte 18,10,19,11,20,12,21,12,22,13,20,15,21,15,$ff
zslice_fr06: !byte 19,10,20,11,21,12,22,12,23,13,19,14,20,15,$ff
zslice_fr07: !byte 17,10,18,11,19,12,20,12,21,12,22,13,20,15,$ff
zslice_fr08: !byte 22,10,21,11,20,11,19,11,18,10,21,14,20,14,19,14,$ff
zslice_fr09: !byte 22,10,21,10,20,11,19,12,18,13,21,14,20,15,19,15,$ff
zslice_fr10: !byte 23,11,22,10,21,10,20,11,19,12,18,13,20,15,$ff
zslice_fr11: !byte 23,11,22,12,21,10,20,11,19,12,18,12,19,14,$ff
zslice_fr12: !byte 22,11,21,10,20,10,19,11,18,11,19,14,20,14,$ff
zslice_fr13: !byte 22,10,21,11,20,12,19,12,18,13,20,15,19,15,$ff
zslice_fr14: !byte 21,10,20,11,19,12,18,12,17,13,21,14,20,15,$ff
zslice_fr15: !byte 23,10,22,11,21,12,20,12,19,12,18,13,20,15,$ff

lens_glint_fr00: !byte 17,9,23,9,16,15,24,15,20,10,$ff
lens_glint_fr01: !byte 18,9,24,10,17,15,23,16,21,11,$ff
lens_glint_fr02: !byte 19,9,23,11,18,16,22,15,21,12,$ff
lens_glint_fr03: !byte 20,9,24,12,17,14,21,16,22,11,$ff
lens_glint_fr04: !byte 23,9,17,10,24,15,16,15,20,11,$ff
lens_glint_fr05: !byte 22,9,16,10,23,16,17,15,19,12,$ff
lens_glint_fr06: !byte 21,9,17,11,22,16,18,15,19,13,$ff
lens_glint_fr07: !byte 20,9,16,12,23,14,19,16,18,11,$ff
lens_glint_fr08: !byte 23,9,17,9,24,15,16,15,20,10,$ff
lens_glint_fr09: !byte 22,9,16,10,23,15,17,16,19,11,$ff
lens_glint_fr10: !byte 21,9,17,11,22,16,18,15,19,12,$ff
lens_glint_fr11: !byte 20,9,16,12,23,14,19,16,18,11,$ff
lens_glint_fr12: !byte 17,9,23,10,16,15,24,15,20,11,$ff
lens_glint_fr13: !byte 18,9,24,10,17,16,23,15,21,12,$ff
lens_glint_fr14: !byte 19,9,23,11,18,16,22,15,21,13,$ff
lens_glint_fr15: !byte 20,9,24,12,17,14,21,16,22,11,$ff

cast_shadow_frame_lo:
        !byte <cast_shadow_fr00,<cast_shadow_fr01,<cast_shadow_fr02,<cast_shadow_fr03,<cast_shadow_fr04,<cast_shadow_fr05,<cast_shadow_fr06,<cast_shadow_fr07
        !byte <cast_shadow_fr08,<cast_shadow_fr09,<cast_shadow_fr10,<cast_shadow_fr11,<cast_shadow_fr12,<cast_shadow_fr13,<cast_shadow_fr14,<cast_shadow_fr15
cast_shadow_frame_hi:
        !byte >cast_shadow_fr00,>cast_shadow_fr01,>cast_shadow_fr02,>cast_shadow_fr03,>cast_shadow_fr04,>cast_shadow_fr05,>cast_shadow_fr06,>cast_shadow_fr07
        !byte >cast_shadow_fr08,>cast_shadow_fr09,>cast_shadow_fr10,>cast_shadow_fr11,>cast_shadow_fr12,>cast_shadow_fr13,>cast_shadow_fr14,>cast_shadow_fr15
cast_shadow_fr00: !byte 18,16,19,16,20,16,21,16,22,16,23,16,19,17,20,17,21,17,22,17,$ff
cast_shadow_fr01: !byte 17,16,18,16,19,16,20,16,21,17,22,17,23,17,18,18,19,18,20,18,$ff
cast_shadow_fr02: !byte 16,16,17,16,18,17,19,17,20,17,21,18,22,18,17,18,18,18,19,18,$ff
cast_shadow_fr03: !byte 16,15,17,16,18,17,19,18,20,18,21,18,22,17,18,19,19,19,20,19,$ff
cast_shadow_fr04: !byte 17,15,18,16,19,17,20,18,21,18,22,18,23,17,18,19,19,19,20,19,$ff
cast_shadow_fr05: !byte 18,15,19,16,20,17,21,18,22,19,23,18,24,18,19,19,20,19,21,19,$ff
cast_shadow_fr06: !byte 19,15,20,16,21,17,22,18,23,18,24,18,25,17,20,19,21,19,22,19,$ff
cast_shadow_fr07: !byte 20,15,21,16,22,17,23,18,24,18,25,18,24,19,21,19,22,19,23,19,$ff
cast_shadow_fr08: !byte 23,16,22,16,21,16,20,16,19,16,18,16,22,17,21,17,20,17,19,17,$ff
cast_shadow_fr09: !byte 24,16,23,16,22,16,21,16,20,17,19,17,18,17,23,18,22,18,21,18,$ff
cast_shadow_fr10: !byte 24,16,23,16,22,17,21,17,20,17,19,18,18,18,23,18,22,18,21,18,$ff
cast_shadow_fr11: !byte 24,15,23,16,22,17,21,18,20,18,19,18,18,17,22,19,21,19,20,19,$ff
cast_shadow_fr12: !byte 23,15,22,16,21,17,20,18,19,18,18,18,17,17,22,19,21,19,20,19,$ff
cast_shadow_fr13: !byte 22,15,21,16,20,17,19,18,18,19,17,18,16,18,21,19,20,19,19,19,$ff
cast_shadow_fr14: !byte 21,15,20,16,19,17,18,18,17,18,16,18,15,17,20,19,19,19,18,19,$ff
cast_shadow_fr15: !byte 20,15,19,16,18,17,17,18,16,18,15,18,16,19,19,19,18,19,17,19,$ff

depth_dot_frame_lo:
        !byte <depth_dot_fr00,<depth_dot_fr01,<depth_dot_fr02,<depth_dot_fr03,<depth_dot_fr04,<depth_dot_fr05,<depth_dot_fr06,<depth_dot_fr07
        !byte <depth_dot_fr08,<depth_dot_fr09,<depth_dot_fr10,<depth_dot_fr11,<depth_dot_fr12,<depth_dot_fr13,<depth_dot_fr14,<depth_dot_fr15
depth_dot_frame_hi:
        !byte >depth_dot_fr00,>depth_dot_fr01,>depth_dot_fr02,>depth_dot_fr03,>depth_dot_fr04,>depth_dot_fr05,>depth_dot_fr06,>depth_dot_fr07
        !byte >depth_dot_fr08,>depth_dot_fr09,>depth_dot_fr10,>depth_dot_fr11,>depth_dot_fr12,>depth_dot_fr13,>depth_dot_fr14,>depth_dot_fr15
accent_frame_lo:
        !byte <accent_fr00,<accent_fr01,<accent_fr02,<accent_fr03,<accent_fr04,<accent_fr05,<accent_fr06,<accent_fr07
        !byte <accent_fr08,<accent_fr09,<accent_fr10,<accent_fr11,<accent_fr12,<accent_fr13,<accent_fr14,<accent_fr15
accent_frame_hi:
        !byte >accent_fr00,>accent_fr01,>accent_fr02,>accent_fr03,>accent_fr04,>accent_fr05,>accent_fr06,>accent_fr07
        !byte >accent_fr08,>accent_fr09,>accent_fr10,>accent_fr11,>accent_fr12,>accent_fr13,>accent_fr14,>accent_fr15

depth_dot_fr00: !byte 17,10,23,10,17,14,23,14,20,12,$ff
depth_dot_fr01: !byte 17,10,24,10,16,14,23,15,20,12,$ff
depth_dot_fr02: !byte 16,11,24,11,15,13,22,14,19,12,$ff
depth_dot_fr03: !byte 16,10,23,9,16,14,24,13,20,12,$ff
depth_dot_fr04: !byte 16,10,24,10,16,14,24,14,20,12,$ff
depth_dot_fr05: !byte 18,9,25,11,17,14,22,15,20,12,$ff
depth_dot_fr06: !byte 19,9,25,12,16,13,21,15,20,12,$ff
depth_dot_fr07: !byte 20,9,24,12,15,13,20,15,19,12,$ff
depth_dot_fr08: !byte 23,10,17,10,23,14,17,14,20,12,$ff
depth_dot_fr09: !byte 24,10,18,10,23,15,16,14,20,12,$ff
depth_dot_fr10: !byte 24,11,16,11,22,14,15,13,19,12,$ff
depth_dot_fr11: !byte 23,9,16,10,24,13,16,14,20,12,$ff
depth_dot_fr12: !byte 24,10,16,10,24,14,16,14,20,12,$ff
depth_dot_fr13: !byte 25,11,18,9,22,15,17,14,20,12,$ff
depth_dot_fr14: !byte 25,12,19,9,21,15,16,13,20,12,$ff
depth_dot_fr15: !byte 24,12,20,9,20,15,15,13,19,12,$ff

accent_fr00: !byte 18,12,19,12,20,12,21,12,22,12,20,11,$ff
accent_fr01: !byte 17,12,18,12,19,13,20,13,21,13,22,14,$ff
accent_fr02: !byte 16,12,17,12,18,13,19,13,20,14,21,14,$ff
accent_fr03: !byte 16,11,17,12,18,13,19,14,20,14,21,13,$ff
accent_fr04: !byte 17,11,18,11,19,12,20,12,21,13,22,13,$ff
accent_fr05: !byte 18,10,19,11,20,12,21,13,22,14,21,14,$ff
accent_fr06: !byte 19,10,20,11,21,12,22,13,23,13,20,14,$ff
accent_fr07: !byte 20,10,21,11,22,12,23,13,22,14,19,14,$ff
accent_fr08: !byte 22,12,21,12,20,12,19,12,18,12,20,13,$ff
accent_fr09: !byte 23,12,22,12,21,13,20,13,19,13,18,14,$ff
accent_fr10: !byte 24,12,23,12,22,13,21,13,20,14,19,14,$ff
accent_fr11: !byte 24,11,23,12,22,13,21,14,20,14,19,13,$ff
accent_fr12: !byte 23,11,22,11,21,12,20,12,19,13,18,13,$ff
accent_fr13: !byte 22,10,21,11,20,12,19,13,18,14,19,14,$ff
accent_fr14: !byte 21,10,20,11,19,12,18,13,17,13,20,14,$ff
accent_fr15: !byte 20,10,19,11,18,12,17,13,18,14,21,14,$ff

detail_frame_lo:
        !byte <detail_fr00,<detail_fr01,<detail_fr02,<detail_fr03,<detail_fr04,<detail_fr05,<detail_fr06,<detail_fr07
        !byte <detail_fr08,<detail_fr09,<detail_fr10,<detail_fr11,<detail_fr12,<detail_fr13,<detail_fr14,<detail_fr15
detail_frame_hi:
        !byte >detail_fr00,>detail_fr01,>detail_fr02,>detail_fr03,>detail_fr04,>detail_fr05,>detail_fr06,>detail_fr07
        !byte >detail_fr08,>detail_fr09,>detail_fr10,>detail_fr11,>detail_fr12,>detail_fr13,>detail_fr14,>detail_fr15

detail_fr00: !byte 18,11,19,12,20,12,21,12,22,11,18,13,19,13,20,13,21,13,22,13,$ff
detail_fr01: !byte 17,11,18,12,19,12,20,13,21,13,22,14,17,13,18,13,19,13,20,14,$ff
detail_fr02: !byte 16,12,17,12,18,13,19,13,20,14,21,13,22,12,18,11,19,11,20,10,$ff
detail_fr03: !byte 16,11,17,12,18,13,19,13,20,12,21,11,22,10,19,14,20,14,21,13,$ff
detail_fr04: !byte 17,11,18,11,19,12,20,12,21,12,22,11,18,13,19,13,20,13,21,13,$ff
detail_fr05: !byte 17,10,18,11,19,12,20,12,21,13,22,14,18,14,19,14,20,14,21,15,$ff
detail_fr06: !byte 18,10,19,11,20,12,21,12,22,13,23,13,17,13,18,14,19,14,20,15,$ff
detail_fr07: !byte 17,10,18,11,19,11,20,12,21,12,22,12,23,13,18,14,19,14,20,15,$ff
detail_fr08: !byte 18,11,19,11,20,12,21,12,22,12,23,13,18,13,19,13,20,13,21,13,$ff
detail_fr09: !byte 18,10,19,11,20,11,21,12,22,13,23,13,17,14,18,14,19,14,20,14,$ff
detail_fr10: !byte 17,10,18,11,19,12,20,13,21,13,22,13,23,12,18,14,19,14,20,14,$ff
detail_fr11: !byte 16,11,17,12,18,12,19,12,20,13,21,13,22,12,18,14,19,14,20,15,$ff
detail_fr12: !byte 17,11,18,12,19,12,20,12,21,12,22,12,18,14,19,14,20,14,21,14,$ff
detail_fr13: !byte 16,11,17,12,18,12,19,13,20,13,21,12,22,11,18,14,19,14,20,15,$ff
detail_fr14: !byte 16,12,17,12,18,13,19,13,20,14,21,14,22,13,18,11,19,10,20,9,$ff
detail_fr15: !byte 17,10,18,10,19,11,20,11,21,12,22,12,23,11,17,13,18,13,19,14,$ff

mul40_lo:
        !byte $00,$28,$50,$78,$a0,$c8,$f0,$18,$40,$68,$90,$b8,$e0,$08,$30,$58,$80,$a8,$d0,$f8,$20,$48,$70,$98,$c0
mul40_hi:
        !byte $00,$00,$00,$00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$02,$02,$02,$02,$02,$02,$02,$03,$03,$03,$03,$03

cube_frame_lo:
        !byte <cube_fr00,<cube_fr01,<cube_fr02,<cube_fr03,<cube_fr04,<cube_fr05,<cube_fr06,<cube_fr07,<cube_fr08,<cube_fr09,<cube_fr10,<cube_fr11,<cube_fr12,<cube_fr13,<cube_fr14,<cube_fr15,<cube_pu00,<cube_pu01,<cube_pu02,<cube_pu03,<cube_pu04,<cube_pu05,<cube_pu06,<cube_pu07,<cube_pu08,<cube_pu09,<cube_pu10,<cube_pu11,<cube_pu12,<cube_pu13,<cube_pu14,<cube_pu15
cube_frame_hi:
        !byte >cube_fr00,>cube_fr01,>cube_fr02,>cube_fr03,>cube_fr04,>cube_fr05,>cube_fr06,>cube_fr07,>cube_fr08,>cube_fr09,>cube_fr10,>cube_fr11,>cube_fr12,>cube_fr13,>cube_fr14,>cube_fr15,>cube_pu00,>cube_pu01,>cube_pu02,>cube_pu03,>cube_pu04,>cube_pu05,>cube_pu06,>cube_pu07,>cube_pu08,>cube_pu09,>cube_pu10,>cube_pu11,>cube_pu12,>cube_pu13,>cube_pu14,>cube_pu15
cube_fr00:
        !byte 16,11,17,11,18,11,19,11,20,11,21,11,22,11,23,11,24,11,24,12,23,13,23,14
        !byte 22,14,21,14,20,14,19,14,18,14,17,14,17,13,16,12,17,10,18,10,19,10,20,10
        !byte 21,10,22,10,23,10,23,12,22,13,21,13,20,13,19,13,18,13,17,12
        !byte $ff

cube_fr01:
        !byte 15,11,16,11,17,11,18,11,19,12,20,12,21,12,22,12,22,13,22,14,22,15,21,15
        !byte 20,15,19,14,18,14,17,14,16,14,16,13,15,12,18,9,19,9,20,9,21,10,22,10
        !byte 23,10,24,10,24,11,24,12,23,12,19,11,18,10,16,10,17,10,23,11,23,14,23,13
        !byte 17,13,18,13
        !byte $ff

cube_fr02:
        !byte 15,11,16,12,17,12,18,13,19,13,20,14,20,15,19,14,18,14,17,13,16,13,15,12
        !byte 20,9,21,9,22,10,23,10,24,11,25,11,24,12,24,13,23,12,22,12,21,11,20,11
        !byte 20,10,16,11,17,10,18,10,19,9,21,13,22,13,21,14,22,14,23,13,18,12,19,11
        !byte $ff

cube_fr03:
        !byte 15,10,16,11,17,12,17,13,18,14,18,15,17,14,16,12,15,11,22,9,23,10,24,11
        !byte 24,12,25,13,24,13,23,12,23,11,22,10,16,10,17,10,18,10,19,9,20,9,21,9
        !byte 19,14,20,14,21,14,22,13,23,13,19,15,22,14,18,11,19,11,20,11,21,10
        !byte $ff

cube_fr04:
        !byte 16,10,16,11,16,12,16,13,16,14,17,14,17,13,17,12,17,11,17,10,24,10,24,11
        !byte 24,12,24,13,24,14,23,14,23,13,23,12,23,11,23,10,18,10,19,10,20,10,21,10
        !byte 22,10,18,14,19,14,20,14,21,14,22,14
        !byte $ff

cube_fr05:
        !byte 18,10,17,11,16,12,15,13,16,13,17,12,18,9,25,11,24,12,23,13,23,14,22,15
        !byte 22,14,23,12,24,11,19,10,20,10,21,10,22,11,23,11,17,14,18,14,19,14,20,14
        !byte 21,15,17,13,18,13,21,14,19,9,22,10
        !byte $ff

cube_fr06:
        !byte 20,10,19,11,18,11,17,12,16,12,15,13,16,11,17,10,18,10,19,9,20,9,25,13
        !byte 24,13,23,14,22,14,21,15,20,15,20,14,20,13,21,12,22,12,23,11,24,11,25,12
        !byte 21,11,22,11,23,12,24,12,16,13,17,14,18,14,19,15,18,12,19,13,21,10,22,10
        !byte $ff

cube_fr07:
        !byte 22,11,21,11,20,12,19,12,18,12,17,12,16,13,15,13,15,12,16,11,16,10,17,10
        !byte 18,10,19,9,20,9,21,9,22,9,22,10,24,14,23,14,22,14,21,15,20,15,19,15
        !byte 18,15,18,14,19,13,21,12,22,12,23,12,24,12,24,13,23,13,16,14,17,14,17,11
        !byte 18,11,23,10,23,11
        !byte $ff

cube_fr08:
        !byte 24,13,23,13,22,13,21,13,20,13,19,13,18,13,17,13,16,13,16,12,17,11,17,10
        !byte 18,10,19,10,20,10,21,10,22,10,23,10,23,11,24,12,23,14,22,14,21,14,20,14
        !byte 19,14,18,14,17,14,17,12,18,12,19,12,20,12,21,12,22,12,23,12
        !byte $ff

cube_fr09:
        !byte 25,13,24,13,23,13,22,13,21,13,20,13,19,13,18,13,18,12,18,11,18,10,19,10
        !byte 20,10,21,10,22,10,23,10,24,10,24,11,25,12,22,14,21,14,20,14,19,14,18,14
        !byte 17,14,16,14,16,13,16,12,16,11,17,11,19,11,20,11,21,11,21,12,23,14,22,11
        !byte $ff

cube_fr10:
        !byte 24,13,23,13,22,14,21,14,20,14,20,13,20,12,20,11,21,11,22,11,23,10,24,10
        !byte 25,10,25,11,24,12,19,13,18,13,17,13,16,13,16,12,15,11,15,10,16,10,17,10
        !byte 18,10,19,10,20,10,22,13,21,13,19,14,19,11,18,11,22,10,21,10
        !byte $ff

cube_fr11:
        !byte 24,13,23,14,22,15,22,14,22,13,22,12,22,11,23,10,24,10,24,11,24,12,19,12
        !byte 18,13,17,13,16,14,16,13,15,12,15,11,16,11,17,10,18,10,19,11,23,13,21,12
        !byte 20,12,21,15,20,15,19,14,18,14,17,14,21,11,20,11,18,11,17,11,22,10,21,10
        !byte 20,10,19,10
        !byte $ff

cube_fr12:
        !byte 23,12,23,13,23,14,24,13,24,12,23,11,23,10,17,12,17,13,17,14,16,13,16,12
        !byte 17,11,17,10,22,12,21,12,20,12,19,12,18,12,22,14,21,14,20,14,19,14,18,14
        !byte 22,10,21,10,20,10,19,10,18,10
        !byte $ff

cube_fr13:
        !byte 21,11,22,12,23,13,24,14,25,13,25,12,24,11,23,10,22,9,21,10,16,12,17,13
        !byte 17,14,18,15,18,14,18,13,17,12,17,11,16,10,16,11,20,11,19,11,18,12,23,14
        !byte 22,14,21,15,20,15,19,15,24,12,23,12,21,13,20,13,19,13,21,9,20,9,19,10
        !byte 18,10,17,10
        !byte $ff

cube_fr14:
        !byte 20,10,21,11,22,11,23,12,24,12,25,12,24,11,23,11,22,10,21,10,20,9,16,12
        !byte 17,13,18,14,19,14,20,15,20,14,18,13,15,12,19,11,18,11,17,12,23,13,22,14
        !byte 21,14,22,13,19,10,18,10,17,11,16,11
        !byte $ff

cube_fr15:
        !byte 18,10,19,10,20,10,21,11,22,11,23,11,24,11,25,11,23,10,22,10,21,10,19,9
        !byte 18,9,16,13,17,13,18,13,19,14,20,14,21,14,22,14,22,15,21,15,18,14,17,14
        !byte 15,13,17,11,17,12,23,12,23,13,24,12,23,14,17,10,16,11,16,12
        !byte $ff

cube_pu00:
        !byte 14,11,15,11,16,11,17,11,18,11,19,11,20,11,21,11,22,11,23,11,24,11,25,11
        !byte 26,11,26,12,26,13,26,14,26,15,26,16,25,16,24,16,23,16,22,16,21,16,20,16
        !byte 19,16,18,16,17,16,16,16,15,16,14,16,14,15,14,14,14,13,14,12,15,9,16,9
        !byte 17,9,18,9,19,9,20,9,21,9,22,9,23,9,24,9,25,9,25,10,25,12,25,13
        !byte 24,13,23,13,22,13,21,13,20,13,19,13,18,13,17,13,16,13,15,13,15,12,15,10
        !byte 25,14,15,14
        !byte $ff

cube_pu01:
        !byte 12,11,13,11,14,11,15,12,16,12,17,12,18,12,19,12,20,12,21,13,22,13,23,13
        !byte 24,13,24,14,23,15,23,16,23,17,22,17,21,17,20,16,19,16,18,16,17,16,16,16
        !byte 15,15,14,15,13,15,13,14,12,13,12,12,17,8,18,8,19,8,20,8,21,8,22,9
        !byte 23,9,24,9,25,9,26,9,27,9,27,10,26,11,26,12,26,13,25,13,22,12,21,12
        !byte 18,11,17,10,17,9,13,10,14,10,15,9,16,9,25,12,26,10,24,16,25,15,25,14
        !byte 14,14,15,14,16,13,17,13
        !byte $ff

cube_pu02:
        !byte 12,10,13,11,14,11,15,12,16,13,17,13,18,14,19,14,20,15,20,16,20,17,19,16
        !byte 18,16,17,15,16,15,15,14,14,14,13,13,13,12,12,11,20,7,21,7,22,8,23,8
        !byte 24,9,25,9,26,9,27,10,28,10,28,11,27,12,27,13,26,13,25,12,24,12,23,11
        !byte 22,11,21,10,20,10,20,9,20,8,13,10,14,9,15,9,16,8,17,8,18,8,19,7
        !byte 21,14,22,14,23,13,26,11,27,11,21,16,22,16,23,15,24,15,25,14,26,14,14,13
        !byte 16,12,17,11,18,11,19,10
        !byte $ff

cube_pu03:
        !byte 13,9,14,10,14,11,15,12,15,13,16,14,16,15,17,16,13,10,23,7,24,8,25,9
        !byte 26,10,26,11,27,12,28,13,27,14,26,14,25,13,24,12,24,11,23,10,22,9,23,8
        !byte 14,9,15,9,16,8,17,8,18,8,19,8,20,8,21,7,22,7,18,16,19,15,20,15
        !byte 21,15,22,15,23,14,24,14,25,14,27,13,19,16,23,15,15,11,16,10,17,10,18,10
        !byte 19,10,20,9,21,9
        !byte $ff

cube_pu04:
        !byte 14,9,14,10,14,11,14,12,14,13,14,14,14,15,15,15,15,14,15,13,15,12,15,11
        !byte 15,10,15,9,26,9,26,10,26,11,26,12,26,13,26,14,26,15,25,15,25,14,25,13
        !byte 25,12,25,11,25,10,25,9,16,9,17,9,18,9,19,9,20,9,21,9,22,9,23,9
        !byte 24,9,16,15,17,15,18,15,19,15,20,15,21,15,22,15,23,15,24,15
        !byte $ff

cube_pu05:
        !byte 17,8,16,9,15,10,14,11,14,12,13,13,12,14,14,13,15,12,15,11,16,10,28,11
        !byte 27,12,26,13,25,14,25,15,24,16,23,17,22,16,22,15,23,14,24,13,24,12,25,11
        !byte 26,10,27,11,18,8,19,9,20,9,21,9,22,9,23,10,24,10,25,10,13,14,14,15
        !byte 15,15,16,15,17,15,18,16,19,16,20,16,21,16,22,17,15,13,16,14,17,14,18,14
        !byte 19,14,20,15,21,15,19,8,23,9
        !byte $ff

cube_pu06:
        !byte 20,9,19,10,18,10,17,11,16,11,15,12,14,12,13,13,12,13,13,12,13,11,14,10
        !byte 15,10,16,9,17,9,18,8,19,8,20,7,20,8,28,13,27,14,26,14,25,15,24,15
        !byte 23,16,22,16,21,17,20,17,20,16,20,15,20,14,21,14,22,13,23,13,24,12,25,12
        !byte 26,11,27,11,28,12,21,10,22,10,23,11,24,11,26,12,27,13,13,14,14,14,15,15
        !byte 16,15,17,16,18,16,19,17,14,11,16,12,17,13,18,13,19,14,21,8,22,8,23,9
        !byte 24,9,25,10,26,10
        !byte $ff

cube_pu07:
        !byte 24,11,23,11,22,11,21,12,20,12,19,12,18,12,17,12,16,12,15,13,14,13,13,13
        !byte 12,13,12,12,13,11,13,10,13,9,14,9,15,9,16,8,17,8,18,8,19,8,20,8
        !byte 21,7,22,7,23,7,23,8,24,9,24,10,27,15,26,15,25,15,24,15,23,15,22,16
        !byte 21,16,20,16,19,16,18,16,17,16,17,15,18,14,18,13,19,13,22,12,23,12,25,11
        !byte 26,11,26,12,27,13,27,14,25,12,26,13,26,14,13,14,14,14,15,15,16,15,14,10
        !byte 15,11,16,11,24,8,25,9,25,10
        !byte $ff

cube_pu08:
        !byte 26,13,25,13,24,13,23,13,22,13,21,13,20,13,19,13,18,13,17,13,16,13,15,13
        !byte 14,13,14,12,14,11,14,10,14,9,14,8,15,8,16,8,17,8,18,8,19,8,20,8
        !byte 21,8,22,8,23,8,24,8,25,8,26,8,26,9,26,10,26,11,26,12,25,15,24,15
        !byte 23,15,22,15,21,15,20,15,19,15,18,15,17,15,16,15,15,15,15,14,15,12,15,11
        !byte 16,11,17,11,18,11,19,11,20,11,21,11,22,11,23,11,24,11,25,11,25,12,25,14
        !byte 15,10,25,10
        !byte $ff

cube_pu09:
        !byte 28,14,27,14,26,14,25,14,24,14,23,14,22,14,21,14,20,14,19,14,18,14,17,14
        !byte 17,13,17,12,17,11,17,10,17,9,17,8,18,8,19,8,20,8,21,8,22,9,23,9
        !byte 24,9,25,9,26,9,27,9,27,10,27,11,28,12,28,13,22,15,21,15,20,15,19,15
        !byte 18,15,17,15,16,15,15,15,14,15,13,15,13,14,13,13,14,12,14,11,14,10,15,10
        !byte 16,10,18,10,19,10,20,10,21,10,22,10,22,11,22,12,22,13,25,15,24,15,23,15
        !byte 16,14,16,9,15,9,24,10,23,10
        !byte $ff

cube_pu10:
        !byte 27,14,26,14,25,15,24,15,23,15,22,15,21,16,20,16,20,15,20,14,20,13,20,12
        !byte 20,11,20,10,21,10,22,10,23,10,24,10,25,10,26,10,27,10,28,10,28,11,27,12
        !byte 27,13,19,14,18,14,17,14,16,14,15,14,14,14,13,14,13,13,12,12,12,11,12,10
        !byte 13,10,14,10,15,10,16,9,17,9,18,9,19,9,20,9,25,14,24,14,23,14,22,14
        !byte 21,14,19,16,18,15,17,15,16,15,15,15,19,10,18,10,17,10,16,10,24,9,23,9
        !byte 22,9,21,9
        !byte $ff

cube_pu11:
        !byte 26,13,25,14,24,15,23,16,23,15,23,14,24,13,24,12,24,11,25,10,26,10,27,9
        !byte 27,10,26,11,26,12,18,13,17,13,16,14,15,14,14,15,13,15,13,14,13,13,12,12
        !byte 12,11,12,10,13,10,14,10,15,9,16,9,17,9,17,10,18,11,18,12,25,13,23,13
        !byte 22,13,21,13,20,13,19,13,22,16,21,16,20,16,19,16,18,15,17,15,16,15,15,15
        !byte 23,11,22,11,21,11,20,11,19,11,18,10,16,10,15,10,26,9,25,9,24,9,23,9
        !byte 22,9,21,9,20,9,19,9,18,9
        !byte $ff

cube_pu12:
        !byte 24,12,24,13,25,14,25,15,25,16,26,14,26,13,26,12,26,11,25,10,25,9,25,8
        !byte 24,10,24,11,16,12,16,13,15,14,15,15,15,16,14,14,14,13,14,12,14,11,15,10
        !byte 15,9,15,8,16,10,16,11,23,12,22,12,21,12,20,12,19,12,18,12,17,12,24,16
        !byte 23,16,22,16,21,16,20,16,19,16,18,16,17,16,16,16,25,12,15,12,24,8,23,8
        !byte 22,8,21,8,20,8,19,8,18,8,17,8,16,8
        !byte $ff

cube_pu13:
        !byte 22,10,23,11,24,12,25,13,26,14,27,15,27,14,28,13,28,12,27,11,26,10,25,9
        !byte 24,8,23,7,23,8,22,9,14,12,15,13,15,14,16,15,16,16,17,17,17,16,17,15
        !byte 17,14,16,13,15,12,15,11,14,10,13,9,13,10,14,11,21,10,20,11,19,11,18,11
        !byte 17,11,16,12,26,15,25,15,24,16,23,16,22,16,21,16,20,16,19,17,18,17,27,12
        !byte 26,12,24,13,23,13,22,13,21,13,20,13,19,14,18,14,22,7,21,7,20,8,19,8
        !byte 18,8,17,8,16,8,15,9,14,9
        !byte $ff

cube_pu14:
        !byte 20,9,21,10,22,10,23,11,24,11,25,12,26,12,27,13,28,12,28,11,27,10,26,10
        !byte 25,9,24,9,23,8,22,8,21,7,20,7,20,8,13,13,14,14,15,14,16,15,17,15
        !byte 18,16,19,16,20,17,20,16,19,15,18,15,17,14,16,13,15,13,14,12,13,12,12,11
        !byte 19,10,18,10,17,11,16,11,15,12,26,14,25,14,24,15,23,15,22,16,21,16,27,12
        !byte 25,13,24,14,23,14,22,15,21,15,19,8,18,8,17,9,16,9,15,10,14,10,13,11
        !byte $ff

cube_pu15:
        !byte 17,8,18,8,19,9,20,9,21,9,22,10,23,10,24,10,25,11,26,11,27,10,28,10
        !byte 26,10,25,9,24,9,23,9,22,9,19,8,14,14,15,14,16,14,17,15,18,15,19,15
        !byte 20,15,21,16,22,16,23,16,16,15,15,15,13,14,12,14,16,9,16,10,15,11,15,12
        !byte 14,13,25,12,25,13,24,14,24,15,27,11,26,12,25,14,15,10,14,11,14,12,13,13
        !byte $ff


; =====================================================================
; Song order: 112 patterns * 1.6 sec = 179.2 sec
; Format per pattern: bass, drum, lead, flags
; flags bit0 = chorus lead, bit1 = build filter
; =====================================================================
order:
order_intro:
        !byte 0,0,0,0,0,1,0,0,1,1,0,0,1,2,1,0
        !byte 1,2,1,0,2,2,0,0,3,2,1,0,4,2,0,0
order_verse1:
        !byte 1,2,5,0,2,2,5,0,3,2,5,0,4,2,5,0
        !byte 1,2,0,0,2,2,5,0,3,2,0,0,4,2,5,0
        !byte 1,2,5,0,2,2,6,0,3,2,5,0,4,2,6,0
        !byte 1,2,0,0,2,2,5,0,3,2,6,0,4,2,5,0
order_build1:
        !byte 1,3,2,2,2,3,3,2,3,3,2,2,4,3,3,2
        !byte 1,5,6,2,2,5,6,2,3,5,6,2,4,5,6,2
order_chorus1:
        !byte 1,3,1,1,2,3,2,1,3,3,3,1,4,3,4,1
        !byte 1,4,1,1,2,4,2,1,3,4,3,1,4,4,4,1
        !byte 1,3,1,1,2,3,2,1,3,3,3,1,4,3,4,1
        !byte 1,4,7,1,2,4,8,1,3,4,9,1,4,4,10,1
order_verse2:
        !byte 1,2,5,0,2,2,6,0,3,2,5,0,4,2,6,0
        !byte 1,2,0,0,2,2,5,0,3,2,6,0,4,2,5,0
        !byte 1,2,5,0,2,2,5,0,3,2,6,0,4,2,6,0
        !byte 1,2,0,0,2,2,5,0,3,2,0,0,4,2,6,0
order_build2:
        !byte 1,3,2,2,2,3,3,2,3,3,2,2,4,3,3,2
        !byte 1,5,6,2,2,5,6,2,3,5,6,2,4,5,6,2
order_chorus2:
        !byte 1,3,1,1,2,3,2,1,3,3,3,1,4,3,4,1
        !byte 1,4,7,1,2,4,8,1,3,4,9,1,4,4,10,1
        !byte 1,3,7,1,2,3,8,1,3,3,9,1,4,3,10,1
        !byte 1,4,1,1,2,4,8,1,3,4,3,1,4,4,10,1
order_break:
        !byte 0,1,0,2,1,0,5,2,2,1,0,2,3,1,6,2
        !byte 0,6,5,2,1,2,6,2,2,6,5,2,3,5,6,2
order_final:
        !byte 1,5,7,3,2,6,8,3,3,5,9,3,4,6,10,3
        !byte 1,5,7,3,2,6,8,3,3,5,9,3,4,6,10,3
        !byte 1,5,1,3,2,5,8,3,3,5,3,3,4,5,10,3
order_outro:
        !byte 1,2,5,0,2,2,0,0,3,1,0,0,4,1,0,0
        !byte $ff

; =====================================================================
; Pattern data
; Note index: 1=C0, 46=A3, 58=A4, 70=A5
; =====================================================================
; ---------------------------------------------------------------------
; V4.7_LIGHT_FLASH_DEPTH_FX coordinate frames
; Sparse bright overlays.  These replace the failed V4.6 layer-order idea
; with simple, readable light bursts/CRT flares/rim hits drawn after cube.
; ---------------------------------------------------------------------
crystal_snap_fr00:
        !byte 12,7,20,5,28,7,34,12,28,17,20,19,12,17,$ff
crystal_snap_fr01:
        !byte 13,7,21,5,29,7,35,12,29,17,21,19,13,17,$ff
crystal_snap_fr02:
        !byte 14,8,22,6,30,8,35,13,30,18,22,20,14,18,$ff
crystal_snap_fr03:
        !byte 13,8,23,6,31,9,35,13,31,18,23,20,13,18,$ff
crystal_snap_fr04:
        !byte 12,9,22,7,30,10,35,14,30,19,22,20,12,19,$ff
crystal_snap_fr05:
        !byte 11,8,21,6,29,9,34,13,29,18,21,19,11,18,$ff
crystal_snap_fr06:
        !byte 10,8,20,6,28,9,33,13,28,18,20,19,10,18,$ff
crystal_snap_fr07:
        !byte 9,7,19,5,27,8,32,12,27,17,19,18,9,17,$ff
crystal_snap_fr08:
        !byte 10,6,20,4,28,7,33,11,28,16,20,18,10,16,$ff
crystal_snap_fr09:
        !byte 11,6,21,4,29,7,34,11,29,16,21,18,11,16,$ff
crystal_snap_fr10:
        !byte 12,5,22,4,30,7,35,11,30,16,22,17,12,16,$ff
crystal_snap_fr11:
        !byte 13,6,23,5,31,8,35,12,31,17,23,18,13,17,$ff
crystal_snap_fr12:
        !byte 12,6,22,4,30,8,35,12,30,17,22,18,12,17,$ff
crystal_snap_fr13:
        !byte 11,7,21,5,29,8,34,12,29,17,21,18,11,17,$ff
crystal_snap_fr14:
        !byte 10,7,20,5,28,8,33,12,28,17,20,18,10,17,$ff
crystal_snap_fr15:
        !byte 11,8,19,6,27,9,33,13,27,18,19,19,11,18,$ff

apex_flash_fr00:
        !byte 20,5,35,12,20,20,8,12,$ff
apex_flash_fr01:
        !byte 21,5,35,12,21,20,9,12,$ff
apex_flash_fr02:
        !byte 22,6,35,13,22,20,10,13,$ff
apex_flash_fr03:
        !byte 23,6,35,13,23,20,11,13,$ff
apex_flash_fr04:
        !byte 22,7,35,14,22,21,10,14,$ff
apex_flash_fr05:
        !byte 21,6,34,13,21,20,9,13,$ff
apex_flash_fr06:
        !byte 20,6,33,13,20,20,8,13,$ff
apex_flash_fr07:
        !byte 19,5,32,12,19,19,7,12,$ff
apex_flash_fr08:
        !byte 20,4,33,11,20,18,8,11,$ff
apex_flash_fr09:
        !byte 21,4,34,11,21,18,9,11,$ff
apex_flash_fr10:
        !byte 22,4,35,11,22,17,10,11,$ff
apex_flash_fr11:
        !byte 23,5,35,12,23,18,11,12,$ff
apex_flash_fr12:
        !byte 22,4,35,12,22,18,10,12,$ff
apex_flash_fr13:
        !byte 21,5,34,12,21,18,9,12,$ff
apex_flash_fr14:
        !byte 20,5,33,12,20,18,8,12,$ff
apex_flash_fr15:
        !byte 19,6,33,13,19,19,7,13,$ff

neon_focus_fr00:
        !byte 20,12,19,12,21,12,20,11,20,13,18,12,22,12,$ff
neon_focus_fr01:
        !byte 21,12,20,12,22,12,21,11,21,13,$ff
neon_focus_fr02:
        !byte 22,13,21,13,23,13,22,12,22,14,$ff
neon_focus_fr03:
        !byte 22,13,21,13,23,13,22,12,22,14,20,13,24,13,$ff
neon_focus_fr04:
        !byte 21,14,20,14,22,14,21,13,21,15,$ff
neon_focus_fr05:
        !byte 20,14,19,14,21,14,20,13,20,15,$ff
neon_focus_fr06:
        !byte 19,13,18,13,20,13,19,12,19,14,17,13,21,13,$ff
neon_focus_fr07:
        !byte 18,12,17,12,19,12,18,11,18,13,$ff
neon_focus_fr08:
        !byte 19,11,18,11,20,11,19,10,19,12,$ff
neon_focus_fr09:
        !byte 20,10,19,10,21,10,20,9,20,11,18,10,22,10,$ff
neon_focus_fr10:
        !byte 21,10,20,10,22,10,21,9,21,11,$ff
neon_focus_fr11:
        !byte 22,11,21,11,23,11,22,10,22,12,$ff
neon_focus_fr12:
        !byte 21,11,20,11,22,11,21,10,21,12,19,11,23,11,$ff
neon_focus_fr13:
        !byte 20,12,19,12,21,12,20,11,20,13,$ff
neon_focus_fr14:
        !byte 19,12,18,12,20,12,19,11,19,13,$ff
neon_focus_fr15:
        !byte 18,13,17,13,19,13,18,12,18,14,16,13,20,13,$ff

safe_wide_rim_fr00:
        !byte 6,12,8,8,18,5,28,8,34,12,28,17,18,20,8,17,16,12,24,12,$ff
safe_wide_rim_fr01:
        !byte 7,12,10,7,20,5,30,8,34,13,30,18,20,20,10,17,15,13,25,13,$ff
safe_wide_rim_fr02:
        !byte 8,13,12,7,22,6,32,9,34,14,32,17,22,19,12,18,16,12,24,12,$ff
safe_wide_rim_fr03:
        !byte 7,14,13,8,23,6,33,10,34,15,31,18,21,20,11,18,15,13,25,13,$ff
safe_wide_rim_fr04:
        !byte 6,15,12,9,22,7,32,10,33,15,29,18,19,20,9,17,16,12,24,12,$ff
safe_wide_rim_fr05:
        !byte 5,14,10,9,20,6,30,9,34,14,28,17,18,19,8,17,15,13,25,13,$ff
safe_wide_rim_fr06:
        !byte 6,13,9,8,18,5,28,8,33,13,27,18,17,20,7,17,16,12,24,12,$ff
safe_wide_rim_fr07:
        !byte 7,12,11,7,19,5,29,8,34,12,29,17,19,20,9,18,15,13,25,13,$ff
safe_wide_rim_fr08:
        !byte 8,11,12,6,20,5,30,7,34,11,30,16,20,19,10,17,16,12,24,12,$ff
safe_wide_rim_fr09:
        !byte 9,10,13,6,22,5,32,8,34,12,31,17,21,20,11,18,15,13,25,13,$ff
safe_wide_rim_fr10:
        !byte 8,10,12,7,23,6,33,9,34,13,32,18,22,20,12,18,16,12,24,12,$ff
safe_wide_rim_fr11:
        !byte 7,11,11,7,22,5,32,8,33,12,30,17,20,19,10,16,15,13,25,13,$ff
safe_wide_rim_fr12:
        !byte 6,12,10,8,20,6,30,9,34,13,29,18,19,20,9,17,16,12,24,12,$ff
safe_wide_rim_fr13:
        !byte 5,13,9,9,18,6,28,9,33,14,27,18,17,19,7,17,15,13,25,13,$ff
safe_wide_rim_fr14:
        !byte 6,14,10,8,19,5,29,8,34,13,28,17,18,20,8,18,16,12,24,12,$ff
safe_wide_rim_fr15:
        !byte 7,13,11,7,21,5,31,8,34,12,30,17,20,20,10,18,15,13,25,13,$ff

inner_depth_weave_fr00:
        !byte 10,10,16,8,22,8,28,10,30,14,24,17,18,17,12,14,$ff
inner_depth_weave_fr01:
        !byte 11,10,17,7,23,8,29,11,30,15,23,18,17,17,12,13,$ff
inner_depth_weave_fr02:
        !byte 12,11,18,7,24,8,30,12,29,16,22,18,16,17,11,14,$ff
inner_depth_weave_fr03:
        !byte 13,12,19,8,25,9,31,13,28,17,21,18,15,16,10,14,$ff
inner_depth_weave_fr04:
        !byte 12,13,18,9,24,9,30,14,27,18,20,17,14,16,9,15,$ff
inner_depth_weave_fr05:
        !byte 11,13,17,10,23,9,29,13,28,17,21,16,15,15,10,14,$ff
inner_depth_weave_fr06:
        !byte 10,12,16,9,22,8,28,12,29,16,22,17,16,16,11,13,$ff
inner_depth_weave_fr07:
        !byte 9,11,15,8,21,8,27,11,30,15,23,18,17,17,12,14,$ff
inner_depth_weave_fr08:
        !byte 10,10,16,7,22,7,28,10,31,14,24,18,18,18,12,15,$ff
inner_depth_weave_fr09:
        !byte 11,9,17,7,23,8,29,11,32,15,25,18,19,17,13,14,$ff
inner_depth_weave_fr10:
        !byte 12,9,18,8,24,9,30,12,33,14,26,17,20,16,14,13,$ff
inner_depth_weave_fr11:
        !byte 13,10,19,8,25,8,31,11,32,13,25,16,19,16,13,13,$ff
inner_depth_weave_fr12:
        !byte 12,11,18,9,24,9,30,12,31,14,24,17,18,17,12,14,$ff
inner_depth_weave_fr13:
        !byte 11,12,17,10,23,9,29,13,30,15,23,18,17,17,11,14,$ff
inner_depth_weave_fr14:
        !byte 10,12,16,9,22,8,28,12,29,16,22,17,16,16,10,13,$ff
inner_depth_weave_fr15:
        !byte 9,11,15,8,21,8,27,11,30,15,23,18,17,17,11,14,$ff

; V6.4 smooth perspective-orbit anchors.  Eight points per frame: two
; front-bright anchors, two rear anchors, and four converging diagonal
; anchors.  Motion is monotonic over 16 frames and locked to vis_frame.
perspective_orbit_fr00:
        !byte 20,6,25,8,31,11,34,14,30,17,24,19,18,18,13,14,$ff
perspective_orbit_fr01:
        !byte 22,6,27,8,32,11,34,13,29,17,23,19,17,18,12,14,$ff
perspective_orbit_fr02:
        !byte 24,7,29,9,33,12,34,15,28,18,22,19,16,17,11,13,$ff
perspective_orbit_fr03:
        !byte 25,8,30,10,33,13,33,16,27,18,21,18,15,16,10,12,$ff
perspective_orbit_fr04:
        !byte 26,10,31,12,33,15,32,17,26,18,20,17,14,15,10,11,$ff
perspective_orbit_fr05:
        !byte 25,12,30,14,32,16,31,18,25,18,19,16,13,14,11,10,$ff
perspective_orbit_fr06:
        !byte 24,14,29,16,31,18,29,19,24,18,18,15,12,13,11,9,$ff
perspective_orbit_fr07:
        !byte 22,15,27,17,29,19,27,19,23,17,17,14,12,12,12,8,$ff
perspective_orbit_fr08:
        !byte 20,16,25,18,27,19,25,19,22,17,16,13,12,11,13,8,$ff
perspective_orbit_fr09:
        !byte 18,15,23,17,25,19,23,19,21,17,15,14,11,12,12,8,$ff
perspective_orbit_fr10:
        !byte 16,14,21,16,23,18,21,19,20,18,14,15,10,13,11,9,$ff
perspective_orbit_fr11:
        !byte 15,12,20,14,22,16,20,18,19,18,13,16,10,14,11,10,$ff
perspective_orbit_fr12:
        !byte 14,10,19,12,21,15,20,17,18,18,12,17,10,15,10,11,$ff
perspective_orbit_fr13:
        !byte 15,8,20,10,22,13,21,16,19,18,13,18,10,16,10,12,$ff
perspective_orbit_fr14:
        !byte 16,7,21,9,23,12,23,15,20,18,14,19,11,17,11,13,$ff
perspective_orbit_fr15:
        !byte 18,6,23,8,25,11,25,14,21,17,15,19,12,18,12,14,$ff


; V6.5 phase-locked kinematic vanishing rails.  Seven points per frame:
; three front-to-rear rail anchors, two counter-motion rear anchors, and two
; diagonal depth anchors.  All x<=33 and y 7..18, so V6.1/V5.9 edge scrub
; cannot be touched.  Motion is coherent over 16 frames and locked to vis_frame.
kinematic_rail_fr00:
        !byte 12,7,18,9,24,11,30,13,26,16,20,18,15,16,$ff
kinematic_rail_fr01:
        !byte 13,7,19,8,25,10,31,12,27,15,21,17,16,16,$ff
kinematic_rail_fr02:
        !byte 14,8,20,8,26,10,32,12,28,15,22,17,17,16,$ff
kinematic_rail_fr03:
        !byte 15,9,21,9,27,11,33,13,28,16,22,18,16,17,$ff
kinematic_rail_fr04:
        !byte 16,10,22,10,28,12,33,14,27,17,21,18,15,17,$ff
kinematic_rail_fr05:
        !byte 15,11,21,11,27,13,32,15,26,17,20,18,14,16,$ff
kinematic_rail_fr06:
        !byte 14,12,20,12,26,14,31,16,25,18,19,17,13,15,$ff
kinematic_rail_fr07:
        !byte 13,13,19,13,25,15,30,17,24,18,18,16,12,14,$ff
kinematic_rail_fr08:
        !byte 12,14,18,14,24,16,29,18,23,17,17,15,11,13,$ff
kinematic_rail_fr09:
        !byte 11,13,17,13,23,15,28,17,22,16,16,14,10,12,$ff
kinematic_rail_fr10:
        !byte 10,12,16,12,22,14,27,16,21,15,15,13,9,11,$ff
kinematic_rail_fr11:
        !byte 9,11,15,11,21,13,26,15,20,14,14,12,8,10,$ff
kinematic_rail_fr12:
        !byte 8,10,14,10,20,12,25,14,19,13,13,11,7,9,$ff
kinematic_rail_fr13:
        !byte 9,9,15,9,21,11,26,13,20,13,14,12,8,10,$ff
kinematic_rail_fr14:
        !byte 10,8,16,8,22,10,27,12,21,14,15,13,9,11,$ff
kinematic_rail_fr15:
        !byte 11,7,17,8,23,10,28,12,22,15,16,14,10,12,$ff


; V6.6 phase-hinge front/back anchors.  Six points per frame: two front
; hinge anchors, two rear inverse-phase anchors, and two center vanishing
; pivots.  Motion is phase-matched with orbit/rails but offset by 12 frames.
; All x<=33 and y 7..18 to preserve V6.x no-wrap viewport.
phase_hinge_fr00:
        !byte 11,8,17,9,24,11,33,14,27,17,19,16,$ff
phase_hinge_fr01:
        !byte 12,8,18,9,25,10,33,13,28,16,20,16,$ff
phase_hinge_fr02:
        !byte 13,9,19,9,26,10,32,12,29,16,21,15,$ff
phase_hinge_fr03:
        !byte 14,10,20,10,27,11,31,12,30,15,22,15,$ff
phase_hinge_fr04:
        !byte 15,11,21,11,28,12,30,13,31,15,23,14,$ff
phase_hinge_fr05:
        !byte 16,12,22,12,29,13,29,14,30,16,22,14,$ff
phase_hinge_fr06:
        !byte 15,13,21,13,28,14,28,15,29,17,21,15,$ff
phase_hinge_fr07:
        !byte 14,14,20,14,27,15,27,16,28,18,20,16,$ff
phase_hinge_fr08:
        !byte 13,15,19,15,26,16,26,17,27,18,19,17,$ff
phase_hinge_fr09:
        !byte 12,14,18,14,25,15,25,17,26,18,18,17,$ff
phase_hinge_fr10:
        !byte 11,13,17,13,24,14,24,16,25,17,17,16,$ff
phase_hinge_fr11:
        !byte 10,12,16,12,23,13,23,15,24,16,16,15,$ff
phase_hinge_fr12:
        !byte 9,11,15,11,22,12,24,14,23,15,15,14,$ff
phase_hinge_fr13:
        !byte 10,10,16,10,23,11,25,13,24,15,16,14,$ff
phase_hinge_fr14:
        !byte 11,9,17,9,24,10,27,13,25,16,17,15,$ff
phase_hinge_fr15:
        !byte 12,8,18,8,25,10,30,13,26,17,18,16,$ff

; V6.7 interpolated motion-spline depth guide.  Six points per frame form
; a smooth S-curve between orbit/rail/hinge phases.  All coordinates stay
; within x<=32/y 8..18 and selection is locked to vis_frame.
motion_spline_fr00:
        !byte 10,9,15,10,20,11,25,12,31,14,24,17,$ff
motion_spline_fr01:
        !byte 11,9,16,9,21,10,26,12,32,13,25,16,$ff
motion_spline_fr02:
        !byte 12,8,17,9,22,10,27,11,32,13,26,16,$ff
motion_spline_fr03:
        !byte 13,8,18,9,23,10,28,12,31,14,27,16,$ff
motion_spline_fr04:
        !byte 14,9,19,10,24,11,29,13,30,15,26,17,$ff
motion_spline_fr05:
        !byte 15,10,20,11,25,12,29,14,29,16,25,17,$ff
motion_spline_fr06:
        !byte 14,11,19,12,24,13,28,15,28,17,24,18,$ff
motion_spline_fr07:
        !byte 13,12,18,13,23,14,27,16,27,18,23,18,$ff
motion_spline_fr08:
        !byte 12,13,17,14,22,15,26,17,26,18,22,17,$ff
motion_spline_fr09:
        !byte 11,13,16,14,21,15,25,17,25,18,21,17,$ff
motion_spline_fr10:
        !byte 10,12,15,13,20,14,24,16,24,17,20,16,$ff
motion_spline_fr11:
        !byte 9,11,14,12,19,13,23,15,23,16,19,15,$ff
motion_spline_fr12:
        !byte 8,10,13,11,18,12,22,14,24,15,18,14,$ff
motion_spline_fr13:
        !byte 9,9,14,10,19,11,23,13,26,15,19,14,$ff
motion_spline_fr14:
        !byte 10,8,15,9,20,10,24,12,28,14,21,15,$ff
motion_spline_fr15:
        !byte 11,8,16,9,21,10,25,12,30,14,23,16,$ff

; V6.8 phase-correct depth-normal vector anchors.  Four paired points per
; frame: two front normals and two inverse rear normals.  They are intentionally
; sparse, coherent, and inside x<=32/y 8..17 so edge scrub never touches them.
depth_normal_fr00:
        !byte 16,9,20,10,28,14,24,16,$ff
depth_normal_fr01:
        !byte 17,9,21,10,29,13,25,16,$ff
depth_normal_fr02:
        !byte 18,8,22,10,30,13,26,15,$ff
depth_normal_fr03:
        !byte 19,8,23,11,31,13,27,15,$ff
depth_normal_fr04:
        !byte 20,9,24,11,32,14,28,15,$ff
depth_normal_fr05:
        !byte 21,10,25,12,31,15,27,16,$ff
depth_normal_fr06:
        !byte 20,11,24,13,30,16,26,17,$ff
depth_normal_fr07:
        !byte 19,12,23,14,29,17,25,17,$ff
depth_normal_fr08:
        !byte 18,13,22,15,28,17,24,16,$ff
depth_normal_fr09:
        !byte 17,13,21,15,27,17,23,16,$ff
depth_normal_fr10:
        !byte 16,12,20,14,26,16,22,15,$ff
depth_normal_fr11:
        !byte 15,11,19,13,25,15,21,14,$ff
depth_normal_fr12:
        !byte 14,10,18,12,24,14,20,13,$ff
depth_normal_fr13:
        !byte 15,9,19,11,25,13,21,13,$ff
depth_normal_fr14:
        !byte 16,8,20,10,26,13,22,14,$ff
depth_normal_fr15:
        !byte 17,8,21,10,27,14,23,15,$ff

; V6.9 phase-correct depth-inertia anchors.  Three lead/trail point pairs per
; frame.  The path is intentionally one-frame-smoothed versus depth_normal,
; staying inside x<=32/y 8..17 so the viewport scrub never erases/bleeds it.
depth_inertia_fr00:
        !byte 15,10,19,10,23,12,29,15,25,16,21,14,$ff
depth_inertia_fr01:
        !byte 16,9,20,10,24,12,30,14,26,16,22,14,$ff
depth_inertia_fr02:
        !byte 17,9,21,10,25,12,31,14,27,15,23,13,$ff
depth_inertia_fr03:
        !byte 18,8,22,10,26,12,32,14,28,15,24,13,$ff
depth_inertia_fr04:
        !byte 19,8,23,11,27,13,32,15,28,16,24,14,$ff
depth_inertia_fr05:
        !byte 20,9,24,12,28,14,31,16,27,17,23,15,$ff
depth_inertia_fr06:
        !byte 21,10,25,13,28,15,30,17,26,17,22,16,$ff
depth_inertia_fr07:
        !byte 20,11,24,14,27,16,29,17,25,16,21,15,$ff
depth_inertia_fr08:
        !byte 19,12,23,15,26,16,28,17,24,16,20,14,$ff
depth_inertia_fr09:
        !byte 18,13,22,15,25,16,27,16,23,15,19,13,$ff
depth_inertia_fr10:
        !byte 17,13,21,14,24,15,26,16,22,14,18,12,$ff
depth_inertia_fr11:
        !byte 16,12,20,13,23,14,25,15,21,13,17,11,$ff
depth_inertia_fr12:
        !byte 15,11,19,12,22,13,24,14,20,12,16,10,$ff
depth_inertia_fr13:
        !byte 14,10,18,11,21,12,25,13,21,12,17,10,$ff
depth_inertia_fr14:
        !byte 15,9,19,10,22,12,26,13,22,13,18,11,$ff
depth_inertia_fr15:
        !byte 16,9,20,10,23,12,28,14,24,15,20,13,$ff

; V7.0 phase-correct centroid/axis-lock anchors.  Three centre/axis pairs per
; frame: centre of mass, near-axis, rear-axis.  All points x<=31/y 9..16 and
; smoothed over 16 frames so the whole depth stack reads as one coherent body.
centroid_lock_fr00:
        !byte 20,12,18,11,22,13,16,12,24,12,28,14,$ff
centroid_lock_fr01:
        !byte 21,12,19,11,23,13,17,11,25,12,29,14,$ff
centroid_lock_fr02:
        !byte 22,12,20,11,24,13,18,10,26,12,30,13,$ff
centroid_lock_fr03:
        !byte 23,12,21,11,25,13,19,10,27,12,31,13,$ff
centroid_lock_fr04:
        !byte 24,13,22,12,26,14,20,10,28,13,31,14,$ff
centroid_lock_fr05:
        !byte 24,14,22,13,26,15,21,11,28,14,30,15,$ff
centroid_lock_fr06:
        !byte 23,15,21,14,25,16,20,12,27,15,29,16,$ff
centroid_lock_fr07:
        !byte 22,15,20,14,24,16,19,13,26,15,28,16,$ff
centroid_lock_fr08:
        !byte 21,15,19,14,23,16,18,14,25,15,27,16,$ff
centroid_lock_fr09:
        !byte 20,14,18,13,22,15,17,14,24,14,26,15,$ff
centroid_lock_fr10:
        !byte 19,13,17,12,21,14,16,13,23,13,25,14,$ff
centroid_lock_fr11:
        !byte 18,12,16,11,20,13,15,12,22,12,24,13,$ff
centroid_lock_fr12:
        !byte 17,12,15,11,19,13,14,11,21,12,23,13,$ff
centroid_lock_fr13:
        !byte 18,11,16,10,20,12,15,10,22,11,24,12,$ff
centroid_lock_fr14:
        !byte 19,11,17,10,21,12,16,10,23,11,26,13,$ff
centroid_lock_fr15:
        !byte 20,11,18,10,22,12,16,11,24,11,27,13,$ff
; V7.2 phase-correct coherent-body anchors.  Four centre-weighted point pairs
; per frame: body centroid, near normal, rear counter-normal, and diagonal mass
; cue.  All points x<=30/y 9..16 and smoothed over 16 frames so the full motion
; stack reads as one coherent rigid cube body.
coherent_body_fr00:
        !byte 20,12,22,12,18,12,24,14,16,10,$ff
coherent_body_fr01:
        !byte 21,12,23,12,19,12,25,14,17,10,$ff
coherent_body_fr02:
        !byte 22,12,24,12,20,12,26,13,18,10,$ff
coherent_body_fr03:
        !byte 23,12,25,12,21,12,27,13,19,10,$ff
coherent_body_fr04:
        !byte 24,13,26,13,22,12,28,13,20,10,$ff
coherent_body_fr05:
        !byte 24,14,26,14,22,13,29,14,20,11,$ff
coherent_body_fr06:
        !byte 23,15,25,15,21,14,30,15,19,12,$ff
coherent_body_fr07:
        !byte 22,15,24,15,20,14,29,16,18,13,$ff
coherent_body_fr08:
        !byte 21,15,23,15,19,14,28,16,17,14,$ff
coherent_body_fr09:
        !byte 20,14,22,14,18,13,27,15,16,14,$ff
coherent_body_fr10:
        !byte 19,13,21,13,17,12,26,14,15,13,$ff
coherent_body_fr11:
        !byte 18,12,20,12,16,12,25,13,14,12,$ff
coherent_body_fr12:
        !byte 17,12,19,12,15,12,24,13,13,11,$ff
coherent_body_fr13:
        !byte 18,11,20,11,16,11,25,12,14,10,$ff
coherent_body_fr14:
        !byte 19,11,21,11,17,11,26,13,15,10,$ff
coherent_body_fr15:
        !byte 20,11,22,11,18,11,27,13,16,10,$ff

; V7.4_PHASE_FUSED_BODY_MOTION_FX
; V7.3 phase-correct temporal-coherence anchors.  Three centre-weighted pairs
; per frame: bridge, axis-memory, and near/rear blend.  It fills the gap between
; coherent-body and eased-vector cues so the cube reads as one continuous
; rotation, not frame-by-frame dots.  All points x<=30/y 9..16.
temporal_coherence_fr00:
        !byte 20,12,21,12,19,12,23,13,17,11,27,14,$ff
temporal_coherence_fr01:
        !byte 21,12,22,12,20,12,24,13,18,10,28,14,$ff
temporal_coherence_fr02:
        !byte 22,12,23,12,21,12,25,13,19,10,29,13,$ff
temporal_coherence_fr03:
        !byte 23,12,24,12,22,12,26,13,20,10,30,13,$ff
temporal_coherence_fr04:
        !byte 24,13,25,13,23,12,27,13,21,10,30,14,$ff
temporal_coherence_fr05:
        !byte 24,14,25,14,23,13,28,14,21,11,29,15,$ff
temporal_coherence_fr06:
        !byte 23,15,24,15,22,14,29,15,20,12,28,16,$ff
temporal_coherence_fr07:
        !byte 22,15,23,15,21,14,28,16,19,13,27,16,$ff
temporal_coherence_fr08:
        !byte 21,15,22,15,20,14,27,16,18,14,26,16,$ff
temporal_coherence_fr09:
        !byte 20,14,21,14,19,13,26,15,17,14,25,15,$ff
temporal_coherence_fr10:
        !byte 19,13,20,13,18,12,25,14,16,13,24,14,$ff
temporal_coherence_fr11:
        !byte 18,12,19,12,17,12,24,13,15,12,23,13,$ff
temporal_coherence_fr12:
        !byte 17,12,18,12,16,12,23,13,14,11,22,13,$ff
temporal_coherence_fr13:
        !byte 18,11,19,11,17,11,24,12,15,10,23,12,$ff
temporal_coherence_fr14:
        !byte 19,11,20,11,18,11,25,13,16,10,25,13,$ff
temporal_coherence_fr15:
        !byte 20,11,21,11,19,11,26,13,17,10,26,13,$ff


; V7.4 phase-fused rigid-body anchors.  Three pairs per frame: a centre-line
; body pair, an eased near-axis pair, and a counter-phase rear-memory pair.
; These are intentionally x<=30/y 9..16 and phase-correct, so they improve the
; 3D illusion without wrap, shimmer, or random starfield timing.
phase_fused_body_fr00:
        !byte 20,12,21,12,19,13,24,13,17,11,27,14,$ff
phase_fused_body_fr01:
        !byte 21,12,22,12,20,13,25,13,18,10,28,14,$ff
phase_fused_body_fr02:
        !byte 22,12,23,12,21,13,26,13,19,10,29,14,$ff
phase_fused_body_fr03:
        !byte 23,12,24,12,22,13,27,14,20,10,30,13,$ff
phase_fused_body_fr04:
        !byte 24,13,25,13,23,13,28,14,21,10,30,14,$ff
phase_fused_body_fr05:
        !byte 24,14,25,14,23,14,28,15,21,11,29,15,$ff
phase_fused_body_fr06:
        !byte 23,15,24,15,22,14,27,15,20,12,28,16,$ff
phase_fused_body_fr07:
        !byte 22,15,23,15,21,14,26,16,19,13,27,16,$ff
phase_fused_body_fr08:
        !byte 21,15,22,15,20,14,25,16,18,14,26,16,$ff
phase_fused_body_fr09:
        !byte 20,14,21,14,19,14,24,15,17,14,25,15,$ff
phase_fused_body_fr10:
        !byte 19,13,20,13,18,13,23,14,16,13,24,14,$ff
phase_fused_body_fr11:
        !byte 18,12,19,12,17,13,22,13,15,12,23,13,$ff
phase_fused_body_fr12:
        !byte 17,12,18,12,16,12,21,13,14,11,22,13,$ff
phase_fused_body_fr13:
        !byte 18,11,19,11,17,12,22,12,15,10,23,12,$ff
phase_fused_body_fr14:
        !byte 19,11,20,11,18,12,23,12,16,10,25,13,$ff
phase_fused_body_fr15:
        !byte 20,11,21,11,19,12,24,13,17,10,26,13,$ff

; V7.5_MOTION_CONVERGENCE_LOCK_FX
; phase-correct motion-convergence anchors.  Six points per frame:
; centre convergence, near-axis convergence and rear damped memory cue.
; x<=29/y 9..16, no star_phase jitter, no SID-tail lag, no right-wrap risk.
motion_convergence_fr00:
        !byte 20,12,21,12,19,12,24,13,17,11,28,14,$ff
motion_convergence_fr01:
        !byte 21,12,22,12,20,12,25,13,18,10,29,14,$ff
motion_convergence_fr02:
        !byte 22,12,23,12,21,13,26,13,19,10,29,13,$ff
motion_convergence_fr03:
        !byte 23,13,24,13,22,13,27,14,20,10,28,13,$ff
motion_convergence_fr04:
        !byte 24,13,25,13,23,14,28,14,21,11,27,14,$ff
motion_convergence_fr05:
        !byte 24,14,25,14,23,14,28,15,21,12,26,15,$ff
motion_convergence_fr06:
        !byte 23,15,24,15,22,14,27,15,20,13,25,16,$ff
motion_convergence_fr07:
        !byte 22,15,23,15,21,14,26,16,19,14,24,16,$ff
motion_convergence_fr08:
        !byte 21,15,22,15,20,14,25,16,18,14,23,16,$ff
motion_convergence_fr09:
        !byte 20,14,21,14,19,14,24,15,17,14,22,15,$ff
motion_convergence_fr10:
        !byte 19,13,20,13,18,13,23,14,16,13,21,14,$ff
motion_convergence_fr11:
        !byte 18,12,19,12,17,13,22,13,15,12,20,13,$ff
motion_convergence_fr12:
        !byte 17,12,18,12,16,12,21,13,14,11,20,12,$ff
motion_convergence_fr13:
        !byte 18,11,19,11,17,12,22,12,15,10,21,12,$ff
motion_convergence_fr14:
        !byte 19,11,20,11,18,12,23,12,16,10,23,13,$ff
motion_convergence_fr15:
        !byte 20,11,21,11,19,12,24,13,17,10,25,13,$ff

; V7.6_ORBITAL_STABILITY_BODY_FX
; phase-correct orbital-stability anchors.  Six points per frame: eased inner
; diagonal, counter-diagonal and damped centre-memory cue.  x<=28/y 10..15,
; no star_phase jitter, no SID-tail lag, no right-wrap risk.
orbital_stability_fr00:
        !byte 19,12,21,12,23,13,17,11,25,14,28,14,$ff
orbital_stability_fr01:
        !byte 20,12,22,12,24,13,18,10,26,14,28,13,$ff
orbital_stability_fr02:
        !byte 21,12,23,12,25,13,19,10,27,13,28,13,$ff
orbital_stability_fr03:
        !byte 22,13,24,13,26,14,20,10,28,13,27,12,$ff
orbital_stability_fr04:
        !byte 23,13,25,13,27,14,21,11,28,14,26,12,$ff
orbital_stability_fr05:
        !byte 23,14,25,14,27,15,21,12,27,15,25,13,$ff
orbital_stability_fr06:
        !byte 22,15,24,15,26,15,20,13,26,15,24,14,$ff
orbital_stability_fr07:
        !byte 21,15,23,15,25,15,19,14,25,15,23,15,$ff
orbital_stability_fr08:
        !byte 20,15,22,15,24,15,18,14,24,15,22,15,$ff
orbital_stability_fr09:
        !byte 19,14,21,14,23,14,17,14,23,15,21,15,$ff
orbital_stability_fr10:
        !byte 18,13,20,13,22,13,16,13,22,14,20,14,$ff
orbital_stability_fr11:
        !byte 17,12,19,12,21,13,15,12,21,13,19,13,$ff
orbital_stability_fr12:
        !byte 16,12,18,12,20,12,14,11,20,13,18,13,$ff
orbital_stability_fr13:
        !byte 17,11,19,11,21,12,15,10,21,12,19,12,$ff
orbital_stability_fr14:
        !byte 18,11,20,11,22,12,16,10,23,12,21,13,$ff
orbital_stability_fr15:
        !byte 19,11,21,11,23,12,17,10,25,13,23,13,$ff

; V7.7_BODY_PROJECTION_LOCK_FX
; phase-correct body-projection lock anchors.  Five points per frame form a
; projected near/far axis chord plus a small centre stabilizer.  This is a
; low-noise rigid-body reference, x<=27/y 9..16, no star_phase jitter,
; no SID-tail lag, no right-wrap risk.
body_projection_lock_fr00:
        !byte 18,12,20,12,22,13,24,13,27,14,$ff
body_projection_lock_fr01:
        !byte 19,12,21,12,23,13,25,13,27,13,$ff
body_projection_lock_fr02:
        !byte 20,12,22,12,24,13,26,13,27,12,$ff
body_projection_lock_fr03:
        !byte 21,13,23,13,25,13,27,12,26,11,$ff
body_projection_lock_fr04:
        !byte 22,13,24,13,26,13,27,13,25,10,$ff
body_projection_lock_fr05:
        !byte 22,14,24,14,26,14,27,14,24,10,$ff
body_projection_lock_fr06:
        !byte 21,15,23,15,25,14,26,15,23,11,$ff
body_projection_lock_fr07:
        !byte 20,15,22,15,24,15,25,16,22,12,$ff
body_projection_lock_fr08:
        !byte 19,15,21,15,23,15,24,16,21,13,$ff
body_projection_lock_fr09:
        !byte 18,14,20,14,22,15,23,16,20,14,$ff
body_projection_lock_fr10:
        !byte 17,13,19,13,21,14,22,15,19,15,$ff
body_projection_lock_fr11:
        !byte 16,12,18,12,20,13,21,14,18,15,$ff
body_projection_lock_fr12:
        !byte 15,12,17,12,19,12,20,13,17,14,$ff
body_projection_lock_fr13:
        !byte 16,11,18,11,20,12,21,12,18,13,$ff
body_projection_lock_fr14:
        !byte 17,11,19,11,21,12,23,12,20,12,$ff
body_projection_lock_fr15:
        !byte 18,11,20,11,22,12,24,12,22,13,$ff

; V8.0_CAMERA_SPLINE_BLACK_LOCK_FX
; final phase-correct camera/body spline cue.  Six points per frame form a
; centre-weighted near/far motion chord inside x<=26/y 9..16.  It is locked to
; vis_frame, uses cached star_color_index for colour, and cannot touch the
; scrubbed right edge or the black background.
camera_spline_lock_fr00:
        !byte 18,12,19,12,20,12,22,13,24,13,26,14,$ff
camera_spline_lock_fr01:
        !byte 19,12,20,12,21,12,23,13,25,13,26,13,$ff
camera_spline_lock_fr02:
        !byte 20,12,21,12,22,13,24,13,26,12,25,11,$ff
camera_spline_lock_fr03:
        !byte 21,13,22,13,23,13,25,12,26,11,24,10,$ff
camera_spline_lock_fr04:
        !byte 22,13,23,13,24,13,26,12,25,10,23,9,$ff
camera_spline_lock_fr05:
        !byte 22,14,23,14,24,14,26,13,24,10,22,9,$ff
camera_spline_lock_fr06:
        !byte 21,15,22,15,23,14,25,15,23,11,21,10,$ff
camera_spline_lock_fr07:
        !byte 20,15,21,15,22,15,24,16,22,12,20,11,$ff
camera_spline_lock_fr08:
        !byte 19,15,20,15,21,15,23,16,21,13,19,12,$ff
camera_spline_lock_fr09:
        !byte 18,14,19,14,20,15,22,16,20,14,18,13,$ff
camera_spline_lock_fr10:
        !byte 17,13,18,13,19,14,21,15,19,15,17,14,$ff
camera_spline_lock_fr11:
        !byte 16,12,17,12,18,13,20,14,18,15,16,15,$ff
camera_spline_lock_fr12:
        !byte 15,12,16,12,17,12,19,13,17,14,15,14,$ff
camera_spline_lock_fr13:
        !byte 16,11,17,11,18,12,20,12,18,13,16,13,$ff
camera_spline_lock_fr14:
        !byte 17,11,18,11,19,12,21,12,20,12,18,12,$ff
camera_spline_lock_fr15:
        !byte 18,11,19,11,20,12,22,12,22,13,20,13,$ff

; V8.1_CAMERA_INERTIA_BLACK_LOCK_FX
; final damped camera-inertia anchors.  Five points per frame: near axis,
; centre-memory and far counter-cue.  x<=25/y 10..15, locked to cube phase,
; no star_phase jitter, no SID-tail lag, no right-wrap risk, black bg safe.
camera_inertia_lock_fr00:
        !byte 18,12,19,12,20,12,22,13,25,14,$ff
camera_inertia_lock_fr01:
        !byte 19,12,20,12,21,12,23,13,25,13,$ff
camera_inertia_lock_fr02:
        !byte 20,12,21,12,22,13,24,13,25,12,$ff
camera_inertia_lock_fr03:
        !byte 21,13,22,13,23,13,25,12,24,11,$ff
camera_inertia_lock_fr04:
        !byte 22,13,23,13,24,13,25,12,23,10,$ff
camera_inertia_lock_fr05:
        !byte 22,14,23,14,24,14,25,13,22,10,$ff
camera_inertia_lock_fr06:
        !byte 21,15,22,15,23,14,24,15,21,11,$ff
camera_inertia_lock_fr07:
        !byte 20,15,21,15,22,15,23,15,20,12,$ff
camera_inertia_lock_fr08:
        !byte 19,15,20,15,21,15,22,15,19,13,$ff
camera_inertia_lock_fr09:
        !byte 18,14,19,14,20,15,21,15,18,14,$ff
camera_inertia_lock_fr10:
        !byte 17,13,18,13,19,14,20,14,17,15,$ff
camera_inertia_lock_fr11:
        !byte 16,12,17,12,18,13,19,14,16,15,$ff
camera_inertia_lock_fr12:
        !byte 15,12,16,12,17,12,18,13,15,14,$ff
camera_inertia_lock_fr13:
        !byte 16,11,17,11,18,12,19,12,16,13,$ff
camera_inertia_lock_fr14:
        !byte 17,11,18,11,19,12,20,12,18,12,$ff
camera_inertia_lock_fr15:
        !byte 18,11,19,11,20,12,21,12,20,13,$ff

sync_strobe_fr00:
        !byte 20,12,19,12,21,12,20,11,20,13,$ff
sync_strobe_fr01:
        !byte 21,12,20,12,22,12,21,11,21,13,$ff
sync_strobe_fr02:
        !byte 22,13,21,13,23,13,22,12,22,14,$ff
sync_strobe_fr03:
        !byte 22,14,21,14,23,14,22,13,22,15,$ff
sync_strobe_fr04:
        !byte 21,15,20,15,22,15,21,14,21,16,$ff
sync_strobe_fr05:
        !byte 20,16,19,16,21,16,20,15,20,17,$ff
sync_strobe_fr06:
        !byte 19,15,18,15,20,15,19,14,19,16,$ff
sync_strobe_fr07:
        !byte 18,14,17,14,19,14,18,13,18,15,$ff
sync_strobe_fr08:
        !byte 18,12,17,12,19,12,18,11,18,13,$ff
sync_strobe_fr09:
        !byte 19,11,18,11,20,11,19,10,19,12,$ff
sync_strobe_fr10:
        !byte 20,10,19,10,21,10,20,9,20,11,$ff
sync_strobe_fr11:
        !byte 21,11,20,11,22,11,21,10,21,12,$ff
sync_strobe_fr12:
        !byte 22,12,21,12,23,12,22,11,22,13,$ff
sync_strobe_fr13:
        !byte 21,13,20,13,22,13,21,12,21,14,$ff
sync_strobe_fr14:
        !byte 20,14,19,14,21,14,20,13,20,15,$ff
sync_strobe_fr15:
        !byte 19,13,18,13,20,13,19,12,19,14,$ff

light_flash_fr00:
        !byte 30,13,27,17,20,18,13,17,10,13,13,9,20,8,27,9,17,13,23,13,$ff
light_flash_fr01:
        !byte 32,14,27,18,19,19,12,17,10,12,14,8,22,7,30,9,18,13,24,13,$ff
light_flash_fr02:
        !byte 33,14,27,18,18,18,11,16,10,11,16,7,25,7,32,10,18,13,24,13,$ff
light_flash_fr03:
        !byte 34,15,27,19,17,19,10,15,10,10,17,6,27,6,34,10,19,12,25,12,$ff
light_flash_fr04:
        !byte 30,15,24,17,17,16,12,13,14,9,20,7,27,8,32,11,19,12,25,12,$ff
light_flash_fr05:
        !byte 30,15,23,18,15,16,11,12,13,8,21,6,29,7,33,11,19,12,25,12,$ff
light_flash_fr06:
        !byte 29,16,21,17,12,15,9,11,13,7,22,5,30,7,33,12,18,11,24,11,$ff
light_flash_fr07:
        !byte 28,17,18,18,10,15,8,10,13,5,23,4,32,7,34,12,18,11,24,11,$ff
light_flash_fr08:
        !byte 24,15,17,16,11,13,11,9,16,7,23,6,29,9,29,13,17,11,23,11,$ff
light_flash_fr09:
        !byte 23,17,14,16,9,13,9,8,16,5,24,6,30,9,29,14,16,11,22,11,$ff
light_flash_fr10:
        !byte 21,17,12,16,7,12,9,8,17,5,25,6,30,10,28,15,16,11,22,11,$ff
light_flash_fr11:
        !byte 19,19,9,17,5,12,9,7,18,5,27,6,31,11,28,16,15,12,21,12,$ff
light_flash_fr12:
        !byte 17,17,10,15,8,11,12,8,19,7,26,9,28,13,24,16,15,12,21,12,$ff
light_flash_fr13:
        !byte 15,18,9,15,7,11,12,7,21,7,28,9,29,14,24,18,15,12,21,12,$ff
light_flash_fr14:
        !byte 14,18,8,15,7,10,14,7,23,7,30,10,30,15,23,18,16,13,22,13,$ff
light_flash_fr15:
        !byte 13,19,7,15,8,9,16,6,26,7,32,11,30,16,23,20,16,13,22,13,$ff
scanline_flare_fr00:
        !byte 5,9,9,9,13,9,17,9,21,9,25,9,29,9,14,12,20,12,26,12,32,12,$ff
scanline_flare_fr01:
        !byte 8,10,12,10,16,10,20,10,24,10,28,10,32,10,13,13,19,13,25,13,31,13,$ff
scanline_flare_fr02:
        !byte 11,11,15,11,19,11,23,11,27,11,31,11,35,11,11,14,17,14,23,14,29,14,$ff
scanline_flare_fr03:
        !byte 6,12,10,12,14,12,18,12,22,12,26,12,30,12,14,15,20,15,26,15,32,15,$ff
scanline_flare_fr04:
        !byte 9,13,13,13,17,13,21,13,25,13,29,13,33,13,12,16,18,16,24,16,30,16,$ff
scanline_flare_fr05:
        !byte 12,9,16,9,20,9,24,9,28,9,32,9,35,9,11,12,17,12,23,12,29,12,$ff
scanline_flare_fr06:
        !byte 7,10,11,10,15,10,19,10,23,10,27,10,31,10,13,13,19,13,25,13,31,13,$ff
scanline_flare_fr07:
        !byte 10,11,14,11,18,11,22,11,26,11,30,11,34,11,12,14,18,14,24,14,30,14,$ff
scanline_flare_fr08:
        !byte 5,12,9,12,13,12,17,12,21,12,25,12,29,12,14,15,20,15,26,15,32,15,$ff
scanline_flare_fr09:
        !byte 8,13,12,13,16,13,20,13,24,13,28,13,32,13,13,16,19,16,25,16,31,16,$ff
scanline_flare_fr10:
        !byte 11,9,15,9,19,9,23,9,27,9,31,9,35,9,11,12,17,12,23,12,29,12,$ff
scanline_flare_fr11:
        !byte 6,10,10,10,14,10,18,10,22,10,26,10,30,10,14,13,20,13,26,13,32,13,$ff
scanline_flare_fr12:
        !byte 9,11,13,11,17,11,21,11,25,11,29,11,33,11,12,14,18,14,24,14,30,14,$ff
scanline_flare_fr13:
        !byte 12,12,16,12,20,12,24,12,28,12,32,12,35,12,11,15,17,15,23,15,29,15,$ff
scanline_flare_fr14:
        !byte 7,13,11,13,15,13,19,13,23,13,27,13,31,13,13,16,19,16,25,16,31,16,$ff
scanline_flare_fr15:
        !byte 10,9,14,9,18,9,22,9,26,9,30,9,34,9,12,12,18,12,24,12,30,12,$ff
rim_flash_fr00:
        !byte 9,7,19,5,29,7,29,17,19,19,9,17,$ff
rim_flash_fr01:
        !byte 14,6,26,6,32,12,26,18,14,18,8,12,$ff
rim_flash_fr02:
        !byte 11,7,21,5,31,7,31,17,21,19,11,17,$ff
rim_flash_fr03:
        !byte 13,6,25,6,31,12,25,18,13,18,7,12,$ff
rim_flash_fr04:
        !byte 10,7,20,5,30,7,30,17,20,19,10,17,$ff
rim_flash_fr05:
        !byte 15,6,27,6,33,12,27,18,15,18,9,12,$ff
rim_flash_fr06:
        !byte 9,7,19,5,29,7,29,17,19,19,9,17,$ff
rim_flash_fr07:
        !byte 14,6,26,6,32,12,26,18,14,18,8,12,$ff
rim_flash_fr08:
        !byte 11,7,21,5,31,7,31,17,21,19,11,17,$ff
rim_flash_fr09:
        !byte 13,6,25,6,31,12,25,18,13,18,7,12,$ff
rim_flash_fr10:
        !byte 10,7,20,5,30,7,30,17,20,19,10,17,$ff
rim_flash_fr11:
        !byte 15,6,27,6,33,12,27,18,15,18,9,12,$ff
rim_flash_fr12:
        !byte 9,7,19,5,29,7,29,17,19,19,9,17,$ff
rim_flash_fr13:
        !byte 14,6,26,6,32,12,26,18,14,18,8,12,$ff
rim_flash_fr14:
        !byte 11,7,21,5,31,7,31,17,21,19,11,17,$ff
rim_flash_fr15:
        !byte 13,6,25,6,31,12,25,18,13,18,7,12,$ff

eased_vector_fr00:
        !byte 25,12,25,14,25,10,20,16,13,12,$ff
eased_vector_fr01:
        !byte 25,13,24,15,26,11,18,16,14,11,$ff
eased_vector_fr02:
        !byte 24,14,22,15,26,13,16,15,15,11,$ff
eased_vector_fr03:
        !byte 23,15,20,16,26,14,15,14,17,10,$ff
eased_vector_fr04:
        !byte 20,15,17,15,23,15,15,12,20,10,$ff
eased_vector_fr05:
        !byte 17,15,14,14,20,16,15,10,23,10,$ff
eased_vector_fr06:
        !byte 16,14,14,13,18,15,16,9,25,11,$ff
eased_vector_fr07:
        !byte 15,13,14,11,16,15,18,8,26,11,$ff
eased_vector_fr08:
        !byte 15,12,15,10,15,14,20,8,27,12,$ff
eased_vector_fr09:
        !byte 15,11,16,9,14,13,22,8,26,13,$ff
eased_vector_fr10:
        !byte 16,10,18,9,14,11,24,9,25,13,$ff
eased_vector_fr11:
        !byte 17,9,20,8,14,10,25,10,23,14,$ff
eased_vector_fr12:
        !byte 20,9,23,9,17,9,25,12,20,14,$ff
eased_vector_fr13:
        !byte 23,9,26,10,20,8,25,14,17,14,$ff
eased_vector_fr14:
        !byte 24,10,26,11,22,9,24,15,15,13,$ff
eased_vector_fr15:
        !byte 25,11,26,13,24,9,22,16,14,13,$ff

bsilent: !fill 16,0
bassAm:  !byte 0,0,34,0,0,0,34,0,0,0,34,0,0,0,34,46
bassF:   !byte 0,0,30,0,0,0,30,0,0,0,30,0,0,0,30,42
bassC:   !byte 0,0,37,0,0,0,37,0,0,0,37,0,0,0,37,49
bassG:   !byte 0,0,32,0,0,0,32,0,0,0,32,0,0,0,32,44

; 0=silence, 1=kick, 2=snare/clap, 3=hat, 4=crash, 5=lift/noise fill
dsilent: !fill 16,0
d_basic: !byte 1,0,3,0,2,0,3,3,1,0,3,0,2,0,3,3
d_full:  !byte 1,0,3,0,2,3,3,0,1,0,3,2,5,0,3,4
d_chorus:!byte 1,0,3,2,3,3,3,0,1,0,3,2,5,3,4,2
d_big:   !byte 1,0,3,2,5,3,3,0,1,0,3,2,3,3,4,2
d_lift:  !byte 1,0,3,0,2,3,3,0,1,5,3,0,2,3,4,0
d_pshhh: !byte 0,0,0,0,3,0,0,0,5,0,0,0,3,0,4,0

lsilent: !fill 16,0
leadAm:  !byte 58,0,61,0,65,0,61,0,58,0,61,0,65,0,61,0
leadF:   !byte 58,0,61,0,66,0,61,0,58,0,61,0,66,0,61,0
leadC:   !byte 56,0,61,0,65,0,61,0,56,0,61,0,65,0,61,0
leadG:   !byte 56,0,60,0,63,0,60,0,56,0,60,0,63,0,60,0
verseA:  !byte 46,0,49,0,53,0,49,0,58,0,53,0,49,0,46,0
leadUp:  !byte 46,49,53,58,61,65,68,65,61,58,53,49,46,49,53,58
leadEAm: !byte 70,0,73,0,77,0,73,0,70,73,77,73,70,73,77,82
leadEF:  !byte 70,0,73,0,78,0,73,0,70,73,78,73,70,73,78,82
leadEC:  !byte 68,0,73,0,77,0,73,0,68,73,77,73,68,73,77,80
leadEG:  !byte 68,0,72,0,75,0,72,0,68,72,75,72,68,72,75,80

bpat_lo: !byte <bsilent,<bassAm,<bassF,<bassC,<bassG
bpat_hi: !byte >bsilent,>bassAm,>bassF,>bassC,>bassG

dpat_lo: !byte <dsilent,<d_basic,<d_full,<d_chorus,<d_big,<d_lift,<d_pshhh
dpat_hi: !byte >dsilent,>d_basic,>d_full,>d_chorus,>d_big,>d_lift,>d_pshhh

lpat_lo: !byte <lsilent,<leadAm,<leadF,<leadC,<leadG,<verseA,<leadUp,<leadEAm,<leadEF,<leadEC,<leadEG
lpat_hi: !byte >lsilent,>leadAm,>leadF,>leadC,>leadG,>verseA,>leadUp,>leadEAm,>leadEF,>leadEC,>leadEG

freqlo:
        !byte $16,$27,$39,$4b,$5f,$74,$8a,$a1,$ba,$d4,$f0,$0e,$2d,$4e,$71,$96,$be,$e7,$14,$42,$74,$a9,$e0,$1b,$5a,$9c,$e2,$2d,$7b,$cf,$27,$85,$e8,$51,$c1,$37,$b4,$38,$c4,$59,$f7,$9d,$4e,$0a,$d0,$a2,$81,$6d,$67,$70,$89,$b2,$ed,$3b,$9c,$13,$a0,$45,$02,$da,$ce,$e0,$11,$64,$da,$76,$39,$26,$40,$89,$04,$b4,$9c,$c0,$23,$c8,$b4,$eb,$72,$4c,$80,$12,$08,$68,$39,$80,$45,$90,$68,$d6,$e3,$99,$00,$24,$10,$d0
freqhi:
        !byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02,$02,$02,$02,$02,$02,$02,$03,$03,$03,$03,$03,$04,$04,$04,$04,$05,$05,$05,$06,$06,$06,$07,$07,$08,$08,$09,$09,$0a,$0a,$0b,$0c,$0d,$0d,$0e,$0f,$10,$11,$12,$13,$14,$15,$17,$18,$1a,$1b,$1d,$1f,$20,$22,$24,$27,$29,$2b,$2e,$31,$34,$37,$3a,$3e,$41,$45,$49,$4e,$52,$57,$5c,$62,$68,$6e,$75,$7c,$83,$8b,$93,$9c,$a5,$af,$b9,$c4,$d0,$dd,$ea,$f8,$06

; V3.7: hot runtime variables are zero-page aliases above; no BSS bytes here.
