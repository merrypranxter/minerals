// shaders/minerals/fantasy/l11-submetallic.glsl
// SUBMETALLIC LUSTER (Hematite/Goethite)
// Source: Weird Guy Mineral Shader Corpus (Pass 4)

vec3 submetallic(vec3 base_color, vec3 view, vec3 normal, vec3 light) {
    // Weak metallic reflection
    float fresnel = pow(1.0 - abs(dot(view, normal)), 3.0) * 0.5;

    // Dull specular
    vec3 half_vec = normalize(view + light);
    float spec = pow(max(0.0, dot(normal, half_vec)), 8.0);

    // Earthy undertone
    float earthy = max(0.0, dot(normal, light)) * 0.7;

    return base_color * (fresnel + spec + earthy);
}
