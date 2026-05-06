// shaders/minerals/alexandrite.glsl
// ALEXANDRITE
// Source: Weird Guy Mineral Shader Corpus

vec3 alexandrite_logic(float temp, float angle) {
    vec3 emerald = vec3(0.1, 0.6, 0.4);
    vec3 ruby = vec3(0.6, 0.05, 0.15);
    float shift = smoothstep(0.4, 0.6, temp + angle * 0.2);
    return mix(emerald, ruby, shift);
}
