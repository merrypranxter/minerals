// shaders/minerals/fantasy/i7-exotic.glsl
// EXOTIC MATTER (Wormhole Crystal)
// Source: Weird Guy Mineral Shader Corpus (Pass 4)

// Exotic matter: repulsive gravity, negative pressure
vec3 exotic_matter(vec2 p, float time) {
    // Wormhole throat
    float throat = exp(-length(p) * length(p) * 5.0);

    // Exotic matter ring around throat
    float ring = exp(-pow(length(p) - 0.3, 2.0) * 100.0);

    // Negative energy = "dark" glow (absorbs light)
    vec3 exotic = vec3(-0.5, -0.3, -0.2) * ring;

    // Wormhole distortion (simplified)
    float distortion = sin(atan(p.y, p.x) * 3.0 + time) * throat;

    return exotic + vec3(0.3, 0.2, 0.5) * distortion;
}
