// shaders/minerals/fantasy/c8-phosphorescence.glsl
// PHOSPHORESCENCE (Afterglow)
// Source: Weird Guy Mineral Shader Corpus (Pass 4)

// Requires feedback buffer for persistence
uniform sampler2D u_prev_frame;

vec3 phosphorescence(vec2 uv, float excitation, float decay_rate) {
    // Previous glow
    vec3 prev = texture2D(u_prev_frame, uv).rgb;

    // New excitation
    vec3 new = vec3(1.0, 0.8, 0.5) * excitation;

    // Decay
    vec3 glow = prev * (1.0 - decay_rate) + new;

    return glow;
}
