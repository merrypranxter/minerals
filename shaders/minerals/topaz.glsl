// shaders/minerals/topaz.glsl
// TOPAZ (Al2SiO4F2)
// Source: Weird Guy Mineral Shader Corpus (Pass 4 - Real)

// Topaz: perfect cleavage visible as flat break
float topaz_cleavage(vec2 p, vec3 normal) {
    // Cleavage plane
    float cleavage_plane = dot(normal, vec3(0.0, 0.0, 1.0));

    // Perfect cleavage = very flat
    float flat_break = smoothstep(0.99, 1.0, cleavage_plane);

    // Break along cleavage
    float broken = step(0.0, p.y); // Broken along one plane

    return flat_break * broken;
}
