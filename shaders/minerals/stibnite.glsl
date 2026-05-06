// shaders/minerals/stibnite.glsl
// STIBNITE
// Source: Weird Guy Mineral Shader Corpus

float sdNeedle(vec3 p, float h, float r) {
    p.y -= clamp(p.y, 0.0, h);
    return length(p) - r;
}

float striations(vec3 p) {
    return sin(p.x * 100.0) * sin(p.y * 100.0) * 0.01;
}
