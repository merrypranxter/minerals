// shaders/minerals/staurolite.glsl
// STAUROLITE (Fairy Cross)
// Source: Weird Guy Mineral Shader Corpus (Pass 4 - Real)

// Staurolite twin cross
float staurolite_cross(vec2 p, float size) {
    // Two prisms at 90°
    float prism1 = max(abs(p.x) * 0.3, abs(p.y)) - size;
    float prism2 = max(abs(p.x), abs(p.y) * 0.3) - size;

    // Intersection = cross
    float cross = min(prism1, prism2);

    return cross;
}
