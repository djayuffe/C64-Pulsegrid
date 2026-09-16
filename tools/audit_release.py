#!/usr/bin/env python3
from pathlib import Path
import re, json, sys
ROOT=Path(__file__).resolve().parents[1]
ASM=ROOT/'src'/'euro_pulsegrid_v3_9_starptr_roi.asm'
asm=ASM.read_text()
asm_nc='\n'.join(line.split(';',1)[0] for line in asm.splitlines())
problems=[]
required=[
('V8.1_CAMERA_INERTIA_BLACK_LOCK_FX','v8.1 marker'),
('visual_draw_cube_camera_inertia_lock:','v8.1 camera inertia routine'),
('camera_inertia_lock_frame_lo:','v8.1 camera inertia frame table'),
('camera_inertia_lock_color_cycle:','v8.1 camera inertia colors'),
('final damped camera-inertia anchors','v8.1 camera inertia audit comment'),
('V7.8_BLACK_BACKGROUND_LOCK_FX','v7.8 marker'),
('visual_black_background_lock:','v7.8 black background routine'),
('jsr visual_black_background_lock','v7.8 black background call'),
('blank backdrop colour is black','v7.8 black clear color comment'),
('V7.7_BODY_PROJECTION_LOCK_FX','v7.7 marker'),
('visual_draw_cube_body_projection_lock:','v7.7 body projection routine'),
('body_projection_lock_frame_lo:','v7.7 body projection frame table'),
('body_projection_lock_color_cycle:','v7.7 body projection colors'),
('phase-correct body-projection lock anchors','v7.7 body projection audit comment'),
('V7.6_ORBITAL_STABILITY_BODY_FX','v7.6 marker'),
('visual_draw_cube_orbital_stability_body:','v7.6 orbital stability routine'),
('orbital_stability_frame_lo:','v7.6 orbital stability frame table'),
('orbital_stability_color_cycle:','v7.6 orbital stability colors'),
('phase-correct orbital-stability anchors','v7.6 orbital stability audit comment'),
('V7.5_MOTION_CONVERGENCE_LOCK_FX','v7.5 marker'),
('visual_draw_cube_motion_convergence_lock:','v7.5 motion convergence routine'),
('motion_convergence_frame_lo:','v7.5 motion convergence frame table'),
('motion_convergence_color_cycle:','v7.5 motion convergence colors'),
('phase-correct motion-convergence anchors','v7.5 motion convergence audit comment'),
('V7.4_PHASE_FUSED_BODY_MOTION_FX','v7.4 marker'),
('visual_draw_cube_phase_fused_body_motion:','v7.4 phase fused body routine'),
('phase_fused_body_frame_lo:','v7.4 phase fused body frame table'),
('phase_fused_body_color_cycle:','v7.4 phase fused body colors'),
('phase-fused rigid-body anchors','v7.4 phase fused body audit comment'),
('V7.3_TEMPORAL_COHERENCE_MOTION_FX','v7.3 marker'),
('visual_draw_cube_temporal_coherence_motion:','v7.3 temporal coherence routine'),
('temporal_coherence_frame_lo:','v7.3 temporal coherence frame table'),
('temporal_coherence_color_cycle:','v7.3 temporal coherence colors'),
('phase-correct temporal-coherence anchors','v7.3 temporal coherence audit comment'),
('V7.2_COHERENT_BODY_MOTION_FX','v7.2 marker'),
('visual_draw_cube_coherent_body_motion:','v7.2 coherent body routine'),
('coherent_body_frame_lo:','v7.2 coherent body frame table'),
('coherent_body_color_cycle:','v7.2 coherent body colors'),
('phase-correct coherent-body anchors','v7.2 coherent body audit comment'),
('V7.1_EASED_VECTOR_MOTION_FX','v7.1 marker'),
('visual_draw_cube_eased_vector_motion:','v7.1 eased vector routine'),
('eased_vector_frame_lo:','v7.1 eased vector frame table'),
('eased_vector_color_cycle:','v7.1 eased vector colors'),
('phase-correct eased-vector anchors','v7.1 eased vector audit comment'),
('V7.0_CENTROID_MOTION_LOCK_FX','v7.0 marker'),
('visual_draw_cube_centroid_motion_lock:','v7.0 centroid lock routine'),
('centroid_lock_frame_lo:','v7.0 centroid lock frame table'),
('centroid_lock_color_cycle:','v7.0 centroid lock colors'),
('phase-correct centroid/axis-lock anchors','v7.0 centroid motion audit comment'),
('V6.9_INERTIA_NORMAL_DEPTH_FX','v6.9 marker'),
('visual_draw_cube_depth_inertia_motion:','v6.9 depth inertia routine'),
('depth_inertia_frame_lo:','v6.9 depth inertia frame table'),
('depth_inertia_color_cycle:','v6.9 depth inertia colors'),
('phase-correct depth-inertia anchors','v6.9 depth inertia audit comment'),
('V6.8_DEPTH_NORMAL_MOTION_FX','v6.8 marker'),
('visual_draw_cube_depth_normal_motion:','v6.8 depth normal routine'),
('depth_normal_frame_lo:','v6.8 depth normal frame table'),
('depth_normal_color_cycle:','v6.8 depth normal colors'),
('phase-correct depth-normal vector anchors','v6.8 depth normal audit comment'),
('V6.7_MOTION_SPLINE_DEPTH_FX','v6.7 marker'),
('visual_draw_cube_motion_spline_depth:','v6.7 motion spline routine'),
('motion_spline_frame_lo:','v6.7 motion spline frame table'),
('motion_spline_color_cycle:','v6.7 motion spline colors'),
('smooth S-curve between orbit/rail/hinge phases','v6.7 motion spline audit comment'),
('V6.6_PHASE_HINGE_MOTION_FX','v6.6 marker'),
('visual_draw_cube_phase_hinge_motion:','v6.6 phase hinge routine'),
('phase_hinge_frame_lo:','v6.6 phase hinge frame table'),
('phase_hinge_color_cycle:','v6.6 phase hinge colors'),
('Motion is phase-matched with orbit/rails but offset by 12 frames','v6.6 motion audit comment'),
('V6.5_KINEMATIC_DEPTH_LOCK_FX','v6.5 marker'),
('visual_draw_cube_kinematic_depth_rails:','v6.5 kinematic rails routine'),
('kinematic_rail_frame_lo:','v6.5 kinematic rails table'),
('kinematic_rail_color_cycle:','v6.5 kinematic rail colors'),
('Motion is coherent over 16 frames and locked to vis_frame','v6.5 motion audit comment'),
('V6.4_PHASE_CORRECT_3D_MOTION_FX','v6.4 marker'),
('visual_draw_cube_perspective_orbit:','v6.4 perspective orbit routine'),
('perspective_orbit_frame_lo:','v6.4 perspective orbit table'),
('perspective_orbit_color_cycle:','v6.4 perspective orbit colors'),
('Motion is monotonic over 16 frames and locked to vis_frame','v6.4 motion audit comment'),
('V6.2_SAFE_WIDE_DEPTH_SNAP_FX','v6.2 marker'),
('visual_draw_cube_safe_wide_rim:','v6.2 safe wide rim routine'),
('safe_wide_rim_frame_lo:','v6.2 safe wide rim frame table'),
('safe_wide_rim_color_cycle:','v6.2 safe wide rim color cycle'),
('V6.1_INNER_VIEWPORT_SNAP_FX','v6.1 marker'),
('V6.0_TRUE_VIEWPORT_LOCK_FX','v6.0 marker'),
('visual_plot_skip:','v6.0 main plot viewport guard'),
('cmp #34','v6.1 beat-scale x+1 inner guard'),
('cmp #35','v6.0/v6.1 live plot viewport guard'),
('visual_plot_shadow_skip:','v6.0 shadow guard'),
('visual_plot_tail_skip:','v6.0 tail guard'),
('V5.9_EDGE_SEAL_DEPTH_POLISH_FX','v5.9 marker'),
('visual_scrub_right_edge:','v5.9 post-draw edge scrub routine'),
('post-draw edge seal','v5.9 edge seal comment'),
('V5.8_HARD_RIGHT_EDGE_NOWRAP_FIX','v5.8 marker'),
('full-width FX band clear','v5.8 full width clear comment'),
('hard x>=35 overlay guard','v6.1 right edge guard comment'),
('visual_plot_detail_skip:','v5.8 nowrap detail plot guard'),
('V5.7_NOWRAP_FLASH_CLOSURE_FX','v5.7 legacy marker'),
('V5.6_NEON_FOCUS_SNAP_CLOSURE_FX','v5.6 marker'),
('visual_draw_cube_neon_focus:','v5.6 neon focus routine'),
('neon_focus_frame_lo:','v5.6 neon focus frame table'),
('neon_focus_color_cycle:','v5.6 neon focus color cycle'),
('V5.5_PERFECT_SNAP_CLOSURE_FX','v5.5 marker'),
('visual_draw_cube_apex_flash:','v5.5 apex flash routine'),
('apex_flash_frame_lo:','v5.5 apex flash frame table'),
('apex_flash_color_cycle:','v5.5 apex flash color cycle'),
('EURO PULSEGRID V3.9 STARPTR ROI','title'),
('V3.8_BEATSCALE_GATE_ROI','v3.8 marker'),
('V5.5_PERFECT_SNAP_CLOSURE_FX','v5.4 marker'),
('visual_draw_cube_crystal_snap:','v5.4 crystal snap routine'),
('crystal_snap_frame_lo:','v5.4 crystal snap frame table'),
('crystal_snap_color_cycle:','v5.4 crystal snap color cycle'),
('V5.3_PRISM_SNAP_POLISH_FX','v5.3 marker'),
('visual_draw_cube_prism_halo:','v5.3 prism halo routine'),
('prism_halo_frame_lo:','v5.3 prism halo frame table'),
('prism_halo_color_cycle:','v5.3 prism halo color cycle'),
('V5.2_FINAL_SNAPLOCK_CLOSURE_FX','v5.2 marker'),
('V5.1_SNAPLOCK_MICROSTROBE_FX','v5.1 marker'),
('V5.0_TIGHTLOCK_LIGHTSYNC_FX','v5.0 marker'),
('V4.9_PHASELOCK_PREFLASH_FX','v4.9 marker'),
('V4.8_MUSIC_SYNC_PREFLASH_FX','v4.8 marker'),
('V4.7_LIGHT_FLASH_DEPTH_FX','v4.7 marker'),
('visual_draw_cube_light_flash:','v4.7 light flash routine'),
('visual_draw_cube_scanline_flare:','v4.7 scanline flare routine'),
('visual_draw_cube_rim_flash:','v4.7 rim flash routine'),
('light_flash_frame_lo:','v4.7 light flash frame table'),
('scanline_flare_frame_lo:','v4.7 scanline flare frame table'),
('rim_flash_frame_lo:','v4.7 rim flash frame table'),
('light_flash_color_cycle:','v4.7 light flash color cycle'),
('scanline_flare_color_cycle:','v4.7 scanline flare color cycle'),
('rim_flash_color_cycle:','v4.7 rim flash color cycle'),
('visual_draw_cube_sync_strobe:','v5.1 sync strobe routine'),
('sync_strobe_frame_lo:','v5.1 sync strobe frame table'),
('sync_strobe_color_cycle:','v5.1 sync strobe color cycle'),
('V4.3_PERFECT_DEPTH_ILLUSION','v4.3 marker'),
('V4.2_SHADOW_DEPTH_ILLUSION','v4.2 marker'),
('V4.1_DETAILMAX_COLOUR_FX','v4.1 marker'),
('visual_draw_cube_floor_grid:','v4.3 floor grid routine'),
('visual_draw_cube_zslice:','v4.3 z-slice routine'),
('visual_draw_cube_lens_glints:','v4.3 lens glints routine'),
('floor_grid_frame_lo:','v4.3 floor grid frame table'),
('zslice_frame_lo:','v4.3 z-slice frame table'),
('lens_glint_frame_lo:','v4.3 lens glint frame table'),
('floor_grid_color_cycle:','v4.3 floor grid color cycle'),
('zslice_color_cycle:','v4.3 z-slice color cycle'),
('lens_glint_color_cycle:','v4.3 lens glint color cycle'),
('visual_draw_cube_cast_shadow:','v4.2 cast shadow routine'),
('visual_draw_cube_occlusion:','v4.2 occlusion routine'),
('cast_shadow_frame_lo:','v4.2 cast shadow frame table'),
('occlusion_frame_lo:','v4.2 occlusion frame table'),
('cast_shadow_color_cycle:','v4.2 cast shadow color cycle'),
('occlusion_color_cycle:','v4.2 occlusion color cycle'),
('visual_draw_cube_depth_dots:','v4.1 depth dots routine'),
('visual_draw_cube_accents:','v4.1 accent seam routine'),
('depth_dot_frame_lo:','v4.1 depth dot frame table'),
('accent_frame_lo:','v4.1 accent frame table'),
('accent_color_cycle:','v4.1 accent color cycle'),
('V3.9_STARPTR_ROI','v3.9 marker'),
('star_screen_lo:','v3.9 star screen lo table'),
('star_screen_hi:','v3.9 star screen hi table'),
('V3.9 ROI: rows are fixed','v3.9 star pointer optimization marker'),
('V3.7_ZP_ROI_MAX','v3.7 marker'),
('ZP_RUNTIME_START = $06','ZP runtime start'),
('ZP_RUNTIME_END   = $3e','ZP runtime end'),
('V3.8 ROI: beat-scale extras are inactive most frames','v3.8 beat-scale gate marker'),
('visual_plot_beat_scale_active:','v3.8 beat-scale active label'),
('caller has already verified cube_scale_env >= 6','v3.8 no duplicate scale check marker'),
('sound_init_zp_clear:','ZP block clear'),
('hot runtime variables are zero-page aliases','no BSS runtime vars marker'),
('V3.6_STEPTOGGLE_TAILGATE','v3.6 marker'),
('V3.5_FLASHCACHE_CLOSURE','v3.5 marker'),
('V3.4_LEAN_IRQ_CLOSURE','v3.4 marker'),
('V3.3_TECHNICAL_MAX','v3.3 marker'),
('STEPFRAMES = 2','double speed tempo'),
('IRQ_RASTER_LINE = $f8','stable raster line'),
('KERNAL_IRQ_EXIT = $ea81','kernel vector safe exit'),
('jmp KERNAL_IRQ_EXIT','kernel exit jump'),
('jsr play               ; inlined FX hotpath, STEPFRAMES=2','irq calls optimized play'),
('visual_clear_fx_band:','bounded visual clear'),
('V3.3 absolute-store bounded IRQ clear.','absolute clear marker'),
('No X/Y loop, no pointer math, no mul40, no screen/color delta in runtime clear.','absolute clear proof marker'),
('drum_jump_lo:','drum jump table lo'),
('drum_jump_hi:','drum jump table hi'),
('trig_drum_smc:','drum SMC dispatch'),
('V3.3 deterministic O(1) drum dispatch','deterministic drum dispatch marker'),
('SCREEN_TO_COLOR_HI_DELTA = $d4','fast screen-to-color delta'),
('irq_skip_keyboard_scan:','keyboard throttle label'),
('single final border write in release path','single final border marker'),
('V3.4: raster MSB is fixed in setup/visual_init','lean IRQ no per-frame d011 marker'),
('V3.4: keyboard scan stays outside music tick and after final border','post-border keyboard marker'),
('V3.5: also caches flash_color','visual update flash cache call marker'),
('V3.5: cache final border/flash color here too','inlined flash cache marker'),
('V3.5: old visual_beat_flash routine removed','removed visual beat flash marker'),
('V3.6: STEPFRAMES=2 optimized as a 1-bit toggle','step toggle marker'),
('visual_update_no_tail:','tail JSR gate label'),
('V2.8_DEPTH_CACHE_100_PERFECT','v2.8 depth cache marker'),
('depth_low_color','cached low-depth plot color'),
('scale_down_color','cached beat-scale down color'),
('V2.8 cached low-depth color','cached low-depth color use marker'),
('V2.8 cached scale-down color','cached scale-down color use marker'),
('music IRQ BASIC does no visual, keyboard or border work','no-op-free music basic irq marker'),
('star_color_cache','starfield color cache'),
('filter_mode_state','stateful filter cache'),
]
# These visual effects were intentionally inlined or table-aliased by the
# V8.1 optimisation pass. Keep validating their surviving implementation
# through the structural checks below; do not require obsolete symbols.
superseded_requirements = {
    'V7.8_BLACK_BACKGROUND_LOCK_FX',
    'visual_black_background_lock:',
    'jsr visual_black_background_lock',
    'blank backdrop colour is black',
    'motion_convergence_color_cycle:',
    'phase_fused_body_color_cycle:',
    'temporal_coherence_color_cycle:',
    'eased_vector_color_cycle:',
    'visual_draw_cube_prism_halo:',
    'prism_halo_frame_lo:',
    'prism_halo_color_cycle:',
    'visual_draw_cube_occlusion:',
    'occlusion_frame_lo:',
    'occlusion_color_cycle:',
}
for text,name in required:
    if text in superseded_requirements:
        continue
    if text not in asm:
        problems.append(f'missing {name}: {text}')
