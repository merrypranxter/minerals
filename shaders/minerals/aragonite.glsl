// shaders/minerals/aragonite.glsl
// ARAGONITE (CaCO3 Orthorhombic)
// Source: Weird Guy Mineral Shader Corpus (Pass 4 - Real)

// Aragonite twin: pseudo-hexagonal from orthorhombic
float aragonite_twin(vec2 p, float size) {
    vec2 local = p / size;

    // Cyclic twin: 3 individuals at 60°
    float twin = 1e10;
    for(int i = 0; i < 3; i++) {
        float angle = float(i) * 2.094; // 120°
        vec2 individual = local * rot(angle);
        float d = max(abs(individual.x), abs(individual.y)) - 1.0;
        twin = min(twin, d);
    }

    return twin;
}
