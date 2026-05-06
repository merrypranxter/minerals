// shaders/minerals/fantasy/l13-hackly.glsl
// HACKLY FRACTURE LUSTER (Copper/Arsenic)
// Source: Weird Guy Mineral Shader Corpus (Pass 4)

vec3 hackly(vec2 uv, vec3 view, vec3 normal, float roughness) {
    // Random micro-facets
    float facet_noise = fbm(uv * 20.0);
    vec3 micro_normal = normalize(normal + vec3(facet_noise - 0.5) * roughness);

    // Each facet reflects differently
    float spec = pow(max(0.0, dot(micro_normal, view)), 16.0);

    // Sharp, random highlights
    float sharp = step(0.9, spec);

    return vec3(0.8, 0.7, 0.5) * sharp * 3.0;
}
