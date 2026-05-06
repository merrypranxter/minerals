// shaders/minerals/fantasy/l12-silky-waxy.glsl
// SILKY-WAXY LUSTER (Satin Spar Gypsum)
// Source: Weird Guy Mineral Shader Corpus (Pass 4)

vec3 silky_waxy(vec2 uv, vec3 view, vec3 normal, vec3 light, vec2 fiber_dir) {
    // Very soft fiber highlight
    float along = dot(view.xy, fiber_dir);
    float band = exp(-along * along * 5.0);

    // Waxy base
    float waxy = pow(1.0 - abs(dot(view, normal)), 2.0);

    // Combine: soft fiber on waxy base
    vec3 base = vec3(0.9, 0.88, 0.85) * waxy;
    vec3 fiber = vec3(1.0, 0.95, 0.9) * band * 0.3;

    return base + fiber;
}
