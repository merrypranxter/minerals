// shaders/minerals/sphalerite.glsl
// SPHALERITE (ZnS)
// Source: Weird Guy Mineral Shader Corpus (Pass 4 - Real)

// Sphalerite: dispersion higher than diamond
vec3 sphalerite_dispersion(vec3 view, vec3 normal, vec3 light) {
    float n = 2.37; // Very high refractive index

    // Extreme dispersion
    vec3 half_vec = normalize(view + light);
    float cos_half = dot(normal, half_vec);

    vec3 color;
    color.r = pow(max(0.0, cos_half), 32.0);
    color.g = pow(max(0.0, cos_half * 0.995), 32.0); // Slight angle shift
    color.b = pow(max(0.0, cos_half * 0.99), 32.0);  // More shift

    return color * 5.0; // Intense fire
}