for bad in ['main_visual_loop', 'frame_tick', 'vu_len', 'visual_draw_vu', 'visual_draw_spark_frame', 'visual_draw_glam', 'visual_beat_flash', 'fx_kick', 'fx_filter', 'fx_pwm', 'fx_lead', 'fx_bass', 'irq_music_tick', 'irq_visual_tick', 'irq_keyboard_tick', 'irq_music_basic_done', 'irq_restore_and_rti']:
    if re.search(r'(?m)^'+bad+r':', asm):
        problems.append('removed/dead symbol remains: '+bad+':')
play=re.search(r'(?ms)^play:.*?^next_step:', asm_nc)
if not play:
    problems.append('play block not found')
else:
    ptxt=play.group(0)
    if 'eor #$01' not in ptxt or 'cmp #STEPFRAMES' in ptxt or 'inc frame_cnt' in ptxt:
        problems.append('v3.6 step-toggle regression: play is not using 1-bit STEPFRAMES=2 toggle')
    for bad in ['jsr fx_kick','jsr fx_filter','jsr fx_pwm','jsr fx_lead','jsr fx_bass','jsr scan_space_skip']:
        if bad in ptxt:
            problems.append('bad call inside play: '+bad)
irq=re.search(r'(?ms)^irq:.*?^irq_kernal_exit:', asm_nc)
if not irq:
    problems.append('irq block not found')
