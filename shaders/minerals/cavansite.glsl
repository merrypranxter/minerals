// shaders/minerals/cavansite.glsl
// CAVANSITE
// Source: Weird Guy Mineral Shader Corpus

// Impossible blue (overdriven channel)
vec3 neon_blue = vec3(0.0, 0.4, 2.5);
vec3 deep_indigo = vec3(0.0, 0.05, 0.3);
float ao = smoothstep(0.0, 0.8, needles);
vec3 final_color = mix(deep_indigo, neon_blue, ao);
