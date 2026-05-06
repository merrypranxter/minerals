// shaders/minerals/fantasy/i5-negative.glsl
// NEGATIVE MASS MINERAL
// Source: Weird Guy Mineral Shader Corpus (Pass 4)

// Negative mass: repels everything
vec2 negative_gravity(vec2 p, vec2 mass_center, float negative_mass) {
    vec2 delta = p - mass_center;
    float r = length(delta);

    // Repulsive force
    vec2 repulsion = -normalize(delta) * negative_mass / (r * r + 0.01);

    return repulsion;
}

// Visual: light bends away from mineral
