// shaders/minerals/tigers-eye.glsl
// TIGER'S EYE
// Source: Weird Guy Mineral Shader Corpus

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;

vec3 tiger_palette(float t) {
    return vec3(0.2, 0.1, 0.0) + vec3(0.8, 0.5, 0.1) * pow(t, 2.0);
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;
    vec2 mouse = (u_mouse / u_resolution.xy) * 2.0 - 1.0;

    float fiber_warp = sin(uv.y * 3.0 + u_time * 0.5) * 0.2;
    vec2 tangent = normalize(vec2(1.0, fiber_warp));

    vec3 L = normalize(vec3(mouse, 1.0));
    vec3 V = vec3(0.0, 0.0, 1.0);
    vec3 T = vec3(tangent, 0.0);

    float dotLT = dot(L, T);
    float dotVT = dot(V, T);
    float chatoyancy = pow(
        sqrt(1.0 - dotLT * dotLT) * sqrt(1.0 - dotVT * dotVT) - dotLT * dotVT, 
        32.0
    );

    float layers = sin(uv.x * 20.0 + fiber_warp * 10.0);
    layers = smoothstep(-0.5, 0.5, layers);

    vec3 base_stone = tiger_palette(0.2 + uv.y * 0.1);
    vec3 silk_glow = tiger_palette(0.9) * chatoyancy * 5.0;
    vec3 final = base_stone + (silk_glow * layers);
    final = mix(final, vec3(0.05, 0.02, 0.0), length(uv) * 0.5);

    gl_FragColor = vec4(final, 1.0);
}
