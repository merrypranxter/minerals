// shaders/minerals/labradorite.glsl
// LABRADORITE
// Source: Weird Guy Mineral Shader Corpus

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;

vec3 pal(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
    return a + b * cos(6.28318 * (c * t + d));
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;
    vec3 view = normalize(vec3(uv, 1.0));
    vec3 norm = vec3(0.0, 0.0, 1.0);

    // Domain warp
    vec2 p = uv;
    p += cos(p.yx * 4.0 + u_time * 0.2) * 0.2;

    float d = dot(view, norm);
    float noise = fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);

    // Interference engine
    float interference = sin(d * 80.0 + p.x * 10.0 + p.y * 5.0 + u_time);
    float flash = smoothstep(0.85, 0.99, interference);

    vec3 spec_color = pal(p.x * 0.1 + p.y * 0.1 + u_time * 0.05,
        vec3(0.5), vec3(0.5), vec3(1.0), vec3(0.0, 0.33, 0.67));

    vec3 stone = vec3(0.08, 0.09, 0.1) + noise * 0.02;
    vec3 final = mix(stone, spec_color, flash * 0.8);
    final += pow(max(0.0, d), 32.0) * 0.1;

    gl_FragColor = vec4(final, 1.0);
}
