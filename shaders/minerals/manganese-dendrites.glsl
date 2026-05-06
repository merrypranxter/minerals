// shaders/minerals/manganese-dendrites.glsl
// MANGANESE DENDRITES
// Source: Weird Guy Mineral Shader Corpus

float ridge(float n) { return 1.0 - abs(n); }

float fbm_dendrite(vec2 p) {
    float v = 0.0, amp = 0.5;
    for(int i = 0; i < 6; i++) {
        p += cos(p.yx * 2.0 + u_time * 0.1);
        v += ridge(sin(dot(p, vec2(1.0, 1.7)))) * amp;
        p *= 2.1; amp *= 0.5;
    }
    return v;
}
