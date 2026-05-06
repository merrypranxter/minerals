// shaders/minerals/kyanite.glsl
// KYANITE (Al2SiO5)
// Source: Weird Guy Mineral Shader Corpus (Pass 4 - Real)

// Kyanite: hardness varies with direction
float kyanite_hardness(vec2 direction) {
    // Hard along c-axis (length)
    float along_length = abs(dot(direction, vec2(1.0, 0.0)));
    // Soft perpendicular
    float across = abs(dot(direction, vec2(0.0, 1.0)));

    // Hardness varies 4.5 to 7
    return mix(4.5, 7.0, along_length);
}
