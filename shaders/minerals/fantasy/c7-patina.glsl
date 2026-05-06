// shaders/minerals/fantasy/c7-patina.glsl
// PATINA (Copper Weathering)
// Source: Weird Guy Mineral Shader Corpus (Pass 4)

vec3 patina(vec3 base_copper, float age, float moisture) {
    // Verdigris (copper acetate/carbonate)
    vec3 verdigris = vec3(0.2, 0.5, 0.3);

    // Azurite (deep blue)
    vec3 azurite = vec3(0.1, 0.2, 0.5);

    // Malachite (green)
    vec3 malachite = vec3(0.1, 0.4, 0.2);

    // Layered patina
    float layer1 = smoothstep(0.0, 5.0, age) * moisture;
    float layer2 = smoothstep(5.0, 20.0, age);
    float layer3 = smoothstep(20.0, 100.0, age);

    vec3 color = base_copper;
    color = mix(color, verdigris, layer1);
    color = mix(color, azurite, layer2);
    color = mix(color, malachite, layer3);

    return color;
}
