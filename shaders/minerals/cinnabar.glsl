// shaders/minerals/cinnabar.glsl
// CINNABAR (HgS Vermilion)
// Source: Weird Guy Mineral Shader Corpus (Pass 4 - Real)

// Cinnabar: intense vermilion red
vec3 cinnabar(vec2 uv) {
    // Rhombohedral crystal outline
    float r = length(uv);
    float theta = atan(uv.y, uv.x);
    float rhomb = abs(cos(theta * 3.0)) * r;
    float crystal = smoothstep(0.5, 0.45, rhomb);

    // Vermilion: HgS color
    vec3 vermilion = vec3(0.9, 0.15, 0.05);

    // Adamantine luster
    float luster = pow(1.0 - r, 4.0);

    return vermilion * crystal * (0.8 + luster * 0.5);
}
