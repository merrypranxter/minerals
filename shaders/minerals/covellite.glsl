// shaders/minerals/covellite.glsl
// COVELLITE
// Source: Weird Guy Mineral Shader Corpus

vec3 covellite_palette(float t) {
    vec3 base = vec3(0.02, 0.05, 0.2);
    vec3 irid = vec3(0.1, 0.8, 1.0);
    return base + irid * pow(sin(t * 6.28 + vec3(0, 1.2, 2.5)), vec3(4.0));
}
