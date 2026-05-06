// shaders/minerals/cassiterite.glsl
// CASSITERITE (SnO2 Tin Ore)
// Source: Weird Guy Mineral Shader Corpus (Pass 4 - Real)

// Cassiterite: high dispersion, diamond-like sparkle
vec3 cassiterite(vec3 view, vec3 normal, vec3 light) {
    // n = 2.0, very high
    float fresnel = pow(1.0 - abs(dot(view, normal)), 2.0 * 2.0);

    // Strong dispersion
    float spec_r = pow(max(0.0, dot(normal, normalize(view + light))), 64.0);
    float spec_b = pow(max(0.0, dot(normal, normalize(view * 0.98 + light))), 64.0);

    return vec3(spec_r, spec_r * 0.9, spec_b) * 3.0;
}
