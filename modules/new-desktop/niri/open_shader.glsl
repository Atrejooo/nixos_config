vec4 open_color(vec3 coords_geo, vec3 size_geo) {
    float pi = 3.14159;

    float aspect = size_geo.x / size_geo.y;
    vec2 pos = coords_geo.xy - vec2(0.5, 0.5);
    // huh why tf is * 0.95 even needed for a nice circle :O
    vec2 aspect_norm_pos = vec2(pos.x * aspect * 0.95, pos.y);

    // -------------------
    //     ZOOM + JUMP
    // -------------------
     
    // -- params --
    // faster zoom to catch up with shockwave 
    float zoom_speed_f = 2.3;
    // scale factor (i.e. 10 means 0.1 scale on begin)
    float zoom_scale_f = 10.0;
    // jump height
    float jump_height = 0.6;

    // -- computing --
    float zoom_p = min(1.0, niri_progress * zoom_speed_f);
    // own ease out curve
    zoom_p = -zoom_p * zoom_p + zoom_p * 2.0;
    float zoom_pxp = zoom_p * zoom_p;
    // little jump
    float jump = zoom_pxp - zoom_pxp * zoom_p;
    pos.y += jump * jump_height;

    // zoom from 1/10 to 1 
    float zoom = mix(zoom_scale_f, 1.0, zoom_p);

    float angle = atan(pos.y, pos.x);
    // distance to PI/2 diagonal axis
    float angle_f = 1.0 - abs(mod(angle, pi * 0.5) / (pi * 0.5) - 0.5) * 2.0;
    // squared to round off distortion
    angle_f *= angle_f;
    // 1.0 - x and y axis [lerped] -> zoom - diagonals
    float corner_influence = mix(1.0, zoom, angle_f * 0.13);
    // distorted from zoom to ca. zoom^2 (in corners)
    vec2 distorted = pos * zoom * corner_influence;

    // -------------------
    //      SHOCKWAVE
    // -------------------
     
    // -- params --
    // delays the start of the wave
    float shockwave_p_delay = 0.20;
    // controls overall strenght of the wave
    float shockwave_strength_f = 0.14;
    // makes the wave travel further and faster (dependent on window size)
    float shockwave_speed_f = 0.8 * max(size_geo.x, size_geo.y);
    // wave ripple zoom
    float shockwave_zoom = 0.04;
    // where in the progress should the wave be most prominent
    float p_mask_peak = 0.15;
    // progress peak lenght (plateau lenght)
    float p_mask_peak_lenght = 0.1;
    // controls the size of the falloff edge size at the edge of the uv sapce of a window for the wave
    // 0.1 means from uv 0.9 to 1.0 and 0.1 to 0.0 the wave distortion is decayed via smoothstep 
    float shockwave_border_mask_edge = 0.05;

    // -- computing --
    float shockwave_p = clamp((niri_progress - shockwave_p_delay) / (1.0 - shockwave_p_delay), 0.0, 1.0);
    // shockwave_p = -shockwave_p * shockwave_p + shockwave_p * 2.0;
    float shockwave_pxp = shockwave_p * shockwave_p;

    // * size_geo.x * xxx makes the wave depend on screen space instead of window space
    //     - i.e. small windows have the same wave
    float shockwave_sd = (shockwave_p * shockwave_speed_f - length(size_geo.xy * pos)) * shockwave_zoom;
     
    // applies a mask based on progress to the strenght via two smoothstep going 0 -> 1 -> 0 in one smooth slope 
    float strenght_p_mask = smoothstep(0.0, p_mask_peak, shockwave_p)
        * (1.0 - smoothstep(p_mask_peak + p_mask_peak_lenght, 1.0, shockwave_p)); 
    // smooth fall off for strenght over distance (f(x) = 1 / (x ^ 2 + 1))
    float shockwave_d_mask = 1.0 / (shockwave_sd * shockwave_sd + 1.0);
    // ripple via sin and applied masks
    float shockwave_strength = sin(0.5 * shockwave_sd) * shockwave_d_mask * strenght_p_mask;
    // controls overall strenght of the wave
    shockwave_strength *= shockwave_strength_f;

    shockwave_strength *= 1.0 - smoothstep(0.5 - shockwave_border_mask_edge, 0.5, abs(pos.x));
    shockwave_strength *= 1.0 - smoothstep(0.5 - shockwave_border_mask_edge, 0.5, abs(pos.y));

    // apply shockwave 
    distorted += shockwave_strength * normalize(aspect_norm_pos);

    // rmap to uv space
    vec2 remapped_uv = distorted + vec2(0.5, 0.5);

    // color mods
    float alpha_fade_f = zoom_pxp;

    // geometry coords -> texture coords (texture can extend past geometry for CSD shadows)
    vec3 tc = niri_geo_to_tex * vec3(remapped_uv, 1.0);

    vec4 color = texture2D(niri_tex, tc.st);
    color.w *= alpha_fade_f;
    return color;
}
 
