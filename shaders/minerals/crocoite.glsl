// shaders/minerals/crocoite.glsl
// CROCOITE
// Source: Weird Guy Mineral Shader Corpus

vec3 monoclinic(vec3 p) {
    p.x += p.y * 0.4;
    return p;
}

float sdHollowPrism(vec3 p, vec2 h) {
    p = monoclinic(p);
    vec2 d = abs(vec2(length(p.xz), p.y)) - h;
    float outer = min(max(d.x, d.y), 0.0) + length(max(d, 0.0));
    float inner = length(p.xz) - (h.x * 0.8);
    return max(outer, -inner);
}
