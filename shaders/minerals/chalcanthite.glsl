// shaders/minerals/chalcanthite.glsl
// CHALCANTHITE
// Source: Weird Guy Mineral Shader Corpus

mat3 triclinic_skew() {
    return mat3(
        1.0, 0.2, 0.1,
        0.3, 1.0, -0.2,
        0.1, 0.1, 1.0
    );
}

float sdTriclinicBox(vec3 p, vec3 b) {
    p = triclinic_skew() * p;
    vec3 q = abs(p) - b;
    return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0);
}
