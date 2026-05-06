// shaders/minerals/agate.glsl
// AGATE
// Source: Weird Guy Mineral Shader Corpus

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;

void main() {
    vec2 p = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;
    float d = length(p);

    // Recursive folding
    for(int i = 0; i < 4; i++) {
        p += cos(p.yx * 3.0 + vec2(u_time, u_time * 1.3)) * 0.5;
        p -= sin(p.yx * 2.0 - u_time * 0.5) * 0.5;
    }

    float strata = sin(length(p) * 15.0 + u_time);
    strata = smoothstep(-0.2, 0.2, strata);

    vec3 col = 0.5 + 0.5 * cos(u_time + p.xyx + vec3(0, 2, 4));
    col *= strata;

    gl_FragColor = vec4(col / (d * d + 0.5), 1.0);
}
