// shaders/minerals/seraphinite.glsl
// SERAPHINITE
// Source: Weird Guy Mineral Shader Corpus

vec2 get_feather_tangent(vec2 p) {
    float eps = 0.1;
    float n1 = noise(p + vec2(eps, 0.0));
    float n2 = noise(p - vec2(eps, 0.0));
    float n3 = noise(p + vec2(0.0, eps));
    float n4 = noise(p - vec2(0.0, eps));
    return normalize(vec2(n3 - n4, n2 - n1));
}
