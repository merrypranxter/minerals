// shaders/minerals/zircon.glsl
// ZIRCON (ZrSiO4)
// Source: Weird Guy Mineral Shader Corpus (Pass 4 - Real)

// Zircon: high birefringence creates double image
vec3 zircon_double_refraction(vec2 uv, sampler2D scene, float birefringence) {
    // Ordinary ray
    vec3 ordinary = texture2D(scene, uv).rgb;

    // Extraordinary ray (shifted)
    vec2 shift = vec2(birefringence * 0.02, 0.0);
    vec3 extraordinary = texture2D(scene, uv + shift).rgb;

    // Combine with interference
    float phase = sin(uv.x * 100.0) * 0.5 + 0.5;

    return mix(ordinary, extraordinary, phase);
}
