// shaders/minerals/garnet.glsl
// GARNET (X3Y2(SiO4)3)
// Source: Weird Guy Mineral Shader Corpus (Pass 4 - Real)

// Garnet dodecahedron
float garnet_crystal(vec3 p, float size) {
    // Dodecahedron: 12 pentagonal faces
    float d = abs(p.x) + abs(p.y) + abs(p.z);
    d = max(d, abs(p.x) + abs(p.y) - abs(p.z));
    d = max(d, abs(p.x) - abs(p.y) + abs(p.z));
    d = max(d, -abs(p.x) + abs(p.y) + abs(p.z));

    return d - size;
}