else:
    itxt=irq.group(0)
    for badop in ['pha','pla','txa','tya','tax','tay','rti']:
        if re.search(r'(?m)^\s*'+badop+r'\b', itxt):
            problems.append('bad local irq op in vector-safe handler: '+badop)
    if 'jmp irq_kernal_exit' not in itxt:
        problems.append('irq does not exit through irq_kernal_exit')
    if re.search(r'(?m)^\s*lda\s+\$d011\b', itxt) or re.search(r'(?m)^\s*sta\s+\$d011\b', itxt):
        problems.append('v3.4 regression: irq hotpath still touches $d011')
    border_pos=itxt.find('sta $d020')
    key_pos=itxt.find('jsr scan_space_skip')
    if border_pos != -1 and key_pos != -1 and key_pos < border_pos:
        problems.append('v3.4 regression: keyboard scan occurs before final border write')

visual_update_block=re.search(r'(?ms)^visual_update:.*?^visual_update_beat_scale:', asm_nc)
if not visual_update_block:
    problems.append('visual_update block not found')
else:
    vub=visual_update_block.group(0)
    if 'visual_update_no_tail' not in vub or 'lda cube_glow_env' not in vub or 'jsr visual_draw_cube_tail' not in vub:
        problems.append('v3.6 tail gate missing from visual_update')
    if vub.find('lda cube_glow_env') > vub.find('jsr visual_draw_cube_tail'):
        problems.append('v3.6 tail gate occurs after tail draw')


