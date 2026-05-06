// shaders/minerals/fantasy/superconductor.glsl
// SUPERCONDUCTOR MINERAL (Meissner Effect)
// Source: Weird Guy Mineral Shader Corpus (Pass 4 - Fantasy)

precision highp float;
uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;

// Meissner effect: magnetic field exclusion
float meissner(vec2 p, vec2 magnet, float strength) {
    float d = length(p - magnet);
    // Field drops exponentially inside superconductor
    float exclusion = 1.0 - exp(-d * d / strength);
    return exclusion;
}

// Flux pinning (quantum locking)
float flux_pin(vec2 p, float lattice_constant) {
    vec2 grid = p / lattice_constant;
    vec2 f = fract(grid) - 0.5;
    // Vortices at pinning sites
    float vortex = length(f);
    return exp(-vortex * vortex * 100.0);
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / u_resolution.y;

    // Superconducting disk
    float disk = smoothstep(0.5, 0.48, length(uv));

    // Magnetic field (from mouse)
    vec2 magnet = (u_mouse / u_resolution - 0.5) * 2.0;
    float field = meissner(uv, magnet, 0.2);

    // Field lines excluded
    float field_lines = abs(sin(atan(uv.y - magnet.y, uv.x - magnet.x) * 10.0));
    field_lines *= field;

    // Flux pinning vortices
    float pins = 0.0;
    for(int i = 0; i < 20; i++) {
        float fi = float(i);
        vec2 pin_site = vec2(sin(fi * 3.1) * 0.3, cos(fi * 2.7) * 0.3);
        pins += flux_pin(uv - pin_site, 0.1);
    }

    // Superconductor color: silvery, mirror-like
    vec3 superconductor = vec3(0.9, 0.95, 1.0) * disk;

    // Excluded field glow
    vec3 exclusion = vec3(0.2, 0.5, 1.0) * field_lines * 2.0;

    // Vortex cores (normal state inside)
    vec3 vortex = vec3(0.1, 0.1, 0.2) * pins;

    // Levitation shadow (floating above surface)
    float levitation = sin(u_time * 2.0) * 0.02 + 0.05;
    float shadow = smoothstep(0.5 + levitation, 0.3 + levitation, length(uv));

    vec3 final = superconductor + exclusion + vortex;
    final *= 1.0 - shadow * 0.3;

    gl_FragColor = vec4(final, 1.0);
}
