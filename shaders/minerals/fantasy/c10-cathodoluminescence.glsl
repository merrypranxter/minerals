// shaders/minerals/fantasy/c10-cathodoluminescence.glsl
// CATHODOLUMINESCENCE (Electron Beam Glow)
// Source: Weird Guy Mineral Shader Corpus (Pass 4)

vec3 cathodoluminescence(vec2 uv, float electron_intensity, float mineral_type) {
    // Electron beam spot
    float beam = exp(-length(uv) * length(uv) * 50.0) * electron_intensity;

    // Mineral-specific emission
    vec3 emission;
    if(mineral_type < 0.25) emission = vec3(0.9, 0.5, 0.1); // Orange (Mn²⁺)
    else if(mineral_type < 0.5) emission = vec3(0.1, 0.8, 0.3); // Green (Tb³⁺)
    else if(mineral_type < 0.75) emission = vec3(0.9, 0.1, 0.1); // Red (Eu³⁺)
    else emission = vec3(0.5, 0.5, 1.0); // Blue (Ce³⁺)

    return emission * beam * 3.0;
}
