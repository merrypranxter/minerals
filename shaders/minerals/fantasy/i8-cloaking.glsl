// shaders/minerals/fantasy/i8-cloaking.glsl
// CLOAKING MINERAL (Invisibility)
// Source: Weird Guy Mineral Shader Corpus (Pass 4)

// Metamaterial cloaking: light passes through undeviated
vec2 cloak(vec2 p, vec2 center, float radius) {
    vec2 delta = p - center;
    float r = length(delta);

    if(r > radius) return p; // Outside: no effect

    // Inside: compress space to push light around
    float compression = radius / (r + 0.01);
    vec2 cloaked = center + delta * compression;

    return cloaked;
}

// Visual: see background through "hole" in space
