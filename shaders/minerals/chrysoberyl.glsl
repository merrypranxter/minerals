// shaders/minerals/chrysoberyl.glsl
// CHRYSOBERYL (Cat's Eye / Cymophane)
// Source: Weird Guy Mineral Shader Corpus

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    // Honey-gold base
    vec3 base = vec3(0.6, 0.5, 0.1);

    // Needle direction (slightly wavy)
    float needle_angle = 0.3 + sin(uv.y * 2.0) * 0.05;
    vec2 needle_dir = vec2(cos(needle_angle), sin(needle_angle));

    // The cat's eye band: sharp, single, moving
    float band_pos = dot(uv, needle_dir);
    float light_pos = dot((u_mouse / u_resolution - 0.5) * 2.0, needle_dir);

    // Band follows light position
    float band = exp(-pow((band_pos - light_pos) * 20.0, 2.0));

    // Sharp highlight (much sharper than Tiger's Eye)
    vec3 highlight = vec3(1.0, 0.9, 0.6) * band * 3.0;

    // Milk-and-honey body color
    float body = 0.8 + sin(uv.x * 3.0 + uv.y * 2.0) * 0.1;

    vec3 final = base * body + highlight;

    // Translucency at edges
    float edge = 1.0 - length(uv) * 0.3;
    final *= edge;

    gl_FragColor = vec4(final, 1.0);
}
