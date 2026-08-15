vec4 open_color(vec3 coords_geo, vec3 size_geo) {
    float pi = 3.14159;

    float p = niri_progress;
    float pxp = p*p;

    float aspect = size_geo.x / size_geo.y;
    vec2 pos = coords_geo.xy - vec2(0.5, 0.5);

    // little jump
    float bump = pxp - pxp * p;
    pos.y += bump * 0.6;

    // zoom from 1/10 to 1 
    float factor = mix(10.0, 1.0, p);

    float angle = atan(pos.y, pos.x);
    // distance to PI/2 diagonal axis
    float angle_f = 1.0 - abs(mod(angle, pi * 0.5) / (pi * 0.5) - 0.5) * 2.0;
    // squared to round distortion
    angle_f *= angle_f;
    // 1 -> x and y axis to factor -> diagonals
    float corner_influence = mix(1.0, factor, angle_f * 0.13);
    // corner_influence is from factor to factor^2
    vec2 distorted = pos * factor * corner_influence;

    // rmap to uv space
    vec2 remapped_uv = distorted + vec2(0.5, 0.5);

    // color mods
    float alpha_fade_f = p;

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
