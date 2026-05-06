// shaders/minerals/rutilated-quartz.glsl
// RUTILATED QUARTZ
// Source: Weird Guy Mineral Shader Corpus

// Internal parallax layers
for(int i = 0; i < 8; i++) {
    float z_layer = float(i) * 0.1;
    vec2 internal_uv = uv + viewDir.xy * z_layer;
    // Needle seeds at depth
    float seed = fract(sin(z_layer * 123.4) * 456.7);
    float needle_mask = smoothstep(0.98, 0.99, 
        fract(sin(dot(internal_uv, vec2(12.9, 78.2)) + seed)));
    // Accumulate with depth dimming
    final_color += (gold * needle_mask * 0.5 + glint) * (1.0 - z_layer);
}
