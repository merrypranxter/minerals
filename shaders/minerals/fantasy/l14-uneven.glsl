// shaders/minerals/fantasy/l14-uneven.glsl
// UNEVEN FRACTURE LUSTER (Quartz/Flint)
// Source: Weird Guy Mineral Shader Corpus (Pass 4)

vec3 uneven(vec2 uv, vec3 view, vec3 normal, vec3 light) {
    // Large-scale roughness
    float macro = fbm(uv * 3.0);

    // Scattered specular
    vec3 half_vec = normalize(view + light);
    float spec = pow(max(0.0, dot(normal, half_vec)), 4.0);
    spec *= macro;

    // Conchoidal ripple highlights
    float ripple = abs(sin(uv.x * 10.0 + macro * 5.0));
    float ripple_highlight = pow(ripple, 8.0) * spec;

    return vec3(0.9, 0.9, 1.0) * ripple_highlight;
}