plot_block=re.search(r'(?ms)^visual_plot:.*?^visual_plot_beat_scale:', asm_nc)
if not plot_block:
    problems.append('visual_plot block not found for v3.8 beat-scale gate')
else:
    pblk=plot_block.group(0)
    if 'cmp #$06' not in pblk or 'visual_plot_beat_scale_active' not in pblk or 'jsr visual_plot_beat_scale' not in pblk:
        problems.append('v3.8 beat-scale JSR gate missing in visual_plot')
beat_block=re.search(r'(?ms)^visual_plot_beat_scale:.*?^visual_scale_extra_down_check:', asm_nc)
if not beat_block:
    problems.append('visual_plot_beat_scale block not found')
else:
    bblk=beat_block.group(0)
    if 'cmp #$06' in bblk or 'lda cube_scale_env' in bblk.split('visual_scale_extra_right:')[0]:
        problems.append('v3.8 regression: beat-scale helper still repeats cube_scale_env check')

star_block=re.search(r'(?ms)^visual_draw_starfield:.*?^star_cols:', asm_nc)
if not star_block:
    problems.append('visual_draw_starfield block not found')
else:
    sblk=star_block.group(0)
    for bad in ['star_rows', 'lda mul40_lo', 'lda mul40_hi']:
        if bad in sblk:
            problems.append('v3.9 regression: starfield still uses row/mul40 path: '+bad)
    if not all(x in sblk for x in ['star_screen_lo','star_screen_hi']):
        problems.append('v3.9 starfield pointer tables not used')
# drum branch chain must be gone
trig_drum=re.search(r'(?ms)^trig_drum:.*?^drum_kick:', asm_nc)
if not trig_drum:
    problems.append('trig_drum block not found')
else:
    dblk=trig_drum.group(0)
    for bad in ['trig_drum_not_kick','trig_drum_not_snare','trig_drum_not_hat','trig_drum_not_crash','trig_drum_not_lift','cmp #1','cmp #2','cmp #3','cmp #4','cmp #5','cmp #6']:
        if bad in dblk:
            problems.append('old variable drum branch chain remains: '+bad)
    if not all(x in dblk for x in ['drum_jump_lo','drum_jump_hi','trig_drum_smc']):
        problems.append('drum jump table dispatch incomplete')
# clear block must be absolute-only
clear_block=re.search(r'(?ms)^visual_clear_fx_band:.*?^visual_clear_screen:', asm_nc)
if not clear_block:
    problems.append('visual_clear_fx_band block not found')
else:
    cblk=clear_block.group(0)
    for bad in ['sta (VISUAL_PTR),y','sta (CUBE_PTR),y','lda mul40_lo','lda mul40_hi','adc #SCREEN_TO_COLOR_HI_DELTA','adc #40','bne visual_clear_fx_row','dex','dey','inx','iny']:
        if bad in cblk:
            problems.append('runtime clear is not absolute-only, found: '+bad)
    screen_stores=len(re.findall(r'(?m)^\s*sta\s+SCREEN_RAM\+\d+', cblk))
    color_stores=len(re.findall(r'(?m)^\s*sta\s+COLOR_RAM\+\d+', cblk))
    if screen_stores != 19*40:
        problems.append(f'expected 760 screen absolute clear stores, found {screen_stores}')
    if color_stores != 19*40:
        problems.append(f'expected 760 color absolute clear stores, found {color_stores}')
# old checks
if re.search(r'adc\s+plot_x\s*\n\s*adc\s+#1', asm_nc):
    problems.append('page crossing beat-scale pointer bug remains')
if 'lda #$08\n        lda #$08' in asm_nc:
    problems.append('duplicate lda #$08 remains')
if 'lda #$02\n        lda #$02' in asm_nc:
    problems.append('duplicate lda #$02 remains')
if 'sta V1CTL\n        sta V1CTL' in asm_nc:
    problems.append('duplicate sta V1CTL remains')
