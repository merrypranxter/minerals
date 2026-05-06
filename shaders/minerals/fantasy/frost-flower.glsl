// shaders/minerals/fantasy/frost-flower.glsl
// FROST FLOWER (Ice on Window)
// Source: Weird Guy Mineral Shader Corpus (Pass 4 - Atmospheric)

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;

// DLA-like frost growth
float frost_growth(vec2 p, float seed, float time) {
    float growth = 0.0;
    vec2 pos = p;

    for(int i = 0; i < 6; i++) {
        float fi = float(i);
        // Random walk biased toward cold (edge)
        float angle = hash21(pos * 10.0 + fi + seed) * 6.28;
        vec2 dir = vec2(cos(angle), sin(angle));

        // Bias toward edges (colder)
        dir += normalize(p) * 0.3;
        dir = normalize(dir);

        pos += dir * 0.02;

        // Deposit if cold enough
        float cold = smoothstep(0.5, 1.0, length(pos));
        growth += exp(-length(p - pos) * length(p - pos) * 200.0) * cold;
    }

    return growth;
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    // Multiple seed points (dust particles)
    float frost = 0.0;
    for(int i = 0; i < 20; i++) {
        float fi = float(i);
        vec2 seed = vec2(
            sin(fi * 3.1 + 1.0) * 0.8,
            cos(fi * 2.7 + 2.0) * 0.8
        );
        frost += frost_growth(uv, fi, u_time * 0.1);
    }

    // Frost: white, crystalline
    vec3 frost_color = vec3(0.95, 0.97, 1.0) * smoothstep(0.1, 0.5, frost);

    // Glass background
    vec3 glass = vec3(0.6, 0.7, 0.8) * (1.0 - length(uv) * 0.2);

    // Cold condensation at edges
    float condensation = smoothstep(0.8, 1.0, length(uv));
    glass += vec3(0.7, 0.75, 0.85) * condensation * 0.5;

    gl_FragColor = vec4(glass + frost_color, 1.0);
}
