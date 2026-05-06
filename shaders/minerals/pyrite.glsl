// shaders/minerals/pyrite.glsl
// PYRITE
// Source: Weird Guy Mineral Shader Corpus

float sdBox(vec3 p, vec3 b) {
    vec3 q = abs(p) - b;
    return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0);
}

float pyriteSDF(vec3 p) {
    float d = 1e10;
    for(int i = 0; i < 3; i++) {
        float a = 0.785398;
        p.xy *= mat2(cos(a), -sin(a), sin(a), cos(a));
        p = abs(p) - 0.2;
        d = min(d, sdBox(p, vec3(0.4)));
    }
    return d;
}
