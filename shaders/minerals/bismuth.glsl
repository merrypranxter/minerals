// shaders/minerals/bismuth.glsl
// BISMUTH
// Source: Weird Guy Mineral Shader Corpus

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;

float l1_norm(vec3 p) {
    return abs(p.x) + abs(p.y) + abs(p.z);
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;
    vec3 p = vec3(uv, 0.0);
    p.z = sin(u_time * 0.2) * 0.5;

    float d = 0.0, scale = 1.0;
    for(int i = 0; i < 6; i++) {
        p = abs(p) - 0.5;
        p *= 1.5;
        scale *= 1.5;
        float step_d = l1_norm(p) / scale;
        d = max(d, step_d);
    }

    vec3 rainbow = 0.5 + 0.5 * cos(u_time + d * 50.0 + vec3(0, 2, 4));
    float edge = smoothstep(0.01, 0.02, fract(d * 10.0));
    vec3 final_color = rainbow * edge;
    final_color *= exp(-length(uv) * 1.0);

    gl_FragColor = vec4(final_color, 1.0);
}