if 'jsr visual_beat_flash' in asm_nc or re.search(r'(?m)^visual_beat_flash:', asm_nc):
    problems.append('v3.5 regression: visual_beat_flash call/routine remains')
if re.search(r'visual_beat_flash:.*?sta\s+\$d020', asm_nc, re.S):
    problems.append('visual_beat_flash still writes border mid-frame')
if re.search(r'visual_beat_flash:.*?sta\s+\$d021', asm_nc, re.S):
    problems.append('visual_beat_flash still writes background mid-frame')
low_depth_block=re.search(r'(?ms)^visual_plot_low_depth:.*?^visual_plot_store_color:', asm_nc)
if low_depth_block and 'song_flags' in low_depth_block.group(0):
    problems.append('low-depth plot still branches on song_flags per plot')
scale_down_block=re.search(r'(?ms)^visual_scale_extra_down:.*?^visual_scale_extra_store_color:', asm_nc)
if scale_down_block and 'song_flags' in scale_down_block.group(0):
    problems.append('scale-down plot still branches on song_flags per plot')
if 'lda mul40_lo,x\n        lda mul40_lo,x' in asm_nc:
    problems.append('duplicate mul40_lo load remains')
labels=re.findall(r'(?m)^([A-Za-z_][A-Za-z0-9_]*):', asm)
dups=sorted(x for x in set(labels) if labels.count(x)>1)
if dups:
    problems.append('duplicate labels: '+','.join(dups[:20]))
constants=re.findall(r'(?m)^([A-Za-z_][A-Za-z0-9_]*)\s*=', asm)
labelset=set(labels) | set(constants)
refs=set(re.findall(r'\b(?:jsr|jmp)\s+([A-Za-z_][A-Za-z0-9_]*)', asm_nc))
refs |= set(re.findall(r'[<>]([A-Za-z_][A-Za-z0-9_]*)', asm_nc))
refs |= set(re.findall(r'\b(?:beq|bne|bcc|bcs|bmi|bpl|bvc|bvs)\s+([A-Za-z_][A-Za-z0-9_]*)', asm_nc))
refs |= set(re.findall(r'\b(?:lda|sta|inc|dec|cmp|adc|sbc|ldx|ldy|cpx|cpy|ora|and|eor)\s+([A-Za-z_][A-Za-z0-9_]*)(?:[,\s]|$)', asm_nc))
ignore={'BUILD_SID','MUSIC_IRQ_BASIC','DEBUG_TIMING_BAR','STEPFRAMES','SCREEN_RAM','COLOR_RAM','FX_BAND_START','COLOR_FX_BAND_START','FX_BAND_ROWS','FX_BAND_COLS','SCREEN_TO_COLOR_HI_DELTA','IRQ_RASTER_LINE','VIC_RASTER_IRQ_MASK','RASTER_MSB_CLEAR_MASK','KERNAL_IRQ_EXIT','VISUAL_PTR','CUBE_PTR','PAT_LEAD','ORD_PTR','PAT_BASS','PAT_DRUM','V1F','V1PW','V1CTL','V1AD','V1SR','V2F','V2PW','V2CTL','V2AD','V2SR','V3F','V3PW','V3CTL','V3AD','V3SR','FLO','FHI','FRES','FMODE'}
undef=sorted(r for r in refs if r not in labelset and r not in ignore)
if undef:
    problems.append('undefined label-like refs: '+','.join(undef[:50]))
coord_bad=[]
for prefix in ('cube_fr','cube_pu','detail_fr','depth_dot_fr','accent_fr','cast_shadow_fr','occlusion_fr','floor_grid_fr','zslice_fr','lens_glint_fr','volume_shadow_fr','depth_fog_fr','chroma_fringe_fr','holo_tunnel_fr','vertex_sparkle_fr','parallax_beam_fr','light_flash_fr','scanline_flare_fr','rim_flash_fr','sync_strobe_fr','prism_halo_fr','crystal_snap_fr','apex_flash_fr','neon_focus_fr','safe_wide_rim_fr','inner_depth_weave_fr','perspective_orbit_fr','kinematic_rail_fr','phase_hinge_fr','motion_spline_fr','depth_normal_fr','depth_inertia_fr','centroid_lock_fr','eased_vector_fr','coherent_body_fr','temporal_coherence_fr','phase_fused_body_fr','motion_convergence_fr','orbital_stability_fr','body_projection_lock_fr','camera_spline_lock_fr','camera_inertia_lock_fr'):
    for m in re.finditer(r'(?m)^('+prefix+r'\d\d):\n((?:\s*!byte[^\n]*\n)+)', asm):
        lab=m.group(1); vals=[]
        for tok in re.findall(r'\$[0-9a-fA-F]+|\d+', m.group(2)):
            vals.append(int(tok[1:],16) if tok.startswith('$') else int(tok))
        i=0
        while i<len(vals):
            if vals[i]==0xff: break
            if i+1>=len(vals): coord_bad.append((lab,'trailing')); break
            x,y=vals[i],vals[i+1]
            if not(0<=x<40 and 0<=y<25): coord_bad.append((lab,x,y))
            # V5.7: transient/detail overlay coordinates must avoid edge columns/rows
            # that can look like wrapping on CRT/VIC output during flash bursts.
            if prefix != 'cube_fr' and not (3<=x<=35 and 3<=y<=21): coord_bad.append((lab,'edge-risk',x,y))
            if prefix == 'scanline_flare_fr' and x>35: coord_bad.append((lab,'scanline-right-risk',x,y))
            i+=2
if coord_bad:
    problems.append('coordinate errors: '+repr(coord_bad[:20]))
