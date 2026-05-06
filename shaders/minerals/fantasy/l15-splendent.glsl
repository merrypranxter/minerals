// shaders/minerals/fantasy/l15-splendent.glsl
// SPLENDENT LUSTER (Hematite/Magnetite)
// Source: Weird Guy Mineral Shader Corpus (Pass 4)

vec3 splendent(vec3 view, vec3 normal, vec3 light, vec3 base_color) {
    // Near-perfect reflection
    vec3 reflect = reflect(-view, normal);
    float mirror = pow(max(0.0, dot(reflect, light)), 512.0);

    // Colored metal
    vec3 metal = base_color * (0.5 + mirror * 5.0);

    // Environment reflection (simplified)
    float env = pow(1.0 - abs(dot(view, normal)), 2.0);
    metal += vec3(0.3, 0.3, 0.4) * env;

    return metal;
}
