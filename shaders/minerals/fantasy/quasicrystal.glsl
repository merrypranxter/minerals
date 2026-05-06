// shaders/minerals/fantasy/quasicrystal.glsl
// QUASICRYSTAL (Forbidden Symmetry)
// Source: Weird Guy Mineral Shader Corpus (Pass 4 - Fantasy)

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;

// Penrose rhombus tiling
float penrose_rhombus(vec2 p, float scale) {
    // Golden ratio
    float phi = 1.618033988;

    // 5-fold symmetry
    float r = length(p);
    float theta = atan(p.y, p.x);

    // Ammann bars (decoration lines)
    float ammann = 0.0;
    for(int i = 0; i < 5; i++) {
        float fi = float(i);
        float angle = fi * 2.51327; // 2*pi/5 * phi
        float proj = p.x * cos(angle) + p.y * sin(angle);
        ammann += smoothstep(0.02, 0.0, abs(fract(proj * scale) - 0.5));
    }

    return ammann;
}

// Fat and skinny rhombi
float rhombus_sdf(vec2 p, vec2 center, float angle, float fat) {
    vec2 local = (p - center) * rot(-angle);

    // Golden ratio proportions
    float phi = 1.618033988;
    float a = fat ? phi : 1.0;
    float b = fat ? 1.0 : 1.0 / phi;

    vec2 d = abs(local) - vec2(a, b) * 0.1;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    // Generate Penrose tiling
    float tiling = 0.0;
    vec3 color = vec3(0.0);

    for(int i = 0; i < 50; i++) {
        float fi = float(i);
        vec2 center = vec2(
            sin(fi * 2.5 + 1.0) * 0.6,
            cos(fi * 1.9 + 2.0) * 0.6
        );
        float angle = fi * 2.51327; // Golden angle
        bool fat = mod(fi, 2.0) < 1.0;

        float rhomb = rhombus_sdf(uv, center, angle, fat);
        float inside = smoothstep(0.02, -0.02, rhomb);

        // Fat = blue, skinny = gold
        vec3 rhomb_color = fat ? vec3(0.2, 0.3, 0.5) : vec3(0.6, 0.5, 0.2);
        color += rhomb_color * inside;
        tiling += inside;
    }

    // Ammann lines (quasiperiodic decoration)
    float ammann = penrose_rhombus(uv, 3.0);
    color += vec3(0.1, 0.1, 0.2) * ammann;

    // Metallic aluminum base
    vec3 base = vec3(0.8, 0.85, 0.9) * (1.0 - tiling);

    vec3 final = base + color;

    gl_FragColor = vec4(final, 1.0);
}