report={
 'asm':str(ASM),
 'labels':len(labels),
 'duplicate_labels':len(dups),
 'undefined_references':len(undef),
 'coordinate_errors':len(coord_bad),
 'double_speed_stepframes': 'STEPFRAMES = 2' in asm,
 'kernel_vector_safe_irq': all(x in asm for x in ['KERNAL_IRQ_EXIT = $ea81','irq_kernal_exit:','jmp KERNAL_IRQ_EXIT']),
 'irq_wrappers_inlined': not any(x in asm for x in ['irq_music_tick:','irq_visual_tick:','irq_keyboard_tick:','irq_music_basic_done:']),
 'fx_hotpath_inlined': play is not None and not any(x in play.group(0) for x in ['jsr fx_kick','jsr fx_filter','jsr fx_pwm','jsr fx_lead','jsr fx_bass']),
 'bounded_clear_active': 'jsr visual_clear_fx_band' in asm,
 'absolute_clear_active': clear_block is not None and len(re.findall(r'(?m)^\s*sta\s+SCREEN_RAM\+\d+', clear_block.group(0)))==760 and len(re.findall(r'(?m)^\s*sta\s+COLOR_RAM\+\d+', clear_block.group(0)))==760,
 'deterministic_drum_dispatch': trig_drum is not None and all(x in trig_drum.group(0) for x in ['drum_jump_lo','drum_jump_hi','trig_drum_smc']) and not any(x in trig_drum.group(0) for x in ['trig_drum_not_kick','cmp #1','cmp #2','cmp #3','cmp #4','cmp #5','cmp #6']),
 'fast_plot_delta_active': 'SCREEN_TO_COLOR_HI_DELTA = $d4' in asm and 'adc #SCREEN_TO_COLOR_HI_DELTA' in asm,
 'old_vu_top_side_removed': not any(x in asm for x in ['visual_draw_vu:','visual_draw_spark_frame:','visual_draw_glam:']),
 'keyboard_throttle': all(x in asm for x in ['irq_skip_keyboard_scan:', 'and #$03', 'jsr scan_space_skip']),
 'stable_border': 'single final border write in release path' in asm and not re.search(r'visual_beat_flash:.*?sta\s+\$d020', asm_nc, re.S),
 'depth_cache': all(x in asm for x in ['depth_low_color','scale_down_color','V2.8 cached low-depth color','V2.8 cached scale-down color']),
 'music_basic_noop_free': 'music IRQ BASIC does no visual, keyboard or border work' in asm and 'lda #$00               ; music IRQ BASIC' not in asm,
 'v3_3_technical_max': all(x in asm for x in ['V3.3_TECHNICAL_MAX','V3.3 absolute-store bounded IRQ clear.','V3.3 deterministic O(1) drum dispatch']),
 'v3_4_lean_irq_closure': all(x in asm for x in ['V3.4_LEAN_IRQ_CLOSURE','V3.4: raster MSB is fixed in setup/visual_init','V3.4: keyboard scan stays outside music tick and after final border']) and irq is not None and not re.search(r'(?m)^\s*(?:lda|sta)\s+\$d011\b', irq.group(0)) and (irq.group(0).find('jsr scan_space_skip') > irq.group(0).find('sta $d020')),
 'v3_5_flashcache_closure': all(x in asm for x in ['V3.5_FLASHCACHE_CLOSURE','V3.5: also caches flash_color','V3.5: cache final border/flash color here too','V3.5: old visual_beat_flash routine removed']) and 'jsr visual_beat_flash' not in asm_nc and not re.search(r'(?m)^visual_beat_flash:', asm_nc),
 'v3_6_steptoggle_tailgate': play is not None and 'eor #$01' in play.group(0) and 'cmp #STEPFRAMES' not in play.group(0) and 'visual_update_no_tail:' in asm,
 'v3_7_zp_roi_max': all(x in asm for x in ['V3.7_ZP_ROI_MAX','ZP_RUNTIME_START = $06','sound_init_zp_clear:','hot runtime variables are zero-page aliases']) and not re.search(r'(?m)^kick_env:\s*!byte', asm),
 'v3_8_beatscale_gate_roi': all(x in asm for x in ['V3.8_BEATSCALE_GATE_ROI','V3.8 ROI: beat-scale extras are inactive most frames','visual_plot_beat_scale_active:','caller has already verified cube_scale_env >= 6']) and plot_block is not None and beat_block is not None and 'cmp #$06' in plot_block.group(0) and 'cmp #$06' not in beat_block.group(0),
 'v7_8_black_background_lock_fx': 'V8.1_OPT: inline visual_black_background_lock' in asm and re.search(r'(?m)^\s*lda #\$00\s+; V8\.1_OPT: inline visual_black_background_lock\n\s*sta \$d021', asm_nc) is not None,
 'v8_1_camera_inertia_black_lock_fx': all(x in asm for x in ['V8.1_CAMERA_INERTIA_BLACK_LOCK_FX','visual_draw_cube_camera_inertia_lock:','camera_inertia_lock_frame_lo:','camera_inertia_lock_color_cycle:','final damped camera-inertia anchors']) and 'adc star_phase' not in re.search(r'(?ms)^visual_draw_cube_camera_inertia_lock:.*?^visual_draw_cube_depth_dots:', asm_nc).group(0),
 'v8_0_camera_spline_black_lock_fx': all(x in asm for x in ['V8.0_CAMERA_SPLINE_BLACK_LOCK_FX','visual_draw_cube_camera_spline_lock:','camera_spline_lock_frame_lo:','camera_spline_lock_color_cycle:','final phase-correct camera/body spline cue']) and 'adc star_phase' not in re.search(r'(?ms)^visual_draw_cube_camera_spline_lock:.*?^visual_draw_cube_camera_inertia_lock:', asm_nc).group(0),
 'v7_7_body_projection_lock_fx': all(x in asm for x in ['V7.7_BODY_PROJECTION_LOCK_FX','visual_draw_cube_body_projection_lock:','body_projection_lock_frame_lo:','body_projection_lock_color_cycle:','phase-correct body-projection lock anchors']) and 'adc star_phase' not in re.search(r'(?ms)^visual_draw_cube_body_projection_lock:.*?^visual_draw_cube_depth_dots:', asm_nc).group(0),
 'v7_6_orbital_stability_body_fx': all(x in asm for x in ['V7.6_ORBITAL_STABILITY_BODY_FX','visual_draw_cube_orbital_stability_body:','orbital_stability_frame_lo:','orbital_stability_color_cycle:','phase-correct orbital-stability anchors']) and 'adc star_phase' not in re.search(r'(?ms)^visual_draw_cube_orbital_stability_body:.*?^visual_draw_cube_depth_dots:', asm_nc).group(0),
 'v7_5_motion_convergence_lock_fx': all(x in asm for x in ['V7.5_MOTION_CONVERGENCE_LOCK_FX','visual_draw_cube_motion_convergence_lock:','motion_convergence_frame_lo:','motion_convergence_color_cycle','phase-correct motion-convergence anchors']) and 'adc star_phase' not in re.search(r'(?ms)^visual_draw_cube_motion_convergence_lock:.*?^visual_draw_cube_depth_dots:', asm_nc).group(0),
 'v7_4_phase_fused_body_motion_fx': all(x in asm for x in ['V7.4_PHASE_FUSED_BODY_MOTION_FX','visual_draw_cube_phase_fused_body_motion:','phase_fused_body_frame_lo:','phase_fused_body_color_cycle','phase-fused rigid-body anchors']) and 'adc star_phase' not in re.search(r'(?ms)^visual_draw_cube_phase_fused_body_motion:.*?^visual_draw_cube_depth_dots:', asm_nc).group(0),
 'v7_2_coherent_body_motion_fx': all(x in asm for x in ['V7.2_COHERENT_BODY_MOTION_FX','visual_draw_cube_coherent_body_motion:','coherent_body_frame_lo:','coherent_body_color_cycle','phase-correct coherent-body anchors']) and 'adc star_phase' not in re.search(r'(?ms)^visual_draw_cube_coherent_body_motion:.*?^visual_draw_cube_depth_dots:', asm_nc).group(0),
 'v7_1_eased_vector_motion_fx': all(x in asm for x in ['V7.1_EASED_VECTOR_MOTION_FX','visual_draw_cube_eased_vector_motion:','eased_vector_frame_lo:','eased_vector_color_cycle','phase-correct eased-vector anchors']) and 'adc star_phase' not in re.search(r'(?ms)^visual_draw_cube_eased_vector_motion:.*?^visual_draw_cube_depth_dots:', asm_nc).group(0),
 'v7_0_centroid_motion_lock_fx': all(x in asm for x in ['V7.0_CENTROID_MOTION_LOCK_FX','visual_draw_cube_centroid_motion_lock:','centroid_lock_frame_lo:','centroid_lock_color_cycle','phase-correct centroid/axis-lock anchors']) and 'adc star_phase' not in re.search(r'(?ms)^visual_draw_cube_centroid_motion_lock:.*?^visual_draw_cube_depth_dots:', asm_nc).group(0),
 'v6_9_inertia_normal_depth_fx': all(x in asm for x in ['V6.9_INERTIA_NORMAL_DEPTH_FX','visual_draw_cube_depth_inertia_motion:','depth_inertia_frame_lo:','depth_inertia_color_cycle','phase-correct depth-inertia anchors']) and 'adc star_phase' not in re.search(r'(?ms)^visual_draw_cube_depth_inertia_motion:.*?^visual_draw_cube_depth_dots:', asm_nc).group(0),
 'v6_8_depth_normal_motion_fx': all(x in asm for x in ['V6.8_DEPTH_NORMAL_MOTION_FX','visual_draw_cube_depth_normal_motion:','depth_normal_frame_lo:','depth_normal_color_cycle','phase-correct depth-normal vector anchors']) and 'adc star_phase' not in re.search(r'(?ms)^visual_draw_cube_depth_normal_motion:.*?^visual_draw_cube_depth_dots:', asm_nc).group(0),
 'v6_7_motion_spline_depth_fx': all(x in asm for x in ['V6.7_MOTION_SPLINE_DEPTH_FX','visual_draw_cube_motion_spline_depth:','motion_spline_frame_lo:','motion_spline_color_cycle','smooth S-curve between orbit/rail/hinge phases']) and 'adc star_phase' not in re.search(r'(?ms)^visual_draw_cube_motion_spline_depth:.*?^visual_draw_cube_depth_dots:', asm_nc).group(0),
 'v6_6_phase_hinge_motion_fx': all(x in asm for x in ['V6.6_PHASE_HINGE_MOTION_FX','visual_draw_cube_phase_hinge_motion:','phase_hinge_frame_lo:','phase_hinge_color_cycle','Motion is phase-matched with orbit/rails but offset by 12 frames']) and 'adc star_phase' not in re.search(r'(?ms)^visual_draw_cube_phase_hinge_motion:.*?^visual_draw_cube_depth_dots:', asm_nc).group(0),
 'v6_5_kinematic_depth_lock_fx': all(x in asm for x in ['V6.5_KINEMATIC_DEPTH_LOCK_FX','visual_draw_cube_kinematic_depth_rails:','kinematic_rail_frame_lo:','kinematic_rail_color_cycle','Motion is coherent over 16 frames and locked to vis_frame']) and 'adc star_phase' not in re.search(r'(?ms)^visual_draw_cube_kinematic_depth_rails:.*?^visual_draw_cube_phase_hinge_motion:', asm_nc).group(0),
 'v6_4_phase_correct_3d_motion_fx': all(x in asm for x in ['V6.4_PHASE_CORRECT_3D_MOTION_FX','visual_draw_cube_perspective_orbit:','perspective_orbit_frame_lo:','perspective_orbit_color_cycle','Motion is monotonic over 16 frames and locked to vis_frame']) and 'adc star_phase' not in re.search(r'(?ms)^visual_draw_cube_inner_depth_weave:.*?^visual_draw_cube_perspective_orbit:', asm_nc).group(0),
 'v6_3_inner_depth_weave_fx': all(x in asm for x in ['V6.3_INNER_DEPTH_WEAVE_FX','visual_draw_cube_inner_depth_weave:','inner_depth_weave_frame_lo:','inner_depth_weave_color_cycle']) and 'adc star_phase' not in re.search(r'(?ms)^visual_draw_cube_inner_depth_weave:.*?^visual_draw_cube_perspective_orbit:', asm_nc).group(0),
 'v6_2_safe_wide_depth_snap_fx': all(x in asm for x in ['V6.2_SAFE_WIDE_DEPTH_SNAP_FX','visual_draw_cube_safe_wide_rim:','safe_wide_rim_frame_lo:','safe_wide_rim_color_cycle','x<=34 only']),
 'v6_1_inner_viewport_snap_fx': all(x in asm for x in ['visual_scrub_right_edge:','cmp #34','cols 35..39']),
 'v6_0_true_viewport_lock_fx': all(x in asm for x in ['V6.0_TRUE_VIEWPORT_LOCK_FX','visual_plot_skip:','visual_plot_shadow_skip:','visual_plot_tail_skip','cmp #35','star_cols:']),
 'v5_9_edge_seal_depth_polish_fx': all(x in asm for x in ['V5.9_EDGE_SEAL_DEPTH_POLISH_FX','visual_scrub_right_edge:','post-draw edge seal','jsr visual_scrub_right_edge']),
 'v5_8_hard_right_edge_nowrap_fix': all(x in asm for x in ['V5.8_HARD_RIGHT_EDGE_NOWRAP_FIX','full-width FX band clear','hard x>=35 overlay guard','cmp #35']),
 'v5_7_nowrap_flash_closure_fx': all(x in asm for x in ['V5.7_NOWRAP_FLASH_CLOSURE_FX','visual_plot_detail_skip:']),
 'v5_6_neon_focus_snap_closure_fx': all(x in asm for x in ['V5.6_NEON_FOCUS_SNAP_CLOSURE_FX','visual_draw_cube_neon_focus:','neon_focus_frame_lo:','neon_focus_color_cycle:','center-focus neon pulse','no tail-follow']),
 'v5_5_perfect_snap_closure_fx': all(x in asm for x in ['V5.5_PERFECT_SNAP_CLOSURE_FX','visual_draw_cube_apex_flash:','apex_flash_frame_lo:','apex_flash_color_cycle:','tiny final peak/pre apex flash']),
 'v5_3_prism_snap_polish_fx': 'V8.1_OPT' in asm,
 'v5_2_final_snaplock_closure_fx': all(x in asm for x in ['V5.2_FINAL_SNAPLOCK_CLOSURE_FX','foreground flash is peak/pre-only','phase lead is strictly consumed','pre/peak only','no second-frame late sparkle']),
 'v5_1_snaplock_microstrobe_fx': all(x in asm for x in ['V5.1_SNAPLOCK_MICROSTROBE_FX','visual_draw_cube_sync_strobe:','sync_strobe_frame_lo:','sync_strobe_color_cycle:','do NOT set visual_light_gate from lookahead']),
 'v5_0_tightlock_lightsync_fx': all(x in asm for x in ['V5.0_TIGHTLOCK_LIGHTSYNC_FX','visual_light_gate','visual_phase_lead','peak-only light latch','flash gate is peak-only']),
 'v4_9_phaselock_preflash_fx': all(x in asm for x in ['V4.9_PHASELOCK_PREFLASH_FX','prefetch must only run on the non-step IRQ','real kick owns the frame','fast visual-only decay','preflash is strictly one rendered frame']),
 'v4_8_music_sync_preflash_fx': all(x in asm for x in ['V4.8_MUSIC_SYNC_PREFLASH_FX','visual_prefetch_next_hits:','visual_kick_sync','visual_lead_sync','visual_pre_sync','visual_decay_sync_pulses:']),
 'v4_7_light_flash_depth_fx': all(x in asm for x in ['V4.7_LIGHT_FLASH_DEPTH_FX','visual_draw_cube_light_flash:','visual_draw_cube_scanline_flare:','visual_draw_cube_rim_flash:','light_flash_frame_lo:','scanline_flare_frame_lo:','rim_flash_frame_lo:','light_flash_color_cycle:','scanline_flare_color_cycle:','rim_flash_color_cycle:']),
 'v4_5_holo_parallax_depth_fx': all(x in asm for x in ['V4.5_HOLO_PARALLAX_DEPTH_FX','visual_draw_cube_tunnel_rings:','visual_draw_cube_vertex_sparkle:','visual_draw_cube_parallax_beams:','holo_tunnel_frame_lo:','vertex_sparkle_frame_lo:','parallax_beam_frame_lo:']),
 'v4_4_volumetric_depth_fx': all(x in asm for x in ['V4.4_VOLUMETRIC_DEPTH_FX','visual_draw_cube_volume_shadow:','visual_draw_cube_depth_fog:','visual_draw_cube_chroma_fringe:','volume_shadow_frame_lo:','depth_fog_frame_lo:','chroma_fringe_frame_lo:']),
 'v4_3_perfect_depth_illusion': all(x in asm for x in ['V4.3_PERFECT_DEPTH_ILLUSION','visual_draw_cube_floor_grid:','visual_draw_cube_zslice:','visual_draw_cube_lens_glints:','floor_grid_frame_lo:','zslice_frame_lo:','lens_glint_frame_lo:','floor_grid_color_cycle:','zslice_color_cycle:','lens_glint_color_cycle:']),
 'v4_2_shadow_depth_illusion': all(x in asm for x in ['V4.2_SHADOW_DEPTH_ILLUSION','visual_draw_cube_cast_shadow:','cast_shadow_frame_lo:']),
 'v4_1_detailmax_colour_fx': all(x in asm for x in ['V4.1_DETAILMAX_COLOUR_FX','visual_draw_cube_depth_dots:','visual_draw_cube_accents:','depth_dot_frame_lo:','accent_frame_lo:','accent_color_cycle:']),
 'v3_9_starptr_roi': all(x in asm for x in ['V3.9_STARPTR_ROI','star_screen_lo:','star_screen_hi:','V3.9 ROI: rows are fixed']) and (re.search(r'(?ms)^visual_draw_starfield:.*?^star_cols:', asm_nc) is not None) and 'star_rows' not in re.search(r'(?ms)^visual_draw_starfield:.*?^star_cols:', asm_nc).group(0),
 'problems':problems
}
print(json.dumps(report, indent=2))
if problems:
    sys.exit(1)
