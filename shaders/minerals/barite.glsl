// shaders/minerals/barite.glsl
// BARITE (BaSO4 Heavy Spar)
// Source: Weird Guy Mineral Shader Corpus (Pass 4 - Real)

// Barite tabular crystal: flat, plate-like
float barite_crystal(vec2 p, vec2 center, float length, float width, float thickness) {
    vec2 local = (p - center);

    // Tabular: very flat in one dimension
    float tabular = max(
        max(abs(local.x) - length, abs(local.y) - width),
        abs(0.0) - thickness // Very thin
    );

    return tabular;
}