// +------------------------------------------------------------------------------------+
// | Entry functions (define exactly one per animation)                                 |
// +----------------------+-------------------------------------------------------------+
// | animation            | GLSL function                                               |
// +----------------------+-------------------------------------------------------------+
// | window-open          | vec4 open_color(vec3 coords_geo, vec3 size_geo)             |
// | window-close         | vec4 close_color(vec3 coords_geo, vec3 size_geo)            |
// | window-resize        | vec4 resize_color(vec3 coords_curr_geo, vec3 size_curr_geo) |
// +----------------------+-------------------------------------------------------------+
// 
// +------------------------------------------------------------------------------------+
// | Function arguments                                                                 |
// +----------------------+-------------------------------------------------------------+
// | coords_geo /         | Homogeneous (z=1) coords relative to window's visible       |
// | coords_curr_geo      | geometry. (0,0) top-left, y points down; 0..1 spans the     |
// |                      | window; outside that range when outside the window (can be  |
// |                      | fully off-screen).                                          |
// | size_geo /           | Window geometry size in logical pixels (use .xy),           |
// | size_curr_geo        | homogeneous (z=1). For pixel-accurate / aspect-correct      |
// |                      | effects.                                                    |
// +----------------------+-------------------------------------------------------------+
// 
// +----------------------------------------------------------------------------------------+
// | Uniforms: ALL animations                                                               |
// +----------------------+------+----------------------------------------------------------+
// | uniform              | type | meaning                                                  |
// +----------------------+------+----------------------------------------------------------+
// | niri_progress        | float| Unclamped progress 0..1; overshoots/oscillates (springs) |
// | niri_clamped_progress| float| Clamped progress 0..1; freezes at 1, never overshoots    |
// +----------------------+------+----------------------------------------------------------+
// 
// +----------------------------------------------------------------------------------------+
// | Uniforms: window-open / window-close only                                              |
// +----------------------+-----------+-----------------------------------------------------+
// | uniform              | type      | meaning                                             |
// +----------------------+-----------+-----------------------------------------------------+
// | niri_tex             | sampler2D | Window texture (sample: texture2D(niri_tex, tc.st)) |
// | niri_geo_to_tex      | mat3      | Geometry coords -> texture coords (texture can      |
// |                      |           | extend past geometry for CSD shadows)               |
// | niri_random_seed     | float     | Random in [0,1), constant for the animation         |
// +----------------------+-----------+-----------------------------------------------------+
// 
// +----------------------------------------------------------------------------------------+
// | Uniforms: window-resize only                                                           |
// +----------------------+-----------+-----------------------------------------------------+
// | uniform              | type      | meaning                                             |
// +----------------------+-----------+-----------------------------------------------------+
// | niri_tex_prev /      | sampler2D | Window textures before / after the resize           |
// | niri_tex_next        |           |                                                     |
// | niri_geo_to_tex_prev | mat3      | Geometry -> texture for prev / next state           |
// | / niri_geo_to_tex_   |           |                                                     |
// | next                 |           |                                                     |
// | niri_curr_geo_to_    | mat3      | Current geometry -> prev / next geometry; check     |
// | prev_geo / niri_     |           | [0][0] and [1][1] <= 1.0 to pick crop vs stretch    |
// | curr_geo_to_next_geo |           |                                                     |
// +----------------------+-----------+-----------------------------------------------------+
// Notes: no niri_random_seed in resize. Return premultiplied-alpha color; avoid the niri_ prefix; no custom uniforms.
